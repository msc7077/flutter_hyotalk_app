import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class AuthInitial extends AuthState {}

/// Auth 로딩 상태
class AuthLoading extends AuthState {}

/// Auth 인증 완료 상태
class AuthAuthenticated extends AuthState {
  final String token;

  const AuthAuthenticated({required this.token});

  @override
  List<Object?> get props => [token];
}

/// Auth 인증 안된 상태
class AuthUnauthenticated extends AuthState {}

/// Auth 인증 실패 상태
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}
