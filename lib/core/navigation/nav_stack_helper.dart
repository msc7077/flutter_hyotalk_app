import 'package:flutter/widgets.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';
import 'package:go_router/go_router.dart';

/// go_router에서 "뒤로가기 스택"을 보장하기 위한 최소 helper.
///
/// - 상세/2depth로 진입할 때는 보통 바닥을 먼저 깔고(push가 쌓이게) 올려야 back 버튼이 생긴다.
///
/// TODO : 앨범 상세면 /album을 바닥으로 깔아야 할 수도 있고, 어떤 화면은 뒤로가기가 의미 없어서 push가 아니라 go(스택 교체)가 더 맞을 수도 있음
class NavStackHelper {
  NavStackHelper._();

  static String _baseTabForLocation(String location) {
    // 앨범 상세는 앨범 탭을 베이스로
    if (location.startsWith('${AppRouterPath.album}/')) return AppRouterPath.album;
    // 업무일지 상세는 업무일지 탭을 베이스로
    if (location.startsWith('${AppRouterPath.workDiary}/')) return AppRouterPath.workDiary;
    // 그 외는 홈 탭을 베이스로
    return AppRouterPath.home;
  }

  /// 로그인 페이지를 바닥에 깔고, 그 위에 [location]을 push 한다.
  ///
  /// 결과: invite/detail 화면에서 back 하면 login 으로 돌아간다.
  static void goLoginThenPush(BuildContext context, String location) {
    final router = GoRouter.of(context);
    router.go(AppRouterPath.login);
    Future.microtask(() {
      if (!context.mounted) return;
      router.push(location);
    });
  }

  /// 홈을 바닥에 깔고, 그 위에 [location]을 push 한다.
  ///
  /// 단, [location]이 탭 루트면 push 없이 go만 한다.
  /// location에 맞는 "베이스 탭"을 깔고, 그 위에 location을 push 한다.
  ///
  /// 예) /album/1 -> go(/album) 후 push(/album/1)
  /// 예) /work-diary/1 -> go(/work-diary) 후 push(/work-diary/1)
  /// 예) 그 외 -> go(/home) 후 push(location)
  static void goBaseThenPush(BuildContext context, String location) {
    // 탭 루트면 그대로 go
    if (location == AppRouterPath.home ||
        location == AppRouterPath.album ||
        location == AppRouterPath.workDiary) {
      context.go(location);
      return;
    }

    final base = _baseTabForLocation(location);
    final router = GoRouter.of(context);
    router.go(base);
    Future.microtask(() {
      if (!context.mounted) return;
      router.push(location);
    });
  }
}
