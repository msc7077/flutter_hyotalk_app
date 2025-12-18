import 'package:equatable/equatable.dart';

class AlbumItemModel extends Equatable {
  final String id;
  final String title;
  final String thumbnailUrl;
  final int photoCount;
  final DateTime createdAt;

  const AlbumItemModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.photoCount,
    required this.createdAt,
  });

  factory AlbumItemModel.fromJson(Map<String, dynamic> json) {
    return AlbumItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      photoCount: json['photo_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'thumbnail_url': thumbnailUrl,
    'photo_count': photoCount,
    'created_at': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, title, thumbnailUrl, photoCount, createdAt];
}
