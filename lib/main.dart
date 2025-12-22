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
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/core/theme/app_theme.dart';
import 'package:flutter_hyotalk_app/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_hyotalk_app/router/app_router.dart';
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

  @override
  void initState() {
    super.initState();

    // StatelessWidget → build() → 코드 저장하면 build() 다시 실행되버리는데 →
    // router도 새로 → redirect도 초기화되어 앱 재실행되버림.
    // GoRouter가 Hot Reload 때마다 새로 생성되기 때문에 코드 수정을 저장할때마다 앱이 재실행되버린다.
    // 그래서 HyotalkApp StatefulWidget로 바꾸고 GoRouter를 initState에서 딱 1번만 생성하도록 수정했다.
    _appRouter = AppRouter();

    // 1) cold start (앱 완전 종료 상태에서 들어온 링크)
    _appLinks.getInitialLink().then((uri) {
      AppLoggerService.i('getInitialLink > uri: $uri');
      if (uri == null) return;
      // TODO: uri를 location으로 변환해서 저장/이동
      // ex) PendingDeepLinkStore.set(normalize(uri));
    });

    // 2) warm start (실행 중/백그라운드에서 들어온 링크)
    _sub = _appLinks.uriLinkStream.listen((uri) {
      AppLoggerService.i('uriLinkStream >uri: $uri');
      // TODO: uri를 location으로 변환해서 저장/이동
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
