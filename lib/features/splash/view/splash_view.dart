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
/// 1. splashInitProvider를 watch하여 초기화 로직 시작
/// 2. ref.listen으로 초기화 상태 감지
/// 3. 성공 시 -> 홈/로그인 화면으로 이동
/// 4. 실패 시 -> 에러 다이얼로그 표시
class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  /// 다음 화면으로 이동 처리
  void _navigateToNextScreen(BuildContext context, WidgetRef ref) {
    // [중요] 스플래시가 표시되었음을 기록
    ref.read(splashShownProvider.notifier).markAsShown();

    // 현재 인증 상태 확인
    final authState = ref.read(authProvider);

    // 인증 상태에 따라 적절한 화면으로 이동
    if (authState.isAuthenticated) {
      context.replace('/');
    } else {
      context.replace('/login');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // splashInitProvider를 watch하여 로직 실행 (UI에 직접적인 영향은 없음)
    // 하지만 watch를 해야 provider가 active 상태가 되어 로직이 돔
    ref.watch(splashInitProvider);

    // Provider 상태 변화 감지 (Side Effect 처리)
    ref.listen(splashInitProvider, (previous, next) {
      print('previous: $previous');
      print('next: $next');
      next.when(
        data: (_) {
          print('success');
          // 초기화 성공 시 화면 이동
          _navigateToNextScreen(context, ref);
        },
        error: (error, stackTrace) {
          print('error: $error');
          // 초기화 실패 시 에러 다이얼로그 표시 (예: 로딩 실패 등)
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => AlertDialog(
                  title: const Text('오류 발생'),
                  content: Text('알 수 없는 오류가 발생했습니다.\n$error'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // 재시도 로직을 넣거나 앱 종료 안내
                      },
                      child: const Text('확인'),
                    ),
                  ],
                ),
          );
        },
        loading: () {
          print('loading');
          // 로딩 중에는 아무것도 하지 않음 (UI가 이미 로딩 표시 중)
        },
      );
    });

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
