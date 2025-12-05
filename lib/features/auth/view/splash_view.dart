import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/bloc/auth_state.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        AppLoggerService.i('SplashView - Auth State Changed: $state');
        Future.delayed(const Duration(milliseconds: 5000), () {
          if (!context.mounted) return;
          if (state is AuthAuthenticated) {
            context.go('/home');
          } else if (state is AuthUnauthenticated) {
            context.go('/login');
          }
        });
      },
      child: Scaffold(
        body: Center(
          child: Transform.scale(
            scale: 0.7,
            child: SvgPicture.asset('assets/images/splash_new.svg'),
          ),
        ),
      ),
    );
  }
}
