import 'package:equatable/equatable.dart';

enum UserRole {
  admin, // 관리자
  staff, // 일반 직원
  staff_caregiver, // 생활지원사 직원
  protector, // 보호자
  senior, // 어르신
  user, // 일반 사용자
}

/// 사용자 정보 모델
class UserInfoModel extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String userAddress;
  final String userBirthday;
  final String userGender;
  final String userProfileImageUrl;
  final String agencyId;
  final UserRole role;

  const UserInfoModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userAddress,
    required this.userBirthday,
    required this.userGender,
    required this.userProfileImageUrl,
    required this.agencyId,
    required this.role,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userEmail: json['user_email'] as String,
      userPhone: json['user_phone'] as String,
      userAddress: json['user_address'] as String,
      userBirthday: json['user_birthday'] as String,
      userGender: json['user_gender'] as String,
      userProfileImageUrl: json['user_profile_image_url'] as String,
      agencyId: json['agency_id'] as String,
      role: json['role'] as UserRole,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'user_phone': userPhone,
    };
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userEmail,
    userPhone,
    userAddress,
    userBirthday,
    userGender,
    userProfileImageUrl,
    agencyId,
    role,
  ];
}
