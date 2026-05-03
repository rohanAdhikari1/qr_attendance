import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../database/app_database.dart';
import '../models/attendance_model.dart';
import '../models/student_model.dart';

/// Unified storage service combining GetxStorage (for simple key-value pairs)
/// and Drift (for complex relational data)
class StorageService extends GetxService {
  late final GetStorage _getStorage;
  late final AppDatabase _database;

  // ─── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    // Initialize GetxStorage
    _getStorage = GetStorage();
    await _getStorage.writeIfNull('app_initialized', true);

    // Initialize Drift Database
    _database = AppDatabase();
  }

  // ─── Getters ────────────────────────────────────────────────────────────────

  AppDatabase get database => _database;
  GetStorage get getStorage => _getStorage;

  // ─── Attendance Operations ───────────────────────────────────────────────────

  /// Save new attendance record
  Future<void> saveAttendance(AttendanceModel record) async {
    await _database.insertAttendance(
      AttendancesCompanion(
        id: Value(record.id),
        studentId: Value(record.studentId),
        timestamp: Value(record.timestamp),
        syncStatus: Value(record.syncStatus.name),
        rawQrData: Value(record.rawQrData),
        studentName: Value(record.studentName),
        className: Value(record.className),
        grade: Value(record.grade),
        retryCount: Value(record.retryCount),
      ),
    );
  }

  /// Update existing attendance record
  Future<void> updateAttendance(AttendanceModel record) async {
    await _database.updateAttendance(
      AttendancesCompanion(
        id: Value(record.id),
        studentId: Value(record.studentId),
        timestamp: Value(record.timestamp),
        syncStatus: Value(record.syncStatus.name),
        rawQrData: Value(record.rawQrData),
        studentName: Value(record.studentName),
        className: Value(record.className),
        grade: Value(record.grade),
        retryCount: Value(record.retryCount),
      ),
    );
  }

  /// Get all attendance records
  Future<List<AttendanceModel>> getAllAttendance() async {
    final records = await _database.getAllAttendance();
    return records
        .map((r) => AttendanceModel(
              id: r.id,
              studentId: r.studentId,
              timestamp: r.timestamp,
              syncStatus: SyncStatus.values.byName(r.syncStatus),
              rawQrData: r.rawQrData,
              studentName: r.studentName,
              className: r.className,
              grade: r.grade,
              retryCount: r.retryCount,
            ))
        .toList();
  }

  /// Get pending attendance records (not yet synced)
  Future<List<AttendanceModel>> getPendingAttendance() async {
    final records = await _database.getPendingAttendance();
    return records
        .map((r) => AttendanceModel(
              id: r.id,
              studentId: r.studentId,
              timestamp: r.timestamp,
              syncStatus: SyncStatus.values.byName(r.syncStatus),
              rawQrData: r.rawQrData,
              studentName: r.studentName,
              className: r.className,
              grade: r.grade,
              retryCount: r.retryCount,
            ))
        .toList();
  }

  /// Get failed attendance records
  Future<List<AttendanceModel>> getFailedAttendance() async {
    final records = await _database.getFailedAttendance();
    return records
        .map((r) => AttendanceModel(
              id: r.id,
              studentId: r.studentId,
              timestamp: r.timestamp,
              syncStatus: SyncStatus.values.byName(r.syncStatus),
              rawQrData: r.rawQrData,
              studentName: r.studentName,
              className: r.className,
              grade: r.grade,
              retryCount: r.retryCount,
            ))
        .toList();
  }

  /// Get today's attendance records
  Future<List<AttendanceModel>> getTodayAttendance() async {
    final records = await _database.getTodayAttendance();
    return records
        .map((r) => AttendanceModel(
              id: r.id,
              studentId: r.studentId,
              timestamp: r.timestamp,
              syncStatus: SyncStatus.values.byName(r.syncStatus),
              rawQrData: r.rawQrData,
              studentName: r.studentName,
              className: r.className,
              grade: r.grade,
              retryCount: r.retryCount,
            ))
        .toList();
  }

  /// Get attendance records for a specific date
  Future<List<AttendanceModel>> getAttendanceByDate(DateTime date) async {
    final records = await _database.getAttendanceByDate(date);
    return records
        .map((r) => AttendanceModel(
              id: r.id,
              studentId: r.studentId,
              timestamp: r.timestamp,
              syncStatus: SyncStatus.values.byName(r.syncStatus),
              rawQrData: r.rawQrData,
              studentName: r.studentName,
              className: r.className,
              grade: r.grade,
              retryCount: r.retryCount,
            ))
        .toList();
  }

  /// Check if student already has attendance today
  Future<bool> hasAttendanceToday(String studentId) =>
      _database.hasAttendanceToday(studentId);

  /// Delete single attendance record
  Future<void> deleteAttendance(String id) =>
      _database.deleteAttendance(id);

  /// Clear all attendance records
  Future<void> clearAllAttendance() => _database.clearAllAttendance();

  // ─── Student Operations ──────────────────────────────────────────────────────

  /// Save student info to cache
  Future<void> saveStudent(StudentModel student) async {
    await _database.insertStudent(
      StudentsCompanion(
        studentId: Value(student.studentId),
        name: Value(student.name),
        className: Value(student.className),
        grade: Value(student.grade),
        photoUrl: Value(student.photoUrl),
        cachedAt: Value(student.cachedAt),
      ),
    );
  }

  /// Update student info
  Future<void> updateStudent(StudentModel student) async {
    await _database.updateStudent(
      StudentsCompanion(
        studentId: Value(student.studentId),
        name: Value(student.name),
        className: Value(student.className),
        grade: Value(student.grade),
        photoUrl: Value(student.photoUrl),
        cachedAt: Value(student.cachedAt),
      ),
    );
  }

  /// Get student by ID
  Future<StudentModel?> getStudent(String studentId) async {
    final record = await _database.getStudent(studentId);
    if (record == null) return null;
    return StudentModel(
      studentId: record.studentId,
      name: record.name,
      className: record.className,
      grade: record.grade,
      photoUrl: record.photoUrl,
      cachedAt: record.cachedAt,
    );
  }

  /// Get all cached students
  Future<List<StudentModel>> getAllStudents() async {
    final records = await _database.getAllStudents();
    return records
        .map((r) => StudentModel(
              studentId: r.studentId,
              name: r.name,
              className: r.className,
              grade: r.grade,
              photoUrl: r.photoUrl,
              cachedAt: r.cachedAt,
            ))
        .toList();
  }

  /// Delete student from cache
  Future<void> deleteStudent(String studentId) =>
      _database.deleteStudent(studentId);

  /// Clear all students
  Future<void> clearAllStudents() => _database.clearAllStudents();

  // ─── Settings (GetxStorage) ─────────────────────────────────────────────────

  /// Get setting value
  T? getSetting<T>(String key, {T? defaultValue}) {
    return _getStorage.read<T>(key) ?? defaultValue;
  }

  /// Save setting value
  Future<void> setSetting<T>(String key, T value) =>
      _getStorage.write(key, value);

  /// Delete setting
  Future<void> deleteSetting(String key) => _getStorage.remove(key);

  /// Check if setting exists
  bool hasSetting(String key) => _getStorage.hasData(key);

  /// Clear all settings
  Future<void> clearAllSettings() => _getStorage.erase();

  // ─── Convenience Methods ────────────────────────────────────────────────────

  Future<int> getTotalTodayCount() => _database.getTotalTodayCount();
  Future<int> getSyncedTodayCount() => _database.getSyncedTodayCount();
  Future<int> getPendingCount() => _database.getPendingCount();

  /// Close database connection
  Future<void> closeDatabase() => _database.close();
}
