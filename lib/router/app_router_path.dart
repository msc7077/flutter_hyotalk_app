/// 앱 라우터 경로 정의
/// static 으로 선언하여 메모리 최적화 및 빠른 접근 가능하도록 함
///
/// 라우터 이름은 goNamed 사용 시 사용
/// 예) context.goNamed(AppRouterName.noticeDetailName, pathParameters: {'id': '123'});
class AppRouterPath {
  AppRouterPath._();
  // 경로
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String album = '/album';
  static const String workDiary = '/work-diary';
  static const String more = '/more';
  static const String noticeList = '/notice-list';
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

  static const List<String> homeTabRoutes = [home, album, workDiary, more];
}
