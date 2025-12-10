import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// AppSecureStorageKey
///
/// 보안 저장소(FlutterSecureStorage) 키 정의
class AppSecureStorageKey {
  static const String token = 'auth_token';
}

/// 보안 저장소(FlutterSecureStorage)
///
class AppSecureStorage {
  AppSecureStorage._internal();
  static final instance = AppSecureStorage._internal();

  late final FlutterSecureStorage _secureStorage;

  /// secure storage 초기화
  /// 앱 시작 시 1회 호출
  Future<void> init() async {
    _secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  /// String 타입 secure storage 조회
  Future<String?> getString(String key) => _secureStorage.read(key: key);

  /// String 타입 secure storage 저장
  Future<void> setString(String key, String value) =>
      _secureStorage.write(key: key, value: value);

  /// secure storage 삭제
  Future<void> remove(String key) => _secureStorage.delete(key: key);

  /// secure storage 전체 삭제
  Future<void> clearAll() => _secureStorage.deleteAll();
}
