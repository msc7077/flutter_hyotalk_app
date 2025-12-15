import 'package:flutter/material.dart';

/// 앱에서 사용하는 컬러 정의
class AppColors {
  AppColors._(); // 인스턴스 생성 방지

  // 앱 기본 색
  static const Color primary = Color(0xFFFDE048);
  static const Color secondary = Color(0xFFFDE048);

  // 앱 전체 배경색
  static const Color background = Color(0xFFF9F8F1);
  // 배경 위에 올라오는 컴포넌트의 배경색
  static const Color surface = Color(0xFFFFFFFF);

  // 투명색
  static const Color transparent = Color(0x00000000);

  // 블랙 색
  static const Color black = Color(0xFF000000);
  static const Color black87 = Color(0xDD000000); // 87% opacity
  static const Color black54 = Color(0x8A000000); // 54% opacity
  static const Color black45 = Color(0x73000000); // 45% opacity
  static const Color black38 = Color(0x61000000); // 38% opacity
  static const Color black26 = Color(0x42000000); // 26% opacity
  static const Color black12 = Color(0x1F000000); // 12% opacity

  // 화이트 색
  static const Color white = Color(0xFFFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF); // 70% opacity
  static const Color white54 = Color(0x8AFFFFFF); // 54% opacity
  static const Color white38 = Color(0x61FFFFFF); // 38% opacity
  static const Color white30 = Color(0x4DFFFFFF); // 30% opacity
  static const Color white24 = Color(0x3DFFFFFF); // 24% opacity
  static const Color white12 = Color(0x1FFFFFFF); // 12% opacity
  static const Color white10 = Color(0x1AFFFFFF); // 10% opacity

  // 그레이 계열 색
  static const Color grey212121 = Color(0xFF212121);
  static const Color grey424242 = Color(0xFF424242);
  static const Color grey4A4A4A = Color(0xFF4A4A4A);
  static const Color grey616161 = Color(0xFF616161);
  static const Color grey757575 = Color(0xFF757575);
  static const Color grey7E827A = Color(0xFF7E827A);
  static const Color grey888888 = Color(0xFF888888);
  static const Color grey9E9E9E = Color(0xFF9E9E9E);
  static const Color greyA2A2A2 = Color(0xFFA2A2A2);
  static const Color greyBDBDBD = Color(0xFFBDBDBD);
  static const Color greyE0E0E0 = Color(0xFFE0E0E0);
  static const Color greyEEEEEE = Color(0xFFEEEEEE);
  static const Color greyF5F5F5 = Color(0xFFF5F5F5);
  static const Color greyFAFAFA = Color(0xFFFAFAFA);

  // 그외 색
  static const Color orangeEB5E2B = Color(0XFFEB5E2B);
}
