import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';

/// 앱 전체 테마 정의
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoSansKR',

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary, // 주요 색상
        secondary: AppColors.secondary, // 보조 색상
        surface: AppColors.surface, // 표면 색상
        onPrimary: AppColors.white, // primary 위의 텍스트 색
        onSurface: AppColors.black, // surface 위의 텍스트 색
      ),

      // AppBar 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.black),
      ),

      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      ),

      // 입력 필드 테마
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: AppColors.surface,
      ),

      // 카드 테마
      cardTheme: const CardThemeData(color: AppColors.surface, elevation: 2),

      // 다이얼로그 테마
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // 플로팅 액션 버튼 테마
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.black,
      ),
    );
  }
}
