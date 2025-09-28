import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  // Singleton pattern
  StorageService._internal();

  static StorageService get instance {
    _instance ??= StorageService._internal();
    return _instance!;
  }

  // Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Get SharedPreferences instance
  SharedPreferences get preferences {
    if (_preferences == null) {
      throw Exception(
        'StorageService not initialized. Call StorageService.init() first.',
      );
    }
    return _preferences!;
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    try {
      return await preferences.setString(key, value);
    } catch (e) {
      print('Error setting string: $e');
      return false;
    }
  }

  String? getString(String key, {String? defaultValue}) {
    try {
      return preferences.getString(key) ?? defaultValue;
    } catch (e) {
      print('Error getting string: $e');
      return defaultValue;
    }
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    try {
      return await preferences.setInt(key, value);
    } catch (e) {
      print('Error setting int: $e');
      return false;
    }
  }

  int? getInt(String key, {int? defaultValue}) {
    try {
      return preferences.getInt(key) ?? defaultValue;
    } catch (e) {
      print('Error getting int: $e');
      return defaultValue;
    }
  }

  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    try {
      return await preferences.setBool(key, value);
    } catch (e) {
      print('Error setting bool: $e');
      return false;
    }
  }

  bool? getBool(String key, {bool? defaultValue}) {
    try {
      return preferences.getBool(key) ?? defaultValue;
    } catch (e) {
      print('Error getting bool: $e');
      return defaultValue;
    }
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    try {
      return await preferences.setDouble(key, value);
    } catch (e) {
      print('Error setting double: $e');
      return false;
    }
  }

  double? getDouble(String key, {double? defaultValue}) {
    try {
      return preferences.getDouble(key) ?? defaultValue;
    } catch (e) {
      print('Error getting double: $e');
      return defaultValue;
    }
  }

  // List<String> operations
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await preferences.setStringList(key, value);
    } catch (e) {
      print('Error setting string list: $e');
      return false;
    }
  }

  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    try {
      return preferences.getStringList(key) ?? defaultValue;
    } catch (e) {
      print('Error getting string list: $e');
      return defaultValue;
    }
  }

  // JSON operations (for complex objects)
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await setString(key, jsonString);
    } catch (e) {
      print('Error setting JSON: $e');
      return false;
    }
  }

  Map<String, dynamic>? getJson(
    String key, {
    Map<String, dynamic>? defaultValue,
  }) {
    try {
      final jsonString = getString(key);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return defaultValue;
    } catch (e) {
      print('Error getting JSON: $e');
      return defaultValue;
    }
  }

  // Remove operations
  Future<bool> remove(String key) async {
    try {
      return await preferences.remove(key);
    } catch (e) {
      print('Error removing key: $e');
      return false;
    }
  }

  Future<bool> removeAll(List<String> keys) async {
    try {
      bool allSuccess = true;
      for (String key in keys) {
        final success = await remove(key);
        if (!success) allSuccess = false;
      }
      return allSuccess;
    } catch (e) {
      print('Error removing keys: $e');
      return false;
    }
  }

  // Clear all data
  Future<bool> clear() async {
    try {
      return await preferences.clear();
    } catch (e) {
      print('Error clearing preferences: $e');
      return false;
    }
  }

  // Check if key exists
  bool containsKey(String key) {
    try {
      return preferences.containsKey(key);
    } catch (e) {
      print('Error checking key: $e');
      return false;
    }
  }

  // Get all keys
  Set<String> getAllKeys() {
    try {
      return preferences.getKeys();
    } catch (e) {
      print('Error getting keys: $e');
      return <String>{};
    }
  }

  // Auth specific methods
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _refreshTokenKey = 'refresh_token';

  // Token operations
  Future<bool> setAuthToken(String token) async {
    return await setString(_tokenKey, token);
  }

  String? getAuthToken() {
    return getString(_tokenKey);
  }

  Future<bool> removeAuthToken() async {
    return await remove(_tokenKey);
  }

  // User data operations
  Future<bool> setUserData(Map<String, dynamic> userData) async {
    return await setJson(_userKey, userData);
  }

  Map<String, dynamic>? getUserData() {
    return getJson(_userKey);
  }

  Future<bool> removeUserData() async {
    return await remove(_userKey);
  }

  // Refresh token operations
  Future<bool> setRefreshToken(String token) async {
    return await setString(_refreshTokenKey, token);
  }

  String? getRefreshToken() {
    return getString(_refreshTokenKey);
  }

  Future<bool> removeRefreshToken() async {
    return await remove(_refreshTokenKey);
  }

  // Clear all auth data
  Future<bool> clearAuthData() async {
    return await removeAll([_tokenKey, _userKey, _refreshTokenKey]);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    final token = getAuthToken();
    return token != null && token.isNotEmpty;
  }
}
