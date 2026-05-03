import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
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
        // initialBinding: AppBinding(),
        defaultTransition: Transition.fadeIn,
      ),
    );
  }
}
