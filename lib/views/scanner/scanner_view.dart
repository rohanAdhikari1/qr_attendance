import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance/services/local_storage_service.dart';

import '../../controllers/scanner_controller.dart';
import '../../controllers/sync_controller.dart';
import '../../models/attendance_model.dart';
import '../../services/connectivity_service.dart';
import '../../theme/app_theme.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final scanner = Get.find<ScannerController>();
    final sync = Get.find<SyncController>();
    final connectivity = Get.find<ConnectivityService>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) _promptExit(context, scanner);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // ── Top Bar ──────────────────────────────────────────────────
              _TopBar(sync: sync, connectivity: connectivity, scanner: scanner),

              // ── Info Panel (top 40%) ─────────────────────────────────────
              Expanded(
                flex: 42,
                child: _InfoPanel(scanner: scanner),
              ),

              // ── Camera + Overlay (bottom 58%) ────────────────────────────
              Expanded(
                flex: 58,
                child: _CameraSection(scanner: scanner),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _promptExit(BuildContext context, ScannerController scanner) {
    scanner.pauseCamera();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AdminPinDialog(onDismiss: scanner.resumeCamera),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final SyncController sync;
  final ConnectivityService connectivity;
  final ScannerController scanner;

  const _TopBar({
    required this.sync,
    required this.connectivity,
    required this.scanner,
  });

  @override
  Widget build(BuildContext context) {
    final storage = scanner;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Back (admin)
          GestureDetector(
            onTap: () {
              scanner.pauseCamera();
              showDialog(
                context: context,
                builder: (_) =>
                    _AdminPinDialog(onDismiss: scanner.resumeCamera),
              );
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
                Obx(() => Text(
                      'Today: ${scanner.todayCount.value} scanned',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                    )),
              ],
            ),
          ),
          // Connectivity dot
          Obx(() => _ConnectivityBadge(isOnline: connectivity.isOnline.value)),
          const SizedBox(width: 8),
          // Sync badge
          Obx(() {
            if (sync.pendingCount.value == 0) return const SizedBox.shrink();
            return _SyncBadge(
              count: sync.pendingCount.value,
              isSyncing: sync.isSyncing.value,
            );
          }),
          const SizedBox(width: 8),
          // Flash toggle
          GestureDetector(
            onTap: scanner.toggleFlash,
            child: Obx(() => Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scanner.isFlashOn.value
                        ? AppColors.accent.withAlpha(40)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    scanner.isFlashOn.value
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_rounded,
                    size: 18,
                    color: scanner.isFlashOn.value
                        ? AppColors.accent
                        : AppColors.textSecondary,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

// ─── Info Panel ──────────────────────────────────────────────────────────────

class _InfoPanel extends StatelessWidget {
  final ScannerController scanner;

  const _InfoPanel({required this.scanner});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = scanner.scanState.value;
      final student = scanner.lastScanned.value;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildContent(state, student, context),
      );
    });
  }

  Widget _buildContent(
      ScanState state, ScannedStudent? student, BuildContext context) {
    switch (state) {
      case ScanState.idle:
        return _IdlePanel(key: const ValueKey('idle'));

      case ScanState.scanning:
        return _ScanningPanel(key: const ValueKey('scanning'));

      case ScanState.success:
        return _StudentCard(
          key: const ValueKey('success'),
          student: student!,
          state: ScanState.success,
        );

      case ScanState.duplicate:
        return _StudentCard(
          key: const ValueKey('duplicate'),
          student: student!,
          state: ScanState.duplicate,
        );

      case ScanState.error:
      case ScanState.unknown:
        return _ErrorPanel(
          key: const ValueKey('error'),
          message: scanner.errorMessage.value,
        );
    }
  }
}

// ── Idle Panel ────────────────────────────────────────────────────────────────

class _IdlePanel extends StatelessWidget {
  const _IdlePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              size: 36,
              color: AppColors.primary,
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(duration: 2.seconds, color: AppColors.accent.withAlpha(50)),
          const SizedBox(height: 16),
          const Text(
            'Ready to Scan',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Point camera at student QR code',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ── Scanning Panel ────────────────────────────────────────────────────────────

class _ScanningPanel extends StatelessWidget {
  const _ScanningPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.accent),
    );
  }
}

// ── Student Card ─────────────────────────────────────────────────────────────

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

// ── Error Panel ───────────────────────────────────────────────────────────────

class _ErrorPanel extends StatelessWidget {
  final String message;
  const _ErrorPanel({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.error.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline_rounded,
                size: 32, color: AppColors.error),
          ).animate().shake(),
          const SizedBox(height: 12),
          const Text('Invalid QR Code',
              style: TextStyle(
                  color: AppColors.error,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}

// ─── Camera Section ───────────────────────────────────────────────────────────

class _CameraSection extends StatelessWidget {
  final ScannerController scanner;

  const _CameraSection({required this.scanner});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Camera feed
          Positioned.fill(
            child: MobileScanner(
              controller: scanner.cameraController!,
              onDetect: scanner.onQrDetected,
            ),
          ),

          // Dark overlay with scan window cutout
          Positioned.fill(
            child: _ScannerOverlay(),
          ),

          // Scan state border
          Center(
            child: Obx(() => _ScanFrame(state: scanner.scanState.value)),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _CameraControls(scanner: scanner),
          ),
        ],
      ),
    );
  }
}

// ── Scanner Overlay (dark mask with window) ───────────────────────────────────

class _ScannerOverlay extends StatelessWidget {
  final double windowSize = 220;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OverlayPainter(windowSize: windowSize),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final double windowSize;
  _OverlayPainter({required this.windowSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withAlpha(150);
    final center = Offset(size.width / 2, size.height / 2 - 20);
    final rect = Rect.fromCenter(
      center: center,
      width: windowSize,
      height: windowSize,
    );
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path()
      ..addRect(fullRect)
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Scan Frame (animated corners) ────────────────────────────────────────────

class _ScanFrame extends StatelessWidget {
  final ScanState state;
  const _ScanFrame({required this.state});

  Color get _color {
    switch (state) {
      case ScanState.success: return AppColors.success;
      case ScanState.duplicate: return AppColors.warning;
      case ScanState.error:
      case ScanState.unknown: return AppColors.error;
      default: return AppColors.scannerBorder;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: CustomPaint(
        painter: _CornerPainter(color: _color),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeIn(duration: 600.ms);
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 28.0;
    const r = 10.0;

    // Top-left
    canvas.drawPath(
        Path()
          ..moveTo(r, 0)
          ..lineTo(len, 0)
          ..moveTo(0, r)
          ..lineTo(0, len)
          ..moveTo(0, r)
          ..arcToPoint(Offset(r, 0),
              radius: const Radius.circular(r), clockwise: true),
        paint);

    // Top-right
    canvas.drawPath(
        Path()
          ..moveTo(size.width - len, 0)
          ..lineTo(size.width - r, 0)
          ..arcToPoint(Offset(size.width, r),
              radius: const Radius.circular(r), clockwise: true)
          ..lineTo(size.width, len),
        paint);

    // Bottom-left
    canvas.drawPath(
        Path()
          ..moveTo(0, size.height - len)
          ..lineTo(0, size.height - r)
          ..arcToPoint(Offset(r, size.height),
              radius: const Radius.circular(r), clockwise: false)
          ..lineTo(len, size.height),
        paint);

    // Bottom-right
    canvas.drawPath(
        Path()
          ..moveTo(size.width - len, size.height)
          ..lineTo(size.width - r, size.height)
          ..arcToPoint(Offset(size.width, size.height - r),
              radius: const Radius.circular(r), clockwise: false)
          ..lineTo(size.width, size.height - len),
        paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => old.color != color;
}

// ── Camera Controls ───────────────────────────────────────────────────────────

class _CameraControls extends StatelessWidget {
  final ScannerController scanner;
  const _CameraControls({required this.scanner});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withAlpha(200)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlButton(
            icon: Icons.flip_camera_android_rounded,
            label: 'Flip',
            onTap: scanner.toggleCamera,
          ),
          Obx(() => _ControlButton(
                icon: scanner.isFlashOn.value
                    ? Icons.flash_on_rounded
                    : Icons.flash_off_rounded,
                label: 'Flash',
                onTap: scanner.toggleFlash,
                active: scanner.isFlashOn.value,
              )),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.accent.withAlpha(50)
                  : Colors.white.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: active ? AppColors.accent : Colors.white, size: 20),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

class _ConnectivityBadge extends StatelessWidget {
  final bool isOnline;
  const _ConnectivityBadge({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            (isOnline ? AppColors.success : AppColors.error).withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isOnline ? AppColors.success : AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              color: isOnline ? AppColors.success : AppColors.error,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SyncBadge extends StatelessWidget {
  final int count;
  final bool isSyncing;
  const _SyncBadge({required this.count, required this.isSyncing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSyncing)
            const SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                  strokeWidth: 1.5, color: AppColors.warning),
            )
          else
            const Icon(Icons.sync_rounded, size: 12, color: AppColors.warning),
          const SizedBox(width: 4),
          Text('$count',
              style: const TextStyle(
                  color: AppColors.warning,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
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

// ─── Admin PIN Dialog ─────────────────────────────────────────────────────────

class _AdminPinDialog extends StatefulWidget {
  final VoidCallback onDismiss;
  const _AdminPinDialog({required this.onDismiss});

  @override
  State<_AdminPinDialog> createState() => _AdminPinDialogState();
}

class _AdminPinDialogState extends State<_AdminPinDialog> {
  final _controller = TextEditingController();
  bool _wrong = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    // Get admin pin from storage
    final storage = Get.find<LocalStorageService>()..adminPin;
    final pin = Get.find<LocalStorageService>().adminPin;
    if (_controller.text == pin) {
      Navigator.of(context).pop();
      Get.back();
    } else {
      setState(() => _wrong = true);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.lock_outline, color: AppColors.accent, size: 20),
          SizedBox(width: 8),
          Text('Admin Access',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            obscureText: true,
            keyboardType: TextInputType.number,
            autofocus: true,
            maxLength: 6,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Enter PIN',
              counterText: '',
              errorText: _wrong ? 'Incorrect PIN' : null,
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onDismiss();
          },
          child: const Text('Cancel',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Unlock'),
        ),
      ],
    );
  }
}
