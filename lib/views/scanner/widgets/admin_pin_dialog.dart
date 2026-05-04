import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/controllers/admin_pin_controller.dart';
import 'package:qr_attendance/theme/app_theme.dart';

class AdminPinDialog extends GetView<AdminPinController> {
  final VoidCallback onDismiss;

  const AdminPinDialog({
    super.key,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    controller.resetState();
    return AlertDialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.lock_outline,
            color: AppColors.accent,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Admin Access',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
      content: Obx(
            () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              autofocus: true,
              maxLength: 6,
              style: const TextStyle(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Enter PIN',
                counterText: '',
                errorText:
                controller.wrong.value ? 'Incorrect PIN' : null,
              ),
              onSubmitted: (_) {
                controller.submit(() {
                  Get.back();
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            onDismiss();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            controller.submit(() {
              Get.back();
            });
          },
          child: const Text('Unlock'),
        ),
      ],
    );
  }
}