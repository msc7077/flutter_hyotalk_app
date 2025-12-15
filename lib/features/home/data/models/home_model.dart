import 'package:equatable/equatable.dart';
import 'package:flutter_hyotalk_app/features/home/data/models/menu_category_model.dart';

/// 홈 정보 모델 (기관 정보)
class HomeModel extends Equatable {
  final String agencyId;
  final String? agencyIconUrl; // 기관 아이콘 URL
  final String? agencyBackgroundUrl; // 기관 배경 이미지 URL
  final List<MenuCategoryModel> menuCategories; // 메뉴 리스트

  const HomeModel({
    required this.agencyId,
    this.agencyIconUrl,
    this.agencyBackgroundUrl,
    required this.menuCategories,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      agencyId: json['agency_id'] as String,
      agencyIconUrl: json['agency_icon_url'] as String?,
      agencyBackgroundUrl: json['agency_background_url'] as String?,
      menuCategories: (json['menu_categories'] as List<dynamic>?)
              ?.map((e) => MenuCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'agency_id': agencyId,
      'agency_icon_url': agencyIconUrl,
      'agency_background_url': agencyBackgroundUrl,
      'menu_categories': menuCategories.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [agencyId, agencyIconUrl, agencyBackgroundUrl, menuCategories];
}

