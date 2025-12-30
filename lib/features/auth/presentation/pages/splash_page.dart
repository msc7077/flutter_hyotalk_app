import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/navigation/nav_stack_helper.dart';
import 'package:flutter_hyotalk_app/core/storage/app_preference_storage.dart';
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
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // 중요: BlocListener는 "상태 변화"에만 반응함.
    // 앱 시작 직후 AuthBloc이 이미 Unauthenticated로 떨어진 상태면 listener가 한 번도 안 타서
    // 스플래시에서 멈출 수 있으니, 현재 상태를 1회 직접 확인해서 처리한다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _handleAuthState(context.read<AuthBloc>().state);
    });
  }

  Future<void> _handleAuthState(AuthState state) async {
    if (_navigated) return;

    // 인증 상태가 확정되기 전이면 기다림 (BlocListener가 추후 처리)
    if (state is AuthInitial || state is AuthLoading) return;

    _navigated = true;

    // UX: 스플래시 2초 유지
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final pending = AppPreferenceStorage.getString(AppPreferenceStorageKey.pendingDeepLinkLocation);
    if (!mounted) return;

    // pending 딥링크가 있으면 처리 후 이동
    if (pending.isNotEmpty) {
      final isInvite =
          pending.startsWith(AppRouterPath.inviteRegister) || pending.startsWith('/invitemsg');

      // 초대/간편회원가입은 "1회성"으로 소비(뒤로가기/재진입 시 반복 이동 방지)
      if (isInvite) {
        await AppPreferenceStorage.remove(AppPreferenceStorageKey.pendingDeepLinkLocation);
        if (!mounted) return;

        // 미로그인일때 초대 링크는 splash -> simpleRegister, back -> login
        // login을 밑에 깔고 simpleRegister를 push로 올린다.
        if (state is AuthUnauthenticated || state is AuthFailure) {
          NavStackHelper.goLoginThenPush(context, pending);
          return;
        }

        // 로그인 상태면 홈을 깔고 push로 올려서 back stack 보장
        NavStackHelper.goBaseThenPush(context, pending);
        return;
      }

      // 보호 컨텐츠: 로그인 상태면 소비 후 이동, 미로그인이면 pending 유지 후 로그인으로
      if (state is AuthAuthenticated) {
        await AppPreferenceStorage.remove(AppPreferenceStorageKey.pendingDeepLinkLocation);
        if (!mounted) return;
        NavStackHelper.goBaseThenPush(context, pending);
        return;
      }

      // 미로그인: pending 유지(로그인 성공 후 LoginPage에서 처리)
      context.go(AppRouterPath.login);
      return;
    }

    // 딥링크 없고 (=pending 없음) 로그인 상태면 홈으로
    if (state is AuthAuthenticated) {
      context.go(AppRouterPath.home);
      return;
    }
    context.go(AppRouterPath.login);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is! AuthInitial && current is! AuthLoading,
      listener: (context, state) => _handleAuthState(state),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Transform.scale(scale: 0.7, child: SvgPicture.asset(AppAssets.imgSplash)),
          ),
        ),
      ),
    );
  }
}
