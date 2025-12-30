import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 앱에서 사용하는 텍스트 스타일 정의
///
/// 사용 예시:
/// Text('본문 내용입니다.', style: AppTextStyles.text32blackW700)
/// 만약 특정화면에서 특성 스타일을 바꾸고 싶다면 아래와 copyWith 를 사용하여 변경 가능
/// AppTextStyles.text32blackW700.copyWith(
///  color: AppColors.primary,      // 색상 변경
///  fontSize: 18.sp,               // 사이즈도 변경 가능
///  fontWeight: FontWeight.w500,    // 웨이트도 변경 가능
///)
class AppTextStyles {
  AppTextStyles._(); // 인스턴스 생성 방지

  static const fontFamily = 'NotoSansKR';

  // normal weight : w400
  // bold weight : w700

  static TextStyle get text10blackW400 => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    fontFamily: fontFamily,
  );
  static TextStyle get text12blackW400 => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    fontFamily: fontFamily,
  );
  static TextStyle get text13blackW400 => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    fontFamily: fontFamily,
  );
  static TextStyle get text14blackW400 => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    fontFamily: fontFamily,
  );
  static TextStyle get text16blackW400 => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    fontFamily: fontFamily,
  );
  static TextStyle get text16blackW700 => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    fontFamily: fontFamily,
  );
  static TextStyle get text18blackW700 => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    fontFamily: fontFamily,
  );
  static TextStyle get text22blackW700 => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    fontFamily: fontFamily,
  );
  static TextStyle get text24blackW700 => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    fontFamily: fontFamily,
  );
  static TextStyle get text32blackW700 => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    fontFamily: fontFamily,
  );
}
