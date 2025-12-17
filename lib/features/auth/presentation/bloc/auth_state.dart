import 'package:equatable/equatable.dart';
import 'package:flutter_hyotalk_app/features/auth/data/models/nice_token_model.dart';
import 'package:flutter_hyotalk_app/features/auth/data/models/user_info_model.dart';

/// Auth 상태
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
///
/// @param isAutoLogin 자동로그인 여부
class AuthInitial extends AuthState {
  final bool isAutoLogin;

  const AuthInitial({this.isAutoLogin = false});

  @override
  List<Object?> get props => [isAutoLogin];
}

/// Auth 로딩 상태
class AuthLoading extends AuthState {}

/// Auth 인증 완료 상태
///
/// @param Auth 토큰
/// @param userInfo 사용자 정보
/// @return AuthAuthenticated 인증 완료 상태
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
///
/// @param message 에러 메시지
/// @return AuthFailure 인증 실패 상태
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}

/// Nice 본인인증 토큰 로딩 상태
class NiceTokenLoading extends AuthState {}

/// Nice 본인인증 토큰 로드 완료 상태
class NiceTokenCompleted extends AuthState {
  final NiceTokenModel niceToken;

  const NiceTokenCompleted({required this.niceToken});

  @override
  List<Object?> get props => [niceToken];
}

/// Nice 본인인증 토큰 로드 실패 상태
class NiceTokenFailure extends AuthState {
  final String message;

  const NiceTokenFailure(this.message);

  @override
  List<Object?> get props => [message];
}
