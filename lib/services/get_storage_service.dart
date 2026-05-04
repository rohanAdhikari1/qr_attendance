import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GetStorageService extends GetxService {
  late GetStorage _settingsBox;

  Future<GetStorageService> init() async {
    await GetStorage.init();
    _settingsBox = GetStorage();
    return this;
  }

  String get apiBaseUrl =>
      _settingsBox.read('api_base_url');

  Future<void> setApiBaseUrl(String url) async {
    await _settingsBox.write('api_base_url', url);
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
}