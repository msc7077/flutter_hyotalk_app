import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/constants/app_constants.dart';
import 'package:flutter_hyotalk_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_hyotalk_app/features/splash/providers/splash_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// SplashView: 앱 시작 시 표시되는 스플래시 화면
///
/// ## 역할:
/// - 앱 최초 실행 시 브랜딩 화면 표시
/// - 앱 초기화 시간 확보
/// - 인증 상태 확인 후 적절한 화면으로 자동 이동
///
/// ## 동작 흐름:
/// 1. 위젯이 생성되면 즉시 _navigateToNextScreen() 실행
/// 2. 2초 대기 (최소 표시 시간)
/// 3. splashShown 플래그를 true로 설정 (이후 스플래시로 다시 오지 않도록)
/// 4. 인증 상태 확인
/// 5. 로그인 상태면 '/' (홈), 비로그인 상태면 '/login'으로 이동
/// 6. context.replace() 사용으로 뒤로가기 시 스플래시로 돌아가지 않도록 함
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    // 위젯이 생성되면 즉시 다음 화면으로 이동하는 로직 시작
    _navigateToNextScreen();
  }

  /// 다음 화면으로 이동하는 비동기 함수
  ///
  /// 실행 순서:
  /// 1. 2초 대기 (스플래시 최소 표시 시간)
  /// 2. splashShown 플래그를 true로 설정
  /// 3. 인증 상태 확인
  /// 4. 적절한 화면으로 replace 이동
  Future<void> _navigateToNextScreen() async {
    // 최소 스플래시 표시 시간 (너무 빠르게 사라지는 것 방지)
    // 사용자가 앱 로고와 이름을 인지할 수 있는 시간 확보
    await Future.delayed(const Duration(seconds: 2));

    // 위젯이 아직 마운트되어 있는지 확인 (메모리 누수 방지)
    if (!mounted) return;

    // [중요] 스플래시가 표시되었음을 기록
    // - 이 플래그가 true가 되면 라우터의 redirect 로직에서
    //   더 이상 스플래시로 리다이렉트하지 않음
    // - 로그인/로그아웃 시에도 스플래시를 거치지 않고 직접 이동
    ref.read(splashShownProvider.notifier).markAsShown();

    // 현재 인증 상태 확인
    final authState = ref.read(authProvider);
    final isAuthenticated = authState.isAuthenticated;

    // 다시 한 번 마운트 상태 확인 (비동기 작업 중 위젯이 dispose될 수 있음)
    if (!mounted) return;

    // 인증 상태에 따라 적절한 화면으로 이동
    // context.replace() 사용 이유:
    // - 뒤로가기 시 스플래시로 돌아가지 않도록 하기 위함
    // - 스플래시는 앱 최초 실행 시에만 보여야 하므로
    if (isAuthenticated) {
      // 로그인 상태 → 홈 화면으로
      context.replace('/');
    } else {
      // 비로그인 상태 → 로그인 화면으로
      context.replace('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 앱 로고 또는 아이콘
              Icon(
                Icons.chat_bubble_outline,
                size: 100,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(height: 24),
              // 앱 이름
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              // 로딩 인디케이터
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
