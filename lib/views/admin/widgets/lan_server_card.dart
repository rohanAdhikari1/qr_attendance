import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_attendance/theme/app_theme.dart';
import 'package:qr_attendance/views/admin/widgets/action_button.dart';
import 'package:qr_attendance/views/admin/widgets/animated_card.dart';

class LanServerCard extends StatelessWidget {
  const LanServerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      icon: Icons.wifi_tethering_rounded,
      title: 'Live Dashboard (LAN)',
      iconColor: AppColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Start a live web dashboard on this device. Principals and teachers open the URL in any browser on the same WiFi — no app install needed.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
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
                      '0 viewers',
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
                        'https://rohanadhikari.com.np/',
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
                        Clipboard.setData(ClipboardData(text: 'hi'));
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
          ActionButton(
            label: 'Stop Live Dashboard' ,
            icon: Icons.wifi_tethering_rounded,
            // onTap: ctrl.toggleLanServer,
            onTap: (){},
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }
}
