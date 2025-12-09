import 'package:flutter/material.dart';

class ShoppingTabPage extends StatelessWidget {
  const ShoppingTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('쇼핑몰'),
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
              color: Colors.orange.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '쇼핑몰 배너 ${index + 1}',
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
      {'id': 'shop1', 'name': '쇼핑 카테고리 1', 'icon': Icons.shopping_bag},
      {'id': 'shop2', 'name': '쇼핑 카테고리 2', 'icon': Icons.shopping_bag},
      {'id': 'shop3', 'name': '쇼핑 카테고리 3', 'icon': Icons.shopping_bag},
      {'id': 'shop4', 'name': '쇼핑 카테고리 4', 'icon': Icons.shopping_bag},
      {'id': 'shop5', 'name': '쇼핑 카테고리 5', 'icon': Icons.shopping_bag},
      {'id': 'shop6', 'name': '쇼핑 카테고리 6', 'icon': Icons.shopping_bag},
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
          Icon(icon, size: 48, color: Colors.orange),
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

