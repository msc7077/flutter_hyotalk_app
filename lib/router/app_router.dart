import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter_hyotalk_app/features/home/presentation/pages/category_detail_page.dart';
import 'package:flutter_hyotalk_app/features/main/presentation/pages/main_page.dart';
import 'package:flutter_hyotalk_app/features/mypage/presentation/pages/mypage_tab_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) =>
            _buildFadePage(context, state, const SplashPage(), isFadeOut: true),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) =>
            _buildFadePage(context, state, const LoginPage(), isFadeIn: true),
      ),
      ShellRoute(
        pageBuilder: (context, state, child) {
          return _buildFadePage(
            context,
            state,
            MainPage(child: child),
            isFadeIn: true,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/work-diary',
            name: 'work-diary',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/shopping',
            name: 'shopping',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      GoRoute(
        path: '/mypage',
        name: 'mypage',
        builder: (context, state) => const MypageTabPage(),
      ),
      GoRoute(
        path: '/category/:id',
        name: 'category-detail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CategoryDetailPage(categoryId: id);
        },
      ),
    ],
  );
}

/// Fade in/out 애니메이션을 위한 헬퍼 메서드
Page _buildFadePage(
  BuildContext context,
  GoRouterState state,
  Widget child, {
  bool isFadeIn = false,
  bool isFadeOut = false,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (isFadeIn && isFadeOut) {
        // Fade in과 fade out 모두 적용 (로그인 페이지 등)
        // 나타날 때는 animation 사용 (fade in), 사라질 때는 secondaryAnimation 사용 (fade out)
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );
      } else if (isFadeIn) {
        // Fade in: 투명에서 불투명으로
        // 스플래시가 fade out되는 동안 동시에 나타나도록
        // 로그인 페이지는 나타날 때와 사라질 때 모두 fade 적용
        return FadeTransition(opacity: animation, child: child);
      } else if (isFadeOut) {
        // Fade out: 불투명에서 투명으로
        // 메인이 fade in되는 동안 동시에 사라지도록
        return FadeTransition(
          opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOut),
          ),
          child: child,
        );
      } else {
        // 기본 fade
        return FadeTransition(opacity: animation, child: child);
      }
    },
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
  );
}
