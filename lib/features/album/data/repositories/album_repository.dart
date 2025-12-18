import 'package:dio/dio.dart';
import 'package:flutter_hyotalk_app/core/mock/mock_api.dart';
import 'package:flutter_hyotalk_app/features/album/data/models/album_item_model.dart';
import 'package:flutter_hyotalk_app/features/album/data/models/album_list_response_model.dart';

/// Album 관련 네트워크 요청 처리
class AlbumRepository {
  final Dio hyotalkDio;

  AlbumRepository({required this.hyotalkDio});

  /// 앨범 리스트 조회 (Mock)
  ///
  /// 실제 API 응답처럼 meta/페이징 정보를 포함합니다.
  Future<MockApiEnvelope<AlbumListResponseModel>> getAlbumList({
    int page = 1,
    int pageSize = 20,
  }) async {
    final meta = await MockApi.delay(prefix: 'album');

    // "서버에서 데이터가 바뀌었다" 느낌을 주기 위해 시간 기반으로 살짝 변화를 줌
    final serverVersion = (DateTime.now().minute % 3);
    final total = 55 + serverVersion;

    final start = (page - 1) * pageSize;
    final endExclusive = (start + pageSize).clamp(0, total);
    final count = (endExclusive - start).clamp(0, pageSize);

    final items = List.generate(count, (i) {
      final idx = start + i + 1;
      return AlbumItemModel(
        id: idx.toString(),
        title: '행복한 하루 앨범 #$idx',
        thumbnailUrl: 'https://picsum.photos/seed/album-$idx/300/300',
        photoCount: 5 + (idx % 20),
        createdAt: DateTime.now().subtract(Duration(days: idx)),
      );
    });

    final res = AlbumListResponseModel(
      items: items,
      totalCount: total,
      page: page,
      pageSize: pageSize,
      hasNext: endExclusive < total,
    );

    return MockApiEnvelope(status: 200, success: true, message: 'OK', data: res, meta: meta);
  }
}
