import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
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
    // 현재 State 확인
    final currentState = state;

    // 이미 AuthAuthenticated 상태이면 재사용
    if (currentState is AuthAuthenticated) {
      // 저장된 토큰과 현재 State의 토큰 비교
      final storedToken = await AppSecureStorage.getString(AppSecureStorageKey.token);
      final isAutoLogin = AppPreferenceStorage.getBool(AppPreferenceStorageKey.isAutoLogin);

      // 토큰이 같고 자동 로그인이 활성화되어 있다면 재사용 (API 호출 없이 즉시 반환)
      if (isAutoLogin &&
          storedToken != null &&
          storedToken.isNotEmpty &&
          storedToken == currentState.token) {
        // 이미 로그인된 상태이므로 그대로 유지 (불필요한 API 호출 방지)
        return;
      }
    }

    // AuthLoading 상태이면 중복 처리 방지
    if (currentState is AuthLoading) {
      return;
    }

    emit(AuthLoading());

    // 토큰 조회
    final token = await AppSecureStorage.getString(AppSecureStorageKey.token);
    AppLoggerService.i('token: $token');
    // 자동로그인 설정 조회
    final isAutoLogin = AppPreferenceStorage.getBool(AppPreferenceStorageKey.isAutoLogin);

    if (isAutoLogin && token != null && token.isNotEmpty) {
      try {
        // 사용자 정보 조회
        final userInfo = await _authRepository.getUserInfo();
        // 인증된 상태
        emit(AuthAuthenticated(token: token, userInfo: userInfo));
      } catch (e) {
        // 인증되지 않은 상태
        emit(AuthUnauthenticated());
      }
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
      // Auth 토큰 요청
      final token = await _authRepository.requestLogin(event.id, event.password);
      // 자동로그인 설정 저장
      await AppPreferenceStorage.setBool(AppPreferenceStorageKey.isAutoLogin, event.isAutoLogin);
      // 사용자 정보 조회
      final userInfo = await _authRepository.getUserInfo();
      // Auth 인증 완료 상태 발행
      emit(AuthAuthenticated(token: token, userInfo: userInfo));
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
