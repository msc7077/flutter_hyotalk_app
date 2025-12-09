import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/config/env_config.dart';
import 'package:flutter_hyotalk_app/core/network/dio_client.dart';
import 'package:flutter_hyotalk_app/core/router/app_router.dart';
import 'package:flutter_hyotalk_app/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flavor에 따라 환경 설정 로드
  // 기본값은 dev, 실제로는 빌드 시점에 flavor를 전달받아야 함
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  await EnvConfig.loadEnv(flavor);

  runApp(const HyotalkApp());
}

class HyotalkApp extends StatefulWidget {
  const HyotalkApp({super.key});

  @override
  State<HyotalkApp> createState() => _HyotalkAppState();
}

class _HyotalkAppState extends State<HyotalkApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    // StatelessWidget →; build(); → 저장하면; build(); 다시 실행; →
    // authBloc도;; 새로 생성, router;도 새로 생;성 → redirect;도 초기화 ;→ 앱 재실행처;럼 보임
    // GoRouter가 Hot Reload 때마다 새로 생성되기 때문에 코드 수정을 저장할때마다 앱이 재실행되버린다.
    // 그래서 MyApp을 StatefulWidget로 바꾸고 authBloc과 GoRouter를 initState에서 딱 1번만 생성하도록 수정했다.

    // Bloc 1회 생성
    _authBloc = AuthBloc(AuthRepository(DioClient()));

    // Router 1회 생성
    _router = AppRouter.createRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: _authBloc)],
      child: MaterialApp.router(
        title: 'Hyotalk',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
        routerConfig: _router, // 🔥 매 Hot Reload 때 재생성되지 않음
      ),
    );
  }
}
