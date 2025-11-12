import 'package:flutter_hyotalk_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_hyotalk_app/features/auth/views/login_view.dart';
import 'package:flutter_hyotalk_app/features/home/home_view.dart';
import 'package:flutter_hyotalk_app/features/splash/providers/splash_provider.dart';
import 'package:flutter_hyotalk_app/features/splash/splash_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final splashShown = ref.watch(splashShownProvider);

  return GoRouter(
    initialLocation: splashShown ? '/' : '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashView()),
      GoRoute(path: '/', builder: (context, state) => const HomeView()),
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
    ],
    redirect: (context, state) {
      final isSplash = state.matchedLocation == '/splash';

      // 스플래시 경로에서는 어떠한 리다이렉트도 하지 않음
      if (isSplash) {
        return null;
      }

      // 아직 스플래시를 보지 않았다면 무조건 스플래시로 이동
      if (!splashShown) {
        return '/splash';
      }

      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoggingIn) return '/login';
      if (isAuthenticated && isLoggingIn) return '/';
      return null;
    },
  );
});
