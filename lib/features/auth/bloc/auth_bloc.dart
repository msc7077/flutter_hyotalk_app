import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/repository/auth_repository.dart';
import 'package:flutter_hyotalk_app/features/auth/bloc/auth_event.dart';
import 'package:flutter_hyotalk_app/features/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<AutoLoginCheckRequested>(_onAutoLoginCheckRequested);
    on<AuthTokenRequested>(_onAuthTokenRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  /// 자동로그인 체크
  Future<void> _onAutoLoginCheckRequested(
    AutoLoginCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final token = repository.prefs.getString('accessToken');
    if (repository.getIsAutoLogin() && token != null) {
      emit(AuthAuthenticated(token: token));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Auth 토큰 요청
  Future<void> _onAuthTokenRequested(
    AuthTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await repository.requestAuthToken(event.id, event.password);
      if (event.isAutoLogin) await repository.saveIsAutoLogin(true);
      emit(AuthAuthenticated(token: token));
    } on DioException catch (e) {
      final errorMessage =
          e.requestOptions.extra['customErrorMessage'] as String? ??
          '로그인에 실패했습니다.';
      emit(AuthFailure(errorMessage));
    } catch (e) {
      emit(AuthFailure('알 수 없는 오류가 발생했습니다: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await repository.logout();
    emit(AuthUnauthenticated());
  }
}
