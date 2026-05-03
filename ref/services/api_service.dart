import 'dart:async';
import 'package:dio/dio.dart';

import '../models/attendance_model.dart';
import '../services/local_storage_service.dart';

// ─── Response wrappers ────────────────────────────────────────────────────────

class ApiResult<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  const ApiResult.ok(this.data)
      : success = true,
        error = null,
        statusCode = null;

  const ApiResult.fail(this.error, {this.statusCode})
      : success = false,
        data = null;
}

class StudentInfo {
  final String studentId;
  final String name;
  final String className;
  final String grade;
  final String? photoUrl;

  const StudentInfo({
    required this.studentId,
    required this.name,
    required this.className,
    required this.grade,
    this.photoUrl,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> j) => StudentInfo(
        studentId: (j['student_id'] ?? j['studentId'] ?? j['id'] ?? '').toString(),
        name: (j['name'] ?? j['student_name'] ?? j['fullName'] ?? '').toString(),
        className: (j['class'] ?? j['class_name'] ?? j['className'] ?? '').toString(),
        grade: (j['grade'] ?? j['section'] ?? '').toString(),
        photoUrl: j['photo_url']?.toString(),
      );

  bool get hasName => name.trim().isNotEmpty;
}

// ─── Dio API Service ──────────────────────────────────────────────────────────

class ApiService {
  final LocalStorageService _storage = LocalStorageService();
  late Dio _dio;

  ApiService() {
    _dio = _buildDio();
  }

  // ── Build Dio with interceptors ─────────────────────────────────────────────

  Dio _buildDio() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-App': 'school-attendance-v1',
      },
    ));

    // ── Auth interceptor: injects Bearer token from settings ─────────────────
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.baseUrl = _storage.apiBaseUrl.endsWith('/')
            ? _storage.apiBaseUrl.substring(0, _storage.apiBaseUrl.length - 1)
            : _storage.apiBaseUrl;
        final key = _storage.apiKey;
        if (key.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $key';
        }
        handler.next(options);
      },
      onError: (DioException e, handler) {
        // Refresh base URL on every request in case settings changed
        handler.next(e);
      },
    ));

    // ── Logging interceptor (debug only) ─────────────────────────────────────
    dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      logPrint: (o) => print('[API] $o'),
    ));

    // ── Retry interceptor: retries on 5xx or network errors ──────────────────
    dio.interceptors.add(_RetryInterceptor(dio, maxRetries: 2));

    return dio;
  }

  // ── Rebuild when settings change ─────────────────────────────────────────

  void refreshConfig() {
    _dio = _buildDio();
  }

  // ─── POST single attendance ──────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> postAttendance(
      AttendanceModel record) async {
    try {
      final res = await _dio.post(
        '/api/attendance',
        data: record.toJson(),
      );
      return ApiResult.ok(res.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return ApiResult.fail(
        _dioError(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ─── POST batch attendance ───────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> postBatchAttendance(
      List<AttendanceModel> records) async {
    try {
      final res = await _dio.post(
        '/api/attendance/batch',
        data: {'records': records.map((r) => r.toJson()).toList()},
      );
      return ApiResult.ok(res.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return ApiResult.fail(_dioError(e), statusCode: e.response?.statusCode);
    }
  }

  // ─── GET single student ──────────────────────────────────────────────────

  Future<StudentInfo?> fetchStudent(String studentId) async {
    try {
      final res = await _dio.get('/api/students/$studentId');
      final body = res.data;
      if (body is Map<String, dynamic>) {
        final data = body['student'] ?? body['data'] ?? body;
        return StudentInfo.fromJson(data as Map<String, dynamic>);
      }
    } on DioException {
      // Silently return null — cache handles missing info
    }
    return null;
  }

  // ─── GET all students (bulk cache warm-up) ───────────────────────────────
  //
  // Expects: { "students": [...] } OR { "data": [...] } OR [...]
  // Supports pagination via ?page=N&per_page=100

  Future<ApiResult<List<StudentInfo>>> fetchAllStudents({
    int perPage = 100,
    void Function(int loaded, int? total)? onProgress,
  }) async {
    final allStudents = <StudentInfo>[];
    int page = 1;
    int? total;

    try {
      while (true) {
        final res = await _dio.get(
          '/api/students',
          queryParameters: {'page': page, 'per_page': perPage},
        );

        final body = res.data;
        List<dynamic> items = [];

        if (body is List) {
          items = body;
        } else if (body is Map) {
          items = (body['students'] ??
                  body['data'] ??
                  body['results'] ??
                  []) as List<dynamic>;
          total ??= body['total'] as int?;
        }

        if (items.isEmpty) break;

        allStudents.addAll(
          items
              .whereType<Map<String, dynamic>>()
              .map(StudentInfo.fromJson),
        );

        onProgress?.call(allStudents.length, total);

        // Stop if we got fewer items than requested (last page)
        if (items.length < perPage) break;
        page++;
      }

      return ApiResult.ok(allStudents);
    } on DioException catch (e) {
      // Return partial data + error
      if (allStudents.isNotEmpty) return ApiResult.ok(allStudents);
      return ApiResult.fail(_dioError(e), statusCode: e.response?.statusCode);
    }
  }

  // ─── Ping server ─────────────────────────────────────────────────────────

  Future<bool> ping() async {
    try {
      final res = await _dio.get(
        '/api/ping',
        options: Options(receiveTimeout: const Duration(seconds: 5)),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ─── Helper ──────────────────────────────────────────────────────────────

  String _dioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out';
      case DioExceptionType.connectionError:
        return 'No connection to server';
      case DioExceptionType.badResponse:
        return 'Server error ${e.response?.statusCode}';
      default:
        return e.message ?? 'Unknown error';
    }
  }
}

// ─── Retry interceptor ────────────────────────────────────────────────────────

class _RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  _RetryInterceptor(this.dio, {this.maxRetries = 2});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final extra = err.requestOptions.extra;
    final retryCount = (extra['retry_count'] as int?) ?? 0;

    final shouldRetry = retryCount < maxRetries &&
        (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.connectionError ||
            (err.response?.statusCode != null &&
                err.response!.statusCode! >= 500));

    if (shouldRetry) {
      await Future.delayed(Duration(seconds: retryCount + 1));
      err.requestOptions.extra['retry_count'] = retryCount + 1;
      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // Fall through to original error
      }
    }

    handler.next(err);
  }
}
