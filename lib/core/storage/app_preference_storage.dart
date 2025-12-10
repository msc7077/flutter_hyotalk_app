import 'package:shared_preferences/shared_preferences.dart';

/// AppPreferenceStorageKey
///
/// 내부 설정 저장소(SharedPreferences) 키 정의
class AppPreferenceStorageKey {
  static const String isAutoLogin = 'auto_login';
}

/// 내부 설정 저장소(SharedPreferences)
///
class AppPreferenceStorage {
  AppPreferenceStorage._internal();
  static final instance = AppPreferenceStorage._internal();

  late final SharedPreferences _prefs;

  /// preference 초기화
  /// 앱 시작 시 1회 호출
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// preference를 범용적으로 제공하기 위한 메서드 정의
  /// 키마다 메서드를 만들지 않아 확장이 용이하고 일관성 있게 사용할 수 있다.

  /// String 타입 preference 조회
  String getString(String key) => _prefs.getString(key) ?? '';

  /// String 타입 preference 저장
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  /// Boolean 타입 preference 조회
  bool getBool(String key) => _prefs.getBool(key) ?? false;

  /// Boolean 타입 preference 저장
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  /// preference 삭제
  Future<void> remove(String key) => _prefs.remove(key);

  /// preference 전체 삭제
  Future<void> clearAll() => _prefs.clear();
}
