import 'package:flutter_hyotalk_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_hyotalk_app/features/auth/views/login_view.dart';
import 'package:flutter_hyotalk_app/features/home/home_view.dart';
import 'package:flutter_hyotalk_app/features/splash/providers/splash_provider.dart';
import 'package:flutter_hyotalk_app/features/splash/view/splash_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 라우터 Provider
///
/// 앱의 전체 네비게이션 흐름을 관리합니다.
///
/// ## 전체 흐름:
/// 1. 앱 최초 실행: splashShown = false → initialLocation = '/splash'
/// 2. 스플래시 화면 표시 (2초)
/// 3. 스플래시에서 splashShown = true로 설정
/// 4. 인증 상태에 따라 '/' 또는 '/login'으로 이동
/// 5. 이후 로그인/로그아웃 시: splashShown = true이므로 스플래시를 거치지 않고 직접 이동
///
/// ## 리다이렉트 로직:
/// - 스플래시 경로에서는 리다이렉트하지 않음 (스플래시가 자체적으로 처리)
/// - 아직 스플래시를 보지 않았다면 무조건 스플래시로 이동
/// - 이미 스플래시를 봤다면 인증 상태에 따라 로그인/홈으로 이동
final routerProvider = Provider<GoRouter>((ref) {
  // 인증 상태와 스플래시 표시 여부를 watch하여 라우터가 변경사항에 반응하도록 함
  final authState = ref.watch(authProvider);
  final splashShown = ref.watch(splashShownProvider);

  return GoRouter(
    // 초기 위치 결정:
    // - 스플래시를 이미 봤다면 → 인증 상태에 따라 자동 리다이렉트될 홈('/')
    // - 스플래시를 아직 안 봤다면 → 스플래시('/splash')
    initialLocation: splashShown ? '/' : '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashView()),
      GoRoute(path: '/', builder: (context, state) => const HomeView()),
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
    ],
    redirect: (context, state) {
      final isSplash = state.matchedLocation == '/splash';

      // [중요] 스플래시 경로에서는 어떠한 리다이렉트도 하지 않음
      // - 스플래시 화면이 자체적으로 2초 후 적절한 화면으로 이동하므로
      // - 여기서 리다이렉트하면 스플래시가 즉시 사라지는 문제 발생
      if (isSplash) {
        return null;
      }

      // 아직 스플래시를 보지 않았다면 무조건 스플래시로 이동
      // - 앱 최초 실행 시 또는 앱 재시작 시에만 실행됨
      if (!splashShown) {
        return '/splash';
      }

      // 스플래시를 이미 봤다면 인증 상태에 따라 리다이렉트
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      // 비로그인 상태이고 로그인 화면이 아니면 → 로그인 화면으로
      if (!isAuthenticated && !isLoggingIn) return '/login';
      // 로그인 상태인데 로그인 화면에 있으면 → 홈 화면으로
      if (isAuthenticated && isLoggingIn) return '/';
      // 그 외의 경우는 리다이렉트하지 않음
      return null;
    },
  );
});
