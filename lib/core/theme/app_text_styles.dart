import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 앱에서 사용하는 텍스트 스타일 정의
class AppTextStyles {
  AppTextStyles._(); // 인스턴스 생성 방지

  // Headings
  static TextStyle heading1(BuildContext context) =>
      TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR');

  static TextStyle heading2(BuildContext context) =>
      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR');

  static TextStyle heading3(BuildContext context) =>
      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR');

  // Body
  static TextStyle bodyLarge(BuildContext context) =>
      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR');

  static TextStyle bodyMedium(BuildContext context) =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR');

  static TextStyle bodySmall(BuildContext context) =>
      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR');

  // Caption
  static TextStyle caption(BuildContext context) =>
      TextStyle(fontSize: 11.sp, fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR');

  // Button
  static TextStyle buttonLarge(BuildContext context) =>
      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR');

  static TextStyle buttonMedium(BuildContext context) =>
      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR');

  static TextStyle buttonSmall(BuildContext context) =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, fontFamily: 'NotoSansKR');
}
