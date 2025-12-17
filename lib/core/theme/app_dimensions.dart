import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 앱에서 사용하는 간격, 크기 정의
class AppDimensions {
  AppDimensions._();

  // 수평 간격
  static double get spacingW0_0 => 0.0;
  static double get spacingW1_5 => 1.5.w;
  static double get spacingW4 => 4.w;
  static double get spacingW8 => 8.w;
  static double get spacingW12 => 12.w;
  static double get spacingW16 => 16.w;
  static double get spacingW20 => 20.w;
  static double get spacingW24 => 24.w;
  static double get spacingW32 => 32.w;

  // 수직 간격
  static double get spacingV0_0 => 0.0;
  static double get spacingV0_5 => 0.5.h;
  static double get spacingV4 => 4.h;
  static double get spacingV8 => 8.h;
  static double get spacingV12 => 12.h;
  static double get spacingV15 => 15.h;
  static double get spacingV16 => 16.h;
  static double get spacingV20 => 20.h;
  static double get spacingV24 => 24.h;
  static double get spacingV25 => 25.h;
  static double get spacingV32 => 32.h;
  static double get spacingV60 => 60.h;

  // 라운드 값
  static double get radius4 => 4.r;
  static double get radius8 => 8.r;
  static double get radius10 => 10.r;
  static double get radius12 => 12.r;
  static double get radius16 => 16.r;
  static double get radius24 => 24.r;
  static double get radius50 => 50.r;

  // 아이콘 크기
  static double get iconSmall => 16.sp;
  static double get iconMedium => 24.sp;
  static double get iconLarge => 32.sp;

  // 버튼 크기
  static double get buttonWidthFull => double.infinity; // 버튼 너비를 화면 너비로 고정
  static double get buttonHeight => 1.sw / 5.5; // 화면 너비의 1/5.5로 고정
}
