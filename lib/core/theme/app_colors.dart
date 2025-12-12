import 'package:flutter/material.dart';

/// 앱에서 사용하는 컬러 정의
class AppColors {
  AppColors._(); // 인스턴스 생성 방지

  // Primary Colors
  static const Color primary = Color(0xFFFDE048);
  static const Color primaryDark = Color(0xFFF5602A);
  static const Color primaryLight = Color(0xFFEB5E2B);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF4A4A4A);
  static const Color textTertiary = Color(0xFF888888);
  static const Color textDisabled = Color(0xFFA2A2A2);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Gray Scale
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Blue Scale (현재 코드에서 사용 중)
  static const Color blue50 = Color(0xFFE3F2FD);
  static const Color blue700 = Color(0xFF1976D2);
}
