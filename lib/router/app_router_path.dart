/// 앱 라우터 경로 정의
/// static 으로 선언하여 메모리 최적화 및 빠른 접근 가능하도록 함
///
/// 라우터 이름은 goNamed 사용 시 사용
/// 예) context.goNamed(AppRouterName.noticeDetailName, pathParameters: {'id': '123'});
class AppRouterPath {
  AppRouterPath._();

  // 스플레시 페이지
  static const String splash = '/splash';
  // 본인인증 페이지
  static const String selfCertification = '/self-certification';
  // 본인인증 웹뷰 페이지
  static const String selfCertificationWebView = '/self-certification-webview';
  // 회원가입 페이지
  static const String register = '/register';
  // 아이디 찾기 페이지
  static const String findId = '/find-id';
  // 비밀번호 재설정 페이지
  static const String resetPassword = '/reset-password';
  // 로그인 페이지
  static const String login = '/login';
  // 메인 - 홈 페이지
  static const String home = '/home';
  // 메인 - 앨범 페이지
  static const String album = '/album';
  // 메인 - 일지 페이지
  static const String workDiary = '/work-diary';
  // 메인 - 더보기 페이지
  static const String more = '/more';
  // 공지사항 - 리스트 페이지
  static const String noticeList = '/notice-list';
  // 공지사항 - 상세 페이지
  static const String noticeDetail = '/notice/:id';
  // 공지사항 - 작성 페이지
  static const String noticeForm = '/notice/form';
  // 공지사항 - 수정 페이지
  static const String noticeEdit = '/notice/form/:id';
  // 알림장 - 리스트 페이지
  static const String note = '/note';
  // 알림장 - 상세 페이지
  static const String noteDetail = '/note/:id';
  // 어르신 정보 - 리스트 페이지
  static const String seniorInfo = '/senior-info';
  // 어르신 정보 - 상세 페이지
  static const String seniorInfoDetail = '/senior-info/:id';
  // 어르신 출석 - 리스트 페이지
  static const String seniorAttendance = '/senior-attendance';
  // 직원 출석 - 리스트 페이지
  static const String staffAttendance = '/staff-attendance';
  // 생활교육 - 리스트 페이지
  static const String lifeEducation = '/life-education';
  // 생활교육 - 상세 페이지
  static const String lifeEducationDetail = '/life-education/:id';
  // 오늘의 영상 - 리스트 페이지
  static const String todayVideo = '/today-video';
  // 승인 및 초대 - 리스트 페이지
  static const String approveAndInvite = '/approve-and-invite';
  // 홈 - 탭 라우트
  static const List<String> homeTabRoutes = [home, album, workDiary, more];
}
