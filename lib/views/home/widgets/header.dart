import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/routes/app_pages.dart';
import 'package:qr_attendance/theme/app_theme.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.school_rounded, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'School Name',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Text(
                'Attendance System',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () => Get.toNamed(AppRoutes.admin),
          icon: const Icon(Icons.admin_panel_settings_rounded,
              color: AppColors.textSecondary, size: 22),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.success.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
               'Online',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Obx(() => Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //   decoration: BoxDecoration(
        //     color: (connectivity.isOnline.value
        //         ? AppColors.success
        //         : AppColors.error)
        //         .withAlpha(25),
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Container(
        //         width: 6,
        //         height: 6,
        //         decoration: BoxDecoration(
        //           color: connectivity.isOnline.value
        //               ? AppColors.success
        //               : AppColors.error,
        //           shape: BoxShape.circle,
        //         ),
        //       ),
        //       const SizedBox(width: 5),
        //       Text(
        //         connectivity.isOnline.value ? 'Online' : 'Offline',
        //         style: TextStyle(
        //           color: connectivity.isOnline.value
        //               ? AppColors.success
        //               : AppColors.error,
        //           fontSize: 11,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //     ],
        //   ),
        // )),
      ],
    );
  }
}
