import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/theme/app_assets.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/core/theme/app_text_styles.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:flutter_hyotalk_app/features/album/presentation/pages/album_tab_page.dart';
import 'package:flutter_hyotalk_app/features/home/presentation/pages/home_tab_page.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/pages/work_diary_tab_page.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

/// 메인 페이지
///
/// 하단 탭바를 통해 홈, 업무일지, 쇼핑몰 페이지로 이동
/// 더보기 탭은 마이페이지 페이지로 이동
class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// 페이지 전환 제어
  late PageController _pageController;

  /// 현재 선택된 탭 인덱스 초기값은 0으로 설정
  int _currentIndex = 0;

  /// 이전 선택된 탭 인덱스 (리로드 판단용)
  int _previousIndex = 0;

  /// 각 탭 페이지의 GlobalKey (리로드 신호 전달용)
  final GlobalKey _homeTabKey = GlobalKey();
  final GlobalKey _albumTabKey = GlobalKey();
  final GlobalKey _workDiaryTabKey = GlobalKey();

  /// 하단 탭바 아이콘과 라벨 정의
  final List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: SvgPicture.asset(AppAssets.iconMenuHomeOutlined),
      selectedIcon: SvgPicture.asset(AppAssets.iconMenuHome),
      label: AppTexts.home,
    ),
    NavigationDestination(
      icon: SvgPicture.asset(AppAssets.iconMenuAlbumOutlined),
      selectedIcon: SvgPicture.asset(AppAssets.iconMenuAlbum),
      label: AppTexts.album,
    ),
    NavigationDestination(
      icon: SvgPicture.asset(AppAssets.iconMenuWorkOutlined),
      selectedIcon: SvgPicture.asset(AppAssets.iconMenuWork),
      label: AppTexts.workDiary,
    ),
    NavigationDestination(
      icon: SvgPicture.asset(AppAssets.iconMenuMoreOutlined),
      selectedIcon: SvgPicture.asset(AppAssets.iconMenuMore),
      label: AppTexts.more,
    ),
  ];

  /// 탭 페이지들
  /// 탭으로만 이동될 페이지들
  late final List<Widget> _pages = [
    HomeTabPage(key: _homeTabKey),
    AlbumTabPage(key: _albumTabKey),
    WorkDiaryTabPage(key: _workDiaryTabKey),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _currentIndex = 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 하단 탭바 선택 시 페이지 이동
  void _onDestinationSelected(int index) {
    if (index == 3) {
      // "더보기" 탭은 서브페이지로 열기
      context.push(AppRouterPath.more);
    } else {
      context.go(AppRouterPath.homeTabRoutes[index]);
    }
  }

  /// PageView 변경 시 인덱스 동기화 및 리로드
  void _onPageChanged(int index) {
    if (_currentIndex != index) {
      setState(() {
        _previousIndex = _currentIndex;
        _currentIndex = index;
      });

      // 탭으로 돌아왔을 때 리로드 (다른 탭에서 돌아온 경우)
      _reloadCurrentTab(index);
    }
  }

  /// 현재 탭 리로드
  ///
  /// 탭으로 돌아왔을 때 데이터를 최신 상태로 갱신합니다.
  /// 스크롤 위치는 AutomaticKeepAliveClientMixin에 의해 자동으로 유지됩니다.
  void _reloadCurrentTab(int index) {
    // 더보기 탭(index 3)은 리로드 불필요
    if (index >= _pages.length) return;

    // 탭이 변경되었을 때만 리로드 (같은 탭을 다시 선택한 경우는 제외)
    if (_previousIndex != index) {
      switch (index) {
        case 0: // 홈 탭
          (_homeTabKey.currentState as dynamic)?.onTabResumed();
          break;
        case 1: // 앨범 탭
          (_albumTabKey.currentState as dynamic)?.onTabResumed();
          break;
        case 2: // 일지 탭
          (_workDiaryTabKey.currentState as dynamic)?.onTabResumed();
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 경로에 따라 인덱스 동기화
    final currentLocation = GoRouterState.of(context).matchedLocation; //GoRouter의 현재 매칭된 경로를 가져옵니다
    final index = AppRouterPath.homeTabRoutes.indexOf(currentLocation);
    // 경로가 탭 라우트 중 하나이고 현재 선택된 탭 인덱스와 다르면 페이지 이동
    if (index != -1 && _currentIndex != index) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _currentIndex != index) {
          try {
            // PageController가 위젯 트리에 연결되어 있는지 확인
            if (_pageController.hasClients) {
              final previousIndex = _currentIndex;
              _pageController.jumpToPage(index);
              setState(() {
                _previousIndex = previousIndex;
                _currentIndex = index;
              });
              // 탭 변경 후 리로드
              _reloadCurrentTab(index);
            }
          } catch (e) {
            // PageController가 아직 준비되지 않은 경우 무시
          }
        }
      });
    }

    return Scaffold(
      // PageView로 탭 페이지들 세팅
      body: PageView(
        controller: _pageController, // 페이지 전환 제어
        physics: const NeverScrollableScrollPhysics(), // 스와이프 비활성화 (탭바로만 이동)
        onPageChanged: _onPageChanged, // 페이지 변경 시 인덱스 동기화
        children: _pages, // 홈, 앨범, 일지 페이지들
      ),
      // 하단 네비게이션 바 (홈, 앨범, 일지, 더보기)
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppTextStyles.text10blackW400;
            }
            return AppTextStyles.text10blackW400.copyWith(color: AppColors.grey7E827A);
          }),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: _destinations,
          indicatorColor: AppColors.transparent,
          backgroundColor: AppColors.surface,
        ),
      ),
    );
  }
}
