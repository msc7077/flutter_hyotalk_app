import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/hyotalk_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // ProviderScope: Riverpod 상태 저장소를 사용하기 위한 루트 위젯
  // 이제 모든 Provider는 이 범위 내에서 사용할 수 있다.
  runApp(const ProviderScope(child: HyotalkApp()));
}
