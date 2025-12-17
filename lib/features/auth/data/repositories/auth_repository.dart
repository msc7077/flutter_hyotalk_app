import 'package:dio/dio.dart';
import 'package:flutter_hyotalk_app/core/network/api_endpoints.dart';
import 'package:flutter_hyotalk_app/core/storage/app_preference_storage.dart';
import 'package:flutter_hyotalk_app/core/storage/app_secure_storage.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:flutter_hyotalk_app/features/auth/data/models/user_info_model.dart';

/// Auth 관련 네트워크 요청 처리
///
/// authDio를 주입 받아 네트워크 요청 처리
class AuthRepository {
  final Dio authDio;

  AuthRepository({required this.authDio});

  /// 로그인
  ///
  /// @param id 아이디
  /// @param password 비밀번호
  /// @return String 토큰
  ///
  /// Auth 토큰 요청 - 정상 토큰 발급시 정상 로그인
  /// Secure storage에 토큰 저장
  Future<String> requestLogin(String id, String password) async {
    final res = await authDio.post(
      ApiEndpoints.authLogin,
      data: {
        'userid': id,
        'password': password,
        'grant_type': 'password',
        'scope': '*',
        'service': 'silveredu',
        'site': 'Hyotalk',
      },
    );

    if (res.statusCode != 200) {
      return _throwAuthFailure(res, AppTexts.loginFailed);
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      return _throwAuthFailure(res, AppTexts.unknownError);
    }

    final token = data['token'] as String?;
    if (token == null || token.isEmpty) {
      final messageCode = data['message'] as String?;
      final message = _mapAuthErrorMessage(messageCode);
      return _throwAuthFailure(res, message);
    }

    await AppSecureStorage.setString(AppSecureStorageKey.token, token);
    return token;
  }

  /// 사용자 정보 조회
  ///
  /// @return UserInfoModel 사용자 정보 (기관아이디, 권한 포함)
  Future<UserInfoModel> getUserInfo() async {
    // 임시 데이터 (실제 API 응답 형식)
    await Future.delayed(const Duration(milliseconds: 300));
    return UserInfoModel.fromJson({
      'user_id': 'user123',
      'agency_id': 'agency123',
      'permissions': ['read', 'write', 'admin'],
    });
  }

  /// 로그아웃
  ///
  /// 토큰 제거 및 자동 로그인 정보 제거
  Future<void> requestLogout() async {
    await AppSecureStorage.remove(AppSecureStorageKey.token);
    await AppPreferenceStorage.remove(AppPreferenceStorageKey.isAutoLogin);
  }

  /// 본인인증 토큰 조회
  ///
  /// @return NiceTokenModel 본인인증 토큰
  // Future<NiceTokenModel> getNiceToken() async {
  //   final res = await authDio.get(ApiEndpoints.authNiceToken);
  //   if (res.statusCode != 200) {
  //     return _throwAuthFailure(res, AppTexts.niceTokenFailed);
  //   }

  //   final data = res.data;
  //   if (data is! Map<String, dynamic>) {
  //     return _throwAuthFailure(res, AppTexts.unknownError);
  //   }

  //   return NiceTokenModel.fromJson(data);
  // }

  /// Auth 실패 예외 처리
  ///
  /// response 값과 message 값을 받아서 예외 처리
  Never _throwAuthFailure(Response res, String message) {
    res.requestOptions.extra['customErrorMessage'] = message;
    throw DioException(
      requestOptions: res.requestOptions,
      response: res,
      message: message,
      type: DioExceptionType.badResponse,
    );
  }

  /// Auth Api 에러 메시지
  ///
  /// @param code Api에서 받은 에러 코드
  /// @return Api에서 받은 에러 메시지를 반환
  String _mapAuthErrorMessage(String? code) {
    switch (code?.toLowerCase()) {
      case 'befound':
        return AppTexts.loginFailedBefound;
      case 'none':
        return AppTexts.loginFailedNone;
      case 'user expired':
        return AppTexts.loginFailedUserExpired;
      case 'user restore':
        return AppTexts.loginFailedUserRestore;
      case 'user hold':
        return AppTexts.loginFailedUserHold;
      default:
        return AppTexts.loginFailedTokenIssue;
    }
  }
}
