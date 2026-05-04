import 'package:get/get.dart';
import 'package:qr_attendance/controllers/admin_pin_controller.dart';
import 'package:qr_attendance/controllers/camera_controller.dart';
import 'package:qr_attendance/controllers/scanner_clock_controller.dart';
import 'package:qr_attendance/controllers/scanner_controller.dart';

class ScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>AdminPinController());
    Get.lazyPut(()=>ScannerClockController());
    Get.lazyPut(()=>CameraController());
    Get.put(ScannerController());
  }
}