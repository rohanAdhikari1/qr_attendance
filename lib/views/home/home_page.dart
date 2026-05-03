import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance/theme/app_theme.dart';
import 'package:qr_attendance/views/home/widgets/header.dart';
import 'package:qr_attendance/views/home/widgets/quick_actions.dart';
import 'package:qr_attendance/views/home/widgets/scan_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(),
                const SizedBox(height: 28),

                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Today's Attendance",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                ScanButton(),
                const SizedBox(height: 24),
                QuickActions(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        )
    );
  }
}
