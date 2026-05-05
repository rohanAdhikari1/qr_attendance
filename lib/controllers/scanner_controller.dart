import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_attendance/data/enums.dart';
import 'package:qr_attendance/data/models/scanned_student.dart';
import 'package:qr_attendance/services/get_storage_service.dart';
import 'package:qr_attendance/views/scanner/widgets/admin_pin_dialog.dart';
import 'package:uuid/uuid.dart';

class ScannerController extends GetxController {
  MobileScannerController cameraController = MobileScannerController();
  final _storage = Get.find<GetStorageService>();
  final isFlashOn = false.obs;
  String? _lastScanned;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
    lastScanned.value = ScannedStudent(studentId: '123', timestamp: DateTime.now(), syncStatus: SyncStatus.synced);
  }

  void _initCamera() {
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: false,
      facing: _storage.cameraView,
    );
  }

  Future<void> toggleFlash() async {
    await cameraController.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  void pauseCamera() {
    cameraController.stop();
  }

  void resumeCamera() {
    cameraController.start();
  }

  void onQrDetected(BarcodeCapture capture) async{
    final value = capture.barcodes.firstOrNull?.rawValue;
    print(value);
    if (value == _lastScanned) return;
    _lastScanned = value;
    // Future.delayed(const Duration(seconds: 2), () {
    //   _lastScanned = null;
    // });
    await _processQr(value!);
  }

  Future<void> _processQr(String value) async{
    bool randomValue = Random().nextBool();
    if(randomValue){
      showFakeSuccessOverlay();
    }
  }

























  final _uuid = const Uuid();


  final Map<String, dynamic> fakeStudent = {
    "name": "John Doe",
    "studentId": "ST-2026-001",
    "classSection": "10-A",
    "status": "Present",
    "subject": "Mathematics",
    "room": "Room 12",
    "checkInTime": "08:42 AM",
  };
  var scannedStudent = Rxn<Map<String, dynamic>>();

  var overlayCountdown = 5.obs;

  final scanState = ScanState.idle.obs;
  final lastScanned = Rxn<ScannedStudent>();
  final errorMessage = ''.obs;



  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  void showFakeSuccessOverlay() {
    scannedStudent.value = fakeStudent;

    overlayCountdown.value = 5;

    Future.delayed(const Duration(seconds: 5), () {
      scannedStudent.value = null;
    });
  }


  void resetState() {
    scanState.value = ScanState.idle;
    errorMessage.value = '';
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
