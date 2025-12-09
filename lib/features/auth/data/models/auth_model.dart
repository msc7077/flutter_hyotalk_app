import 'package:equatable/equatable.dart';

class AuthModel extends Equatable {
  final String token;
  final String? refreshToken;
  final bool autoLogin;

  const AuthModel({
    required this.token,
    this.refreshToken,
    this.autoLogin = false,
  });

  @override
  List<Object?> get props => [token, refreshToken, autoLogin];
}

