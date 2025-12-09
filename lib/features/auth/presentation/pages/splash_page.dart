import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthInit());
  }

  void _handleAuthState(AuthState state) {
    if (!mounted) return;

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      if (state is AuthAuthenticated) {
        context.go('/home');
      } else if (state is AuthUnauthenticated) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        _handleAuthState(state);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text('Hyotalk', style: Theme.of(context).textTheme.headlineLarge),
            ],
          ),
        ),
      ),
    );
  }
}
