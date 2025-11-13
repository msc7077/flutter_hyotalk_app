import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// HyotalkApp: 앱의 루트 위젯
///
/// ## 역할:
/// - MaterialApp.router를 사용하여 GoRouter 기반 네비게이션 설정
/// - routerProvider를 watch하여 라우터 변경사항에 반응
///
/// ## 동작:
/// - routerProvider가 변경되면 (인증 상태 변경 등) GoRouter가 재생성됨
/// - GoRouter의 redirect 로직이 실행되어 적절한 화면으로 리다이렉트
class HyotalkApp extends ConsumerWidget {
  const HyotalkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // routerProvider를 watch하여 라우터 변경사항에 반응
    // - authState나 splashShown이 변경되면 GoRouter가 재생성됨
    // - 재생성 시 redirect 로직이 실행되어 적절한 화면으로 이동
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hyotalk App',
      routerConfig: router,
    );
  }
}
