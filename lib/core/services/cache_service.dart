import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_studio/mobile/coin_model.dart';

import '../../mobile/chat_model.dart';

class CacheService {
  static const String _lastUpdateKey = 'last_update';
  static const int _cacheDuration = 5 * 60 * 1000;

  static Box<CoinModel>? _box;
  static Box<dynamic>? _chartBox;
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _box = Hive.box<CoinModel>('coins');
    _chartBox = Hive.box<dynamic>('charts');
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<List<CoinModel>> getCachedCoins() async {
    await init();
    return _box!.values.toList();
  }

  static Future<void> cacheCoins(List<CoinModel> coins) async {
    await init();
    await _box!.clear();
    await _box!.addAll(coins);
    await _prefs!.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<bool> shouldUseCache() async {
    await init();
    final lastUpdate = _prefs!.getInt(_lastUpdateKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - lastUpdate) < _cacheDuration;
  }

  static Future<List<ChartModel>?> getCachedChart(
      String coinId, String days) async {
    await init();
    final key = '${coinId}_$days';
    final data = _chartBox!.get(key);

    if (data is List && data.isNotEmpty) {
      try {
        return data
            .where((e) => e is List && e.length >= 5)
            .map((e) => ChartModel.fromJson(e as List<dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Parse error: $e');
      }
    }
    return null;
  }

  static Future<void> cacheChart(
      String coinId, String days, List<ChartModel> chart) async {
    await init();
    final key = '${coinId}_$days';
    final jsonList = chart.map((c) => c.toJson()).toList();
    await _chartBox!.put(key, jsonList);
  }

  static bool get hasCache => _box?.isNotEmpty ?? false;
}
