import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/storage/app_preference_storage.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';

/// SplashBloc 이벤트 베이스 타입
///
abstract class SplashEvent {
  const SplashEvent();
}

class SplashAuthStateChanged extends SplashEvent {
  const SplashAuthStateChanged({required this.authState});

  final AuthState authState;
}

class SplashNavAction {
  SplashNavAction({required this.go, this.push});

  final String go;
  final String? push;
}

class SplashState {
  SplashState({this.action, this.actionSeq = 0});

  final SplashNavAction? action;
  final int actionSeq;

  SplashState copyWith({SplashNavAction? action, int? actionSeq}) {
    return SplashState(action: action ?? this.action, actionSeq: actionSeq ?? this.actionSeq);
  }
}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState()) {
    on<SplashAuthStateChanged>(_onAuthStateChanged);
  }

  bool _navigated = false;

  Future<void> _onAuthStateChanged(SplashAuthStateChanged event, Emitter<SplashState> emit) async {
    if (_navigated) return;

    final authState = event.authState;
    if (authState is AuthInitial || authState is AuthLoading) return;

    _navigated = true;

    await Future.delayed(const Duration(seconds: 2));

    final pending = AppPreferenceStorage.getString(AppPreferenceStorageKey.pendingDeepLinkLocation);

    // pending 딥링크가 있으면 처리 후 이동
    if (pending.isNotEmpty) {
      final isInvite =
          pending.startsWith(AppRouterPath.simpleRegister) || pending.startsWith('/invitemsg');

      // 초대/간편회원가입은 "1회성"으로 소비(뒤로가기/재진입 시 반복 이동 방지)
      if (isInvite) {
        await AppPreferenceStorage.remove(AppPreferenceStorageKey.pendingDeepLinkLocation);

        // 미로그인일때 초대 링크는 splash -> simpleRegister, back -> login
        // login을 밑에 깔고 simpleRegister를 push로 올린다.
        if (authState is AuthUnauthenticated || authState is AuthFailure) {
          emit(
            state.copyWith(
              action: SplashNavAction(go: AppRouterPath.login, push: pending),
              actionSeq: state.actionSeq + 1,
            ),
          );
          return;
        }

        // 로그인 상태면 홈을 깔고 push로 올려서 back stack 보장
        emit(
          state.copyWith(
            action: SplashNavAction(go: AppRouterPath.home, push: pending),
            actionSeq: state.actionSeq + 1,
          ),
        );
        return;
      }

      // 로그인 상태면 소비 후 이동, 미로그인이면 pending 유지 후 로그인으로
      if (authState is AuthAuthenticated) {
        await AppPreferenceStorage.remove(AppPreferenceStorageKey.pendingDeepLinkLocation);
        emit(
          state.copyWith(
            action: SplashNavAction(go: AppRouterPath.home, push: pending),
            actionSeq: state.actionSeq + 1,
          ),
        );
        return;
      }

      // 미로그인 상태면 pending 그대로 두고 로그인으로
      emit(
        state.copyWith(
          action: SplashNavAction(go: AppRouterPath.login),
          actionSeq: state.actionSeq + 1,
        ),
      );
      return;
    }

    // pending 없으면 인증 상태에 따라 기본 이동
    if (authState is AuthAuthenticated) {
      emit(
        state.copyWith(
          action: SplashNavAction(go: AppRouterPath.home),
          actionSeq: state.actionSeq + 1,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        action: SplashNavAction(go: AppRouterPath.login),
        actionSeq: state.actionSeq + 1,
      ),
    );
  }
}
