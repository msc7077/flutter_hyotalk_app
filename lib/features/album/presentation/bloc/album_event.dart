import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object?> get props => [];
}

/// 앨범 리스트 로드 요청
class AlbumListRequested extends AlbumEvent {
  final bool forceRefresh;

  const AlbumListRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

/// 탭으로 돌아왔을 때 호출 (캐시 확인 후 필요 시 리프레시)
class AlbumTabResumed extends AlbumEvent {
  const AlbumTabResumed();
}
