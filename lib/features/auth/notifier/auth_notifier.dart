import 'package:flutter_hyotalk_app/core/models/app_exception.dart';
import 'package:flutter_hyotalk_app/features/auth/models/auth_state.dart';
import 'package:flutter_hyotalk_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_hyotalk_app/features/auth/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AuthNotifier: 인증 상태를 관리하는 Notifier
///
/// - Notifier을 써서 상태(AuthState)를 관리한다. : Riverpod 3.0에서는 StateNotifier가 deprecated되어 Notifier를 사용해야 한다.
/// - authProvider를 제공한다.
/// - login: 로그인 처리
/// - logout: 로그아웃 처리
/// - signup: 회원가입 처리
/// - clearError: 에러 상태 초기화
class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.read(authRepositoryProvider);
    return const AuthState();
  }

  /// 로그인 처리
  Future<void> login(String email, String password) async {
    // 에러 초기화 및 로딩 시작
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _repository.login(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: UnknownException('알 수 없는 오류가 발생했습니다: $e', e),
      );
    }
  }

  /// 로그아웃 처리
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _repository.logout();
      state = const AuthState();
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: UnknownException('로그아웃 중 오류가 발생했습니다: $e', e),
      );
    }
  }

  /// 회원가입 처리
  Future<void> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _repository.signup(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      state = state.copyWith(user: user, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: UnknownException('회원가입 중 오류가 발생했습니다: $e', e),
      );
    }
  }

  /// 에러 상태 초기화
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
