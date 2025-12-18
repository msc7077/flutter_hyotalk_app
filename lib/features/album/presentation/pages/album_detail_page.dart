import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/features/album/data/models/album_item_model.dart';

class AlbumDetailPage extends StatelessWidget {
  final AlbumItemModel album;

  const AlbumDetailPage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('앨범 상세')),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(album.thumbnailUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),
          Text(album.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('사진 ${album.photoCount}장'),
          const SizedBox(height: 8),
          Text('생성일: ${album.createdAt.toLocal()}'),
        ],
      ),
    );
  }
}
