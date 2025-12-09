import 'package:flutter/material.dart';

class WorkDiaryTabPage extends StatelessWidget {
  const WorkDiaryTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('업무일지'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 이미지 배너
            _buildBannerSection(),
            const SizedBox(height: 20),
            // 그리드뷰 카테고리
            _buildCategoryGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '업무일지 배너 ${index + 1}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'id': 'work1', 'name': '업무 카테고리 1', 'icon': Icons.work},
      {'id': 'work2', 'name': '업무 카테고리 2', 'icon': Icons.work},
      {'id': 'work3', 'name': '업무 카테고리 3', 'icon': Icons.work},
      {'id': 'work4', 'name': '업무 카테고리 4', 'icon': Icons.work},
      {'id': 'work5', 'name': '업무 카테고리 5', 'icon': Icons.work},
      {'id': 'work6', 'name': '업무 카테고리 6', 'icon': Icons.work},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(
            category['id'] as String,
            category['name'] as String,
            category['icon'] as IconData,
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(String id, String name, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.green),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

