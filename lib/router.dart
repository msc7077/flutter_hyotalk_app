import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/auth_notifier.dart';
import 'features/auth/login_view.dart';
import 'features/home/home_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeView()),
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
    ],
    redirect: (context, state) {
      final loggedIn = user != null;
      final loggingIn =
          state.matchedLocation ==
          '/login'; // state.subloc은 GoRouter 16.3.0에서 제공되지 않는다.

      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/';
      return null;
    },
  );
});
