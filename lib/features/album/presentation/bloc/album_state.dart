import 'package:equatable/equatable.dart';
import 'package:flutter_hyotalk_app/features/album/data/models/album_item_model.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class AlbumInitial extends AlbumState {}

/// 앨범 로딩 상태
class AlbumLoading extends AlbumState {
  final bool isRefreshing;

  const AlbumLoading({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

/// 앨범 로드 완료 상태
class AlbumLoaded extends AlbumState {
  final List<AlbumItemModel> albumList;
  final DateTime fetchedAt;

  const AlbumLoaded({required this.albumList, required this.fetchedAt});

  @override
  List<Object?> get props => [albumList, fetchedAt];
}

/// 앨범 로드 실패 상태
class AlbumFailure extends AlbumState {
  final String message;

  const AlbumFailure(this.message);

  @override
  List<Object?> get props => [message];
}

