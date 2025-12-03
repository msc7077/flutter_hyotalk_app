import 'package:flutter_hyotalk_app/features/auth/notifier/auth_notifier.dart';
import 'package:flutter_hyotalk_app/features/auth/models/auth_state.dart';
import 'package:flutter_hyotalk_app/features/auth/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AuthRepository Provider
/// 실제 API 연동 시 MockAuthRepository를 실제 구현체로 교체
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

/// AuthState Provider
/// 인증 상태(사용자 정보, 로딩 상태, 에러)를 관리
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
