import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessOverlayController extends GetxController
    with GetTickerProviderStateMixin {

  // ── Ripple ─────────────────────────────────────
  late final List<AnimationController> rippleCtrl;
  late final List<Animation<double>> rippleScale;
  late final List<Animation<double>> rippleOpacity;

  // ── Pop ────────────────────────────────────────
  late final AnimationController popCtrl;
  late final Animation<double> popAnim;

  // ── Fade ───────────────────────────────────────
  late final AnimationController fadeCtrl;
  late final Animation<double> fadeAnim;

  // ── Slide ──────────────────────────────────────
  late final AnimationController slideCtrl;
  late final Animation<Offset> slideAnim;

  @override
  void onInit() {
    super.onInit();

    // Fade
    fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();

    fadeAnim = CurvedAnimation(parent: fadeCtrl, curve: Curves.easeIn);

    // Slide
    slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: slideCtrl, curve: Curves.easeOutCubic));

    // Pop
    popCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    popAnim = CurvedAnimation(
      parent: popCtrl,
      curve: const ElasticOutCurve(0.75),
    );

    Future.delayed(
      const Duration(milliseconds: 150),
          () => popCtrl.forward(),
    );

    // Ripples
    rippleCtrl = List.generate(
      3,
          (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800),
      ),
    );

    rippleScale = rippleCtrl.map((c) {
      return Tween<double>(begin: 0.45, end: 2.0)
          .animate(CurvedAnimation(parent: c, curve: Curves.easeOut));
    }).toList();

    rippleOpacity = rippleCtrl.map((c) {
      return Tween<double>(begin: 1.0, end: 0.0)
          .animate(CurvedAnimation(parent: c, curve: Curves.easeOut));
    }).toList();

    for (int i = 0; i < rippleCtrl.length; i++) {
      Future.delayed(Duration(milliseconds: i * 600), () {
        rippleCtrl[i].repeat();
      });
    }
  }

  @override
  void onClose() {
    for (final c in rippleCtrl) {
      c.dispose();
    }
    popCtrl.dispose();
    fadeCtrl.dispose();
    slideCtrl.dispose();
    super.onClose();
  }
}