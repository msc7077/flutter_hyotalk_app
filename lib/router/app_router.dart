import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:flutter_hyotalk_app/core/widget/dialog/app_common_dialog.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter_hyotalk_app/features/main/presentation/pages/main_page.dart';
import 'package:flutter_hyotalk_app/features/more/presentation/pages/more_tab_page.dart';
import 'package:flutter_hyotalk_app/features/notice/presentation/page/notice_detail_page.dart';
import 'package:flutter_hyotalk_app/features/notice/presentation/page/notice_form_page.dart';
import 'package:flutter_hyotalk_app/features/notice/presentation/page/notice_list_page.dart';
import 'package:flutter_hyotalk_app/router/app_router_name.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';
import 'package:go_router/go_router.dart';

/// AppRouter 앱의 라우팅 관리를 담당
///
class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: AppRouterPath.splash,
    errorBuilder: (context, state) {
      return Scaffold(
        body: Builder(
          builder: (dialogContext) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (dialogContext.mounted) {
                AppCommonDialog.show(
                  dialogContext,
                  AppTexts.pageNotFound,
                  title: AppTexts.error,
                  onConfirm: () {
                    context.go(AppRouterPath.home);
                  },
                );

                // 1초 후 자동으로 홈으로 이동
                Future.delayed(const Duration(seconds: 1), () {
                  if (dialogContext.mounted && context.mounted) {
                    context.go(AppRouterPath.home);
                  }
                });
              }
            });
            return const SizedBox.shrink();
          },
        ),
      );
    },
    routes: [
      GoRoute(
        path: AppRouterPath.splash,
        name: AppRouterName.splashName,
        pageBuilder: (context, state) =>
            _buildFadePage(context, state, const SplashPage(), isFadeOut: true),
      ),
      GoRoute(
        path: AppRouterPath.login,
        name: AppRouterName.loginName,
        pageBuilder: (context, state) =>
            _buildFadePage(context, state, const LoginPage(), isFadeIn: true),
      ),
      ShellRoute(
        pageBuilder: (context, state, child) {
          return _buildFadePage(context, state, MainPage(child: child), isFadeIn: true);
        },
        routes: [
          GoRoute(
            path: AppRouterPath.home,
            name: AppRouterName.homeName,
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: AppRouterPath.album,
            name: AppRouterName.albumName,
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: AppRouterPath.workDiary,
            name: AppRouterName.workDiaryName,
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      GoRoute(
        path: AppRouterPath.more,
        name: AppRouterName.moreName,
        pageBuilder: (context, state) => _buildSlidePage(context, state, const MoreTabPage()),
      ),
      GoRoute(
        path: AppRouterPath.noticeList,
        name: AppRouterName.noticeListName,
        pageBuilder: (context, state) => _buildSlidePage(context, state, const NoticeListPage()),
      ),
      GoRoute(
        path: AppRouterPath.noticeForm,
        name: AppRouterName.noticeFormName,
        pageBuilder: (context, state) {
          // 작성 모드
          return _buildSlidePage(context, state, const NoticeFormPage());
        },
      ),
      GoRoute(
        path: AppRouterPath.noticeEdit,
        name: AppRouterName.noticeEditName,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          // 수정 모드
          return _buildSlidePage(context, state, NoticeFormPage(noticeId: id));
        },
      ),
      GoRoute(
        path: AppRouterPath.noticeDetail,
        name: AppRouterName.noticeDetailName,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _buildSlidePage(context, state, NoticeDetailPage(noticeId: id));
        },
      ),
    ],
  );
}

/// 페이지 전환시 Fade in/out 애니메이션을 위한 헬퍼 메서드
/// 스플레시에서 로그인페이지로 이동시 사용
/// 로그인페이지에서 메인페이지로 이동시 사용
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
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
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
          opacity: Tween<double>(
            begin: 1.0,
            end: 0.0,
          ).animate(CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOut)),
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

/// main 페이지 외에 2depth 페이지 이동시 오른쪽에서 왼쪽으로 슬라이드 애니메이션
/// android/ios 모두 동일한 애니메이션 적용
Page _buildSlidePage(BuildContext context, GoRouterState state, Widget child) {
  if (Platform.isIOS) {
    // iOS: 기본 MaterialPage (스와이프 제스처 자동 지원)
    return MaterialPage(key: state.pageKey, child: child);
  } else {
    // Android: 커스텀 슬라이드 애니메이션
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }
}
