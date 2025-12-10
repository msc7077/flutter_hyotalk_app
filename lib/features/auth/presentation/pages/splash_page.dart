import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/router/app_router_name.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _hasNavigated = false;
  StreamSubscription<AuthState>? _subscription;

  @override
  void initState() {
    super.initState();
    // 초기 상태를 확인하여 즉시 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasNavigated) return;

      final authState = context.read<AuthBloc>().state;

      // 이미 결정된 상태면 즉시 네비게이션
      if (authState is AuthAuthenticated ||
          authState is AuthUnauthenticated ||
          authState is AuthFailure) {
        _checkAuthAndNavigate();
      } else {
        // 상태가 아직 결정되지 않았으면 Stream 구독
        _subscription = context.read<AuthBloc>().stream.listen((state) {
          if (!mounted || _hasNavigated) return;
          if (state is! AuthInitial && state is! AuthLoading) {
            _checkAuthAndNavigate();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _checkAuthAndNavigate() {
    if (_hasNavigated || !mounted) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _hasNavigated = true;
      _subscription?.cancel();
      if (mounted) {
        context.go(AppRouterName.home);
      }
    } else if (authState is AuthUnauthenticated || authState is AuthFailure) {
      _hasNavigated = true;
      _subscription?.cancel();
      if (mounted) {
        context.go(AppRouterName.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform.scale(
          scale: 0.7,
          child: SvgPicture.asset('assets/images/splash_new.svg'),
        ),
      ),
    );
  }
}
