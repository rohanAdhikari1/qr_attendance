import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/controllers/camera_controller.dart';
import 'package:qr_attendance/controllers/corner_painter.dart';
import 'package:qr_attendance/theme/app_theme.dart';

class ScannerBox extends GetView<CameraController> {
  const ScannerBox({super.key});

  static const _boxSize = 240.0;
  static const _beamTravel = _boxSize - 24.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _boxSize,
      height: _boxSize,
      child: Stack(
        children: [
          // ── Camera / QR feed ─────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              color: AppColors.surface,
              child: const Center(
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 72,
                  color: AppColors.surfaceVariant,
                ),
              ),
            ),
          ),

          // ── Scan beam ────────────────────────────────────────────────────
          // Obx(() {
          //   // if (controller.showSuccess || controller.showError) {
          //   //   return const SizedBox.shrink();
          //   // }
          //
          //   return
              AnimatedBuilder(
              animation: controller.beamAnim,
              builder: (_, __) {
                final top = 8 + controller.beamAnim.value * _beamTravel;

                return Positioned(
                  top: top,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.accent.withValues(alpha: 0.08),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Colors.transparent,
                            AppColors.accent,
                            Colors.transparent,
                          ]),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.6),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
    // ;
    //       })
  ,

          // Obx(() {
            // final errorType = controller.activeError.value;
            //
            // final Color baseColor = errorType == null
            //     ? AppColors.scannerBorder
            //     : errorType == ScanErrorType.alreadyMarked
            //     ? AppColors.warning
            //     : AppColors.error;

            // final Color baseColor = AppColors.scannerBorder;

            // return
              AnimatedBuilder(
              animation: controller.cornerAlpha,
              builder: (_, __) => CustomPaint(
                painter: CornerPainter(
                  color:  AppColors.scannerBorder.withValues(
                    // alpha: controller.showError ? controller.cornerAlpha.value : 1.0,
                    alpha: 1.0,
                  ),
                ),
                child: const SizedBox.expand(),
              ),
            )
    // ;
    //       })
  ,
        ],
      ),
    );
  }
}