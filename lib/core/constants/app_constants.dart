import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 앱 전역 상수
class AppConstants {
  AppConstants._();

  // 앱 정보 (초기화 필요)
  static late final String appName;
  static late final String appVersion;
  static late final String packageName;
  static late final String buildNumber;

  /// 앱 정보 초기화 (main.dart에서 호출)
  static Future<void> init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    appVersion = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  // API 관련 (실제 API 연동 시 사용)
  // .env 파일에서 BASE_URL을 읽어옴.
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
}
