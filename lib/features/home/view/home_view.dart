import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // 실제 권한별 화면 구현 예:
    // 슈퍼관리자 / 일반관리자 A,B,C / 일반 사용자 분기
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('권한별 화면 표시')),
    );
  }
}
