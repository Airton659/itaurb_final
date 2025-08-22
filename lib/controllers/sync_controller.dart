import 'package:flutter/material.dart';
import 'package:itaurb_transparente/services/data_cache_service.dart';

class SyncController extends ChangeNotifier {
  String _lastSyncTime = "...";
  bool _isSyncing = false;

  String get lastSyncTime => _lastSyncTime;
  bool get isSyncing => _isSyncing;

  SyncController() {
    loadLastSyncTime();
  }

  Future<void> loadLastSyncTime() async {
    _lastSyncTime = await DataCacheService.instance.getLastSyncTime();
    notifyListeners();
  }

  Future<void> forceSync() async {
    _isSyncing = true;
    notifyListeners();

    DataCacheService.instance.isInitialized = false;
    await DataCacheService.instance.initialize();

    await loadLastSyncTime();

    _isSyncing = false;
    notifyListeners();
  }
}
