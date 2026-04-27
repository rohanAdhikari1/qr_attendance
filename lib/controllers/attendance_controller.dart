import 'package:get/get.dart';

import '../models/attendance_model.dart';
import '../services/local_storage_service.dart';

class AttendanceController extends GetxController {
  final LocalStorageService _storage;

  AttendanceController(this._storage);

  final records = <AttendanceModel>[].obs;
  final selectedDate = DateTime.now().obs;
  final filterStatus = Rxn<SyncStatus>();

  @override
  void onInit() {
    super.onInit();
    loadForDate(DateTime.now());
  }

  void loadForDate(DateTime date) {
    selectedDate.value = date;
    _applyFilter();
  }

  void setFilter(SyncStatus? status) {
    filterStatus.value = status;
    _applyFilter();
  }

  void _applyFilter() {
    var all = _storage.getAttendanceByDate(selectedDate.value);
    if (filterStatus.value != null) {
      all = all.where((r) => r.syncStatus == filterStatus.value).toList();
    }
    records.value = all;
  }

  void refresh() => _applyFilter();

  int get todayTotal => _storage.totalTodayCount;
  int get todaySynced => _storage.syncedTodayCount;
  int get todayPending => _storage.pendingCount;
}
