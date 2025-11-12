/// 입력값 유효성 검사 유틸리티
class Validators {
  Validators._();

  /// 이메일 유효성 검사
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다';
    }

    return null;
  }

  /// 비밀번호 유효성 검사
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }

    if (value.length < 8) {
      return '비밀번호는 최소 8자 이상이어야 합니다';
    }

    if (value.length > 50) {
      return '비밀번호는 50자 이하여야 합니다';
    }

    return null;
  }

  /// 전화번호 유효성 검사
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return '전화번호를 입력해주세요';
    }

    final phoneRegex = RegExp(r'^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$');

    if (!phoneRegex.hasMatch(value.replaceAll('-', ''))) {
      return '올바른 전화번호 형식이 아닙니다 (예: 010-1234-5678)';
    }

    return null;
  }

  /// 필수 입력값 검사
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? '값'}을(를) 입력해주세요';
    }
    return null;
  }
}
