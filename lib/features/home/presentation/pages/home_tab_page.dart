import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/extensions/context_media_query_extension.dart';
import 'package:flutter_hyotalk_app/core/theme/app_assets.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/core/theme/app_dimensions.dart';
import 'package:flutter_hyotalk_app/core/theme/app_text_styles.dart';
import 'package:flutter_hyotalk_app/features/auth/data/models/user_info_model.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// 홈 탭 페이지
class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userInfo = authState is AuthAuthenticated ? authState.userInfo : null;
    final role = userInfo?.role;
    final isAdmin = role == UserRole.admin;

    final userName = userInfo?.userName ?? (isAdmin ? '임현정' : '임현정');

    final topPadding = context.safePadding.top;
    final maxHeaderHeight = AppDimensions.spacingV120 + topPadding;
    final minHeaderHeight = kToolbarHeight + topPadding;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // body
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(top: maxHeaderHeight),
            children: [
              // 아이콘 메뉴 카드(4x2 그리드)
              SizedBox(height: AppDimensions.spacingV12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingW16),
                child: _MenuGridCard(
                  items: isAdmin ? _HomeMenus.admin(context) : _HomeMenus.caregiver(context),
                  crossAxisCount: 4,
                ),
              ),

              // 관리자: 서비스 현황(테이블) + 버튼 2개
              if (isAdmin) ...[
                SizedBox(height: AppDimensions.spacingV18),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingW16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '서비스 현황 >',
                          style: AppTextStyles.text18blackW700.copyWith(height: 1.2),
                        ),
                      ),
                      Text(
                        '2025.09.01',
                        style: AppTextStyles.text12blackW400.copyWith(
                          height: 1.2,
                          color: AppColors.grey888888,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimensions.spacingV8),
                const _ServiceTableCard(),
                SizedBox(height: AppDimensions.spacingV12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingW16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _HomeActionCard(
                          icon: Icons.calendar_today,
                          label: '일정 계획',
                          onTap: () {},
                        ),
                      ),
                      SizedBox(width: AppDimensions.spacingW12),
                      Expanded(
                        child: _HomeActionCard(
                          icon: Icons.fact_check_outlined,
                          label: '서비스결과',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // 생활지원사: (요구사항에 명시되지 않아) 최소 섹션만 유지
              if (!isAdmin) ...[
                SizedBox(height: AppDimensions.spacingV18),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingW16),
                  child: Text(
                    '오늘 일정 >',
                    style: AppTextStyles.text18blackW700.copyWith(height: 1.2),
                  ),
                ),
                SizedBox(height: AppDimensions.spacingV12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingW16),
                  child: _ScheduleCard(
                    time: '09:00',
                    typeLabel: '방문',
                    duration: '60분',
                    name: '김복녀',
                    meta: '여 / 1947-07-01 / 일반',
                    rightTop: '실적 60분',
                    actionLabel: '일지 완료',
                    actionColor: Colors.black87,
                  ),
                ),
              ],

              // 배너
              SizedBox(height: AppDimensions.spacingV16),
              const _BannerPlaceholder(),
              SizedBox(height: AppDimensions.spacingV24),
            ],
          ),

          // header (pinned + collapsible)
          _HomeCollapsingHeader(
            controller: _scrollController,
            maxHeight: maxHeaderHeight,
            minHeight: minHeaderHeight,
            userName: userName,
            isAdmin: isAdmin,
            onTapNotification: () {},
          ),
        ],
      ),
    );
  }
}

class _HomeCollapsingHeader extends AnimatedWidget {
  const _HomeCollapsingHeader({
    required ScrollController controller,
    required this.maxHeight,
    required this.minHeight,
    required this.userName,
    required this.isAdmin,
    required this.onTapNotification,
  }) : super(listenable: controller);

  ScrollController get _controller => listenable as ScrollController;

  final double maxHeight;
  final double minHeight;
  final String userName;
  final bool isAdmin;
  final VoidCallback onTapNotification;

  @override
  Widget build(BuildContext context) {
    final offset = _controller.hasClients ? _controller.offset : 0.0;
    final collapseRange = (maxHeight - minHeight).clamp(1.0, double.infinity);
    final t = (offset / collapseRange).clamp(0.0, 1.0);

    final currentHeight = lerpDouble(maxHeight, minHeight, t)!;
    final greetingOpacity = (1.0 - (t * 1.25)).clamp(0.0, 1.0);

    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      height: currentHeight,
      child: Container(
        color: AppColors.primary,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '함께해서 더 좋은, 효톡',
                            style: AppTextStyles.text14blackW400.copyWith(height: 1.2),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onTapNotification,
                        icon: Icon(Icons.notifications_none, size: 24.sp, color: AppColors.black),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Opacity(
                      opacity: greetingOpacity,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Text(
                          isAdmin ? '$userName 관리자님 >' : '$userName 생활지원사 >',
                          style: AppTextStyles.text22blackW700.copyWith(height: 1.2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({required this.label, required this.iconAsset, this.onTap});

  final String label;
  final String iconAsset;
  final VoidCallback? onTap;
}

class _HomeMenus {
  static List<_MenuItem> caregiver(BuildContext context) => [
    _MenuItem(
      label: '공지',
      iconAsset: AppAssets.iconMenuNotice,
      onTap: () => context.push(AppRouterPath.notice),
    ),
    _MenuItem(label: '알림장', iconAsset: AppAssets.iconMenuNote, onTap: () {}),
    _MenuItem(label: '생활교육', iconAsset: AppAssets.iconMenuLifeEducation, onTap: () {}),
    _MenuItem(label: '어르신정보', iconAsset: AppAssets.iconMenuSeniorInfo, onTap: () {}),
  ];

  static List<_MenuItem> admin(BuildContext context) => [
    _MenuItem(
      label: '공지',
      iconAsset: AppAssets.iconMenuNotice,
      onTap: () => context.push(AppRouterPath.notice),
    ),
    _MenuItem(label: '알림장', iconAsset: AppAssets.iconMenuNote, onTap: () {}),
    _MenuItem(
      label: '앨범',
      iconAsset: AppAssets.iconMenuAlbum,
      onTap: () => context.go(AppRouterPath.album),
    ),
    _MenuItem(label: '어르신정보', iconAsset: AppAssets.iconMenuSeniorInfo, onTap: () {}),
    _MenuItem(label: '직원출근부', iconAsset: AppAssets.iconMenuStaffAttendance, onTap: () {}),
    _MenuItem(label: '생활교육', iconAsset: AppAssets.iconMenuLifeEducation, onTap: () {}),
    _MenuItem(label: '오늘영상', iconAsset: AppAssets.iconMenuTodayVideo, onTap: () {}),
    _MenuItem(
      label: '승인/초대',
      iconAsset: AppAssets.iconMenuApproveAndInvite,
      onTap: () => context.push(AppRouterPath.approveAndInvite),
    ),
  ];
}

class _MenuGridCard extends StatelessWidget {
  const _MenuGridCard({required this.items, required this.crossAxisCount});

  final List<_MenuItem> items;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.0,
        children: items.map((item) {
          return InkWell(
            onTap: item.onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppColors.greyF5F5F5,
                  child: SvgPicture.asset(
                    item.iconAsset,
                    width: 22.sp,
                    height: 22.sp,
                    colorFilter: const ColorFilter.mode(AppColors.grey4A4A4A, BlendMode.srcIn),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(item.label, style: AppTextStyles.text12blackW400.copyWith(height: 1.2)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 88.h,
        decoration: BoxDecoration(
          color: const Color(0xFFE9F3FF),
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Text('공동구매 배너\n자리입니다', style: AppTextStyles.text16blackW700.copyWith(height: 1.2)),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.time,
    required this.typeLabel,
    required this.duration,
    required this.name,
    required this.meta,
    required this.rightTop,
    required this.actionLabel,
    required this.actionColor,
  });

  final String time;
  final String typeLabel;
  final String duration;
  final String name;
  final String meta;
  final String rightTop;
  final String actionLabel;
  final Color actionColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70.w,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingV14),
              child: Column(
                children: [Text(time, style: AppTextStyles.text16blackW700.copyWith(height: 1.2))],
              ),
            ),
          ),
          VerticalDivider(width: AppDimensions.spacingW1),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacingW12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingW8,
                          vertical: AppDimensions.spacingV3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          typeLabel,
                          style: AppTextStyles.text12blackW400.copyWith(height: 1.2),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(duration, style: AppTextStyles.text13blackW400.copyWith(height: 1.2)),
                      const Spacer(),
                      Text(rightTop, style: AppTextStyles.text12blackW400.copyWith(height: 1.2)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(name, style: AppTextStyles.text16blackW700.copyWith(height: 1.2)),
                  SizedBox(height: 2.h),
                  Text(
                    meta,
                    style: AppTextStyles.text12blackW400.copyWith(
                      height: 1.2,
                      color: AppColors.grey888888,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: actionColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                actionLabel,
                style: AppTextStyles.text12blackW400.copyWith(height: 1.2, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceTableCard extends StatelessWidget {
  const _ServiceTableCard();

  @override
  Widget build(BuildContext context) {
    final headerStyle = AppTextStyles.text12blackW400.copyWith(
      height: 1.2,
      color: AppColors.grey4A4A4A,
    );
    final cellStyle = AppTextStyles.text12blackW400.copyWith(height: 1.2);

    TableRow row(List<Widget> cells) => TableRow(children: cells);

    Widget cell(String text, {TextStyle? style, Alignment align = Alignment.centerLeft}) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        alignment: align,
        child: Text(text, style: style ?? cellStyle),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Table(
            border: TableBorder.symmetric(inside: BorderSide(color: AppColors.greyE0E0E0)),
            columnWidths: const {
              0: FlexColumnWidth(1.1),
              1: FlexColumnWidth(1.0),
              2: FlexColumnWidth(1.0),
              3: FlexColumnWidth(1.0),
            },
            children: [
              row([
                cell('서비스', style: headerStyle, align: Alignment.center),
                cell('계획', style: headerStyle, align: Alignment.center),
                cell('실적', style: headerStyle, align: Alignment.center),
                cell('달성율', style: headerStyle, align: Alignment.center),
              ]),
              row([
                cell('안전\n방문'),
                cell('15', align: Alignment.center),
                cell('15', align: Alignment.center),
                cell('100%', align: Alignment.center),
              ]),
              row([
                cell('안전\n전화'),
                cell('80', align: Alignment.center),
                cell('62', align: Alignment.center),
                cell('77%', align: Alignment.center),
              ]),
              row([
                cell('생활교육'),
                cell('48', align: Alignment.center),
                cell('45', align: Alignment.center),
                cell('50.8%', align: Alignment.center),
              ]),
              row([
                cell('일상생활지원'),
                cell('17', align: Alignment.center),
                cell('8', align: Alignment.center),
                cell('40.5%', align: Alignment.center),
              ]),
              row([
                cell('연계서비스'),
                cell('100', align: Alignment.center),
                cell('74', align: Alignment.center),
                cell('73%', align: Alignment.center),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeActionCard extends StatelessWidget {
  const _HomeActionCard({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 84.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.orangeEB5E2B, size: 22.sp),
            SizedBox(height: 8.h),
            Text(label, style: AppTextStyles.text12blackW400.copyWith(height: 1.2)),
          ],
        ),
      ),
    );
  }
}
