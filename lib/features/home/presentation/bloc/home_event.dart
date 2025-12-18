import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// 홈 리스트 로드 요청
class HomeListRequested extends HomeEvent {
  final bool forceRefresh;

  const HomeListRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

/// 탭으로 돌아왔을 때 호출 (캐시 확인 후 필요 시 리프레시)
class HomeTabResumed extends HomeEvent {
  const HomeTabResumed();
}
