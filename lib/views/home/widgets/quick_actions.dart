import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/routes/app_pages.dart';
import 'package:qr_attendance/theme/app_theme.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ActionTile(
          icon: Icons.list_alt_rounded,
          label: 'View Records',
          onTap: () => Get.toNamed(AppRoutes.attendance),
        ),),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionTile(
            icon:  Icons.cloud_upload_rounded,
            label: 'Sync Now',
            onTap: null,
            isLoading: false,
          )),
        // Expanded(
        //   child: Obx(() => _ActionTile(
        //     icon: sync.isSyncing.value
        //         ? Icons.sync_rounded
        //         : Icons.cloud_upload_rounded,
        //     label: sync.isSyncing.value ? 'Syncing…' : 'Sync Now',
        //     onTap: connectivity.isOnline.value
        //         ? sync.syncPending
        //         : null,
        //     isLoading: sync.isSyncing.value,
        //   )),
        // ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const _ActionTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: disabled
                ? AppColors.divider
                : AppColors.primary.withAlpha(60),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            if (isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.accent),
              )
            else
              Icon(icon,
                  color:
                  disabled ? AppColors.textSecondary : AppColors.accent,
                  size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color:
                  disabled ? AppColors.textSecondary : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
