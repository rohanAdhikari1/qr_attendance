// Example 1: Using StorageService in SyncController
// ─────────────────────────────────────────────────

import 'package:get/get.dart';
import 'storage_service.dart';

class SyncControllerExample {
  final StorageService _storage;

  SyncControllerExample(this._storage);

  /// Sync pending records to server
  Future<void> syncPendingAttendance() async {
    try {
      // Get all pending records
      final pending = await _storage.getPendingAttendance();

      for (final record in pending) {
        try {
          // Send to server
          await _uploadRecord(record);

          // Update status to synced
          final updated = record.copyWith(syncStatus: SyncStatus.synced);
          await _storage.updateAttendance(updated);
        } catch (e) {
          // Update status to failed and increment retry count
          final failed = record.copyWith(
            syncStatus: SyncStatus.failed,
            retryCount: record.retryCount + 1,
          );
          await _storage.updateAttendance(failed);
        }
      }
    } catch (e) {
      print('Sync error: $e');
    }
  }

  Future<void> _uploadRecord(AttendanceModel record) async {
    // Implement upload logic
  }
}

// Example 2: Using StorageService in StudentCacheService
// ────────────────────────────────────────────────────

class StudentCacheServiceExample {
  final StorageService _storage;
  final ApiService _apiService;

  StudentCacheServiceExample(this._storage, this._apiService);

  /// Cache student info when attendance is marked
  Future<StudentModel?> cacheStudentIfNeeded(String studentId) async {
    // Check if already cached
    final cached = await _storage.getStudent(studentId);
    if (cached != null && cached.isFresh) {
      return cached;
    }

    // Fetch from API and cache
    try {
      final student = await _apiService.getStudentInfo(studentId);
      await _storage.saveStudent(student);
      return student;
    } catch (e) {
      return cached; // Return stale cache if available
    }
  }

  /// Get student info (from cache if available)
  Future<StudentModel?> getStudent(String studentId) async {
    return _storage.getStudent(studentId);
  }

  /// Clear expired cache entries
  Future<void> cleanExpiredCache() async {
    final all = await _storage.getAllStudents();
    for (final student in all) {
      if (!student.isFresh) {
        await _storage.deleteStudent(student.studentId);
      }
    }
  }
}

// Example 3: Using StorageService with Settings
// ──────────────────────────────────────────────

class AppSettingsExample extends GetxController {
  final StorageService _storage;

  late Rx<bool> darkMode;
  late Rx<String> serverUrl;
  late Rx<int> syncInterval;

  AppSettingsExample(this._storage) {
    darkMode = (_storage.getSetting<bool>('dark_mode') ?? false).obs;
    serverUrl = (_storage.getSetting<String>('server_url') ?? 'http://localhost').obs;
    syncInterval = (_storage.getSetting<int>('sync_interval') ?? 300).obs;
  }

  Future<void> setDarkMode(bool value) async {
    darkMode.value = value;
    await _storage.setSetting<bool>('dark_mode', value);
  }

  Future<void> setServerUrl(String url) async {
    serverUrl.value = url;
    await _storage.setSetting<String>('server_url', url);
  }

  Future<void> setSyncInterval(int seconds) async {
    syncInterval.value = seconds;
    await _storage.setSetting<int>('sync_interval', seconds);
  }

  Future<void> resetSettings() async {
    await _storage.clearAllSettings();
    await _storage.clearAllAttendance();
    await _storage.clearAllStudents();
  }
}

// Example 4: Using StorageService in API Layer
// ──────────────────────────────────────────────

class ApiServiceExample {
  final StorageService _storage;

  ApiServiceExample(this._storage);

  /// Save API response to cache
  Future<void> cacheStudentList(List<StudentModel> students) async {
    for (final student in students) {
      await _storage.saveStudent(student);
    }
  }

  /// Get attendance summary from database
  Future<AttendanceSummary> getAttendanceSummary(DateTime date) async {
    final records = await _storage.getAttendanceByDate(date);
    return AttendanceSummary(
      total: records.length,
      synced: records.where((r) => r.syncStatus == SyncStatus.synced).length,
      pending: records.where((r) => r.syncStatus == SyncStatus.pending).length,
      failed: records.where((r) => r.syncStatus == SyncStatus.failed).length,
    );
  }
}

// Example 5: Reactive GetX Widget Using StorageService
// ──────────────────────────────────────────────────

import 'package:flutter/material.dart';

class ReactiveDashboardExample extends StatelessWidget {
  final controller = Get.find<AttendanceController>();
  final storage = Get.find<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ListView(
          children: [
            // Reactive stats
            _buildStatsSection(),
            // Today's pending records
            _buildPendingSection(),
            // Recent failures
            _buildFailedSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return FutureBuilder<int>(
      future: storage.getTotalTodayCount(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Today: ${snapshot.data} records',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPendingSection() {
    return FutureBuilder<List<AttendanceModel>>(
      future: storage.getPendingAttendance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final pending = snapshot.data ?? [];
        if (pending.isEmpty) return const SizedBox.shrink();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Sync (${pending.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...pending.take(3).map((r) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('• ${r.studentName} - ${r.className}'),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFailedSection() {
    return FutureBuilder<List<AttendanceModel>>(
      future: storage.getFailedAttendance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final failed = snapshot.data ?? [];
        if (failed.isEmpty) return const SizedBox.shrink();

        return Card(
          color: Colors.red.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Failed Syncs (${failed.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                ...failed.take(3).map((r) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '• ${r.studentName} - Retry: ${r.retryCount}',
                    style: const TextStyle(color: Colors.red),
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Data model for API response
class AttendanceSummary {
  final int total;
  final int synced;
  final int pending;
  final int failed;

  AttendanceSummary({
    required this.total,
    required this.synced,
    required this.pending,
    required this.failed,
  });
}
