import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void _goLoginThenPush(String location) {
    final router = GoRouter.of(context);
    router.go(AppRouterPath.login);
    Future.microtask(() {
      if (!mounted) return;
      router.push(location);
    });
  }

  void _goHomeThenPush(String location) {
    // 탭 루트면 그대로 go
    if (location == AppRouterPath.home ||
        location == AppRouterPath.album ||
        location == AppRouterPath.workDiary) {
      context.go(location);
      return;
    }

    // 2depth 이상의 페이지라면 홈을 깔고 push로 올려서 back stack 보장
    final router = GoRouter.of(context);
    router.go(AppRouterPath.home);
    Future.microtask(() {
      if (!mounted) return;
      router.push(location);
    });
  }

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

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    String? pending;
    try {
      pending = AppPreferenceStorage.getString(AppPreferenceStorageKey.pendingDeepLinkLocation);
    } catch (_) {
      pending = null;
    }
    if (!mounted) return;

    if (pending != null) {
      // 미로그인 + 초대 링크는 splash -> simpleRegister, back -> login
      // login을 밑에 깔고 simpleRegister를 push로 올린다.
      if (pending.startsWith('/invitemsg') &&
          (state is AuthUnauthenticated || state is AuthFailure)) {
        _goLoginThenPush(pending);
        return;
      }

      // 그 외 공개 딥링크는 그대로 진입
      if (pending.startsWith('/invitemsg') && state is AuthAuthenticated) {
        _goHomeThenPush(pending);
        return;
      }

      context.go(pending);
      return;
    }

    if (state is AuthAuthenticated) {
      if (pending != null && pending.isNotEmpty) {
        _goHomeThenPush(pending);
      } else {
        context.go(AppRouterPath.home);
      }
      return;
    }

    if (state is AuthUnauthenticated || state is AuthFailure) {
      if (pending != null && pending.isNotEmpty) {
        await AppPreferenceStorage.setString(
          AppPreferenceStorageKey.pendingDeepLinkLocation,
          pending,
        );
      }
      if (!mounted) return;
      context.go(AppRouterPath.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return current is! AuthInitial && current is! AuthLoading;
      },
      listener: (context, state) => _handleAuthState(state),
      child: Scaffold(
        body: Center(
          child: Transform.scale(scale: 0.7, child: SvgPicture.asset(AppAssets.imgSplash)),
        ),
      ),
    );
  }
}
