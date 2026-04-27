import 'package:get/get.dart';

import '../controllers/admin_controller.dart';
import '../controllers/attendance_controller.dart';
import '../controllers/scanner_controller.dart';
import '../controllers/sync_controller.dart';
import '../services/api_service.dart';
import '../services/connectivity_service.dart';
import '../services/lan_server_service.dart';
import '../services/local_storage_service.dart';
import '../services/student_cache_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LocalStorageService>(LocalStorageService(), permanent: true);
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
    Get.put<ApiService>(
      ApiService(Get.find<LocalStorageService>()),
      permanent: true,
    );
    var cn = Get.put<StudentCacheService>(
      StudentCacheService(
        Get.find<ApiService>(),
        Get.find<ConnectivityService>(),
      ),
      permanent: true,
    );
    cn.init();
    Get.put<LanServerService>(
      LanServerService(Get.find<LocalStorageService>()),
      permanent: true,
    );
    Get.put<SyncController>(
      SyncController(
        Get.find<LocalStorageService>(),
        Get.find<ApiService>(),
        Get.find<ConnectivityService>(),
      ),
      permanent: true,
    );
    Get.put<AttendanceController>(
      AttendanceController(Get.find<LocalStorageService>()),
    );
    Get.put<ScannerController>(
      ScannerController(
        Get.find<LocalStorageService>(),
        Get.find<ApiService>(),
        Get.find<ConnectivityService>(),
        Get.find<SyncController>(),
        Get.find<StudentCacheService>(),
        Get.find<LanServerService>(),
      ),
    );
    Get.put<AdminController>(
      AdminController(
        Get.find<LocalStorageService>(),
        Get.find<ApiService>(),
        Get.find<ConnectivityService>(),
        Get.find<SyncController>(),
        Get.find<StudentCacheService>(),
        Get.find<LanServerService>(),
      ),
    );
  }
}
