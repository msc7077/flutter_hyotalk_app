import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/features/work_diary/data/repositories/work_diary_repository.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/bloc/work_diary_event.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/bloc/work_diary_state.dart';

/// WorkDiary 관련 로직 처리
class WorkDiaryBloc extends Bloc<WorkDiaryEvent, WorkDiaryState> {
  final WorkDiaryRepository _workDiaryRepository;
  DateTime? _lastFetchedAt;

  static const Duration _cacheValidDuration = Duration(minutes: 5);

  WorkDiaryBloc(this._workDiaryRepository) : super(WorkDiaryInitial()) {
    on<WorkDiaryListRequested>(_onWorkDiaryListRequested);
    on<WorkDiaryTabResumed>(_onWorkDiaryTabResumed);
  }

  /// 업무일지 리스트 로드
  Future<void> _onWorkDiaryListRequested(
    WorkDiaryListRequested event,
    Emitter<WorkDiaryState> emit,
  ) async {
    final isRefreshing = state is WorkDiaryLoaded;
    emit(WorkDiaryLoading(isRefreshing: isRefreshing));
    try {
      final res = await _workDiaryRepository.getWorkDiaryList(page: 1, pageSize: 30);
      _lastFetchedAt = DateTime.now();
      emit(WorkDiaryLoaded(workDiaryList: res.data.items, fetchedAt: _lastFetchedAt!));
    } on DioException catch (e) {
      final errorMessage =
          e.requestOptions.extra['customErrorMessage'] as String? ?? '업무일지 리스트를 불러오는데 실패했습니다.';
      emit(WorkDiaryFailure(errorMessage));
    } catch (e) {
      emit(WorkDiaryFailure('알 수 없는 오류가 발생했습니다: ${e.toString()}'));
    }
  }

  Future<void> _onWorkDiaryTabResumed(
    WorkDiaryTabResumed event,
    Emitter<WorkDiaryState> emit,
  ) async {
    final last = _lastFetchedAt;
    if (last == null) {
      add(const WorkDiaryListRequested());
      return;
    }
    final age = DateTime.now().difference(last);
    if (age < _cacheValidDuration) {
      return; // 캐시 신선함
    }
    add(const WorkDiaryListRequested(forceRefresh: true));
  }
}
