import 'dart:async';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/connectivity_service.dart';
import '../services/lan_server_service.dart';
import '../services/local_storage_service.dart';
import '../services/student_cache_service.dart';
import 'sync_controller.dart';

enum BulkLoadState { idle, loading, done, error }

class AdminController extends GetxController {
  final LocalStorageService _storage;
  final ApiService _api;
  final ConnectivityService _connectivity;
  final SyncController _sync;
  final StudentCacheService _studentCache;
  final LanServerService _lanServer;

  AdminController(
    this._storage,
    this._api,
    this._connectivity,
    this._sync,
    this._studentCache,
    this._lanServer,
  );

  // ── Bulk load state ────────────────────────────────────────────────────────
  final bulkLoadState = BulkLoadState.idle.obs;
  final bulkLoadProgress = 0.obs;   // students loaded so far
  final bulkLoadTotal = Rxn<int>(); // total on server (if known)
  final bulkLoadMessage = ''.obs;
  final cachedStudentCount = 0.obs;

  // ── Sync state ─────────────────────────────────────────────────────────────
  final isSyncing = false.obs;
  final syncMessage = ''.obs;
  final pendingCount = 0.obs;
  final failedCount = 0.obs;

  // ── LAN server state ──────────────────────────────────────────────────────
  RxBool get lanRunning => _lanServer.isRunning;
  RxString get lanIp => _lanServer.lanIp;
  RxInt get lanClients => _lanServer.connectedClients;
  String get dashboardUrl => _lanServer.dashboardUrl;

  // ── Settings (reactive wrappers) ──────────────────────────────────────────
  final apiUrl = ''.obs;
  final schoolName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _refreshCounts();
    apiUrl.value = _storage.apiBaseUrl;
    schoolName.value = _storage.schoolName;
  }

  void _refreshCounts() {
    pendingCount.value = _storage.getPendingAttendance().length;
    failedCount.value = _storage.getFailedAttendance().length;
    cachedStudentCount.value = _studentCache.cachedCount;
  }

  // ─── Bulk load all students from server ───────────────────────────────────
  //
  // Calls GET /api/students with pagination, caches every student locally.
  // After this runs once (on good internet), the app shows names/classes
  // even with zero connectivity.

  Future<void> loadAllStudents() async {
    if (bulkLoadState.value == BulkLoadState.loading) return;
    if (!_connectivity.isOnline.value) {
      bulkLoadMessage.value = 'No internet connection';
      return;
    }

    bulkLoadState.value = BulkLoadState.loading;
    bulkLoadProgress.value = 0;
    bulkLoadTotal.value = null;
    bulkLoadMessage.value = 'Connecting to server…';

    final result = await _api.fetchAllStudents(
      perPage: 100,
      onProgress: (loaded, total) {
        bulkLoadProgress.value = loaded;
        bulkLoadTotal.value = total;
        bulkLoadMessage.value = total != null
            ? 'Loading… $loaded / $total students'
            : 'Loaded $loaded students…';
      },
    );

    if (result.success && result.data != null) {
      final students = result.data!;
      // Cache all students locally
      for (final info in students) {
        await _studentCache.cacheFromInfo(info);
      }
      bulkLoadState.value = BulkLoadState.done;
      bulkLoadMessage.value = '✓ ${students.length} students cached locally';
      cachedStudentCount.value = _studentCache.cachedCount;
    } else {
      bulkLoadState.value = BulkLoadState.error;
      bulkLoadMessage.value = result.error ?? 'Failed to load students';
    }
  }

  // ─── Manual sync ──────────────────────────────────────────────────────────

  Future<void> syncNow() async {
    if (isSyncing.value) return;
    if (!_connectivity.isOnline.value) {
      syncMessage.value = 'No internet — records saved locally';
      return;
    }

    isSyncing.value = true;
    syncMessage.value = 'Syncing…';
    _refreshCounts();

    await _sync.syncPending();

    isSyncing.value = false;
    syncMessage.value = _sync.lastSyncMessage.value;
    _refreshCounts();
  }

  Future<void> retryFailed() async {
    await _storage.resetFailedToPending();
    _refreshCounts();
    await syncNow();
  }

  // ─── LAN server toggle ────────────────────────────────────────────────────

  Future<void> toggleLanServer() async {
    if (_lanServer.isRunning.value) {
      await _lanServer.stop();
    } else {
      await _lanServer.start();
    }
  }

  // ─── Settings ─────────────────────────────────────────────────────────────

  Future<void> saveSettings({
    required String url,
    required String apiKey,
    required String school,
    required String pin,
  }) async {
    await _storage.setApiBaseUrl(url);
    await _storage.setApiKey(apiKey);
    await _storage.setSchoolName(school);
    if (pin.length >= 4) await _storage.setAdminPin(pin);
    _api.refreshConfig();
    apiUrl.value = url;
    schoolName.value = school;
  }

  // ─── Cache management ─────────────────────────────────────────────────────

  Future<void> clearStudentCache() async {
    await _studentCache.clearCache();
    cachedStudentCount.value = 0;
    bulkLoadMessage.value = 'Cache cleared';
    bulkLoadState.value = BulkLoadState.idle;
  }

  void refresh() => _refreshCounts();
}
