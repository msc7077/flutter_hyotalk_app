/// 앱에서 사용하는 공통 텍스트 정의
class AppTexts {
  AppTexts._(); // 인스턴스 생성 방지

  // Auth 관련 텍스트
  static const String login = '로그인';
  static const String logout = '로그아웃';
  static const String register = '회원가입';
  static const String id = '아이디';
  static const String password = '비밀번호';
  static const String autoLogin = '자동로그인';
  static const String findId = '아이디 찾기';
  static const String resetPassword = '비밀번호 재설정';

  // 입력 필드 관련
  static const String enterId = '아이디를 입력해주세요';
  static const String enterPassword = '비밀번호를 입력해 주세요.';

  // 메뉴 목록
  static const String home = '홈';
  static const String album = '앨범';
  static const String workDiary = '일지';
  static const String more = '더보기';

  static const String notice = '공지';
  static const String note = '알림장';
  static const String seniorInfo = '어르신정보';
  static const String staffAttendance = '직원출근부';
  static const String lifeEducation = '생활교육';
  static const String todayVideo = '오늘의 영상';
  static const String approveAndInvite = '승인/초대';

  // 공통 버튼/액션
  static const String confirm = '확인';
  static const String cancel = '취소';
  static const String delete = '삭제';
  static const String edit = '수정';
  static const String save = '저장';
  static const String close = '닫기';

  // 에러/알림
  static const String error = '오류';
  static const String loginFailed = '로그인 실패';
  static const String loginFailedBefound = '비밀번호가 올바르지 않습니다.';
  static const String loginFailedNone = '해당 아이디를 찾을 수 없습니다.';
  static const String loginFailedUserExpired = '계정이 만료되었습니다. 탈퇴 후 30일 이내라면 복구가 가능합니다.';
  static const String loginFailedUserRestore = '계정이 영구 만료되었습니다. 탈퇴 후 30일이 지나 복구가 불가합니다.';
  static const String loginFailedUserHold = '계정이 정지되었습니다. 관리자에게 문의해주세요.';
  static const String loginFailedTokenIssue = '토큰을 발급받지 못했습니다. 다시 시도해주세요.';
  static const String networkError = '네트워크 오류가 발생했습니다.';
  static const String unknownError = '알 수 없는 오류가 발생했습니다.';
}
