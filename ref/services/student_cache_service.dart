import 'package:hive/hive.dart';

import '../models/student_model.dart';
import '../services/api_service.dart';
import '../services/connectivity_service.dart';

/// Resolves student info using a strict cache-first strategy:
///
///  1. Return from local Hive cache if present (fresh or stale)
///  2. If online AND (not cached OR stale) → fetch from server, save to cache
///  3. If offline AND not cached → return null (scanner still works, just shows ID only)
///
/// This means:
///  - First scan of a student = server fetch (if online), cached forever after
///  - Subsequent scans (online or offline) = instant from local DB
///  - Completely offline device = only shows studentId, attendance still saved
class StudentCacheService {
  static const _boxName = 'student_cache';

  Box<StudentModel>? _box;
  final ApiService _api;
  final ConnectivityService _connectivity;

  StudentCacheService(this._api, this._connectivity);

  Future<void> init() async {
    _box = Hive.box<StudentModel>(_boxName);
  }

  Box<StudentModel> get _safeBox {
    if (_box == null) throw StateError('StudentCacheService not initialized');
    return _box!;
  }

  // ─── Main resolve method ──────────────────────────────────────────────────

  /// Returns student info from cache or server.
  /// Never throws — returns null if unavailable.
  Future<StudentModel?> resolve(String studentId) async {
    // 1. Check local cache
    final cached = _safeBox.get(studentId);

    if (cached != null) {
      // Always return cached data immediately (even stale)
      // Refresh in background if stale and online
      if (!cached.isFresh && _connectivity.isOnline.value) {
        _refreshInBackground(studentId);
      }
      return cached;
    }

    // 2. Not cached — try server if online
    if (_connectivity.isOnline.value) {
      return await _fetchAndCache(studentId);
    }

    // 3. Offline + not cached → null (scanner still works fine)
    return null;
  }

  // ─── Background refresh (doesn't block scanning) ─────────────────────────

  void _refreshInBackground(String studentId) {
    // Fire-and-forget — do not await
    _fetchAndCache(studentId);
  }

  // ─── Fetch from server and save to cache ─────────────────────────────────

  Future<StudentModel?> _fetchAndCache(String studentId) async {
    try {
      final info = await _api.fetchStudent(studentId);
      if (info == null) return null;

      final model = StudentModel(
        studentId: info.studentId.isNotEmpty ? info.studentId : studentId,
        name: info.name,
        className: info.className,
        grade: info.grade,
        photoUrl: info.photoUrl,
        cachedAt: DateTime.now(),
      );

      await _safeBox.put(studentId, model);
      return model;
    } catch (_) {
      return null;
    }
  }

  // ─── Bulk pre-fetch (optional: call on app start when online) ────────────

  /// Pre-fetches and caches all students in the given ID list.
  /// Call this on app startup when internet is available to warm the cache.
  Future<void> preFetch(List<String> studentIds) async {
    if (!_connectivity.isOnline.value) return;

    for (final id in studentIds) {
      final cached = _safeBox.get(id);
      if (cached == null || !cached.isFresh) {
        await _fetchAndCache(id);
      }
    }
  }

  // ─── Cache management ─────────────────────────────────────────────────────

  StudentModel? getCached(String studentId) => _safeBox.get(studentId);

  bool isCached(String studentId) => _safeBox.containsKey(studentId);

  int get cachedCount => _safeBox.length;

  Future<void> clearCache() => _safeBox.clear();

  /// Remove entries older than [days] days.
  Future<void> evictOldEntries({int days = 90}) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final toDelete = _safeBox.values
        .where((s) => s.cachedAt.isBefore(cutoff))
        .map((s) => s.studentId)
        .toList();
    await _safeBox.deleteAll(toDelete);
  }

  /// Called by AdminController after bulk-loading all students from server.
  Future<void> cacheFromInfo(StudentInfo info) async {
    final model = StudentModel(
      studentId: info.studentId,
      name: info.name,
      className: info.className,
      grade: info.grade,
      photoUrl: info.photoUrl,
      cachedAt: DateTime.now(),
    );
    await _safeBox.put(info.studentId, model);
  }
}