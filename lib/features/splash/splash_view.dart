import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/constants/app_constants.dart';
import 'package:flutter_hyotalk_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_hyotalk_app/features/splash/providers/splash_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// SplashView: 앱 시작 시 표시되는 스플래시 화면
///
/// - 앱 초기화 및 인증 상태 확인
/// - 로딩 완료 후 적절한 화면으로 자동 이동
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // 최소 스플래시 표시 시간 (너무 빠르게 사라지는 것 방지)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 스플래시가 표시되었음을 기록 (이후에는 다시 스플래시로 가지 않도록)
    ref.read(splashShownProvider.notifier).markAsShown();

    final authState = ref.read(authProvider);
    final isAuthenticated = authState.isAuthenticated;

    if (!mounted) return;

    // 인증 상태에 따라 적절한 화면으로 이동 (replace로 스플래시를 스택에서 제거)
    if (isAuthenticated) {
      context.replace('/');
    } else {
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
