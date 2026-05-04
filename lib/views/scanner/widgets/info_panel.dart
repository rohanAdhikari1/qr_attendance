import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance/controllers/scanner_controller.dart';
import 'package:qr_attendance/data/enums.dart';
import 'package:qr_attendance/data/models/scanned_student.dart';
import 'package:qr_attendance/views/scanner/widgets/idle_panel.dart';
import 'package:qr_attendance/theme/app_theme.dart';

class InfoPanel extends GetView<ScannerController> {
  const InfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.scanState.value;
      final student = controller.lastScanned.value;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildContent(state, student, context),
      );
    });
  }

  Widget _buildContent(
      ScanState state, ScannedStudent? student, BuildContext context) {
    // switch (state) {
    //   case ScanState.idle:
    //     return IdlePanel(key: const ValueKey('idle'));


    //   case ScanState.scanning:
    // return const Center(
    //   child: CircularProgressIndicator(color: AppColors.accent),
    // );
    //
    //   case ScanState.success:
        return _StudentCard(
          key: const ValueKey('success'),
          student: student!,
          state: ScanState.success,
        );
    //
    //   case ScanState.duplicate:
    //     return _StudentCard(
    //       key: const ValueKey('duplicate'),
    //       student: student!,
    //       state: ScanState.duplicate,
    //     );
    //
    //   case ScanState.error:
    //   case ScanState.unknown:
    //     return _ErrorPanel(
    //       key: const ValueKey('error'),
    //       message: scanner.errorMessage.value,
    //     );
    // }
  }
}

class _StudentCard extends StatelessWidget {
  final ScannedStudent student;
  final ScanState state;

  const _StudentCard({super.key, required this.student, required this.state});

  bool get isSuccess => state == ScanState.success;

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? AppColors.success : AppColors.warning;
    final label = isSuccess ? 'Attendance Marked' : 'Already Marked Today';
    final icon = isSuccess ? Icons.check_circle_rounded : Icons.warning_rounded;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Status icon + label
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                    color: color, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 16),
          // Student ID (large)
          Text(
            student.studentId,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3),
          if (student.name?.isNotEmpty == true) ...[
            const SizedBox(height: 6),
            Text(
              student.name!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(delay: 150.ms),
          ],
          if (student.className?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(40),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                student.className!,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),
          ],
          const SizedBox(height: 12),
          // Time + sync
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                DateFormat('hh:mm:ss a').format(student.timestamp),
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(width: 12),
              _SyncDot(status: student.syncStatus),
            ],
          ).animate().fadeIn(delay: 250.ms),
        ],
      ),
    );
  }
}

class _SyncDot extends StatelessWidget {
  final SyncStatus status;
  const _SyncDot({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case SyncStatus.synced:
        color = AppColors.success;
        label = 'Synced';
        break;
      case SyncStatus.pending:
        color = AppColors.warning;
        label = 'Pending sync';
        break;
      case SyncStatus.failed:
        color = AppColors.error;
        label = 'Sync failed';
        break;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}
