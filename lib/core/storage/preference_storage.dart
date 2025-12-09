import 'package:shared_preferences/shared_preferences.dart';

class PreferenceStorage {
  static const String _keyAutoLogin = 'auto_login';

  // Auto Login
  static Future<void> setAutoLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoLogin, value);
  }

  static Future<bool> getAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAutoLogin) ?? false;
  }

  static Future<void> clearAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAutoLogin);
  }
}

