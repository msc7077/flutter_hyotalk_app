import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/hyotalk_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱의 진입점
///
/// ## 실행 흐름:
/// 1. main() 함수 실행
/// 2. ProviderScope로 앱을 감싸서 Riverpod 상태 관리 초기화
/// 3. HyotalkApp 위젯 생성
/// 4. HyotalkApp에서 routerProvider를 watch하여 GoRouter 생성
/// 5. GoRouter가 initialLocation에 따라 첫 화면 결정
///    - splashShown = false → '/splash' (스플래시 화면)
///    - splashShown = true → '/' (홈 화면, 이후 redirect에서 인증 상태에 따라 조정)
void main() {
  // ProviderScope: Riverpod 상태 저장소를 사용하기 위한 루트 위젯
  // - 모든 Provider는 이 범위 내에서 사용 가능
  // - 앱 전체에서 상태를 공유할 수 있도록 함
  runApp(const ProviderScope(child: HyotalkApp()));
}
