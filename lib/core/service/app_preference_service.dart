import 'package:shared_preferences/shared_preferences.dart';

class AppPreferenceService {
  AppPreferenceService._internal();
  static final instance = AppPreferenceService._internal();

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  Future<void> remove(String key) => _prefs.remove(key);
}
