import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hyotalk_app/core/init/app_initializer.dart';
import 'package:flutter_hyotalk_app/core/repository/auth_repository.dart';
import 'package:flutter_hyotalk_app/core/service/app_bloc_observer_service.dart';
import 'package:flutter_hyotalk_app/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/bloc/auth_event.dart';
import 'package:flutter_hyotalk_app/router/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final envFile = switch (flavor) {
    'stage' => '.env.stage',
    'prod' => '.env.prod',
    _ => '.env.dev',
  };
  await dotenv.load(fileName: envFile);
  await AppInitializer.instance.init();
  Bloc.observer = AppBlocObserverService();

  runApp(
    RepositoryProvider(
      create:
          (_) => AuthRepository(
            dio: AppInitializer.instance.authDio,
            prefs: AppInitializer.instance.prefs,
          ),
      child: BlocProvider(
        create:
            (context) =>
                AuthBloc(context.read<AuthRepository>())
                  ..add(AutoLoginCheckRequested()),
        child: const HyoTalkApp(),
      ),
    ),
  );
}

class HyoTalkApp extends StatelessWidget {
  const HyoTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = context.read<AuthRepository>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 상태바 배경색 설정
        statusBarIconBrightness: Brightness.dark, // 상태바 아이콘 밝기 설정
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black, // 네비게이션 바 배경색 설정
        systemNavigationBarIconBrightness:
            Brightness.light, // 네비게이션 바 아이콘 밝기 설정
      ),
      child: SafeArea(
        top: false,
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          child: MaterialApp.router(
            routerConfig: AppRouter(authRepository: authRepository).router,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}
