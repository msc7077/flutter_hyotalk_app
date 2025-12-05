import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/repository/auth_repository.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/features/auth/view/login_view.dart';
import 'package:flutter_hyotalk_app/features/auth/view/splash_view.dart';
import 'package:flutter_hyotalk_app/features/home/view/home_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AuthRepository authRepository;

  AppRouter({required this.authRepository});

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashView()),
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
      GoRoute(path: '/home', builder: (context, state) => const HomeView()),
    ],
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      AppLoggerService.i(
        'AppRouter > Auth State: $authState, Location: ${state.matchedLocation}',
      );

      final loggingIn = state.matchedLocation == '/login';

      if (authState is AuthUnauthenticated && !loggingIn) {
        return '/login';
      }
      if (authState is AuthAuthenticated && loggingIn) {
        return '/home';
      }
      if (authState is AuthFailure && !loggingIn) {
        return '/login';
      }
      if (authState is AuthFailure && loggingIn) {
        return '/home';
      }
      return null;
    },
  );
}
