import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_attendance/theme/app_theme.dart';
import 'package:qr_attendance/controllers/scanner_controller.dart';
import 'package:qr_attendance/data/enums.dart';

class CameraSection extends GetView<ScannerController> {
  const CameraSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Camera feed
          Positioned.fill(
            child: MobileScanner(
              controller: controller.cameraController,
              onDetect: controller.onQrDetected,
            ),
          ),

          Positioned.fill(
            child: CustomPaint(
              painter: _OverlayPainter(windowSize: 220),
            ),
          ),

          Center(
            child: Obx(() => _scanFrame(controller.scanState.value)),
          ),
        ],
      ),
    );
  }

  Widget _scanFrame(ScanState state) {
    final Color color = switch (state) {
      ScanState.success => AppColors.success,
      ScanState.duplicate => AppColors.warning,
      ScanState.error || ScanState.unknown => AppColors.error,
      _ => AppColors.scannerBorder,
    };

    return SizedBox(
      width: 220,
      height: 220,
      child: CustomPaint(
        painter: _CornerPainter(color: color),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fadeIn(duration: 600.ms);
  }
}

class _OverlayPainter extends CustomPainter {
  final double windowSize;
  _OverlayPainter({required this.windowSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withAlpha(150);
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: windowSize,
      height: windowSize,
    );
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path()
      ..addRect(fullRect)
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CornerPainter extends CustomPainter {
  final Color color;
  _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 28.0;
    const r = 10.0;

    // Top-left
    canvas.drawPath(
        Path()
          ..moveTo(r, 0)
          ..lineTo(len, 0)
          ..moveTo(0, r)
          ..lineTo(0, len)
          ..moveTo(0, r)
          ..arcToPoint(Offset(r, 0),
              radius: const Radius.circular(r), clockwise: true),
        paint);

    // Top-right
    canvas.drawPath(
        Path()
          ..moveTo(size.width - len, 0)
          ..lineTo(size.width - r, 0)
          ..arcToPoint(Offset(size.width, r),
              radius: const Radius.circular(r), clockwise: true)
          ..lineTo(size.width, len),
        paint);

    // Bottom-left
    canvas.drawPath(
        Path()
          ..moveTo(0, size.height - len)
          ..lineTo(0, size.height - r)
          ..arcToPoint(Offset(r, size.height),
              radius: const Radius.circular(r), clockwise: false)
          ..lineTo(len, size.height),
        paint);

    // Bottom-right
    canvas.drawPath(
        Path()
          ..moveTo(size.width - len, size.height)
          ..lineTo(size.width - r, size.height)
          ..arcToPoint(Offset(size.width, size.height - r),
              radius: const Radius.circular(r), clockwise: false)
          ..lineTo(size.width, size.height - len),
        paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => old.color != color;
}