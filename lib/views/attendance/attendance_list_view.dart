import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/attendance_controller.dart';
import '../../controllers/sync_controller.dart';
import '../../models/attendance_model.dart';
import '../../theme/app_theme.dart';

class AttendanceListView extends StatelessWidget {
  const AttendanceListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttendanceController>();
    final sync = Get.find<SyncController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Attendance Records'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
        actions: [
          // Sync button
          Obx(() => IconButton(
                icon: sync.isSyncing.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.accent),
                      )
                    : const Icon(Icons.cloud_sync_rounded),
                tooltip: 'Sync pending',
                onPressed: sync.syncPending,
              )),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              controller.refresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Date picker + filter ───────────────────────────────────────────
          _FilterBar(controller: controller),

          // ── Sync status banner ────────────────────────────────────────────
          Obx(() {
            if (sync.lastSyncMessage.value.isEmpty) return const SizedBox.shrink();
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.surfaceVariant,
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 14, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text(sync.lastSyncMessage.value,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            );
          }),

          // ── Stats row ─────────────────────────────────────────────────────
          Obx(() => _StatsStrip(controller: controller)),

          // ── List ──────────────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              final records = controller.records;
              if (records.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_rounded,
                          size: 48, color: AppColors.textSecondary),
                      SizedBox(height: 12),
                      Text('No records found',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 15)),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: records.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _AttendanceRow(record: records[i]),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Bar ───────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final AttendanceController controller;
  const _FilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.surface,
      child: Column(
        children: [
          // Date picker row
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: controller.selectedDate.value,
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
                builder: (ctx, child) => Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppColors.primary,
                      surface: AppColors.cardBg,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) controller.loadForDate(picked);
            },
            child: Obx(() => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 16, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('EEEE, MMMM d, yyyy')
                            .format(controller.selectedDate.value),
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 13),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down_rounded,
                          color: AppColors.textSecondary),
                    ],
                  ),
                )),
          ),
          const SizedBox(height: 8),
          // Status filter chips
          Obx(() => Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: controller.filterStatus.value == null,
                    onTap: () => controller.setFilter(null),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Synced',
                    selected:
                        controller.filterStatus.value == SyncStatus.synced,
                    color: AppColors.success,
                    onTap: () => controller.setFilter(SyncStatus.synced),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Pending',
                    selected:
                        controller.filterStatus.value == SyncStatus.pending,
                    color: AppColors.warning,
                    onTap: () => controller.setFilter(SyncStatus.pending),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Failed',
                    selected:
                        controller.filterStatus.value == SyncStatus.failed,
                    color: AppColors.error,
                    onTap: () => controller.setFilter(SyncStatus.failed),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    this.color = AppColors.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withAlpha(40) : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ─── Stats Strip ──────────────────────────────────────────────────────────────

class _StatsStrip extends StatelessWidget {
  final AttendanceController controller;
  const _StatsStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Text(
            '${controller.records.length} records',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12),
          ),
          const Spacer(),
          Text(
            'Total today: ${controller.todayTotal} | Synced: ${controller.todaySynced}',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ─── Attendance Row ───────────────────────────────────────────────────────────

class _AttendanceRow extends StatelessWidget {
  final AttendanceModel record;
  const _AttendanceRow({required this.record});

  Color get _statusColor {
    switch (record.syncStatus) {
      case SyncStatus.synced: return AppColors.success;
      case SyncStatus.pending: return AppColors.warning;
      case SyncStatus.failed: return AppColors.error;
    }
  }

  String get _statusLabel {
    switch (record.syncStatus) {
      case SyncStatus.synced: return 'Synced';
      case SyncStatus.pending: return 'Pending';
      case SyncStatus.failed: return 'Failed';
    }
  }

  IconData get _statusIcon {
    switch (record.syncStatus) {
      case SyncStatus.synced: return Icons.cloud_done_rounded;
      case SyncStatus.pending: return Icons.schedule_rounded;
      case SyncStatus.failed: return Icons.cloud_off_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _statusColor.withAlpha(30),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                record.studentId.length >= 2
                    ? record.studentId.substring(0, 2).toUpperCase()
                    : record.studentId.toUpperCase(),
                style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.studentName.isNotEmpty
                      ? record.studentName
                      : 'Student',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'ID: ${record.studentId}',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                    if (record.className.isNotEmpty) ...[
                      const Text(
                        ' · ',
                        style: TextStyle(color: AppColors.divider),
                      ),
                      Text(
                        record.className,
                        style: const TextStyle(
                            color: AppColors.accent, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Time + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('hh:mm a').format(record.timestamp),
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_statusIcon, size: 10, color: _statusColor),
                    const SizedBox(width: 4),
                    Text(
                      _statusLabel,
                      style: TextStyle(
                        color: _statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
