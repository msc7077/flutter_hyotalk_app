/// 앱에서 사용하는 이미지/아이콘 경로 정의
class AppAssets {
  AppAssets._(); // 인스턴스 생성 방지

  // 이미지 및 아이콘 경로
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';

  // 이미지 - 스플레시
  static const String imgSplash = '${imagesPath}splash.svg';

  // 아이콘 - 메인 탭
  static const String iconMenuHome = '${iconsPath}icon_menu_home.svg';
  static const String iconMenuHomeOutlined = '${iconsPath}icon_menu_home_outlined.svg';
  static const String iconMenuAlbum = '${iconsPath}icon_menu_album.svg';
  static const String iconMenuAlbumOutlined = '${iconsPath}icon_menu_album_outlined.svg';
  static const String iconMenuWork = '${iconsPath}icon_menu_work.svg';
  static const String iconMenuWorkOutlined = '${iconsPath}icon_menu_work_outlined.svg';
  static const String iconMenuMore = '${iconsPath}icon_menu_more.svg';
  static const String iconMenuMoreOutlined = '${iconsPath}icon_menu_more_outlined.svg';
}
