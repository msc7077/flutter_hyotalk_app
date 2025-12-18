import 'package:dio/dio.dart';
import 'package:flutter_hyotalk_app/core/mock/mock_api.dart';
import 'package:flutter_hyotalk_app/features/work_diary/data/models/work_diary_item_model.dart';
import 'package:flutter_hyotalk_app/features/work_diary/data/models/work_diary_list_response_model.dart';

/// WorkDiary 관련 네트워크 요청 처리
class WorkDiaryRepository {
  final Dio hyotalkDio;

  WorkDiaryRepository({required this.hyotalkDio});

  /// 업무일지 리스트 조회 (Mock)
  ///
  /// 실제 API 응답처럼 meta/페이징 정보를 포함합니다.
  Future<MockApiEnvelope<WorkDiaryListResponseModel>> getWorkDiaryList({
    int page = 1,
    int pageSize = 20,
  }) async {
    final meta = await MockApi.delay(prefix: 'workdiary');

    final serverVersion = (DateTime.now().minute % 5);
    final total = 42 + serverVersion;

    final start = (page - 1) * pageSize;
    final endExclusive = (start + pageSize).clamp(0, total);
    final count = (endExclusive - start).clamp(0, pageSize);

    final items = List.generate(count, (i) {
      final idx = start + i + 1;
      final date = DateTime.now().subtract(Duration(days: idx));
      return WorkDiaryItemModel(
        id: idx.toString(),
        title: '업무일지 #$idx',
        summary: '어르신 케어 및 활동 기록 요약 내용입니다. (#$idx)',
        date: DateTime(date.year, date.month, date.day),
        authorName: '요양보호사 ${(idx % 7) + 1}',
      );
    });

    final res = WorkDiaryListResponseModel(
      items: items,
      totalCount: total,
      page: page,
      pageSize: pageSize,
      hasNext: endExclusive < total,
    );

    return MockApiEnvelope(
      status: 200,
      success: true,
      message: 'OK',
      data: res,
      meta: meta,
    );
  }
}
