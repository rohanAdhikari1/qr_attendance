import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/controllers/scanner_controller.dart';
import 'package:qr_attendance/theme/app_theme.dart';

class TopBar extends GetView<ScannerController> {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Back (admin)
          GestureDetector(
            onTap: () {
              controller.promptExit(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.lock, size: 18, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 12),
          // Title + stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'QR Scanner',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Obx(() => Text(
                //   'Today: ${scanner.todayCount.value} scanned',
                //   style: const TextStyle(
                //       color: AppColors.textSecondary, fontSize: 12),
                // )),
              ],
            ),
          ),
          // Connectivity dot
          // Obx(() => _ConnectivityBadge(isOnline: connectivity.isOnline.value)),
          const SizedBox(width: 8),
          // Sync badge
          // Obx(() {
          //   if (sync.pendingCount.value == 0) return const SizedBox.shrink();
          //   return _SyncBadge(
          //     count: sync.pendingCount.value,
          //     isSyncing: sync.isSyncing.value,
          //   );
          // }),
          const SizedBox(width: 8),
          // Flash toggle
          GestureDetector(
            onTap: (){},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:  AppColors.accent.withAlpha(40),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.flash_off_rounded,
                size: 18,
                color:AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
