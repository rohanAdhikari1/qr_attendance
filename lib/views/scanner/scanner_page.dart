import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/controllers/scanner_controller.dart';
import 'package:qr_attendance/theme/app_theme.dart';
import 'package:qr_attendance/views/scanner/widgets/camera_section.dart';
import 'package:qr_attendance/views/scanner/widgets/info_panel.dart';
import 'package:qr_attendance/views/scanner/widgets/top_bar.dart';

class ScannerPage extends GetView<ScannerController>{
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) controller.promptExit(context,dismissible: false);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              TopBar(),

              // ── Info Panel (top 40%) ─────────────────────────────────────
              Expanded(
                flex: 42,
                child: InfoPanel(),
              ),
              //
              // ── Camera + Overlay (bottom 58%) ────────────────────────────
              Expanded(
                flex: 58,
                child: CameraSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
