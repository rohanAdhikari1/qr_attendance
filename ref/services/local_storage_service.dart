import 'package:hive_flutter/hive_flutter.dart';

import '../models/attendance_model.dart';

class LocalStorageService {
  static const _attendanceBoxName = 'attendance';
  static const _settingsBoxName = 'settings';

  Box<AttendanceModel> get _attendanceBox =>
      Hive.box<AttendanceModel>(_attendanceBoxName);
  Box get _settingsBox => Hive.box(_settingsBoxName);

  // ─── Attendance CRUD ────────────────────────────────────────────────────────

  Future<void> saveAttendance(AttendanceModel record) async {
    await _attendanceBox.put(record.id, record);
  }

  Future<void> updateAttendance(AttendanceModel record) async {
    await _attendanceBox.put(record.id, record);
  }

  List<AttendanceModel> getAllAttendance() =>
      _attendanceBox.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  List<AttendanceModel> getPendingAttendance() => _attendanceBox.values
      .where((r) => r.syncStatus == SyncStatus.pending)
      .toList();

  List<AttendanceModel> getFailedAttendance() => _attendanceBox.values
      .where((r) => r.syncStatus == SyncStatus.failed)
      .toList();

  List<AttendanceModel> getTodayAttendance() {
    final now = DateTime.now();
    return _attendanceBox.values
        .where((r) =>
            r.timestamp.year == now.year &&
            r.timestamp.month == now.month &&
            r.timestamp.day == now.day)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<AttendanceModel> getAttendanceByDate(DateTime date) =>
      _attendanceBox.values
          .where((r) =>
              r.timestamp.year == date.year &&
              r.timestamp.month == date.month &&
              r.timestamp.day == date.day)
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  /// Returns true if the student already has an attendance record today.
  bool hasAttendanceToday(String studentId) {
    final now = DateTime.now();
    return _attendanceBox.values.any((r) =>
        r.studentId == studentId &&
        r.timestamp.year == now.year &&
        r.timestamp.month == now.month &&
        r.timestamp.day == now.day);
  }

  Future<void> deleteAttendance(String id) async {
    await _attendanceBox.delete(id);
  }

  Future<void> markSynced(String id, {String? studentName, String? className}) async {
    final record = _attendanceBox.get(id);
    if (record != null) {
      final updated = record.copyWith(
        syncStatus: SyncStatus.synced,
        studentName: studentName ?? record.studentName,
        className: className ?? record.className,
      );
      await _attendanceBox.put(id, updated);
    }
  }

  Future<void> markFailed(String id) async {
    final record = _attendanceBox.get(id);
    if (record != null) {
      final updated = record.copyWith(
        syncStatus: SyncStatus.failed,
        retryCount: record.retryCount + 1,
      );
      await _attendanceBox.put(id, updated);
    }
  }

  Future<void> resetFailedToPending() async {
    final failed = getFailedAttendance();
    for (final r in failed) {
      if (r.retryCount < 5) {
        final updated = r.copyWith(syncStatus: SyncStatus.pending);
        await _attendanceBox.put(r.id, updated);
      }
    }
  }

  int get totalTodayCount => getTodayAttendance().length;
  int get pendingCount => getPendingAttendance().length;
  int get syncedTodayCount =>
      getTodayAttendance().where((r) => r.syncStatus == SyncStatus.synced).length;

  // ─── Settings ──────────────────────────────────────────────────────────────

  String get apiBaseUrl =>
      _settingsBox.get('api_base_url', defaultValue: 'https://your-school-api.com');
  Future<void> setApiBaseUrl(String url) =>
      _settingsBox.put('api_base_url', url);

  String get apiKey =>
      _settingsBox.get('api_key', defaultValue: '');
  Future<void> setApiKey(String key) => _settingsBox.put('api_key', key);

  String get schoolName =>
      _settingsBox.get('school_name', defaultValue: 'My School');
  Future<void> setSchoolName(String name) =>
      _settingsBox.put('school_name', name);

  String get adminPin =>
      _settingsBox.get('admin_pin', defaultValue: '287569');
  Future<void> setAdminPin(String pin) => _settingsBox.put('admin_pin', pin);

  bool get kioskMode =>
      _settingsBox.get('kiosk_mode', defaultValue: true);
  Future<void> setKioskMode(bool value) =>
      _settingsBox.put('kiosk_mode', value);
}
