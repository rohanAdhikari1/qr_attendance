import 'package:flutter/material.dart';
import 'package:qr_attendance/controllers/success_overlay_controller.dart';
import 'package:qr_attendance/theme/app_theme.dart';

class RippleIcon extends StatelessWidget {
  final SuccessOverlayController ctrl;

  const RippleIcon({super.key,required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < 3; i++)
            AnimatedBuilder(
              animation: ctrl.rippleCtrl[i],
              builder: (_, __) => Transform.scale(
                scale: ctrl.rippleScale[i].value,
                child: Opacity(
                  opacity: ctrl.rippleOpacity[i].value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.success,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ScaleTransition(
            scale: ctrl.popAnim,
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withValues(alpha: 0.12),
                border: Border.all(color: AppColors.success, width: 2),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.success,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}