import 'package:dio/dio.dart';
import 'package:flutter_hyotalk_app/core/network/dio_client.dart';
import 'package:flutter_hyotalk_app/core/storage/app_preference_storage.dart';
import 'package:flutter_hyotalk_app/core/storage/app_secure_storage.dart';

/// AppInitializer
///
/// 앱 초기화 담당 클래스
///
/// 앱 시작 전에 한 번만 준비되어야 하는 싱글턴 자원
///
/// Dio 클라이언트 초기화
/// SharedPreferences 초기화
/// Hive 초기화
/// DeepLink 초기화
class AppInitializer {
  AppInitializer._internal();
  static final instance = AppInitializer._internal();

  late final Dio authDio;
  late final Dio homeDio;

  Future<void> init() async {
    authDio = DioClient.createAuthClient();
    homeDio = DioClient.createHyotalkClient();
    await AppSecureStorage.init();
    await AppPreferenceStorage.init();
  }
}
