import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class ScannerClockController extends GetxController{
  final Rx<DateTime> now = DateTime.now().obs;
  Timer? _timer;
  late final DateFormat timeFormat;
  late final DateFormat shortTimeFormat;
  late final DateFormat dateFormat;

  @override
  void onInit() {
    super.onInit();
    timeFormat = DateFormat('HH:mm:ss');
    shortTimeFormat = DateFormat('HH:mm');
    dateFormat = DateFormat('EEEE, dd MMM yyyy');

    _startClock();
  }

  void _startClock() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => now.value = DateTime.now(),
    );
  }

  String get timeString => timeFormat.format(now.value);
  String get shortTime => shortTimeFormat.format(now.value);
  String get dateString => dateFormat.format(now.value);
  String get nepaliDate {
    final bs = now.value.toNepaliDateTime();
    return NepaliDateFormat("yyyy MMMM d, EEE").format(bs);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}