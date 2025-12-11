import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:go_router/go_router.dart';

class MoreTabPage extends StatelessWidget {
  const MoreTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('더보기')),
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
      {'id': 'mypage1', 'name': '마이페이지 카테고리 1', 'icon': Icons.person},
      {'id': 'mypage2', 'name': '마이페이지 카테고리 2', 'icon': Icons.person},
      {'id': 'mypage3', 'name': '마이페이지 카테고리 3', 'icon': Icons.person},
      {'id': 'mypage4', 'name': '마이페이지 카테고리 4', 'icon': Icons.person},
      {'id': 'mypage5', 'name': '마이페이지 카테고리 5', 'icon': Icons.person},
      {'id': 'mypage6', 'name': '마이페이지 카테고리 6', 'icon': Icons.person},
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
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('로그아웃'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String id, String name, IconData icon) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.purple),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
