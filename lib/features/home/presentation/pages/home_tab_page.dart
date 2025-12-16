import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/extensions/context_media_query_extension.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/core/theme/app_text_styles.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:flutter_hyotalk_app/core/widget/dialog/app_common_dialog.dart';
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

class _HomeTabPageState extends State<HomeTabPage> with AutomaticKeepAliveClientMixin {
  late final HomeBloc _homeBloc;
  late final ScrollController _scrollController;
  double _savedScrollPosition = 0.0;

  /// 탭 이동 시에도 상태 유지
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    AppLoggerService.i('HomeTabPage initState');
    _scrollController = ScrollController();
    _homeBloc = HomeBloc(homeRepository: context.read<HomeRepository>());
    _loadAgencyInfo();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

  /// 탭으로 돌아왔을 때 호출 (MainPage에서 호출)
  ///
  /// 데이터를 최신 상태로 갱신합니다.
  /// 스크롤 위치는 저장되어 유지됩니다.
  void onTabResumed() {
    AppLoggerService.i('HomeTabPage onTabResumed - 데이터 리로드');
    // 현재 스크롤 위치 저장
    if (_scrollController.hasClients) {
      _savedScrollPosition = _scrollController.offset;
    }
    _loadAgencyInfo();
  }

  @override
  Widget build(BuildContext context) {
    // AutomaticKeepAliveClientMixin을 사용할 때 필수
    super.build(context);

    return BlocProvider.value(
      value: _homeBloc,
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeFailure) {
            // 에러 발생 시 다이얼로그 표시
            AppCommonDialog.show(context, state.message, title: AppTexts.error);
          } else if (state is HomeLoaded && _savedScrollPosition > 0) {
            // 데이터 로드 완료 후 스크롤 위치 복원
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(_savedScrollPosition);
                _savedScrollPosition = 0.0; // 복원 후 초기화
              }
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Builder(
            builder: (context) {
              final headerHeight = context.screenHeight23; // 화면 높이의 2/3

              return Stack(
                children: [
                  // 배경 이미지는 state에 따라 변경
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      return _buildAgencyImageBackground(context, state, headerHeight);
                    },
                  ),
                  // SingleChildScrollView는 항상 유지하여 스크롤 위치 보존
                  SingleChildScrollView(
                    key: const PageStorageKey('home_scroll'),
                    controller: _scrollController,
                    child: BlocBuilder<HomeBloc, HomeState>(
                      // 실제로 데이터가 변경되었을 때만 리빌드
                      buildWhen: (previous, current) {
                        // 로딩 상태 변경은 무시 (스크롤 위치 유지)
                        if (previous is HomeLoading && current is HomeLoading) {
                          return false;
                        }
                        // 에러 상태는 리빌드 불필요
                        if (current is HomeFailure) {
                          return false;
                        }
                        return true;
                      },
                      builder: (context, state) {
                        return Column(
                          key: const ValueKey('home_content'),
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
                        );
                      },
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
              child: const Center(child: AppLoadingIndicator()),
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
          child: const Center(child: AppLoadingIndicator()),
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
            child: Center(child: Text('배너 ${index + 1}', style: AppTextStyles.text24blackW700)),
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
          crossAxisCount: 4,
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
