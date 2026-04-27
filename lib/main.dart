import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bindings/app_binding.dart';
import 'models/attendance_model.dart';
import 'models/student_model.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Hive.initFlutter();
  Hive.registerAdapter(AttendanceModelAdapter());  // typeId: 0
  Hive.registerAdapter(SyncStatusAdapter());        // typeId: 1
  Hive.registerAdapter(StudentModelAdapter());      // typeId: 2

  await Future.wait([
    Hive.openBox<AttendanceModel>('attendance'),
    Hive.openBox<StudentModel>('student_cache'),
    Hive.openBox('settings'),
  ]);

  runApp(const SchoolAttendanceApp());
}

class SchoolAttendanceApp extends StatelessWidget {
  const SchoolAttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GetMaterialApp(
        title: 'School Attendance',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: AppRoutes.home,
        getPages: AppPages.pages,
        initialBinding: AppBinding(),
        defaultTransition: Transition.fadeIn,
        // onInit: () => Get.find<dynamic>(), // DI wired via AppBinding
      ),
    );
  }
}
