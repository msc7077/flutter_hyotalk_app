/// 앱 라우터 이름 정의
/// 라우터 이름은 라우터 경로와 동일하게 정의
///
/// 라우터 이름은 goNamed 사용 시 사용
/// 예) context.goNamed(AppRouterName.noticeDetailName, pathParameters: {'id': '123'});
class AppRouterName {
  // 경로
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String album = '/album';
  static const String workDiary = '/work-diary';
  static const String more = '/more';
  static const String notice = '/notice';
  static const String noticeDetail = '/notice/:id';
  static const String note = '/note';
  static const String noteDetail = '/note/:id';
  static const String seniorInfo = '/senior-info';
  static const String seniorAttendance = '/senior-attendance';
  static const String staffAttendance = '/staff-attendance';
  static const String lifeEducation = '/life-education';
  static const String lifeEducationDetail = '/life-education/:id';
  static const String todayVideo = '/today-video';
  static const String approveAndInvite = '/approve-and-invite';

  // 이름 (goNamed 사용 시)
  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String albumName = 'album';
  static const String workDiaryName = 'work-diary';
  static const String moreName = 'more';
  static const String noticeName = 'notice';
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

  static const List<String> homeTabRoutes = [home, album, workDiary, more];
}
