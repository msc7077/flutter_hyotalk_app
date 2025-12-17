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
  static const Color black_50_opacity = Color(0x80000000); // 50% opacity

  // 화이트 색
  static const Color white = Color(0xFFFFFFFF);
  static const Color white_50_opacity = Color(0x80FFFFFF); // 50% opacity

  // 그레이 계열 색
  static const Color grey4A4A4A = Color(0xFF4A4A4A);
  static const Color grey7E827A = Color(0xFF7E827A);
  static const Color grey888888 = Color(0xFF888888);
  static const Color grey9E9E9E = Color(0xFF9E9E9E);
  static const Color greyA2A2A2 = Color(0xFFA2A2A2);
  static const Color greyE0E0E0 = Color(0xFFE0E0E0);
  static const Color greyF5F5F5 = Color(0xFFF5F5F5);

  // 그외 색
  static const Color orangeEB5E2B = Color(0XFFEB5E2B);
}
