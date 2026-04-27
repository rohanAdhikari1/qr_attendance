import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final _connectivity = Connectivity();
  final isOnline = false.obs;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _checkInitial();
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> _checkInitial() async {
    final results = await _connectivity.checkConnectivity();
    isOnline.value = _hasConnection(results);
  }

  void _onChanged(List<ConnectivityResult> results) {
    isOnline.value = _hasConnection(results);
  }

  bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet);

  Future<bool> checkNow() async {
    final results = await _connectivity.checkConnectivity();
    isOnline.value = _hasConnection(results);
    return isOnline.value;
  }
}
