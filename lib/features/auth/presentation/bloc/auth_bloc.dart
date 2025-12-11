import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/storage/app_preference_storage.dart';
import 'package:flutter_hyotalk_app/core/storage/app_secure_storage.dart';
import 'package:flutter_hyotalk_app/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';

/// Auth 관련 로직 처리
///
/// authRepository를 주입 받아 네트워크 요청 처리
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AutoLoginCheckRequested>(_onAutoLoginCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  /// 자동로그인 체크
  Future<void> _onAutoLoginCheckRequested(
    AutoLoginCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final token = await AppSecureStorage.getString(AppSecureStorageKey.token);
    final isAutoLogin = AppPreferenceStorage.getBool(AppPreferenceStorageKey.isAutoLogin);
    if (isAutoLogin && token != null && token.isNotEmpty) {
      // 인증된 상태
      emit(AuthAuthenticated(token: token));
    } else {
      // 인증되지 않은 상태
      emit(AuthUnauthenticated());
    }
  }

  /// 로그인
  ///
  /// @param id 아이디
  /// @param password 비밀번호
  /// @param isAutoLogin 자동로그인 여부
  ///
  /// Auth 토큰 요청 - 정상 토큰 발급시 정상 로그인
  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await _authRepository.requestLogin(event.id, event.password);
      await AppPreferenceStorage.setBool(AppPreferenceStorageKey.isAutoLogin, event.isAutoLogin);
      emit(AuthAuthenticated(token: token));
    } on DioException catch (e) {
      final errorMessage =
          e.requestOptions.extra['customErrorMessage'] as String? ?? '로그인에 실패했습니다.';
      emit(AuthFailure(errorMessage));
    } catch (e) {
      emit(AuthFailure('알 수 없는 오류가 발생했습니다: ${e.toString()}'));
    }
  }

  /// 로그아웃 요청
  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.requestLogout();
    emit(AuthUnauthenticated());
  }
}
