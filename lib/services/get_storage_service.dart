import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class GetStorageService extends GetxService {
  late GetStorage _settingsBox;

  Future<GetStorageService> init() async {
    await GetStorage.init();
    _settingsBox = GetStorage();
    return this;
  }

  String get apiStudentFetchUrl =>
      _settingsBox.read('api_student_fetch_url');

  Future<void> setApiStudentFetchUrl(String url) async {
    await _settingsBox.write('api_student_fetch_url', url);
  }

    String get apiStudentUpdateUrl =>
        _settingsBox.read('api_student_update_url');

    Future<void> setApiStudentUpdateUrl(String url) async {
      await _settingsBox.write('api_student_update_url', url);
  }

  String get apiStudentUpdateBulkUrl =>
      _settingsBox.read('api_student_update_bulk_url');

  Future<void> setApiStudentUpdateBulkUrl(String url) async {
    await _settingsBox.write('api_student_update_bulk_url', url);
  }

  String get apiKey =>
      _settingsBox.read('api_key');

  Future<void> setApiKey(String key) async {
    await _settingsBox.write('api_key', key);
  }

  String get schoolName =>
      _settingsBox.read('school_name') ?? 'My School';

  Future<void> setSchoolName(String name) async {
    await _settingsBox.write('school_name', name);
  }

  String get adminPin =>
      _settingsBox.read('admin_pin') ?? '2002';

  Future<void> setAdminPin(String pin) async {
    await _settingsBox.write('admin_pin', pin);
  }

  CameraFacing get cameraView =>
      CameraFacing.fromRawValue(_settingsBox.read('camera_view')??CameraFacing.front.rawValue);

  Future<void> setCameraView(CameraFacing pin) async {
    await _settingsBox.write('camera_view', pin.rawValue);
  }

  int get successTimeout =>
      _settingsBox.read('success_message_timeout')??2;

  Future<void> setSuccessTimeout(int sec) async {
    await _settingsBox.write('success_message_timeout', sec);
  }

  int get errorTimeout =>
      _settingsBox.read('error_message_timeout')??4;

  Future<void> setErrorTimeout(int sec) async {
    await _settingsBox.write('error_message_timeout', sec);
  }
}