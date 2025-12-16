import 'package:flutter/material.dart';

/// Context MediaQuery 확장 메서드
///
/// extension은 “표현”만 담당
/// extension은 “원천 데이터만” 즉 수정하지 않음
/// 최상위 위젯에서만 사용해야함
/// 재사용 위젯을 만들때는 LayoutBuilder 를 사용해야함
///
/// 사용 예시:
/// context.screenWidth => 화면 너비
/// context.screenHeight => 화면 높이
/// context.safeWidth => SafeArea 제외 후 사용 가능한 영역 너비
/// context.safeHeight => SafeArea 제외 후 사용 가능한 영역 높이
/// context.isKeyboardOpen => 키보드가 열려있다면 true, 닫혀있다면 false
///
extension ContextMediaQueryExtension on BuildContext {
  MediaQueryData get media => MediaQuery.of(this);

  // 화면 크기
  Size get screenSize => media.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  double get screenHeight13 => screenHeight * 1 / 3;
  double get screenHeight23 => screenHeight * 2 / 3;

  /// SafeArea 제외 후 사용 가능한 영역
  EdgeInsets get safePadding => media.padding;
  double get safeWidth => screenWidth - safePadding.left - safePadding.right;
  double get safeHeight => screenHeight - safePadding.top - safePadding.bottom;

  // 키보드 높이
  double get keyboardHeight => media.viewInsets.bottom;
  bool get isKeyboardOpen => keyboardHeight > 0; // 키보드가 열려있다면 true, 닫혀있다면 false
}
