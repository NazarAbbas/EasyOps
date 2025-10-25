// prefs.dart
import 'dart:convert';

import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePreferences {
// ------- Keys (const) -------
  static const String userRole = 'userRole';
  static const String engineerRole = 'engineerRole';
  static const String productionManagerRole = 'productionManagerRole';

  SharePreferences._(); // no instances

  /// Put a value by key. Supports String, int, double, bool, List<String>.
  static Future<bool> put(String key, dynamic value) async {
    final p = await SharedPreferences.getInstance();

    if (value == null) return p.remove(key);

    if (value is String) return p.setString(key, value);
    if (value is int) return p.setInt(key, value);
    if (value is double) return p.setDouble(key, value);
    if (value is bool) return p.setBool(key, value);
    if (value is List<String>) return p.setStringList(key, value);

    throw ArgumentError(
        'Unsupported type for key "$key": ${value.runtimeType}');
  }

  /// Get a typed value by key. T must be String/int/double/bool/List<String>.
  static Future<T?> get<T>(String key) async {
    final p = await SharedPreferences.getInstance();

    if (T == String) return p.getString(key) as T?;
    if (T == int) return p.getInt(key) as T?;
    if (T == double) return p.getDouble(key) as T?;
    if (T == bool) return p.getBool(key) as T?;
    if (T == List<String>) return p.getStringList(key) as T?;

    throw ArgumentError('Unsupported type requested for key "$key": $T');
  }

  /// Get with default value if null.
  static Future<T> getOr<T>(String key, T defaultValue) async {
    return (await get<T>(key)) ?? defaultValue;
  }

  /// Remove one key.
  static Future<bool> remove(String key) async {
    final p = await SharedPreferences.getInstance();
    return p.remove(key);
  }

  /// Clear all keys for this app.
  static Future<bool> clear() async {
    final p = await SharedPreferences.getInstance();
    return p.clear();
  }

  /// Check if a key exists.
  static Future<bool> contains(String key) async {
    final p = await SharedPreferences.getInstance();
    return p.containsKey(key);
  }

  static Future<void> setObject(String key, Map<String, dynamic> json) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(key, jsonEncode(json));
  }

  static Future<T?> getObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(key);
    if (s == null) return null;
    return fromJson(jsonDecode(s) as Map<String, dynamic>);
  }

  static Future<void> setObjectList(
      String key, List<Map<String, dynamic>> list) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(key, jsonEncode(list));
  }

  static Future<List<T>> getObjectList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(key);
    if (s == null) return [];
    final raw = (jsonDecode(s) as List).cast<Map<String, dynamic>>();
    return raw.map(fromJson).toList();
  }
}
