import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/admin_controller.dart';
import '../../theme/app_theme.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AdminController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Panel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            ctrl.refresh();
            Get.back();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Student Cache Loader ───────────────────────────────────────────
          _StudentCacheCard(ctrl: ctrl),
          const SizedBox(height: 16),

          // ── Sync Panel ────────────────────────────────────────────────────
          _SyncCard(ctrl: ctrl),
          const SizedBox(height: 16),

          // ── LAN Live Server ───────────────────────────────────────────────
          _LanServerCard(ctrl: ctrl),
          const SizedBox(height: 16),

          // ── Settings ──────────────────────────────────────────────────────
          _SettingsCard(ctrl: ctrl),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Student Cache Loader Card ────────────────────────────────────────────────

class _StudentCacheCard extends StatelessWidget {
  final AdminController ctrl;
  const _StudentCacheCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return _Card(
      icon: Icons.people_rounded,
      title: 'Student Data',
      iconColor: AppColors.accent,
      child: Obx(() {
        final state = ctrl.bulkLoadState.value;
        final isLoading = state == BulkLoadState.loading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cache stats row
            Row(
              children: [
                _InfoChip(
                  icon: Icons.storage_rounded,
                  label: '${ctrl.cachedStudentCount.value} cached',
                  color: AppColors.accent,
                ),
                const SizedBox(width: 8),
                if (ctrl.cachedStudentCount.value > 0)
                  _InfoChip(
                    icon: Icons.check_circle_rounded,
                    label: 'Works offline',
                    color: AppColors.success,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Load all student names and classes from your server. Once loaded, student info shows instantly even with no internet.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5),
            ),
            const SizedBox(height: 14),

            // Progress bar
            if (isLoading) ...[
              Obx(() {
                final loaded = ctrl.bulkLoadProgress.value;
                final total = ctrl.bulkLoadTotal.value;
                final pct = total != null && total > 0 ? loaded / total : null;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: pct,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ctrl.bulkLoadMessage.value,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }),
            ],

            // Status message
            if (!isLoading && ctrl.bulkLoadMessage.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  ctrl.bulkLoadMessage.value,
                  style: TextStyle(
                    color: ctrl.bulkLoadState.value == BulkLoadState.error
                        ? AppColors.error
                        : AppColors.success,
                    fontSize: 12,
                  ),
                ),
              ),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: isLoading ? 'Loading…' : 'Load All Students',
                    icon: isLoading
                        ? null
                        : Icons.cloud_download_rounded,
                    isLoading: isLoading,
                    onTap: isLoading ? null : ctrl.loadAllStudents,
                    color: AppColors.primary,
                  ),
                ),
                if (ctrl.cachedStudentCount.value > 0) ...[
                  const SizedBox(width: 10),
                  IconButton(
                    tooltip: 'Clear cache',
                    onPressed: () => _confirmClear(context),
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppColors.error, size: 20),
                  ),
                ],
              ],
            ),
          ],
        );
      }),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('Clear Student Cache?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Student names and classes will not show until you reload from server.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              ctrl.clearStudentCache();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

// ─── Sync Card ────────────────────────────────────────────────────────────────

class _SyncCard extends StatelessWidget {
  final AdminController ctrl;
  const _SyncCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return _Card(
      icon: Icons.sync_rounded,
      title: 'Sync Attendance',
      iconColor: AppColors.success,
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.schedule_rounded,
                    label: '${ctrl.pendingCount.value} pending',
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  if (ctrl.failedCount.value > 0)
                    _InfoChip(
                      icon: Icons.error_outline_rounded,
                      label: '${ctrl.failedCount.value} failed',
                      color: AppColors.error,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (ctrl.syncMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(ctrl.syncMessage.value,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: ctrl.isSyncing.value ? 'Syncing…' : 'Sync Now',
                      icon: Icons.cloud_upload_rounded,
                      isLoading: ctrl.isSyncing.value,
                      onTap: ctrl.isSyncing.value ? null : ctrl.syncNow,
                      color: AppColors.success,
                    ),
                  ),
                  if (ctrl.failedCount.value > 0) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        label: 'Retry Failed',
                        icon: Icons.replay_rounded,
                        onTap: ctrl.retryFailed,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          )),
    );
  }
}

// ─── LAN Server Card ──────────────────────────────────────────────────────────

class _LanServerCard extends StatelessWidget {
  final AdminController ctrl;
  const _LanServerCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return _Card(
      icon: Icons.wifi_tethering_rounded,
      title: 'Live Dashboard (LAN)',
      iconColor: AppColors.warning,
      child: Obx(() {
        final running = ctrl.lanRunning.value;
        final url = ctrl.dashboardUrl;
        final clients = ctrl.lanClients.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Start a live web dashboard on this device. Principals and teachers open the URL in any browser on the same WiFi — no app install needed.',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 12, height: 1.5),
            ),
            const SizedBox(height: 14),

            if (running && url.isNotEmpty) ...[
              // URL display
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withAlpha(18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.warning.withAlpha(60)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .fadeIn(duration: 800.ms),
                        const SizedBox(width: 8),
                        const Text('Server is live',
                            style: TextStyle(
                                color: AppColors.success,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Text(
                          '$clients viewer${clients == 1 ? '' : 's'}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Open in browser:',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 11)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            url,
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: url));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('URL copied!')),
                            );
                          },
                          icon: const Icon(Icons.copy_rounded,
                              size: 18, color: AppColors.textSecondary),
                          tooltip: 'Copy URL',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '📱 Same WiFi network required',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            _ActionButton(
              label: running ? 'Stop Live Dashboard' : 'Start Live Dashboard',
              icon: running ? Icons.wifi_off_rounded : Icons.wifi_tethering_rounded,
              onTap: ctrl.toggleLanServer,
              color: running ? AppColors.error : AppColors.warning,
            ),
          ],
        );
      }),
    );
  }
}

// ─── Settings Card ────────────────────────────────────────────────────────────

class _SettingsCard extends StatefulWidget {
  final AdminController ctrl;
  const _SettingsCard({required this.ctrl});

  @override
  State<_SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<_SettingsCard> {
  late final _schoolCtrl = TextEditingController(
      text: Get.find<AdminController>().schoolName.value);
  late final _urlCtrl = TextEditingController(
      text: Get.find<AdminController>().apiUrl.value);
  final _keyCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _saved = false;
  bool _showKey = false;

  @override
  void dispose() {
    _schoolCtrl.dispose();
    _urlCtrl.dispose();
    _keyCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await widget.ctrl.saveSettings(
      url: _urlCtrl.text.trim(),
      apiKey: _keyCtrl.text.trim(),
      school: _schoolCtrl.text.trim(),
      pin: _pinCtrl.text.trim(),
    );
    setState(() => _saved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Settings saved ✓')));
  }

  @override
  Widget build(BuildContext context) {
    return _Card(
      icon: Icons.settings_rounded,
      title: 'Configuration',
      iconColor: AppColors.textSecondary,
      child: Column(
        children: [
          _Field(ctrl: _schoolCtrl, label: 'School Name', icon: Icons.school_rounded),
          const SizedBox(height: 12),
          _Field(
            ctrl: _urlCtrl,
            label: 'API Base URL',
            icon: Icons.link_rounded,
            hint: 'https://api.myschool.edu.np',
            type: TextInputType.url,
          ),
          const SizedBox(height: 12),
          _Field(
            ctrl: _keyCtrl,
            label: 'API Key (leave blank to keep current)',
            icon: Icons.vpn_key_rounded,
            obscure: !_showKey,
            suffix: IconButton(
              icon: Icon(
                _showKey ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
              onPressed: () => setState(() => _showKey = !_showKey),
            ),
          ),
          const SizedBox(height: 12),
          _Field(
            ctrl: _pinCtrl,
            label: 'Admin PIN (min 4 digits)',
            icon: Icons.pin_rounded,
            obscure: true,
            type: TextInputType.number,
            maxLen: 6,
          ),
          const SizedBox(height: 16),
          _ActionButton(
            label: _saved ? 'Saved ✓' : 'Save Settings',
            icon: _saved ? Icons.check_rounded : Icons.save_rounded,
            onTap: _save,
            color: _saved ? AppColors.success : AppColors.primary,
          ),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Widget child;

  const _Card({
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color color;
  final bool isLoading;

  const _ActionButton({
    required this.label,
    this.icon,
    required this.onTap,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: onTap == null ? AppColors.surfaceVariant : color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Icon(icon, size: 18),
        label: Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData icon;
  final String? hint;
  final bool obscure;
  final TextInputType? type;
  final int? maxLen;
  final Widget? suffix;

  const _Field({
    required this.ctrl,
    required this.label,
    required this.icon,
    this.hint,
    this.obscure = false,
    this.type,
    this.maxLen,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: type,
      maxLength: maxLen,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '',
        prefixIcon: Icon(icon, size: 18, color: AppColors.accent),
        suffixIcon: suffix,
      ),
    );
  }
}
