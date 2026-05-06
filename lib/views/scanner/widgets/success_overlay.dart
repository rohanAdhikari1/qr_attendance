import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/controllers/scanner_controller.dart';
import 'package:qr_attendance/controllers/success_overlay_controller.dart';
import 'package:qr_attendance/data/enums.dart';
import 'package:qr_attendance/theme/app_theme.dart';
import 'package:qr_attendance/views/scanner/widgets/ripple_icon.dart';

class SuccessOverlay extends StatelessWidget {
  SuccessOverlay({super.key});

  final ctrl = Get.put(SuccessOverlayController());
  final scannerCtrl = Get.find<ScannerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final student = scannerCtrl.scannedStudent.value;
      final isSuccess = scannerCtrl.scanState.value == ScanState.success;
      if (student == null || !isSuccess) return const SizedBox.shrink();

      return AnimatedBuilder(
        animation: ctrl.fadeCtrl,
        builder: (_, __) {
          return FadeTransition(
            opacity: ctrl.fadeAnim,
            child: Container(
              color: AppColors.background.withValues(alpha: 0.94),
              child: SafeArea(
                child: SlideTransition(
                  position: ctrl.slideAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RippleIcon(ctrl: ctrl),
                      const SizedBox(height: 18),
                      const Text(
                        'MARKED IN',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        student["name"] ?? "",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        '${student["studentId"]} · ${student["classSection"]}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildInfoCard(student),

                      const SizedBox(height: 22),

                      Obx(() => Text(
                        'Returning to scanner in ${scannerCtrl.overlayCountdown.value}s...',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0x66B0BAD0),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildInfoCard(student) {
    final isLate = student["status"] == "Late";

    final rows = [
      ("Check-in", student["checkInTime"] ?? "", AppColors.success),
      ("Status", student["status"] ?? "", AppColors.success),
      ("Subject", student["subject"] ?? "", AppColors.textPrimary),
      ("Room", student["room"] ?? "", AppColors.textPrimary),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.28),
          ),
        ),
        child: Column(
          children: [
            for (int i = 0; i < rows.length; i++) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(rows[i].$1,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  Text(rows[i].$2,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: rows[i].$3,
                      )),
                ],
              ),
              if (i < rows.length - 1)
                const Divider(color: AppColors.divider),
              const SizedBox(height: 8),
            ]
          ],
        ),
      ),
    );
  }
}