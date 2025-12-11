import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/router/app_router_name.dart';
import 'package:go_router/go_router.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 이미지 배너 (가로 슬라이드)
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
        itemCount: 3, // 예시: 3개의 배너
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '배너 ${index + 1}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'id': '1', 'name': '카테고리 1', 'icon': Icons.category},
      {'id': '2', 'name': '카테고리 2', 'icon': Icons.category},
      {'id': '3', 'name': '카테고리 3', 'icon': Icons.category},
      {'id': '4', 'name': '카테고리 4', 'icon': Icons.category},
      {'id': '5', 'name': '카테고리 5', 'icon': Icons.category},
      {'id': '6', 'name': '카테고리 6', 'icon': Icons.category},
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
    return Builder(
      builder: (context) => InkWell(
        onTap: () {
          context.pushNamed(AppRouterName.noticeListName);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.blue),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
