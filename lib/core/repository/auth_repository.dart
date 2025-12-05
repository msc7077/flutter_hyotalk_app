import 'package:dio/dio.dart';
import 'package:flutter_hyotalk_app/core/service/app_preference_service.dart';

class AuthRepository {
  final Dio dio;
  final AppPreferenceService prefs;

  AuthRepository({required this.dio, required this.prefs});

  /// Token 요청 - Auth API
  ///
  /// @param id 아이디
  /// @param password 비밀번호
  ///
  /// @return token
  Future<String> requestAuthToken(String email, String password) async {
    final response = await dio.post(
      '/api/login',
      data: {
        'userid': email,
        'password': password,
        'grant_type': 'password',
        'scope': '*',
        'service': 'silveredu',
        'site': 'Hyotalk',
      },
    );

    final token = response.data['accessToken'];
    await prefs.setString('accessToken', token);
    return token;
  }

  /// 자동로그인 여부 값 확인
  ///
  /// isAutoLogin 값 prefs에서 조회
  bool getIsAutoLogin() => prefs.getBool('isAutoLogin') ?? false;

  /// 자동로그인 여부 값 저장
  ///
  /// isAutoLogin 값 prefs에 저장
  Future<void> saveIsAutoLogin(bool value) =>
      prefs.setBool('isAutoLogin', value);

  /// 로그아웃
  ///
  /// token 과 isAutoLogin 값 제거
  Future<void> logout() async {
    await prefs.remove('accessToken');
    await prefs.remove('isAutoLogin');
  }
}
