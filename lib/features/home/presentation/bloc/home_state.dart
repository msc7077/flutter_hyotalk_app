import 'package:equatable/equatable.dart';
import 'package:flutter_hyotalk_app/features/album/data/models/album_item_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class HomeInitial extends HomeState {}

/// 홈 로딩 상태
class HomeLoading extends HomeState {
  final bool isRefreshing;

  const HomeLoading({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

/// 홈 로드 완료 상태
class HomeLoaded extends HomeState {
  final List<AlbumItemModel> homeList;
  final DateTime fetchedAt;

  const HomeLoaded({required this.homeList, required this.fetchedAt});

  @override
  List<Object?> get props => [homeList, fetchedAt];
}

/// 홈 로드 실패 상태
class HomeFailure extends HomeState {
  final String message;

  const HomeFailure(this.message);

  @override
  List<Object?> get props => [message];
}
