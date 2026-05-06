import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_attendance/controllers/camera_controller.dart';
import 'package:qr_attendance/controllers/corner_painter.dart';
import 'package:qr_attendance/controllers/scanner_controller.dart';
import 'package:qr_attendance/data/enums.dart';
import 'package:qr_attendance/theme/app_theme.dart';

class ScannerBox extends GetView<CameraController> {
  const ScannerBox({super.key});
  ScannerController get scanner => GetInstance().find<ScannerController>();

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
              child: Center(
                child: MobileScanner(
                  controller: scanner.cameraController,
                  onDetect:scanner.onQrDetected,
                ),
              ),
            ),
          ),

          // ── Scan beam ────────────────────────────────────────────────────
          Obx(() {
            var state = scanner.scanState.value;
            if ( state!=ScanState.idle) {
              return const SizedBox.shrink();
            }

            return
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
            );
          }),

          Obx(() {
            final scanState = scanner.scanState.value;
            Color baseColor = AppColors.scannerBorder;
            if(scanState == ScanState.scanning){
              baseColor = AppColors.primary;
            }
            if(scanState == ScanState.success){
              baseColor = AppColors.success;
            }
            if(scanState == ScanState.error){
              baseColor = AppColors.error;
            }
            if(scanState == ScanState.duplicate){
              baseColor=AppColors.warning;
            }
            final isError = scanState == ScanState.error;
            return AnimatedBuilder(
              animation: controller.cornerAlpha,
              builder: (_, __) => CustomPaint(
                painter: CornerPainter(
                  color:  baseColor.withValues(
                    alpha: isError ? controller.cornerAlpha.value : 1.0,
                  ),
                ),
                child: const SizedBox.expand(),
              ),
            );
          }),
        ],
      ),
    );
  }
}