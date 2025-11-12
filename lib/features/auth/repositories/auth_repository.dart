import 'package:flutter_hyotalk_app/core/models/app_exception.dart';
import 'package:flutter_hyotalk_app/features/auth/models/user.dart';

/// AuthRepository: 인증 관련 데이터 레이어
///
/// - API 호출을 담당하는 Repository
/// - 실제 API 연동 시 이 클래스를 수정하여 사용
abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
  });
  Future<void> logout();
}

/// MockAuthRepository: 개발/테스트용 Mock 구현
///
/// - 실제 API가 준비되기 전까지 사용
/// - 나중에 실제 API를 호출하는 구현체로 교체 가능
class MockAuthRepository implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    // 네트워크 지연 시뮬레이션
    await Future.delayed(const Duration(seconds: 1));

    // Mock 검증 로직
    if (email.isEmpty || password.isEmpty) {
      throw const ValidationException('이메일과 비밀번호를 입력해주세요.');
    }

    if (email != 'test@example.com' || password != 'password123') {
      throw const AuthException('이메일 또는 비밀번호가 올바르지 않습니다.');
    }

    // Mock 사용자 데이터 반환
    final now = DateTime.now();
    return User(
      id: '1',
      name: 'John Doe',
      email: email,
      phone: '010-1234-5678',
      address: '서울시 강남구',
      birth: DateTime(1990, 1, 1),
      gender: 'male',
      profileImage: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<User> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
      throw const ValidationException('모든 필드를 입력해주세요.');
    }

    final now = DateTime.now();
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
      address: '',
      birth: DateTime(1990, 1, 1),
      gender: 'male',
      profileImage: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // 실제 구현에서는 토큰 삭제 등의 작업 수행
  }
}
