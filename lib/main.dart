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
import 'package:flutter_hyotalk_app/features/work_diary/data/repositories/work_diary_repository.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/bloc/work_diary_bloc.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/bloc/work_diary_event.dart';
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
    // 이 Repository들은 앱이 살아있는 동안 계속 재사용된다
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository(authDio: AppInitializer.instance.authDio)),
        RepositoryProvider(
          create: (_) => WorkDiaryRepository(hyotalkDio: AppInitializer.instance.hyotalkDio),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(context.read<AuthRepository>())..add(AutoLoginCheckRequested()),
          ),
          BlocProvider(
            create: (context) =>
                WorkDiaryBloc(context.read<WorkDiaryRepository>())
                  ..add(const WorkDiaryListRequested()),
          ),
        ],
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
  late AppRouter _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();

    // StatelessWidget → build() → 코드 저장하면 build() 다시 실행되버리는데 →
    // router도 새로 → redirect도 초기화되어 앱 재실행되버림.
    // GoRouter가 Hot Reload 때마다 새로 생성되기 때문에 코드 수정을 저장할때마다 앱이 재실행되버린다.
    // 그래서 HyotalkApp StatefulWidget로 바꾸고 GoRouter를 initState에서 딱 1번만 생성하도록 수정했다.
    _appRouter = AppRouter();
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
