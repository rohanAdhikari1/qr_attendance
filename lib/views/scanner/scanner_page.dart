import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/theme/app_theme.dart';
import 'package:qr_attendance/views/scanner/widgets/top_bar.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) Get.back();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              TopBar(),

              // ── Info Panel (top 40%) ─────────────────────────────────────
              // Expanded(
              //   flex: 42,
              //   child: _InfoPanel(scanner: scanner),
              // ),
              //
              // // ── Camera + Overlay (bottom 58%) ────────────────────────────
              // Expanded(
              //   flex: 58,
              //   child: _CameraSection(scanner: scanner),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
