import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hyotalk_app/core/navigation/deep_link_normalizer.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/core/storage/app_preference_storage.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';
import 'package:go_router/go_router.dart';

class DeepLinkController {
  DeepLinkController({required GoRouter router, AppLinks? appLinks})
    : _router = router,
      _appLinks = appLinks ?? AppLinks();

  final GoRouter _router;
  final AppLinks _appLinks;

  StreamSubscription<Uri>? _sub;
  // Android에서 getInitialLink와 uriLinkStream이 둘 다 한 번씩 같은 걸 주는 경우가 있어서
  // 중복 처리를 방지하기 위해 추가
  String? _lastHandledLink;

  Future<void> init({required AuthState Function() getAuthState}) async {
    // cold start (앱 완전 종료 상태에서 들어온 링크)
    final initial = await _appLinks.getInitialLink();
    AppLoggerService.i('getInitialLink > uri: $initial');
    // initial 이 있을때만 딥링크 처리함
    if (initial != null) {
      await _handle(initial, isColdStart: true, authState: getAuthState());
    }

    // warm start (실행 중/백그라운드에서 들어온 링크)
    // uriLinkStream은 이벤트가 발생할때만 uri가 오기 때문에 null이 될 수 없다.
    _sub = _appLinks.uriLinkStream.listen((uri) {
      AppLoggerService.i('uriLinkStream > uri: $uri');
      _handle(uri, isColdStart: false, authState: getAuthState());
    });
  }

  Future<void> dispose() async {
    await _sub?.cancel();
  }

  /// 외부 딥링크를 처리
  ///
  /// _lastHandledLink 를 통해 중복 처리를 방지
  /// - cold start: 항상 splash를 거치게
  /// - warm start: 현재 컨텍스트에서 auth 상태 확인 후 이동
  Future<void> _handle(Uri uri, {required bool isColdStart, required AuthState authState}) async {
    final raw = uri.toString();
    if (_lastHandledLink == raw) return;
    _lastHandledLink = raw;

    // 외부 딥링크 URI(hyotalk://, https://)를 앱 내부 라우트로 정규화
    final location = DeepLinkNormalizer.normalize(uri);
    AppLoggerService.i('handleIncomingUri > raw: $raw, location: $location');
    if (location == null || location.isEmpty) return;

    if (isColdStart) {
      // cold start: 항상 splash를 거치게
      await AppPreferenceStorage.setString(
        AppPreferenceStorageKey.pendingDeepLinkLocation,
        location,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _router.go(AppRouterPath.splash);
      });
      return;
    }

    // warm start: 현재 컨텍스트에서 auth 상태 확인 후 이동
    final isTabRoot =
        location == AppRouterPath.home ||
        location == AppRouterPath.album ||
        location == AppRouterPath.workDiary;

    final isInvite = location.startsWith(AppRouterPath.inviteRegister);
    // 앨범과 업무일지는 탭 내부 2depth 화면이므로, 탭을 먼저 선택하고 상세를 올린다.
    final isAlbumDetail = location.startsWith('${AppRouterPath.album}/');
    final isWorkDiaryDetail = location.startsWith('${AppRouterPath.workDiary}/');
    // 앨범과 업무일지 탭이 아닌 2depth 화면은 홈 탭을 베이스로 한다.
    // TODO : 공지사항처럼 탭 외에 2depth 화면이 있는 경우가 필요한 경우에는 추가한다.
    final isNoticeDetail = location.startsWith('${AppRouterPath.notice}/');

    if (authState is AuthAuthenticated) {
      // warm start에서 바로 이동하는 경우, 남아있는 pending이 있으면 정리
      AppPreferenceStorage.remove(AppPreferenceStorageKey.pendingDeepLinkLocation);

      if (isTabRoot) {
        _router.go(location);
      } else {
        // 요구사항: 예) /album/1 이면 앨범 탭을 먼저 선택하고 상세를 올린다.
        if (isAlbumDetail || isWorkDiaryDetail || isNoticeDetail) {
          final base = isAlbumDetail
              ? AppRouterPath.album
              : isWorkDiaryDetail
              ? AppRouterPath.workDiary
              : AppRouterPath.home; // 공지사항 상세는 홈 탭을 베이스로
          _router.go(base);
          Future.microtask(() => _router.push(location));
        } else {
          _router.push(location);
        }
      }
      return;
    }

    // 미로그인 상태에 초대 링크가 있으면 로그인으로 보내고, 로그인 성공 후 pending 처리
    if (isInvite) {
      // 초대는 warm start에서 pending 저장 없이 즉시 스택 구성
      AppPreferenceStorage.remove(AppPreferenceStorageKey.pendingDeepLinkLocation);
      // login 스택 만들고 push로 올리기
      _router.go(AppRouterPath.login);
      Future.microtask(() => _router.push(location));
      return;
    }

    // 그 외는 로그인으로 보내고, 로그인 성공 후 pending 처리
    Future.microtask(() async {
      await AppPreferenceStorage.setString(
        AppPreferenceStorageKey.pendingDeepLinkLocation,
        location,
      );
      _router.go(AppRouterPath.login);
    });
  }
}
