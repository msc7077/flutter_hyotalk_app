/// String 확장 메서드
///
/// extension은 “표현”만 담당
/// extension은 “원천 데이터만” 즉 수정하지 않음
///
/// 사용 예시:
/// 'test@test.com'.isEmail => true
/// 'test@test'.isEmail => false
extension StringExtension on String {
  bool get isEmail => RegExp(r'.+@.+\..+').hasMatch(this);
}
