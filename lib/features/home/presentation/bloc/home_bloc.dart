import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/features/home/data/repositories/home_repository.dart';
import 'package:flutter_hyotalk_app/features/home/presentation/bloc/home_event.dart';
import 'package:flutter_hyotalk_app/features/home/presentation/bloc/home_state.dart';

/// Home 관련 로직 처리
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(HomeInitial()) {
    on<AgencyInfoLoadRequested>(_onAgencyInfoLoadRequested);
  }

  /// 기관 정보 로드 (기관 아이디로)
  ///
  /// 기관 아이디로 기관 정보 조회 (아이콘, 배경, 메뉴 리스트)
  Future<void> _onAgencyInfoLoadRequested(
    AgencyInfoLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      // 기관 정보 조회 (기관 아이디로)
      final homeModel = await _homeRepository.getAgencyInfo(event.agencyId);

      emit(HomeLoaded(homeModel: homeModel));
    } on DioException catch (e) {
      final errorMessage =
          e.requestOptions.extra['customErrorMessage'] as String? ?? '기관 정보를 불러오는데 실패했습니다.';
      emit(HomeFailure(errorMessage));
    } catch (e) {
      emit(HomeFailure('알 수 없는 오류가 발생했습니다: ${e.toString()}'));
    }
  }
}
