import 'package:equatable/equatable.dart';
import 'package:flutter_hyotalk_app/features/auth/data/models/user_info_model.dart';

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
  final UserInfoModel userInfo;

  const AuthAuthenticated({required this.token, required this.userInfo});

  @override
  List<Object?> get props => [token, userInfo];
}

/// Auth 인증 안된 상태
class AuthUnauthenticated extends AuthState {}

/// Auth 인증 실패 상태
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}
