import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:flutter_hyotalk_app/core/widget/dialog/app_common_dialog.dart';
import 'package:flutter_hyotalk_app/features/album/data/models/album_item_model.dart';
import 'package:flutter_hyotalk_app/features/album/presentation/pages/album_detail_page.dart';
import 'package:flutter_hyotalk_app/features/album/presentation/pages/album_tab_page.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/pages/find_id_page.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/pages/invite_page.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/pages/self_certification_page.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/pages/self_certification_webview.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter_hyotalk_app/features/home/presentation/pages/home_tab_page.dart';
import 'package:flutter_hyotalk_app/features/main/presentation/pages/main_page.dart';
import 'package:flutter_hyotalk_app/features/main/presentation/scope/main_scope.dart';
import 'package:flutter_hyotalk_app/features/more/presentation/pages/more_tab_page.dart';
import 'package:flutter_hyotalk_app/features/notice/presentation/page/notice_detail_page.dart';
import 'package:flutter_hyotalk_app/features/notice/presentation/page/notice_form_page.dart';
import 'package:flutter_hyotalk_app/features/notice/presentation/page/notice_list_page.dart';
import 'package:flutter_hyotalk_app/features/work_diary/data/models/work_diary_item_model.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/pages/work_diary_detail_page.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/pages/work_diary_tab_page.dart';
import 'package:flutter_hyotalk_app/router/app_router_name.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';
import 'package:go_router/go_router.dart';

/// AppRouter 앱의 라우팅 관리를 담당
///
/// GlobalKey 를 통해 2depth 이상은 바텀탭 바를 숨기고 전체화면으로 띄우도록 설정했다.
///
class AppRouter {
  AppRouter();
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRouterPath.splash,
    redirect: (context, state) {
      final path = state.uri.path;
      if (path.length > 1 && path.endsWith('/')) {
        final normalizedPath = path.substring(0, path.length - 1);
        return Uri(
          path: normalizedPath,
          queryParameters: state.uri.queryParameters.isEmpty ? null : state.uri.queryParameters,
          fragment: state.uri.fragment.isEmpty ? null : state.uri.fragment,
        ).toString();
      }
      return null;
    },
    errorBuilder: (context, state) {
      AppLoggerService.e(
        'GoRouter errorBuilder > uri=${state.uri}, matchedLocation=${state.matchedLocation}, fullPath=${state.fullPath}',
      );
      final authState = context.read<AuthBloc>().state;
      return Scaffold(
        body: SafeArea(
          child: Builder(
            builder: (dialogContext) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (dialogContext.mounted) {
                  AppCommonDialog.show(
                    dialogContext,
                    AppTexts.pageNotFound,
                    title: AppTexts.error,
                    onConfirm: () {
                      // 인증 상태에 따라 이동 목적지를 분기 (무조건 홈으로 보내지 않음)
                      if (authState is AuthAuthenticated) {
                        context.go(AppRouterPath.home);
                      } else {
                        context.go(AppRouterPath.splash);
                      }
                    },
                  );
                }
              });
              return const SizedBox.shrink();
            },
          ),
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
        path: AppRouterPath.inviteRegister,
        name: AppRouterName.inviteRegisterName,
        pageBuilder: (context, state) {
          final inviteId = state.uri.queryParameters['id'] ?? '';
          return _buildSlidePage(context, state, InvitePage(inviteId: inviteId));
        },
      ),
      GoRoute(
        path: AppRouterPath.login,
        name: AppRouterName.loginName,
        pageBuilder: (context, state) =>
            _buildFadePage(context, state, const LoginPage(), isFadeIn: true),
      ),
      GoRoute(
        path: AppRouterPath.selfCertification,
        name: AppRouterName.selfCertificationName,
        pageBuilder: (context, state) {
          final nextRoute = state.uri.queryParameters['nextRoute'];
          final error = state.uri.queryParameters['error'];
          return _buildSlidePage(
            context,
            state,
            SelfCertificationPage(nextRoute: nextRoute, errorMessage: error),
          );
        },
      ),
      GoRoute(
        path: AppRouterPath.selfCertificationWebView,
        name: AppRouterName.selfCertificationWebViewName,
        pageBuilder: (context, state) {
          final nextRoute = state.uri.queryParameters['nextRoute'];
          return _buildSlidePage(
            context,
            state,
            SelfCertificationWebViewPage(nextRoute: nextRoute),
          );
        },
      ),
      GoRoute(
        path: AppRouterPath.register,
        name: AppRouterName.registerName,
        pageBuilder: (context, state) {
          final ci = state.uri.queryParameters['ci'];
          final cd = state.uri.queryParameters['cd'];
          return _buildSlidePage(context, state, RegisterPage(ci: ci, cd: cd));
        },
      ),
      GoRoute(
        path: AppRouterPath.findId,
        name: AppRouterName.findIdName,
        pageBuilder: (context, state) {
          final ci = state.uri.queryParameters['ci'];
          final cd = state.uri.queryParameters['cd'];
          return _buildSlidePage(context, state, FindIdPage(ci: ci, cd: cd));
        },
      ),
      GoRoute(
        path: AppRouterPath.resetPassword,
        name: AppRouterName.resetPasswordName,
        pageBuilder: (context, state) {
          final ci = state.uri.queryParameters['ci'];
          final cd = state.uri.queryParameters['cd'];
          return _buildSlidePage(context, state, ResetPasswordPage(ci: ci, cd: cd));
        },
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          return _buildFadePage(
            context,
            state,
            MainScope(child: MainPage(navigationShell: navigationShell)),
            isFadeIn: true,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouterPath.home,
                name: AppRouterName.homeName,
                pageBuilder: (context, state) =>
                    _buildFadePage(context, state, const HomeTabPage()),
              ),
            ],
          ),
          // 앨범 브랜치
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouterPath.album,
                name: AppRouterName.albumName,
                pageBuilder: (context, state) =>
                    _buildFadePage(context, state, const AlbumTabPage()),
              ),
            ],
          ),
          // 업무일지 브랜치
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouterPath.workDiary,
                name: AppRouterName.workDiaryName,
                pageBuilder: (context, state) =>
                    _buildFadePage(context, state, const WorkDiaryTabPage()),
              ),
            ],
          ),
        ],
      ),
      // ===== 2depth 이상은 전체 페이지(root navigator)로 띄움 (바텀탭 숨김) =====
      GoRoute(
        path: AppRouterPath.more,
        name: AppRouterName.moreName,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _buildSlidePage(context, state, const MoreTabPage()),
      ),
      GoRoute(
        path: AppRouterPath.notice,
        name: AppRouterName.noticeName,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _buildSlidePage(context, state, const NoticeListPage()),
      ),
      GoRoute(
        path: AppRouterPath.noticeForm,
        name: AppRouterName.noticeFormName,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _buildSlidePage(context, state, const NoticeFormPage()),
      ),
      GoRoute(
        path: AppRouterPath.noticeEdit,
        name: AppRouterName.noticeEditName,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _buildSlidePage(context, state, NoticeFormPage(noticeId: id));
        },
      ),
      GoRoute(
        path: AppRouterPath.noticeDetail,
        name: AppRouterName.noticeDetailName,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _buildSlidePage(context, state, NoticeDetailPage(noticeId: id));
        },
      ),
      GoRoute(
        path: AppRouterPath.albumDetail,
        name: AppRouterName.albumDetailName,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final extra = state.extra;
          if (extra is AlbumItemModel) {
            return _buildSlidePage(context, state, AlbumDetailPage(album: extra));
          }
          return _buildSlidePage(
            context,
            state,
            Scaffold(
              appBar: AppBar(title: const Text('앨범 상세')),
              body: Center(child: Text('id: $id')),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouterPath.workDiaryDetail,
        name: AppRouterName.workDiaryDetailName,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final extra = state.extra;
          if (extra is WorkDiaryItemModel) {
            return _buildSlidePage(context, state, WorkDiaryDetailPage(item: extra));
          }
          return _buildSlidePage(
            context,
            state,
            Scaffold(
              appBar: AppBar(title: const Text('업무일지 상세')),
              body: Center(child: Text('id: $id')),
            ),
          );
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
