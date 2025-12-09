import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  bool _autoLoginFlag = false;

  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    on<AuthInit>(_onAuthInit);
    on<AuthGetToken>(_onAuthGetToken);
    on<AuthLogin>(_onAuthLogin);
    on<AuthAutoLogin>(_onAuthAutoLogin);
    on<AuthLogout>(_onAuthLogout);
  }

  void setAutoLoginFlag(bool value) {
    _autoLoginFlag = value;
  }

  Future<void> _onAuthInit(AuthInit event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    
    final autoLoginEnabled = await _authRepository.checkAutoLogin();
    if (autoLoginEnabled) {
      add(const AuthAutoLogin());
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthGetToken(
    AuthGetToken event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final token = await _authRepository.getTokenFromServer();
      // 토큰을 받은 후 자동으로 로그인
      final authModel = await _authRepository.loginWithToken(token);
      
      // 자동 로그인 플래그가 설정되어 있으면 저장
      if (_autoLoginFlag) {
        await _authRepository.setAutoLogin(true);
      }
      
      emit(AuthAuthenticated(authModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final authModel = await _authRepository.loginWithToken(event.token);
      
      if (event.autoLogin) {
        await _authRepository.setAutoLogin(true);
      }
      
      emit(AuthAuthenticated(authModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthAutoLogin(
    AuthAutoLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final authModel = await _authRepository.autoLogin();
      if (authModel != null) {
        emit(AuthAuthenticated(authModel));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

