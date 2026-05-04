import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/controllers/scanner_clock_controller.dart';
import 'package:qr_attendance/theme/app_theme.dart';

class ClockHeader extends GetView<ScannerClockController> {
  const ClockHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'ATTENDANCE SYSTEM',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 3,
            color: AppColors.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),

        Obx(
              () => Text(
            controller.timeString,
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: 4,
              height: 1,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: 4),

        Obx(
              () => Text(
            controller.nepaliDate,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Divider
        Container(
          width: 80,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.transparent,
              AppColors.divider,
              Colors.transparent,
            ]),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );;
  }
}
