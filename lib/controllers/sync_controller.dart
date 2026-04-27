import 'dart:async';
import 'package:get/get.dart';

import '../models/attendance_model.dart';
import '../services/api_service.dart';
import '../services/connectivity_service.dart';
import '../services/local_storage_service.dart';

class SyncController extends GetxController {
  final LocalStorageService _storage;
  final ApiService _api;
  final ConnectivityService _connectivity;

  SyncController(this._storage, this._api, this._connectivity);

  final isSyncing = false.obs;
  final pendingCount = 0.obs;
  final lastSyncTime = Rxn<DateTime>();
  final lastSyncMessage = ''.obs;

  Timer? _syncTimer;

  @override
  void onInit() {
    super.onInit();
    _updatePendingCount();

    // Watch connectivity: sync when back online
    ever(_connectivity.isOnline, (bool online) {
      if (online) {
        Future.delayed(const Duration(seconds: 2), syncPending);
      }
    });

    // Periodic sync every 2 minutes
    _syncTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      if (_connectivity.isOnline.value) syncPending();
    });
  }

  @override
  void onClose() {
    _syncTimer?.cancel();
    super.onClose();
  }

  void _updatePendingCount() {
    pendingCount.value = _storage.getPendingAttendance().length +
        _storage.getFailedAttendance().length;
  }

  /// Syncs all pending (and retry-eligible failed) records to the server.
  Future<void> syncPending() async {
    if (isSyncing.value) return;
    if (!_connectivity.isOnline.value) return;

    // Reset failed records that can be retried
    await _storage.resetFailedToPending();
    _updatePendingCount();

    final pending = _storage.getPendingAttendance();
    if (pending.isEmpty) {
      lastSyncMessage.value = 'All records synced ✓';
      return;
    }

    isSyncing.value = true;
    lastSyncMessage.value = 'Syncing ${pending.length} records…';

    int successCount = 0;
    int failCount = 0;

    // Try batch first
    if (pending.length > 1) {
      final result = await _api.postBatchAttendance(pending);
      if (result.success) {
        // Mark all as synced
        final syncedIds = _extractSyncedIds(result.data, pending);
        for (final record in pending) {
          if (syncedIds.contains(record.id) || syncedIds.isEmpty) {
            await _storage.markSynced(record.id);
            successCount++;
          }
        }
      } else {
        // Fall back to individual
        await _syncIndividually(pending, onSuccess: (n) => successCount += n,
            onFail: (n) => failCount += n);
      }
    } else {
      await _syncIndividually(pending, onSuccess: (n) => successCount += n,
          onFail: (n) => failCount += n);
    }

    isSyncing.value = false;
    lastSyncTime.value = DateTime.now();
    _updatePendingCount();

    if (successCount > 0 && failCount == 0) {
      lastSyncMessage.value = '$successCount record(s) synced ✓';
    } else if (failCount > 0) {
      lastSyncMessage.value = '$successCount synced, $failCount failed';
    }
  }

  Future<void> _syncIndividually(
    List<AttendanceModel> records, {
    required void Function(int) onSuccess,
    required void Function(int) onFail,
  }) async {
    for (final record in records) {
      final result = await _api.postAttendance(record);
      if (result.success) {
        final studentName =
            result.data?['student']?['name']?.toString();
        final className =
            result.data?['student']?['class']?.toString();
        await _storage.markSynced(record.id,
            studentName: studentName, className: className);
        onSuccess(1);
      } else {
        await _storage.markFailed(record.id);
        onFail(1);
      }
    }
  }

  Set<String> _extractSyncedIds(
      Map<String, dynamic>? data, List<AttendanceModel> records) {
    if (data == null) return {};
    final synced = data['synced_ids'];
    if (synced is List) return synced.map((e) => e.toString()).toSet();
    return {};
  }
}
