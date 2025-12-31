/// 앱에서 사용하는 이미지/아이콘 경로 정의
class AppAssets {
  AppAssets._(); // 인스턴스 생성 방지

  // 이미지 및 아이콘 경로
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';

  // 이미지 - 스플레시
  static const String imgSplash = '${imagesPath}splash.svg';

  // 아이콘 - 하단 탭바
  static const String iconBottomTabMenuHome = '${iconsPath}icon_bottom_tab_menu_home.svg';
  static const String iconBottomTabMenuHomeOutlined =
      '${iconsPath}icon_bottom_tab_menu_home_outlined.svg';
  static const String iconBottomTabMenuAlbum = '${iconsPath}icon_bottom_tab_menu_album.svg';
  static const String iconBottomTabMenuAlbumOutlined =
      '${iconsPath}icon_bottom_tab_menu_album_outlined.svg';
  static const String iconBottomTabMenuWork = '${iconsPath}icon_bottom_tab_menu_work.svg';
  static const String iconBottomTabMenuWorkOutlined =
      '${iconsPath}icon_bottom_tab_menu_work_outlined.svg';
  static const String iconBottomTabMenuMore = '${iconsPath}icon_bottom_tab_menu_more.svg';
  static const String iconBottomTabMenuMoreOutlined =
      '${iconsPath}icon_bottom_tab_menu_more_outlined.svg';

  // 아이콘 - 메뉴 아이콘
  static const String iconMenuNotice = '${iconsPath}icon_menu_notice.png';
  static const String iconMenuNote = '${iconsPath}icon_menu_note.png';
  static const String iconMenuAlbum = '${iconsPath}icon_menu_album.png';
  static const String iconMenuSeniorInfo = '${iconsPath}icon_menu_senior_info.png';
  static const String iconMenuStaffAttendance = '${iconsPath}icon_menu_staff_attendance.png';
  static const String iconMenuLifeEducation = '${iconsPath}icon_menu_life_education.png';
  static const String iconMenuTodayVideo = '${iconsPath}icon_menu_today_video.png';
  static const String iconMenuApproveAndInvite = '${iconsPath}icon_menu_approve_and_invite.png';
}
