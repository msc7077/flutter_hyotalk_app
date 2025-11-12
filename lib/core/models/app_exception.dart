/// 앱에서 사용하는 공통 예외 클래스
sealed class AppException implements Exception {
  final String message;
  final Object? originalError;

  const AppException(this.message, [this.originalError]);

  @override
  String toString() => message;
}

/// 네트워크 관련 예외
class NetworkException extends AppException {
  const NetworkException(super.message, [super.originalError]);
}

/// 인증 관련 예외
class AuthException extends AppException {
  const AuthException(super.message, [super.originalError]);
}

/// 서버 응답 예외
class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, this.statusCode, [super.originalError]);
}

/// 유효성 검사 예외
class ValidationException extends AppException {
  const ValidationException(super.message, [super.originalError]);
}

/// 알 수 없는 예외
class UnknownException extends AppException {
  const UnknownException(super.message, [super.originalError]);
}
