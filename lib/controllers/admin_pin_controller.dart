import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/services/get_storage_service.dart';

class AdminPinController extends GetxController {
  final TextEditingController pinController = TextEditingController();
  final RxBool wrong = false.obs;
  final GetStorageService storage = Get.find<GetStorageService>();
  String get adminPin => storage.adminPin;

  void resetState() {
    wrong.value = false;
    pinController.clear();
  }

  void submit(VoidCallback onSuccess) {
    if (pinController.text == adminPin) {
      Get.back();
      onSuccess();
    } else {
      wrong.value = true;
      pinController.clear();
    }
  }

  @override
  void onClose() {
    pinController.dispose();
    super.onClose();
  }
}