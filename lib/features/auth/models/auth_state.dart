import 'package:flutter_hyotalk_app/core/models/app_exception.dart';
import 'package:flutter_hyotalk_app/features/auth/models/user.dart';

/// 인증 상태를 관리하는 클래스
class AuthState {
  final User? user;
  final bool isLoading;
  final AppException? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    AppException? error,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
