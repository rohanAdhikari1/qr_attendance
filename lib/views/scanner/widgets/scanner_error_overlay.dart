import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/controllers/scanner_controller.dart';
import 'package:qr_attendance/data/enums.dart';

class ScannerErrorOverlay extends GetView<ScannerController> {
  const ScannerErrorOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final error = controller.activeError.value;

      if (error == null) {
        return const SizedBox.shrink();
      }

      final isWarning = error == ScanErrorType.alreadyMarked;

      final color = isWarning
          ? const Color(0xFFFFB020)
          : const Color(0xFFFF5A5F);

      return AnimatedPositioned(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        left: 16,
        right: 16,
        bottom: 18,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: 0.25),
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 18,
                  offset: Offset(0, 6),
                  color: Color(0x22000000),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ───── ICON ─────

                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _icon(error),
                    color: color,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 14),

                // ───── CONTENT ─────

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title(error),
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        _message(error),
                        style: const TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                                  () => Text(
                                'Closing in ${controller.overlayCountdown.value}s',
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: controller.dismissError,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Dismiss',
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ───────────────── HELPERS ─────────────────

  IconData _icon(ScanErrorType type) {
    switch (type) {
      case ScanErrorType.invalidQr:
        return Icons.qr_code_rounded;

      case ScanErrorType.studentNotFound:
        return Icons.person_off_rounded;

      case ScanErrorType.alreadyMarked:
        return Icons.info_outline_rounded;
    }
  }

  String _title(ScanErrorType type) {
    switch (type) {
      case ScanErrorType.invalidQr:
        return 'Invalid QR Code';

      case ScanErrorType.studentNotFound:
        return 'Student Not Found';

      case ScanErrorType.alreadyMarked:
        return 'Already Marked';
    }
  }

  String _message(ScanErrorType type) {
    switch (type) {
      case ScanErrorType.invalidQr:
        return 'This QR code is not recognized.';

      case ScanErrorType.studentNotFound:
        return 'No student record exists for this QR.';

      case ScanErrorType.alreadyMarked:
        return "On Progress";
        // return controller.alreadyMarkedInfo.value?.studentName != null
        //     ? '${controller.alreadyMarkedInfo.value!.studentName} already checked in.'
        //     : 'Attendance already marked.';
    }
  }
}