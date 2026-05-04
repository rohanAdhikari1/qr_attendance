import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/services/connectivity_service.dart';
import 'package:qr_attendance/services/get_storage_service.dart';
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
  await initializeServices();
  runApp(const SchoolAttendanceApp());
}

Future<void> initializeServices() async{
  Get.putAsync(() => ConnectivityService().init());
  await Get.putAsync(() => GetStorageService().init());
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
