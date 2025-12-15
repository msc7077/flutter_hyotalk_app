import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:flutter_hyotalk_app/core/widget/dialog/app_error_dialog.dart';
import 'package:flutter_hyotalk_app/core/widget/loading/app_loading_indicator.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/features/home/data/models/menu_category_model.dart';
import 'package:flutter_hyotalk_app/features/home/data/repositories/home_repository.dart';
import 'package:flutter_hyotalk_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_hyotalk_app/features/home/presentation/bloc/home_event.dart';
import 'package:flutter_hyotalk_app/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_hyotalk_app/router/app_router_name.dart';
import 'package:go_router/go_router.dart';

/// 홈 탭 페이지
class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  late final HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(homeRepository: context.read<HomeRepository>());
    _loadAgencyInfo();
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  /// 기관 정보 로드
  ///
  /// AuthBloc에서 UserInfo를 가져와서 기관 아이디로 기관 정보를 로드합니다.
  Future<void> _loadAgencyInfo() async {
    // AuthBloc의 State에서 사용자 정보 가져오기
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {
      // State에 이미 사용자 정보가 있음
      final userInfo = authState.userInfo;
      _homeBloc.add(AgencyInfoLoadRequested(userInfo.agencyId));
    } else {
      // 로그인 안 된 상태 (이론적으로는 발생하지 않아야 함)
      // TODO: 에러 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeBloc,
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeFailure) {
            // 에러 발생 시 다이얼로그 표시
            AppErrorDialog.show(context, state.message, title: AppTexts.error);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final screenHeight = MediaQuery.of(context).size.height;
              final headerHeight = screenHeight * 2 / 3; // 화면 높이의 2/3

              return Stack(
                children: [
                  _buildAgencyImageBackground(context, state, headerHeight),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        // 이미지 배너 (가로 슬라이드)
                        _buildBannerSection(),
                        const SizedBox(height: 20),
                        // 그리드뷰 카테고리
                        _buildCategoryGrid(context, state),
                        const SizedBox(height: 20),
                        // 그리드뷰 카테고리
                        _buildCategoryGrid(context, state),
                        const SizedBox(height: 20),
                        // 그리드뷰 카테고리
                        _buildCategoryGrid(context, state),
                        const SizedBox(height: 20),
                        // 그리드뷰 카테고리
                        _buildCategoryGrid(context, state),
                        const SizedBox(height: 20),
                        // 그리드뷰 카테고리
                        _buildCategoryGrid(context, state),
                        const SizedBox(height: 20),
                        // 그리드뷰 카테고리
                        _buildCategoryGrid(context, state),
                        const SizedBox(height: 20),
                        // 그리드뷰 카테고리
                        _buildCategoryGrid(context, state),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// 기관 이미지 백그라운드
  ///
  /// 화면의 2/3
  Widget _buildAgencyImageBackground(BuildContext context, HomeState state, double height) {
    if (state is HomeLoaded && state.homeModel.agencyBackgroundUrl != null) {
      return Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: height,
        child: Image.network(
          state.homeModel.agencyBackgroundUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.greyE0E0E0,
              child: const Center(child: Icon(Icons.image, size: 64, color: AppColors.grey9E9E9E)),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppColors.greyF5F5F5,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      );
    } else if (state is HomeLoading) {
      return Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: height,
        child: Container(
          color: AppColors.greyF5F5F5,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    } else {
      return Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: height,
        child: Container(color: AppColors.greyE0E0E0),
      );
    }
  }

  Widget _buildBannerSection() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: 3, // 예시: 3개의 배너
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '배너 ${index + 1}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, HomeState state) {
    // State에서 메뉴 리스트 가져오기
    List<MenuCategoryModel> menuCategories = [];
    if (state is HomeLoaded) {
      menuCategories = state.homeModel.menuCategories;
    }

    // 로딩 중이거나 메뉴가 없을 때
    if (state is HomeLoading || menuCategories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: state is HomeLoading
            ? const Center(child: AppLoadingIndicator())
            : const Center(child: Text('메뉴가 없습니다.')),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: menuCategories.length,
        itemBuilder: (context, index) {
          final menu = menuCategories[index];
          return _buildCategoryCard(menu.id, menu.name, menu.icon, menu.route);
        },
      ),
    );
  }

  Widget _buildCategoryCard(String id, String name, String icon, String? route) {
    return Builder(
      builder: (context) => InkWell(
        onTap: () {
          // route가 있으면 해당 경로로 이동, 없으면 기본 공지사항 리스트로
          if (route != null && route.isNotEmpty) {
            context.push(route);
          } else {
            context.pushNamed(AppRouterName.noticeListName);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO: icon이 URL이면 Image.network, 아니면 Icon 사용
              // 임시로 Icon 사용
              Icon(Icons.category, size: 48, color: Colors.blue),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
