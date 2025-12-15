import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/theme/app_assets.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

/// 스플레시 페이지
///
/// 앱 시작 시 표시되는 페이지
/// 2초 후 인증 상태에 따라 자동으로 네비게이션
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        // AuthInitial, AuthLoading이 아닐 때만 listener 실행
        return current is! AuthInitial && current is! AuthLoading;
      },
      listener: (context, state) {
        // 인증 상태에 따라 자동으로 네비게이션
        Future.delayed(const Duration(seconds: 2), () {
          // 위젯이 아직 살아있는지 확인
          if (!context.mounted) return;

          if (state is AuthAuthenticated) {
            context.go(AppRouterPath.home);
          } else if (state is AuthUnauthenticated || state is AuthFailure) {
            context.go(AppRouterPath.login);
          }
        });
      },
      child: Scaffold(
        body: Center(
          child: Transform.scale(scale: 0.7, child: SvgPicture.asset(AppAssets.imgSplash)),
        ),
      ),
    );
  }
}
