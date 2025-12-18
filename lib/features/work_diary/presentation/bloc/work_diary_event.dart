import 'package:equatable/equatable.dart';

abstract class WorkDiaryEvent extends Equatable {
  const WorkDiaryEvent();

  @override
  List<Object?> get props => [];
}

/// 업무일지 리스트 로드 요청
class WorkDiaryListRequested extends WorkDiaryEvent {
  final bool forceRefresh;

  const WorkDiaryListRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

/// 탭으로 돌아왔을 때 호출 (캐시 확인 후 필요 시 리프레시)
class WorkDiaryTabResumed extends WorkDiaryEvent {
  const WorkDiaryTabResumed();
}

