import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../services/local_storage_service.dart';
import '../../theme/app_theme.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _storage = Get.find<LocalStorageService>();

  late final _schoolNameCtrl = TextEditingController(text: _storage.schoolName);
  late final _apiUrlCtrl = TextEditingController(text: _storage.apiBaseUrl);
  late final _apiKeyCtrl = TextEditingController(text: _storage.apiKey);
  late final _pinCtrl = TextEditingController(text: _storage.adminPin);

  bool _saved = false;
  bool _showApiKey = false;

  @override
  void dispose() {
    _schoolNameCtrl.dispose();
    _apiUrlCtrl.dispose();
    _apiKeyCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await _storage.setSchoolName(_schoolNameCtrl.text.trim());
    await _storage.setApiBaseUrl(_apiUrlCtrl.text.trim());
    await _storage.setApiKey(_apiKeyCtrl.text.trim());
    if (_pinCtrl.text.trim().length >= 4) {
      await _storage.setAdminPin(_pinCtrl.text.trim());
    }
    setState(() => _saved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved ✓')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── School Info ───────────────────────────────────────────────────
          _SectionHeader(title: 'School Information', icon: Icons.school_rounded),
          const SizedBox(height: 12),
          _SettingField(
            controller: _schoolNameCtrl,
            label: 'School Name',
            icon: Icons.business_rounded,
          ),
          const SizedBox(height: 24),

          // ── API Config ────────────────────────────────────────────────────
          _SectionHeader(title: 'API Configuration', icon: Icons.api_rounded),
          const SizedBox(height: 4),
          const Text(
            'Configure your school attendance server endpoint. The app will POST attendance records to /api/attendance.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          _SettingField(
            controller: _apiUrlCtrl,
            label: 'API Base URL',
            icon: Icons.link_rounded,
            hint: 'https://your-school-api.com',
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 12),
          _SettingField(
            controller: _apiKeyCtrl,
            label: 'API Key / Token',
            icon: Icons.vpn_key_rounded,
            obscure: !_showApiKey,
            suffix: IconButton(
              icon: Icon(
                _showApiKey ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
              onPressed: () => setState(() => _showApiKey = !_showApiKey),
            ),
          ),
          const SizedBox(height: 24),

          // ── Security ──────────────────────────────────────────────────────
          _SectionHeader(title: 'Security', icon: Icons.lock_rounded),
          const SizedBox(height: 4),
          const Text(
            'Admin PIN is required to exit scanner mode or access settings from the scanner.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          _SettingField(
            controller: _pinCtrl,
            label: 'Admin PIN (min 4 digits)',
            icon: Icons.pin_rounded,
            obscure: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
          const SizedBox(height: 32),

          // ── API Payload Info ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 16, color: AppColors.accent),
                    SizedBox(width: 8),
                    Text('API Payload Format',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 10),
                _CodeBlock(text: '''{
  "id": "uuid",
  "student_id": "STU001",
  "timestamp": "2024-01-15T10:30:00Z",
  "raw_qr": "original QR data"
}'''),
                const SizedBox(height: 10),
                const Text(
                  'Batch: POST /api/attendance/batch\nSingle: POST /api/attendance\nStudent lookup: GET /api/students/{id}',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Supported QR Formats ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.qr_code_rounded,
                        size: 16, color: AppColors.accent),
                    SizedBox(width: 8),
                    Text('Supported QR Formats',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 10),
                for (final fmt in [
                  'StudentId: STU001',
                  'student_id: STU001',
                  'studentId: STU001',
                  'StudentID=STU001',
                  '{"studentId":"STU001","name":"Ram"}',
                  'STU001  (plain ID)',
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            size: 12, color: AppColors.success),
                        const SizedBox(width: 8),
                        Text(fmt,
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontFamily: 'monospace')),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Save Button ───────────────────────────────────────────────────
          ElevatedButton.icon(
            onPressed: _save,
            icon: Icon(_saved ? Icons.check_rounded : Icons.save_rounded),
            label: Text(_saved ? 'Saved!' : 'Save Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _saved ? AppColors.success : AppColors.primary,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SettingField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Widget? suffix;

  const _SettingField({
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.maxLength,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: AppColors.accent),
        suffixIcon: suffix,
        counterText: '',
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String text;
  const _CodeBlock({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 11,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
