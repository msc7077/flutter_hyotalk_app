import 'package:shared_preferences/shared_preferences.dart';

/// AppPreferenceStorageKey
///
/// 내부 설정 저장소(SharedPreferences) 키 정의
class AppPreferenceStorageKey {
  static const String isAutoLogin = 'auto_login';
  static const String pendingDeepLinkLocation = 'pending_deep_link_location';
}

/// 내부 설정 저장소(SharedPreferences)
///
class AppPreferenceStorage {
  AppPreferenceStorage._internal();
  static final _instance = AppPreferenceStorage._internal();

  late final SharedPreferences _prefs;

  /// preference 초기화
  /// 앱 시작 시 1회 호출
  static Future<void> init() async {
    _instance._prefs = await SharedPreferences.getInstance();
  }

  /// preference를 범용적으로 제공하기 위한 메서드 정의
  /// 키마다 메서드를 만들지 않아 확장이 용이하고 일관성 있게 사용할 수 있다.

  /// String 타입 preference 조회
  static String getString(String key) => _instance._prefs.getString(key) ?? '';

  /// String 타입 preference 저장
  static Future<void> setString(String key, String value) => _instance._prefs.setString(key, value);

  /// Boolean 타입 preference 조회
  static bool getBool(String key) => _instance._prefs.getBool(key) ?? false;

  /// Boolean 타입 preference 저장
  static Future<void> setBool(String key, bool value) => _instance._prefs.setBool(key, value);

  /// preference 삭제
  static Future<void> remove(String key) => _instance._prefs.remove(key);

  /// preference 전체 삭제
  static Future<void> clearAll() => _instance._prefs.clear();
}
