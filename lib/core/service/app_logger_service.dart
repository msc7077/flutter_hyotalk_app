import 'package:flutter/foundation.dart';

class AppLoggerService {
  AppLoggerService._();

  /// TAG를 공통으로 정의
  static const String tag = 'HYOTALK';

  /// ANSI 색상 코드
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';

  /// 어디에서 호출했는지 자동 추출
  static String _caller() {
    final trace = StackTrace.current.toString().split('\n')[2];
    final match = RegExp(r'#\d+\s+(.+)\s\((.+):(\d+):\d+\)').firstMatch(trace);

    if (match != null) {
      final method = match.group(1);
      final file = match.group(2)?.split('/').last;
      final line = match.group(3);
      return '$file:$line → $method';
    }
    return 'unknown';
  }

  /// info 로그
  static void i(String message) {
    if (kDebugMode) {
      print('$_green[$tag][INFO] (${_caller()}) $message');
    }
  }

  /// warning 로그
  static void w(String message) {
    if (kDebugMode) {
      print('$_yellow[$tag][WARN] (${_caller()}) $message');
    }
  }

  /// error 로그
  static void e(String message) {
    if (kDebugMode) {
      print('$_red[$tag][ERROR] (${_caller()}) $message');
    }
  }
}
