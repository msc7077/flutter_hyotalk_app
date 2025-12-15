import 'package:equatable/equatable.dart';
import 'package:flutter_hyotalk_app/features/home/data/models/home_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class HomeInitial extends HomeState {}

/// 홈 로딩 상태
class HomeLoading extends HomeState {}

/// 홈 로드 완료 상태
class HomeLoaded extends HomeState {
  final HomeModel homeModel;

  const HomeLoaded({required this.homeModel});

  @override
  List<Object?> get props => [homeModel];
}

/// 홈 로드 실패 상태
class HomeFailure extends HomeState {
  final String message;

  const HomeFailure(this.message);

  @override
  List<Object?> get props => [message];
}

