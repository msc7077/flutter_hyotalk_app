import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/theme/app_assets.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/splash_bloc.dart';
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
  late final SplashBloc _splashBloc;

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

  void _runNavAction(SplashNavAction action) {
    // push가 없으면 go만
    if (action.push == null) {
      context.go(action.go);
      return;
    }

    // go로 바닥을 깔고, push로 올려서 back stack 보장
    if (action.go == AppRouterPath.login) {
      _goLoginThenPush(action.push!);
      return;
    }
    _goHomeThenPush(action.push!);
  }

  @override
  void initState() {
    super.initState();
    _splashBloc = SplashBloc();

    // 중요: BlocListener는 "상태 변화"에만 반응함.
    // 앱 시작 직후 AuthBloc이 이미 Unauthenticated로 떨어진 상태면 listener가 한 번도 안 타서
    // 스플래시에서 멈출 수 있으니, 현재 상태를 1회 직접 확인해서 처리한다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _splashBloc.add(SplashAuthStateChanged(authState: context.read<AuthBloc>().state));
    });
  }

  @override
  void dispose() {
    _splashBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _splashBloc,
      child: MultiBlocListener(
        listeners: [
          // AuthBloc 상태 변화 -> SplashBloc에 전달
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) {
              return current is! AuthInitial && current is! AuthLoading;
            },
            listener: (context, state) {
              _splashBloc.add(SplashAuthStateChanged(authState: state));
            },
          ),
          // SplashBloc이 만든 네비게이션 액션 실행
          BlocListener<SplashBloc, SplashState>(
            listenWhen: (previous, current) => previous.actionSeq != current.actionSeq,
            listener: (context, state) {
              final action = state.action;
              if (action == null) return;
              _runNavAction(action);
            },
          ),
        ],
        child: Scaffold(
          body: Center(
            child: Transform.scale(scale: 0.7, child: SvgPicture.asset(AppAssets.imgSplash)),
          ),
        ),
      ),
    );
  }
}
