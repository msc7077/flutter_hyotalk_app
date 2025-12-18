import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/features/album/data/repositories/album_repository.dart';
import 'package:flutter_hyotalk_app/features/album/presentation/bloc/album_event.dart';
import 'package:flutter_hyotalk_app/features/album/presentation/bloc/album_state.dart';

/// Album 관련 로직 처리
class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository _albumRepository;
  DateTime? _lastFetchedAt;

  static const Duration _cacheValidDuration = Duration(minutes: 5);

  AlbumBloc({required AlbumRepository albumRepository})
      : _albumRepository = albumRepository,
        super(AlbumInitial()) {
    on<AlbumListRequested>(_onAlbumListRequested);
    on<AlbumTabResumed>(_onAlbumTabResumed);
  }

  /// 앨범 리스트 로드
  Future<void> _onAlbumListRequested(
    AlbumListRequested event,
    Emitter<AlbumState> emit,
  ) async {
    final isRefreshing = state is AlbumLoaded;
    emit(AlbumLoading(isRefreshing: isRefreshing));
    try {
      final res = await _albumRepository.getAlbumList(page: 1, pageSize: 30);
      _lastFetchedAt = DateTime.now();
      emit(AlbumLoaded(albumList: res.data.items, fetchedAt: _lastFetchedAt!));
    } on DioException catch (e) {
      final errorMessage =
          e.requestOptions.extra['customErrorMessage'] as String? ?? '앨범 리스트를 불러오는데 실패했습니다.';
      emit(AlbumFailure(errorMessage));
    } catch (e) {
      emit(AlbumFailure('알 수 없는 오류가 발생했습니다: ${e.toString()}'));
    }
  }

  Future<void> _onAlbumTabResumed(AlbumTabResumed event, Emitter<AlbumState> emit) async {
    final last = _lastFetchedAt;
    if (last == null) {
      add(const AlbumListRequested());
      return;
    }
    final age = DateTime.now().difference(last);
    if (age < _cacheValidDuration) {
      return; // 캐시 신선함
    }
    add(const AlbumListRequested(forceRefresh: true));
  }
}

