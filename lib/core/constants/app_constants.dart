/// 앱 전역 상수
class AppConstants {
  AppConstants._();

  // 앱 정보
  static const String appName = 'Hyotalk App';
  static const String appVersion = '1.0.0';

  // API 관련 (실제 API 연동 시 사용)
  static const String baseUrl = 'https://api.example.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // 로컬 스토리지 키
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';

  // 유효성 검사
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
}
