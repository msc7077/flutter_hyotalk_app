import 'package:equatable/equatable.dart';

/// 메뉴 카테고리 모델
class MenuCategoryModel extends Equatable {
  final String id;
  final String name;
  final String icon; // 아이콘 URL 또는 아이콘 이름
  final String? route; // 라우트 경로

  const MenuCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    this.route,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      route: json['route'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'route': route,
    };
  }

  @override
  List<Object?> get props => [id, name, icon, route];
}

