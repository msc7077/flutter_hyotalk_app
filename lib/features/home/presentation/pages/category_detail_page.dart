import 'package:flutter/material.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryId;

  const CategoryDetailPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('카테고리 $categoryId 상세')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('카테고리ssssss ID: $categoryId', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            const Text('카테고리dddddd 상세 내용이 여기에 표시됩니다.'),
          ],
        ),
      ),
    );
  }
}
