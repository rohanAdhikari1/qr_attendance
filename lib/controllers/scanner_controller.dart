import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_attendance/data/enums.dart';
import 'package:qr_attendance/data/models/scanned_student.dart';
import 'package:qr_attendance/views/scanner/widgets/admin_pin_dialog.dart';
import 'package:uuid/uuid.dart';

class ScannerController extends GetxController {
  final _uuid = const Uuid();
  MobileScannerController cameraController = MobileScannerController();

  final scanState = ScanState.idle.obs;
  final lastScanned = Rxn<ScannedStudent>();
  final errorMessage = ''.obs;
  final isFlashOn = false.obs;
  final isFrontCamera = false.obs;
  final isCameraActive = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
    lastScanned.value = ScannedStudent(studentId: '123', timestamp: DateTime.now(), syncStatus: SyncStatus.synced);
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  void _initCamera() {
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: false,
      facing: CameraFacing.front,
    );
  }

  void resetState() {
    scanState.value = ScanState.idle;
    errorMessage.value = '';
  }

  Future<void> toggleFlash() async {
    await cameraController.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  Future<void> toggleCamera() async {
    await cameraController.switchCamera();
    isFrontCamera.value = !isFrontCamera.value;
  }

  void pauseCamera() {
    cameraController.stop();
    isCameraActive.value = false;
  }

  void resumeCamera() {
    cameraController.start();
    isCameraActive.value = true;
  }

  void promptExit(BuildContext context,{bool dismissible=true}){
    pauseCamera();
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => AdminPinDialog(onDismiss: resumeCamera),
    );
  }
}
