import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// HyotalkApp: 앱의 루트 위젯
///
/// - ConsumerWidget을 써서 Provider를 읽을 수 있게 한다.
/// - routerProvider를 사용하여 라우팅을 관리한다.
class HyotalkApp extends ConsumerWidget {
  const HyotalkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Hyotalk App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
