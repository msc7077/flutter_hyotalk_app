import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';

/// 앨범 탭 페이지
class AlbumTabPage extends StatelessWidget {
  const AlbumTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('앨범')),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 그리드뷰 카테고리
            _buildCategoryGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'id': 'shop1', 'name': '앨범 카테고리 1', 'icon': Icons.alarm},
      {'id': 'shop2', 'name': '앨범 카테고리 2', 'icon': Icons.alarm},
      {'id': 'shop3', 'name': '앨범 카테고리 3', 'icon': Icons.alarm},
      {'id': 'shop4', 'name': '앨범 카테고리 4', 'icon': Icons.alarm},
      {'id': 'shop5', 'name': '앨범 카테고리 5', 'icon': Icons.alarm},
      {'id': 'shop6', 'name': '앨범 카테고리 6', 'icon': Icons.alarm},
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
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.orange),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
