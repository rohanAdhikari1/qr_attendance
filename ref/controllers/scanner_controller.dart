import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/uuid.dart';

import '../models/attendance_model.dart';
import '../services/api_service.dart';
import '../services/connectivity_service.dart';
import '../services/lan_server_service.dart';
import '../services/local_storage_service.dart';
import '../services/student_cache_service.dart';
import '../utils/qr_parser.dart';
import 'sync_controller.dart';

enum ScanState { idle, scanning, success, duplicate, error, unknown }

class ScannedStudent {
  final String studentId;
  final String? name;
  final String? className;
  final DateTime timestamp;
  final SyncStatus syncStatus;
  final bool fromCache;

  const ScannedStudent({
    required this.studentId,
    this.name,
    this.className,
    required this.timestamp,
    required this.syncStatus,
    this.fromCache = false,
  });
}

class ScannerController extends GetxController {
  final LocalStorageService _storage;
  final ApiService _api;
  final ConnectivityService _connectivity;
  final SyncController _sync;
  final StudentCacheService _studentCache;
  final LanServerService _lanServer;

  ScannerController(
    this._storage,
    this._api,
    this._connectivity,
    this._sync,
    this._studentCache,
    this._lanServer,
  );

  final _uuid = const Uuid();

  final scanState = ScanState.idle.obs;
  final lastScanned = Rxn<ScannedStudent>();
  final errorMessage = ''.obs;
  final isFlashOn = false.obs;
  final isFrontCamera = false.obs;
  final isCameraActive = true.obs;
  final todayCount = 0.obs;
  final pendingCount = 0.obs;

  MobileScannerController? cameraController;
  bool _isCooldown = false;
  Timer? _cooldownTimer;
  Timer? _resetTimer;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
    _refreshStats();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    _cooldownTimer?.cancel();
    _resetTimer?.cancel();
    super.onClose();
  }

  void _initCamera() {
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: false,
      facing: CameraFacing.back,
    );
  }

  void _refreshStats() {
    todayCount.value = _storage.totalTodayCount;
    pendingCount.value = _storage.pendingCount;
  }

  Future<void> onQrDetected(BarcodeCapture capture) async {
    if (_isCooldown) return;
    if (scanState.value == ScanState.success ||
        scanState.value == ScanState.duplicate) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;
    await _processQr(barcode!.rawValue!);
  }

  Future<void> _processQr(String rawValue) async {
    _startCooldown();
    HapticFeedback.mediumImpact();

    final parsed = QrParser.parse(rawValue);
    if (!parsed.isValid) {
      scanState.value = ScanState.unknown;
      errorMessage.value = 'No student ID found in QR code';
      _scheduleReset();
      return;
    }

    final studentId = parsed.studentId!;

    // ── Duplicate check ───────────────────────────────────────────────────
    if (_storage.hasAttendanceToday(studentId)) {
      HapticFeedback.heavyImpact();
      final existing = _storage
          .getTodayAttendance()
          .firstWhere((r) => r.studentId == studentId);
      final cached = _studentCache.getCached(studentId);
      scanState.value = ScanState.duplicate;
      lastScanned.value = ScannedStudent(
        studentId: studentId,
        name: _best([cached?.name, existing.studentName, parsed.studentName]),
        className: _best([cached?.className, existing.className, parsed.className]),
        timestamp: existing.timestamp,
        syncStatus: existing.syncStatus,
        fromCache: cached != null,
      );
      _scheduleReset(delay: const Duration(seconds: 3));
      return;
    }

    // ── Step 1: Read from LOCAL CACHE — zero network, synchronous ─────────
    final cachedStudent = _studentCache.getCached(studentId);

    // ── Step 2: Save attendance to Hive — 100% offline ───────────────────
    final record = AttendanceModel(
      id: _uuid.v4(),
      studentId: studentId,
      timestamp: DateTime.now(),
      rawQrData: rawValue,
      studentName: _best([cachedStudent?.name, parsed.studentName]) ?? '',
      className: _best([cachedStudent?.className, parsed.className]) ?? '',
    );

    await _storage.saveAttendance(record);
    HapticFeedback.lightImpact();
    scanState.value = ScanState.success;

    lastScanned.value = ScannedStudent(
      studentId: studentId,
      name: record.studentName.isNotEmpty ? record.studentName : null,
      className: record.className.isNotEmpty ? record.className : null,
      timestamp: record.timestamp,
      syncStatus: SyncStatus.pending,
      fromCache: cachedStudent != null,
    );

    _refreshStats();

    // ── Step 3: Push to LAN live dashboard (local, instant) ──────────────
    _lanServer.pushScanEvent(record);

    // ── Step 4: Background network (only if online, non-blocking) ────────
    if (_connectivity.isOnline.value) {
      unawaited(_backgroundNetworkTasks(record, studentId));
    }

    _scheduleReset();
  }

  Future<void> _backgroundNetworkTasks(
      AttendanceModel record, String studentId) async {
    // Post attendance
    final apiResp = await _api.postAttendance(record);
    if (apiResp.success) {
      final serverName =
          (apiResp.data?['student'] as Map?)?['name']?.toString();
      final serverClass =
          (apiResp.data?['student'] as Map?)?['class']?.toString();
      await _storage.markSynced(record.id,
          studentName: serverName, className: serverClass);
    } else {
      await _storage.markFailed(record.id);
    }

    // Fetch + cache student info if not already fresh
    final cached = _studentCache.getCached(studentId);
    if (cached == null || !cached.isFresh) {
      final fresh = await _studentCache.resolve(studentId);
      if (fresh != null &&
          fresh.hasName &&
          lastScanned.value?.studentId == studentId) {
        lastScanned.value = ScannedStudent(
          studentId: studentId,
          name: fresh.name,
          className: fresh.className,
          timestamp: lastScanned.value!.timestamp,
          syncStatus:
              apiResp.success ? SyncStatus.synced : SyncStatus.pending,
          fromCache: false,
        );
        // Update LAN server with enriched info
        final updated = record.copyWith(
          studentName: fresh.name,
          className: fresh.className,
        );
        _lanServer.pushStatsUpdate();
      }
    }

    _refreshStats();
    _lanServer.pushStatsUpdate();
  }

  String? _best(List<String?> values) {
    for (final v in values) {
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }

  void _startCooldown({Duration duration = const Duration(seconds: 2)}) {
    _isCooldown = true;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer(duration, () => _isCooldown = false);
  }

  void _scheduleReset({Duration delay = const Duration(seconds: 4)}) {
    _resetTimer?.cancel();
    _resetTimer = Timer(delay, resetState);
  }

  void resetState() {
    scanState.value = ScanState.idle;
    errorMessage.value = '';
  }

  Future<void> toggleFlash() async {
    await cameraController?.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  Future<void> toggleCamera() async {
    await cameraController?.switchCamera();
    isFrontCamera.value = !isFrontCamera.value;
  }

  void pauseCamera() {
    cameraController?.stop();
    isCameraActive.value = false;
  }

  void resumeCamera() {
    cameraController?.start();
    isCameraActive.value = true;
  }
}
