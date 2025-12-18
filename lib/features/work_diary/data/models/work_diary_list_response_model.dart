import 'package:equatable/equatable.dart';
import 'package:flutter_hyotalk_app/features/work_diary/data/models/work_diary_item_model.dart';

class WorkDiaryListResponseModel extends Equatable {
  final List<WorkDiaryItemModel> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasNext;

  const WorkDiaryListResponseModel({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasNext,
  });

  factory WorkDiaryListResponseModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>).cast<Map<String, dynamic>>();
    return WorkDiaryListResponseModel(
      items: itemsJson.map(WorkDiaryItemModel.fromJson).toList(),
      totalCount: json['total_count'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
      hasNext: json['has_next'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'total_count': totalCount,
        'page': page,
        'page_size': pageSize,
        'has_next': hasNext,
      };

  @override
  List<Object?> get props => [items, totalCount, page, pageSize, hasNext];
}


