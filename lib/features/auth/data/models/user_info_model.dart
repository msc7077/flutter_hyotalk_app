import 'package:equatable/equatable.dart';

/// 사용자 정보 모델
class UserInfoModel extends Equatable {
  final String userId;
  final String agencyId; // 기관 아이디
  final List<String> permissions; // 권한 리스트

  const UserInfoModel({required this.userId, required this.agencyId, required this.permissions});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      userId: json['user_id'] as String,
      agencyId: json['agency_id'] as String,
      permissions: (json['permissions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'agency_id': agencyId, 'permissions': permissions};
  }

  @override
  List<Object?> get props => [userId, agencyId, permissions];
}
