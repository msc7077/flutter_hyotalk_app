import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/theme/app_assets.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/core/theme/app_text_styles.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:flutter_hyotalk_app/features/album/presentation/bloc/album_bloc.dart';
import 'package:flutter_hyotalk_app/features/album/presentation/bloc/album_event.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/bloc/work_diary_bloc.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/bloc/work_diary_event.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

/// 메인 페이지
///
/// 하단 탭바를 통해 홈, 앨범, 업무일지, 쇼핑몰 페이지로 이동
/// 더보기 탭은 마이페이지 페이지로 이동
class MainPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainPage({super.key, required this.navigationShell});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// 하단 탭바 아이콘과 라벨 정의
  final List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: SvgPicture.asset(AppAssets.iconBottomTabMenuHomeOutlined),
      selectedIcon: SvgPicture.asset(AppAssets.iconBottomTabMenuHome),
      label: AppTexts.home,
    ),
    NavigationDestination(
      icon: SvgPicture.asset(AppAssets.iconBottomTabMenuAlbumOutlined),
      selectedIcon: SvgPicture.asset(AppAssets.iconBottomTabMenuAlbum),
      label: AppTexts.album,
    ),
    NavigationDestination(
      icon: SvgPicture.asset(AppAssets.iconBottomTabMenuWorkOutlined),
      selectedIcon: SvgPicture.asset(AppAssets.iconBottomTabMenuWork),
      label: AppTexts.workDiary,
    ),
    NavigationDestination(
      icon: SvgPicture.asset(AppAssets.iconBottomTabMenuMoreOutlined),
      selectedIcon: SvgPicture.asset(AppAssets.iconBottomTabMenuMore),
      label: AppTexts.more,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 하단 탭바 선택 시 페이지 이동
  void _onDestinationSelected(int index) {
    // 더보기는 전체 화면(2depth)로 push
    if (index == 3) {
      context.push(AppRouterPath.more);
      return;
    }

    // 같은 탭을 다시 누르는 경우: 해당 브랜치의 초기 라우트로 이동
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );

    // 탭 전환 시(또는 재선택 시) 필요한 경우 리프레시 트리거
    if (index == 1) {
      context.read<AlbumBloc>().add(const AlbumTabResumed());
    } else if (index == 2) {
      context.read<WorkDiaryBloc>().add(const WorkDiaryTabResumed());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // go_router의 StatefulShellRoute.indexedStack이 각 탭의 Navigator 스택을 유지해줌
      // (스크롤/상세 push-pop이 자연스럽게 유지됨)
      body: widget.navigationShell,
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
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: _destinations,
          indicatorColor: AppColors.transparent,
          backgroundColor: AppColors.surface,
        ),
      ),
    );
  }
}
