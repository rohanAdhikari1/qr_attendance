import 'package:get/get.dart';

import '../views/home/home_view.dart';
import '../views/scanner/scanner_view.dart';
import '../views/attendance/attendance_list_view.dart';
import '../views/admin/admin_view.dart';

abstract class AppRoutes {
  static const home = '/';
  static const scanner = '/scanner';
  static const attendance = '/attendance';
  static const admin = '/admin';
}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.home, page: () => const HomeView(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.scanner, page: () => const ScannerView(), transition: Transition.downToUp),
    GetPage(name: AppRoutes.attendance, page: () => const AttendanceListView(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.admin, page: () => const AdminView(), transition: Transition.rightToLeft),
  ];
}
