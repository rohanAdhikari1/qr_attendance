import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/theme/app_theme.dart';
import 'package:qr_attendance/views/admin/widgets/lan_server_card.dart';
import 'package:qr_attendance/views/admin/widgets/settings_card.dart';
import 'package:qr_attendance/views/admin/widgets/student_cache_card.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Panel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            // ctrl.refresh();
            Get.back();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Student Cache Loader ───────────────────────────────────────────
          StudentCacheCard(),
          const SizedBox(height: 16),

          // ── Sync Panel ────────────────────────────────────────────────────
          // _SyncCard(),
          const SizedBox(height: 16),

          // ── LAN Live Server ───────────────────────────────────────────────
          LanServerCard(),
          const SizedBox(height: 16),

          // ── Settings ──────────────────────────────────────────────────────
          SettingsCard(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
