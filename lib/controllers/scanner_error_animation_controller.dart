import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScannerErrorAnimationController extends GetxController
    with GetTickerProviderStateMixin {
  // ── Ripple ────────────────────────────────────────────────────────────────

  late final List<AnimationController> rippleControllers;

  late final List<Animation<double>> rippleScale;

  late final List<Animation<double>> rippleOpacity;

  // ── Pop ───────────────────────────────────────────────────────────────────

  late final AnimationController popController;

  late final Animation<double> popAnim;

  // ── Slide ─────────────────────────────────────────────────────────────────

  late final AnimationController slideController;

  late final Animation<Offset> slideAnim;

  @override
  void onInit() {
    super.onInit();

    rippleControllers = List.generate(
      3,
          (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800),
      ),
    );

    rippleScale = rippleControllers
        .map(
          (c) => Tween<double>(
        begin: 0.45,
        end: 1.9,
      ).animate(
        CurvedAnimation(
          parent: c,
          curve: Curves.easeOut,
        ),
      ),
    )
        .toList();

    rippleOpacity = rippleControllers
        .map(
          (c) => Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(
        CurvedAnimation(
          parent: c,
          curve: Curves.easeOut,
        ),
      ),
    )
        .toList();

    popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    popAnim = CurvedAnimation(
      parent: popController,
      curve: const ElasticOutCurve(0.8),
    );

    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: slideController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void playAnimations() {
    for (final c in rippleControllers) {
      c.reset();
    }

    popController.reset();
    slideController.reset();

    slideController.forward();

    Future.delayed(
      const Duration(milliseconds: 120),
          () {
        if (!isClosed) {
          popController.forward();
        }
      },
    );

    for (int i = 0; i < 3; i++) {
      Future.delayed(
        Duration(milliseconds: i * 600),
            () {
          if (!isClosed) {
            rippleControllers[i].repeat();
          }
        },
      );
    }
  }

  @override
  void onClose() {
    for (final c in rippleControllers) {
      c.dispose();
    }

    popController.dispose();
    slideController.dispose();

    super.onClose();
  }
}