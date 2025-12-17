import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// 자동로그인 체크박스 토글
/// @param isAutoLogin 자동로그인 여부
class AutoLoginCheckboxToggled extends AuthEvent {
  final bool isAutoLogin;

  const AutoLoginCheckboxToggled({required this.isAutoLogin});

  @override
  List<Object?> get props => [isAutoLogin];
}

/// 자동로그인 체크
class AutoLoginCheckRequested extends AuthEvent {}

/// Auth Token 요청
class LoginRequested extends AuthEvent {
  final String id;
  final String password;
  final bool isAutoLogin;

  const LoginRequested({required this.id, required this.password, this.isAutoLogin = false});

  @override
  List<Object?> get props => [id, password, isAutoLogin];
}

/// 로그아웃 요청 이벤트
class LogoutRequested extends AuthEvent {}

/// 본인인증 토큰 요청 이벤트
class NiceTokenRequested extends AuthEvent {}
