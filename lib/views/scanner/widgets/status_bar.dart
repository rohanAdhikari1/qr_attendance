import 'package:get/get.dart';
import 'package:qr_attendance/controllers/scanner_clock_controller.dart';
import 'package:qr_attendance/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StatusBar extends GetView<ScannerClockController> {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
                () => Text(
              controller.shortTime,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            children: [
              for (int i = 0; i < 3; i++)
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(left: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent
                        .withValues(alpha: 1.0 - i * 0.35),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.wifi, size: 14, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}