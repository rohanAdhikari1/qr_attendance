import 'package:flutter/material.dart';

class CornerPainter extends CustomPainter {
  final Color color;
  final double cornerSize;
  final double strokeWidth;

  const CornerPainter({
    required this.color,
    this.cornerSize = 26,
    this.strokeWidth = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cs = cornerSize;
    const r = 6.0;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, cs)
        ..lineTo(0, r)
        ..arcToPoint(Offset(r, 0), radius: const Radius.circular(r))
        ..lineTo(cs, 0),
      paint,
    );
    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cs, 0)
        ..lineTo(size.width - r, 0)
        ..arcToPoint(Offset(size.width, r), radius: const Radius.circular(r))
        ..lineTo(size.width, cs),
      paint,
    );
    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cs)
        ..lineTo(0, size.height - r)
        ..arcToPoint(Offset(r, size.height), radius: const Radius.circular(r))
        ..lineTo(cs, size.height),
      paint,
    );
    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cs, size.height)
        ..lineTo(size.width - r, size.height)
        ..arcToPoint(
          Offset(size.width, size.height - r),
          radius: const Radius.circular(r),
        )
        ..lineTo(size.width, size.height - cs),
      paint,
    );
  }

  @override
  bool shouldRepaint(CornerPainter old) =>
      old.color != color ||
          old.cornerSize != cornerSize ||
          old.strokeWidth != strokeWidth;
}