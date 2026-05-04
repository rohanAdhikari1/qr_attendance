import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/controllers/scanner_controller.dart';
import 'package:qr_attendance/theme/app_theme.dart';
import 'package:qr_attendance/views/scanner/widgets/hint_card.dart';
import 'package:qr_attendance/views/scanner/widgets/scanner_box.dart';
import 'package:qr_attendance/views/scanner/widgets/clock_header.dart';
import 'package:qr_attendance/views/scanner/widgets/grind_background.dart';
import 'package:qr_attendance/views/scanner/widgets/status_bar.dart';
import 'package:qr_attendance/views/scanner/widgets/top_bar.dart';

class ScannerPage extends GetView<ScannerController> {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) controller.promptExit(context, dismissible: false);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            const GridBackground(),
            StatusBar(),
            SafeArea(
              child: Column(
                children: [
                  TopBar(),
                  SizedBox(height: 10),
                  ClockHeader(),
                  const Column(
                    children: [
                      Text(
                        'Hold your QR code to the camera',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Position within the frame below',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const ScannerBox(),
                  const SizedBox(height: 28),
                  const HintCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
