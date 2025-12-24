import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/config/env_config.dart';
import 'package:flutter_hyotalk_app/core/init/app_initializer.dart';
import 'package:flutter_hyotalk_app/core/service/app_bloc_observer_service.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/core/storage/app_preference_storage.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/core/theme/app_theme.dart';
import 'package:flutter_hyotalk_app/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/router/app_router.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';
import 'package:flutter_hyotalk_app/router/deep_link_normalizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Flavor에 따라 환경 설정 로드
  // 기본값은 dev, 실제로는 빌드 시점에 flavor를 전달받아야 함
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  AppLoggerService.i('Flavor: $flavor');
  await EnvConfig.loadEnv(flavor);
  await AppInitializer.instance.init();

  if (kDebugMode) {
    Bloc.observer = AppBlocObserverService();
  }

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository(authDio: AppInitializer.instance.authDio)),
      ],
      child: BlocProvider(
        create: (context) =>
            AuthBloc(context.read<AuthRepository>())..add(AutoLoginCheckRequested()),
        child: const HyotalkApp(),
      ),
    ),
  );
}

class HyotalkApp extends StatefulWidget {
  const HyotalkApp({super.key});

  @override
  State<HyotalkApp> createState() => _HyotalkAppState();
}

class _HyotalkAppState extends State<HyotalkApp> {
  // 라우터 초기화
  late AppRouter _appRouter = AppRouter();

  // 딥링크 초기화
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  // Android에서 getInitialLink와 uriLinkStream이 둘 다 한 번씩 같은 걸 주는 경우가 있어서
  //중복 처리를 방지하기 위해 추가
  String? _lastHandledLink;

  /// 외부 딥링크를 처리
  ///
  /// - cold start: 항상 splash를 거치게
  /// - warm start: 현재 컨텍스트에서 auth 상태 확인 후 이동
  Future<void> _handleIncomingUri(Uri uri, {required bool isColdStart}) async {
    final raw = uri.toString();
    if (_lastHandledLink == raw) return;
    _lastHandledLink = raw;

    final location = DeepLinkNormalizer.normalize(uri);
    AppLoggerService.i('handleIncomingUri > raw: $raw, location: $location');
    if (location == null || location.isEmpty) return;

    // cold start: 항상 splash를 거치게
    if (isColdStart) {
      await AppPreferenceStorage.setString(
        AppPreferenceStorageKey.pendingDeepLinkLocation,
        location,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _appRouter.router.go(AppRouterPath.splash);
      });
      return;
    } else {
      // warm start: 현재 컨텍스트에서 auth 상태 확인 후 이동
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final authState = context.read<AuthBloc>().state;
        final router = _appRouter.router;

        final isTabRoot =
            location == AppRouterPath.home ||
            location == AppRouterPath.album ||
            location == AppRouterPath.workDiary;

        final isInvite = location.startsWith(
          '/invitemsg',
        ); // iOS https 경로용(라우터에서 /invite로 redirect됨)

        // 로그인 상태
        if (authState is AuthAuthenticated) {
          if (isTabRoot) {
            router.go(location);
          } else {
            router.push(location);
          }
          return;
        } else {
          // 2) 미로그인 상태
          if (isInvite) {
            // login 스택 만들고 push로 올리기
            router.go(AppRouterPath.login);
            Future.microtask(() => router.push(location));
            return;
          }
        }

        // 그 외는 로그인으로 보내고, 로그인 성공 후 pending 처리
        // PendingDeepLinkStore.set(location);
        AppPreferenceStorage.setString(AppPreferenceStorageKey.pendingDeepLinkLocation, location);
        router.go(AppRouterPath.login);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // StatelessWidget → build() → 코드 저장하면 build() 다시 실행되버리는데 →
    // router도 새로 → redirect도 초기화되어 앱 재실행되버림.
    // GoRouter가 Hot Reload 때마다 새로 생성되기 때문에 코드 수정을 저장할때마다 앱이 재실행되버린다.
    // 그래서 HyotalkApp StatefulWidget로 바꾸고 GoRouter를 initState에서 딱 1번만 생성하도록 함.
    _appRouter = AppRouter();

    // cold start (앱 완전 종료 상태에서 들어온 링크)
    _appLinks.getInitialLink().then((uri) {
      AppLoggerService.i('getInitialLink > uri: $uri');
      if (uri == null) return;
      _handleIncomingUri(uri, isColdStart: true);
    });

    // warm start (실행 중/백그라운드에서 들어온 링크)
    // uriLinkStream은 이벤트가 발생할때만 uri가 오기 때문에 null이 될 수 없다.
    _sub = _appLinks.uriLinkStream.listen((uri) {
      AppLoggerService.i('uriLinkStream >uri: $uri');
      _handleIncomingUri(uri, isColdStart: false);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        top: false,
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          child: MaterialApp.router(
            routerConfig: _appRouter.router,
            debugShowCheckedModeBanner: true,
            theme: AppTheme.lightTheme,
          ),
        ),
      ),
    );
  }
}
