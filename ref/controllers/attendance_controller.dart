import 'package:get/get.dart';

import '../models/attendance_model.dart';
import '../services/storage_service.dart';

class AttendanceController extends GetxController {
  final StorageService _storage;

  AttendanceController(this._storage);

  final records = <AttendanceModel>[].obs;
  final selectedDate = DateTime.now().obs;
  final filterStatus = Rxn<SyncStatus>();
  final isLoading = false.obs;

  final todayTotal = 0.obs;
  final todaySynced = 0.obs;
  final todayPending = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadForDate(DateTime.now());
    _updateStats();
  }

  Future<void> loadForDate(DateTime date) async {
    isLoading.value = true;
    try {
      selectedDate.value = date;
      await _applyFilter();
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(SyncStatus? status) {
    filterStatus.value = status;
    _applyFilter();
  }

  Future<void> _applyFilter() async {
    var all = await _storage.getAttendanceByDate(selectedDate.value);
    if (filterStatus.value != null) {
      all = all.where((r) => r.syncStatus == filterStatus.value).toList();
    }
    records.value = all;
  }

  Future<void> refresh() async {
    await _applyFilter();
    await _updateStats();
  }

  Future<void> _updateStats() async {
    todayTotal.value = await _storage.getTotalTodayCount();
    todaySynced.value = await _storage.getSyncedTodayCount();
    todayPending.value = await _storage.getPendingCount();
  }
}
