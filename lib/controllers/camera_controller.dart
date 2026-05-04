import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraController extends GetxController
    with GetTickerProviderStateMixin {
  late final AnimationController beamController;
  late final Animation<double> beamAnim;

  late final AnimationController cornerController;
  late final Animation<double> cornerAlpha;

  static const boxSize = 240.0;
  static const beamTravel = boxSize - 24.0;

  @override
  void onInit() {
    super.onInit();

    beamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    beamAnim = CurvedAnimation(
      parent: beamController,
      curve: Curves.easeInOut,
    );

    cornerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    cornerAlpha = Tween<double>(begin: 0.45, end: 1.0).animate(
      CurvedAnimation(parent: cornerController, curve: Curves.easeInOut),
    );
  }

  @override
  void onClose() {
    beamController.dispose();
    cornerController.dispose();
    super.onClose();
  }
}