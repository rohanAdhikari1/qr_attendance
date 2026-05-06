import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_attendance/data/enums.dart';
import 'package:qr_attendance/data/models/scanned_student.dart';
import 'package:qr_attendance/services/get_storage_service.dart';
import 'package:qr_attendance/views/scanner/widgets/admin_pin_dialog.dart';

class ScannerController extends GetxController {
  MobileScannerController cameraController = MobileScannerController();
  final _storage = Get.find<GetStorageService>();
  final scanState = ScanState.idle.obs;
  final isFlashOn = false.obs;
  String? _lastScanned;
  final scannedStudent = Rxn<ScannedStudent>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  void _initCamera() {
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: false,
      autoZoom: true,
      invertImage: false,
      // facing: _storage.cameraView,
      facing: CameraFacing.back,
      formats: [BarcodeFormat.qrCode],

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

  void onQrDetected(BarcodeCapture capture) {
    final value = capture.barcodes.firstOrNull?.rawValue;
    if (value == _lastScanned) return;
    _lastScanned = value;
    // Future.delayed(const Duration(seconds: 2), () {
    //   _lastScanned = null;
    // });
    _processQr(value!);
  }

  Future<void> _processQr(String value) async{
    HapticFeedback.mediumImpact();
    scanState.value = ScanState.scanning;
    //now parse value get detail of student
    //search for student id got studentId otherwise show unsupported qr error
    //search for student with student_id
    // if(found){
      //save attendance
    // }else{
    await Future.delayed(5.seconds);
    scanState.value=ScanState.error;
    errorMessage.value="Checking for error overlay";
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

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }























  final Map<String, dynamic> fakeStudent = {
    "name": "John Doe",
    "studentId": "ST-2026-001",
    "classSection": "10-A",
    "status": "Present",
    "subject": "Mathematics",
    "room": "Room 12",
    "checkInTime": "08:42 AM",
  };

  var overlayCountdown = 5.obs;


  void showFakeSuccessOverlay() {
    // scannedStudent.value = fakeStudent;

    overlayCountdown.value = 5;

    Future.delayed(const Duration(seconds: 5), () {
      scannedStudent.value = null;
    });
  }

}
