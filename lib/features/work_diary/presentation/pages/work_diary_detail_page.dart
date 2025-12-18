import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/features/work_diary/data/models/work_diary_item_model.dart';

class WorkDiaryDetailPage extends StatelessWidget {
  final WorkDiaryItemModel item;

  const WorkDiaryDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('업무일지 상세')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('작성자: ${item.authorName}'),
            const SizedBox(height: 8),
            Text('작성일: ${item.date.toLocal()}'),
            const SizedBox(height: 16),
            Text(item.summary),
          ],
        ),
      ),
    );
  }
}


