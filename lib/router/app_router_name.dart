/// 앱 라우터 이름 정의
/// static 으로 선언하여 메모리 최적화 및 빠른 접근 가능하도록 함
/// 라우터 이름은 라우터 경로와 동일하게 정의
///
/// 라우터 이름은 goNamed 사용 시 사용
/// 예) context.goNamed(AppRouterName.noticeDetailName, pathParameters: {'id': '123'});
class AppRouterName {
  AppRouterName._();

  // 스플레시 페이지
  static const String splashName = 'splash';
  // 로그인 페이지
  static const String loginName = 'login';
  // 메인 - 홈 페이지
  static const String homeName = 'home';
  // 메인 - 앨범 페이지
  static const String albumName = 'album';
  // 메인 - 일지 페이지
  static const String workDiaryName = 'work-diary';
  // 메인 - 더보기 페이지
  static const String moreName = 'more';
  // 공지사항 - 리스트 페이지
  static const String noticeListName = 'notice-list';
  // 공지사항 - 상세 페이지
  static const String noticeDetailName = 'notice-detail';
  // 공지사항 - 작성 페이지
  static const String noticeFormName = 'notice-form';
  // 공지사항 - 수정 페이지
  static const String noticeEditName = 'notice-edit';
  // 알림장 - 리스트 페이지
  static const String noteName = 'note';
  // 알림장 - 상세 페이지
  static const String noteDetailName = 'note-detail';
  // 어르신 정보 - 리스트 페이지
  static const String seniorInfoName = 'senior-info';
  // 어르신 정보 - 상세 페이지
  static const String seniorInfoDetailName = 'senior-info-detail';
  // 어르신 출석 - 리스트 페이지
  static const String seniorAttendanceName = 'senior-attendance';
  // 직원 출석 - 리스트 페이지
  static const String staffAttendanceName = 'staff-attendance';
  // 생활교육 - 리스트 페이지
  static const String lifeEducationName = 'life-education';
  // 생활교육 - 상세 페이지
  static const String lifeEducationDetailName = 'life-education-detail';
  // 오늘의 영상 - 리스트 페이지
  static const String todayVideoName = 'today-video';
  // 승인 및 초대 - 리스트 페이지
  static const String approveAndInviteName = 'approve-and-invite';
}
