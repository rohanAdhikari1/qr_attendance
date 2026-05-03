import 'package:get/get.dart';

import '../controllers/admin_controller.dart';
import '../controllers/attendance_controller.dart';
import '../controllers/scanner_controller.dart';
import '../controllers/sync_controller.dart';
import '../services/api_service.dart';
import '../services/connectivity_service.dart';
import '../services/lan_server_service.dart';
import '../services/storage_service.dart';
import '../services/student_cache_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize Storage Service (GetxStorage + Drift)
    Get.put<StorageService>(StorageService(), permanent: true);
    
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
    Get.put<ApiService>(
      ApiService(),
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
      LanServerService(Get.find<StorageService>()),
      permanent: true,
    );
    Get.put<SyncController>(
      SyncController(
        Get.find<StorageService>(),
        Get.find<ApiService>(),
        Get.find<ConnectivityService>(),
      ),
      permanent: true,
    );
    Get.put<AttendanceController>(
      AttendanceController(Get.find<StorageService>()),
    );
    Get.put<ScannerController>(
      ScannerController(
        Get.find<StorageService>(),
        Get.find<ApiService>(),
        Get.find<ConnectivityService>(),
        Get.find<SyncController>(),
        Get.find<StudentCacheService>(),
        Get.find<LanServerService>(),
      ),
    );
    Get.put<AdminController>(
      AdminController(
        Get.find<StorageService>(),
        Get.find<ApiService>(),
        Get.find<ConnectivityService>(),
        Get.find<SyncController>(),
        Get.find<StudentCacheService>(),
        Get.find<LanServerService>(),
      ),
    );
  }
}
