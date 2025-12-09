import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthInit extends AuthEvent {
  const AuthInit();
}

class AuthGetToken extends AuthEvent {
  const AuthGetToken();
}

class AuthLogin extends AuthEvent {
  final String token;
  final bool autoLogin;

  const AuthLogin({
    required this.token,
    this.autoLogin = false,
  });

  @override
  List<Object?> get props => [token, autoLogin];
}

class AuthAutoLogin extends AuthEvent {
  const AuthAutoLogin();
}

class AuthLogout extends AuthEvent {
  const AuthLogout();
}

