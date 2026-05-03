import 'package:get/get.dart';
import 'package:qr_attendance/views/admin/admin_page.dart';
import 'package:qr_attendance/views/home/home_page.dart';
import 'package:qr_attendance/views/scanner/scanner_page.dart';

abstract class AppRoutes {
  static const home = '/';
  static const scanner = '/scanner';
  static const attendance = '/attendance';
  static const admin = '/admin';
}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.home, page: () => const HomePage(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.scanner, page: () => const ScannerPage(), transition: Transition.downToUp),
    // GetPage(name: AppRoutes.attendance, page: () => const AttendanceListView(), transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.admin, page: () => const AdminPage(), transition: Transition.rightToLeft),
  ];
}
