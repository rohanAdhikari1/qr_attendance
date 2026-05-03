import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/sync_controller.dart';
import '../../routes/app_pages.dart';
import '../../services/connectivity_service.dart';
import '../../services/local_storage_service.dart';
import '../../theme/app_theme.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<LocalStorageService>();
    final sync = Get.find<SyncController>();
    final connectivity = Get.find<ConnectivityService>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────────────────────────
                _Header(storage: storage, connectivity: connectivity),
                const SizedBox(height: 28),

                // ── Date ─────────────────────────────────────────────────────
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

                // ── Stats Row ─────────────────────────────────────────────────
                _StatsRow(storage: storage, sync: sync),
                const SizedBox(height: 28),

                // ── Big Scan Button ───────────────────────────────────────────
                _ScanButton(),
                const SizedBox(height: 24),

                // ── Quick Actions ─────────────────────────────────────────────
                _QuickActions(sync: sync, connectivity: connectivity),
                const SizedBox(height: 24),

                // ── Recent Scans ──────────────────────────────────────────────
                _RecentScans(storage: storage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final LocalStorageService storage;
  final ConnectivityService connectivity;

  const _Header({required this.storage, required this.connectivity});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // School logo / icon
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
                    storage.schoolName,
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
        // Admin panel
        IconButton(
          onPressed: () => Get.toNamed(AppRoutes.admin),
          icon: const Icon(Icons.admin_panel_settings_rounded,
              color: AppColors.textSecondary, size: 22),
        ),
        // Connectivity indicator
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: (connectivity.isOnline.value
                        ? AppColors.success
                        : AppColors.error)
                    .withAlpha(25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: connectivity.isOnline.value
                          ? AppColors.success
                          : AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    connectivity.isOnline.value ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: connectivity.isOnline.value
                          ? AppColors.success
                          : AppColors.error,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final LocalStorageService storage;
  final SyncController sync;

  const _StatsRow({required this.storage, required this.sync});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Total',
                value: '${storage.totalTodayCount}',
                icon: Icons.people_rounded,
                color: AppColors.accent,
                delay: 0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Synced',
                value: '${storage.syncedTodayCount}',
                icon: Icons.cloud_done_rounded,
                color: AppColors.success,
                delay: 100,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Pending',
                value: '${sync.pendingCount.value}',
                icon: Icons.sync_rounded,
                color: sync.pendingCount.value > 0
                    ? AppColors.warning
                    : AppColors.textSecondary,
                delay: 200,
              ),
            ),
          ],
        ));
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final int delay;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(40), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.2);
  }
}

// ─── Scan Button ──────────────────────────────────────────────────────────────

class _ScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.scanner),
      child: Container(
        width: double.infinity,
        height: 72,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryDark, AppColors.primary, AppColors.accent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(80),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 28),
            SizedBox(width: 14),
            Text(
              'Start Scanning',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shimmer(
              duration: 2500.ms,
              color: Colors.white.withAlpha(30),
              angle: 0.3),
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  final SyncController sync;
  final ConnectivityService connectivity;

  const _QuickActions({required this.sync, required this.connectivity});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            icon: Icons.list_alt_rounded,
            label: 'View Records',
            onTap: () => Get.toNamed(AppRoutes.attendance),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() => _ActionTile(
                icon: sync.isSyncing.value
                    ? Icons.sync_rounded
                    : Icons.cloud_upload_rounded,
                label: sync.isSyncing.value ? 'Syncing…' : 'Sync Now',
                onTap: connectivity.isOnline.value
                    ? sync.syncPending
                    : null,
                isLoading: sync.isSyncing.value,
              )),
        ),
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

// ─── Recent Scans ─────────────────────────────────────────────────────────────

class _RecentScans extends StatelessWidget {
  final LocalStorageService storage;
  const _RecentScans({required this.storage});

  @override
  Widget build(BuildContext context) {
    final recent = storage.getTodayAttendance().take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Scans',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.attendance),
              child: const Text(
                'View all →',
                style: TextStyle(color: AppColors.accent, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (recent.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                'No scans yet today',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ),
          )
        else
          ...recent.asMap().entries.map((e) => _RecentItem(
                record: e.value,
                index: e.key,
              )),
      ],
    );
  }
}

class _RecentItem extends StatelessWidget {
  final dynamic record; // AttendanceModel
  final int index;

  const _RecentItem({required this.record, required this.index});

  @override
  Widget build(BuildContext context) {
    final isSynced = record.syncStatus.index == 1;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                record.studentId.substring(0, 2).toUpperCase(),
                style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.studentName.isNotEmpty
                      ? record.studentName
                      : 'Student ${record.studentId}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'ID: ${record.studentId}',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('hh:mm a').format(record.timestamp),
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isSynced ? AppColors.success : AppColors.warning)
                      .withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isSynced ? 'Synced' : 'Pending',
                  style: TextStyle(
                    color: isSynced ? AppColors.success : AppColors.warning,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 80)).slideX(begin: 0.1);
  }
}
