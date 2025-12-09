import 'package:flutter_hyotalk_app/core/config/env_config.dart';
import 'package:flutter_hyotalk_app/core/network/api_endpoints.dart';
import 'package:flutter_hyotalk_app/core/network/dio_client.dart';
import 'package:flutter_hyotalk_app/core/storage/preference_storage.dart';
import 'package:flutter_hyotalk_app/core/storage/secure_storage.dart';
import 'package:flutter_hyotalk_app/features/auth/data/models/auth_model.dart';

class AuthRepository {
  final DioClient _dioClient;

  AuthRepository(this._dioClient);

  // 서버에서 토큰 가져오기
  Future<String> getTokenFromServer() async {
    // 테스트 모드인 경우 Mock 토큰 반환
    if (EnvConfig.isTestMode) {
      await Future.delayed(const Duration(milliseconds: 500)); // 네트워크 지연 시뮬레이션
      return 'test_token_${DateTime.now().millisecondsSinceEpoch}';
    }

    try {
      final response = await _dioClient.get(ApiEndpoints.getToken);
      return response.data['token'] as String;
    } catch (e) {
      throw Exception('토큰 가져오기 실패: $e');
    }
  }

  // 토큰으로 로그인
  Future<AuthModel> loginWithToken(String token) async {
    // 테스트 모드인 경우 Mock 데이터 반환
    if (EnvConfig.isTestMode) {
      await Future.delayed(const Duration(milliseconds: 500)); // 네트워크 지연 시뮬레이션

      final authModel = AuthModel(token: token, refreshToken: 'refresh_$token');

      // 토큰 저장
      await SecureStorage.saveToken(authModel.token);

      return authModel;
    }

    try {
      final response = await _dioClient.post(ApiEndpoints.login, data: {'token': token});

      final authData = response.data;
      final authModel = AuthModel(
        token: authData['token'] as String,
        refreshToken: authData['refreshToken'] as String?,
      );

      // 토큰 저장
      await SecureStorage.saveToken(authModel.token);

      return authModel;
    } catch (e) {
      throw Exception('로그인 실패: $e');
    }
  }

  // 자동 로그인 설정
  Future<void> setAutoLogin(bool value) async {
    await PreferenceStorage.setAutoLogin(value);
  }

  // 자동 로그인 확인
  Future<bool> checkAutoLogin() async {
    return await PreferenceStorage.getAutoLogin();
  }

  // 저장된 토큰으로 자동 로그인
  Future<AuthModel?> autoLogin() async {
    final token = await SecureStorage.getToken();
    if (token != null) {
      return AuthModel(token: token);
    }
    return null;
  }

  // 로그아웃
  Future<void> logout() async {
    // 테스트 모드인 경우 바로 로컬 데이터만 삭제
    if (EnvConfig.isTestMode) {
      await SecureStorage.clearAll();
      await PreferenceStorage.clearAutoLogin();
      return;
    }

    try {
      await _dioClient.post(ApiEndpoints.logout);
    } catch (e) {
      // 에러가 나도 로컬 데이터는 삭제
    } finally {
      await SecureStorage.clearAll();
      await PreferenceStorage.clearAutoLogin();
    }
  }
}
