import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _autoLogin = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else if (state is AuthAuthenticated) {
          context.go('/home');
        } else if (state is AuthError) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('로그인'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hyotalk',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              CheckboxListTile(
                title: const Text('자동 로그인'),
                value: _autoLogin,
                onChanged: (value) {
                  setState(() {
                    _autoLogin = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          // 자동 로그인 플래그 설정
                          context.read<AuthBloc>().setAutoLoginFlag(_autoLogin);
                          // 서버에서 토큰 가져오기 및 로그인
                          context.read<AuthBloc>().add(const AuthGetToken());
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('로그인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

