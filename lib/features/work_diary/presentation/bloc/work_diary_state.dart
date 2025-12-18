import 'package:equatable/equatable.dart';
import 'package:flutter_hyotalk_app/features/work_diary/data/models/work_diary_item_model.dart';

abstract class WorkDiaryState extends Equatable {
  const WorkDiaryState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class WorkDiaryInitial extends WorkDiaryState {}

/// 업무일지 로딩 상태
class WorkDiaryLoading extends WorkDiaryState {
  final bool isRefreshing;

  const WorkDiaryLoading({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

/// 업무일지 로드 완료 상태
class WorkDiaryLoaded extends WorkDiaryState {
  final List<WorkDiaryItemModel> workDiaryList;
  final DateTime fetchedAt;

  const WorkDiaryLoaded({required this.workDiaryList, required this.fetchedAt});

  @override
  List<Object?> get props => [workDiaryList, fetchedAt];
}

/// 업무일지 로드 실패 상태
class WorkDiaryFailure extends WorkDiaryState {
  final String message;

  const WorkDiaryFailure(this.message);

  @override
  List<Object?> get props => [message];
}

