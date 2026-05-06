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

      return SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          constraints: const BoxConstraints(
            maxWidth: 420,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.withOpacity(0.25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _icon(error),
                  color: color,
                  size: 26,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _title(error),
                      style: TextStyle(
                        color: color,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _message(error),
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Obx(
                              () => Text(
                            '${controller.overlayCountdown.value}s',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const Spacer(),

                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: controller.dismissError,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Dismiss',
                              style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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
      );
    });
  }

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
        return 'Attendance already in progress.';
    }
  }
}