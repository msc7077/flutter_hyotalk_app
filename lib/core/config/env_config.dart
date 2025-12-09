import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get env => dotenv.env['ENV'] ?? 'dev';
  
  // 테스트 모드 (실제 API 호출 없이 Mock 데이터 사용)
  static bool get isTestMode => dotenv.env['TEST_MODE'] == 'true' || baseUrl.isEmpty;
  
  static Future<void> loadEnv(String flavor) async {
    switch (flavor) {
      case 'dev':
        await dotenv.load(fileName: '.env.dev');
        break;
      case 'stage':
        await dotenv.load(fileName: '.env.stage');
        break;
      case 'prod':
        await dotenv.load(fileName: '.env.prod');
        break;
      default:
        await dotenv.load(fileName: '.env.dev');
    }
  }
}

