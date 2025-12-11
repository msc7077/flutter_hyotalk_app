/// 앱 라우터 이름 정의
/// static 으로 선언하여 메모리 최적화 및 빠른 접근 가능하도록 함
/// 라우터 이름은 라우터 경로와 동일하게 정의
///
/// 라우터 이름은 goNamed 사용 시 사용
/// 예) context.goNamed(AppRouterName.noticeDetailName, pathParameters: {'id': '123'});
class AppRouterName {
  AppRouterName._();
  // 이름 (goNamed 사용 시)
  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String albumName = 'album';
  static const String workDiaryName = 'work-diary';
  static const String moreName = 'more';
  static const String noticeListName = 'notice-list';
  static const String noticeDetailName = 'notice-detail';
  static const String noteName = 'note';
  static const String noteDetailName = 'note-detail';
  static const String seniorInfoName = 'senior-info';
  static const String seniorAttendanceName = 'senior-attendance';
  static const String staffAttendanceName = 'staff-attendance';
  static const String lifeEducationName = 'life-education';
  static const String lifeEducationDetailName = 'life-education-detail';
  static const String todayVideoName = 'today-video';
  static const String approveAndInviteName = 'approve-and-invite';
}
