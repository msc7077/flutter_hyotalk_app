import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/features/home/data/repositories/home_repository.dart';
import 'package:flutter_hyotalk_app/features/home/presentation/bloc/home_event.dart';
import 'package:flutter_hyotalk_app/features/home/presentation/bloc/home_state.dart';

/// Home 관련 로직 처리
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  DateTime? _lastFetchedAt;

  static const Duration _cacheValidDuration = Duration(minutes: 5);

  HomeBloc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(HomeInitial()) {
    on<HomeListRequested>(_onHomeListRequested);
    on<HomeTabResumed>(_onHomeTabResumed);
  }

  /// 기관 정보 로드 (기관 아이디로)
  ///
  /// 기관 아이디로 기관 정보 조회 (아이콘, 배경, 메뉴 리스트)
  Future<void> _onHomeListRequested(HomeListRequested event, Emitter<HomeState> emit) async {
    final isRefreshing = state is HomeLoaded;
    emit(HomeLoading(isRefreshing: isRefreshing));
    try {
      final res = await _homeRepository.getHomeList(page: 1, pageSize: 30);
      _lastFetchedAt = DateTime.now();
      emit(HomeLoaded(homeList: res.data.items, fetchedAt: _lastFetchedAt!));
    } on DioException catch (e) {
      final errorMessage =
          e.requestOptions.extra['customErrorMessage'] as String? ?? '홈 리스트를 불러오는데 실패했습니다.';
      emit(HomeFailure(errorMessage));
    } catch (e) {
      emit(HomeFailure('알 수 없는 오류가 발생했습니다: ${e.toString()}'));
    }
  }

  Future<void> _onHomeTabResumed(HomeTabResumed event, Emitter<HomeState> emit) async {
    final last = _lastFetchedAt;
    if (last == null) {
      add(const HomeListRequested());
      return;
    }
    final age = DateTime.now().difference(last);
    if (age < _cacheValidDuration) {
      return; // 캐시 신선함
    }
    add(const HomeListRequested(forceRefresh: true));
  }
}
