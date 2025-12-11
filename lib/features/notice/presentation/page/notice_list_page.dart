import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/router/app_router_name.dart';
import 'package:go_router/go_router.dart';

/// 공지사항 리스트 페이지
class NoticeListPage extends StatelessWidget {
  const NoticeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공지사항 리스트')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 그리드뷰 카테고리
            _buildCategoryGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final categories = [
      {'id': '1', 'name': '공지사항 1', 'icon': Icons.person},
      {'id': '2', 'name': '공지사항 2', 'icon': Icons.person},
      {'id': '3', 'name': '공지사항 3', 'icon': Icons.person},
      {'id': '4', 'name': '공지사항 4', 'icon': Icons.person},
      {'id': '5', 'name': '공지사항 5', 'icon': Icons.person},
      {'id': '6', 'name': '공지사항 6', 'icon': Icons.person},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GridView.builder(
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
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String id, String name, IconData icon) {
    return Builder(
      builder: (context) => InkWell(
        onTap: () {
          // 공지사항 상세 페이지로 이동
          context.pushNamed(AppRouterName.noticeDetailName, pathParameters: {'id': id});
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
              Icon(icon, size: 48, color: Colors.purple),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
