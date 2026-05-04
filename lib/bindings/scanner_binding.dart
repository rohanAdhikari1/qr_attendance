import 'package:get/get.dart';
import 'package:qr_attendance/controllers/admin_pin_controller.dart';
import 'package:qr_attendance/controllers/scanner_controller.dart';

class ScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>AdminPinController());
    Get.put(ScannerController());
  }
}