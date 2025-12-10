import 'package:dio/dio.dart';
import 'package:flutter_hyotalk_app/core/network/api_endpoints.dart';
import 'package:flutter_hyotalk_app/core/storage/app_preference_storage.dart';
import 'package:flutter_hyotalk_app/core/storage/app_secure_storage.dart';

class AuthRepository {
  final Dio authDio;
  final AppPreferenceStorage prefs;
  final AppSecureStorage secureStorage;

  AuthRepository({
    required this.authDio,
    required this.prefs,
    required this.secureStorage,
  });

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
      return _throwAuthFailure(res, '로그인에 실패했습니다.');
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      return _throwAuthFailure(res, '알 수 없는 응답 형식입니다.');
    }

    final token = data['token'] as String?;
    if (token == null || token.isEmpty) {
      final messageCode = data['message'] as String?;
      final message = _mapAuthErrorMessage(messageCode);
      return _throwAuthFailure(res, message);
    }

    await secureStorage.setString(AppSecureStorageKey.token, token);
    return token;
  }

  Future<void> requestLogout() async {
    await secureStorage.remove(AppSecureStorageKey.token);
    await prefs.remove(AppPreferenceStorageKey.isAutoLogin);
  }

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

  /// Auth 에러 메시지 매핑
  String _mapAuthErrorMessage(String? code) {
    switch (code?.toLowerCase()) {
      case 'befound':
        return '비밀번호가 올바르지 않습니다.';
      case 'none':
        return '해당 아이디를 찾을 수 없습니다.';
      case 'user expired':
        return '계정이 만료되었습니다. 탈퇴 후 30일 이내라면 복구가 가능합니다.';
      case 'user restore':
        return '계정이 영구 만료되었습니다. 탈퇴 후 30일이 지나 복구가 불가합니다.';
      case 'user hold':
        return '계정이 정지되었습니다. 관리자에게 문의해주세요.';
      default:
        return '토큰을 발급받지 못했습니다. 다시 시도해주세요.';
    }
  }
}
