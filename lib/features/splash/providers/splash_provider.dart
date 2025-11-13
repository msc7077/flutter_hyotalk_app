import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 스플래시 화면 표시 여부를 관리하는 Notifier
///
/// ## 목적:
/// - 앱 최초 실행 시에만 스플래시를 표시하고, 이후에는 표시하지 않도록 제어
/// - 로그인/로그아웃 시에도 스플래시를 거치지 않고 직접 목적지로 이동
///
/// ## 상태:
/// - false: 스플래시를 아직 보지 않음 (앱 최초 실행)
/// - true: 스플래시를 이미 봄 (이후 스플래시로 리다이렉트하지 않음)
class SplashShownNotifier extends Notifier<bool> {
  @override
  bool build() {
    // 초기값은 false (스플래시를 아직 보지 않음)
    return false;
  }

  /// 스플래시가 표시되었음을 기록
  ///
  /// SplashView에서 2초 대기 후 호출되어
  /// 이후 라우터가 스플래시로 리다이렉트하지 않도록 함
  void markAsShown() {
    state = true;
  }
}

/// 스플래시 표시 여부를 제공하는 Provider
///
/// 사용 위치:
/// - router.dart: 초기 위치 결정 및 리다이렉트 로직
/// - splash_view.dart: 스플래시 표시 후 플래그 설정
final splashShownProvider = NotifierProvider<SplashShownNotifier, bool>(() {
  return SplashShownNotifier();
});
