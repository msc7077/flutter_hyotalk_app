import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 앱에서 사용하는 간격, 크기 정의 (screenutil 적용)
class AppDimensions {
  AppDimensions._();

  // Spacing (screenutil 적용)
  static double get spacing4 => 4.w;
  static double get spacing8 => 8.w;
  static double get spacing12 => 12.w;
  static double get spacing16 => 16.w;
  static double get spacing24 => 24.w;
  static double get spacing32 => 32.w;

  // Vertical Spacing
  static double get spacingV4 => 4.h;
  static double get spacingV8 => 8.h;
  static double get spacingV12 => 12.h;
  static double get spacingV16 => 16.h;
  static double get spacingV24 => 24.h;
  static double get spacingV32 => 32.h;

  // Border Radius (screenutil 적용)
  static double get radius4 => 4.r;
  static double get radius8 => 8.r;
  static double get radius12 => 12.r;
  static double get radius16 => 16.r;
  static double get radius24 => 24.r;

  // Icon Sizes
  static double get iconSmall => 16.sp;
  static double get iconMedium => 24.sp;
  static double get iconLarge => 32.sp;
}
