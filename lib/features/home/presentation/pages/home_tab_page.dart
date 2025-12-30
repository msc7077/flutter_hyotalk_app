import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/features/auth/data/models/user_info_model.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    return Scaffold(
      appBar: _HomeAppBar(),
      backgroundColor: AppColors.background,
      body: ListView(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        children: [
          // 상단 노란 배경 영역 + 프로필 영역
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAdmin ? '$userName 관리자님 >' : '$userName 생활지원사 >',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),

          // 아이콘 메뉴 카드(4x2 그리드)
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _MenuGridCard(
              items: isAdmin ? _HomeMenus.admin(context) : _HomeMenus.caregiver(context),
              crossAxisCount: 4,
            ),
          ),

          // 관리자: 서비스 현황(테이블) + 버튼 2개
          if (isAdmin) ...[
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '서비스 현황 >',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Text(
                    '2025.09.01',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: AppColors.grey888888,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            const _ServiceTableCard(),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: _HomeActionCard(
                      icon: Icons.calendar_today,
                      label: '일정 계획',
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 12.w),
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
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                '오늘 일정 >',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: AppColors.black,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
          SizedBox(height: 16.h),
          const _BannerPlaceholder(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(44.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      title: Text(
        '함께해서 더 좋은, 효톡',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.2,
          color: AppColors.black,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none, size: 24.sp, color: AppColors.black),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  const _MenuItem({required this.label, required this.icon, this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
}

class _HomeMenus {
  static List<_MenuItem> caregiver(BuildContext context) => [
    _MenuItem(
      label: '공지',
      icon: Icons.campaign_outlined,
      onTap: () => context.push(AppRouterPath.notice),
    ),
    _MenuItem(label: '알림장', icon: Icons.menu_book_outlined, onTap: () {}),
    _MenuItem(label: '생활교육', icon: Icons.cast_for_education_outlined, onTap: () {}),
    _MenuItem(label: '어르신정보', icon: Icons.groups_outlined, onTap: () {}),
  ];

  static List<_MenuItem> admin(BuildContext context) => [
    _MenuItem(
      label: '공지',
      icon: Icons.campaign_outlined,
      onTap: () => context.push(AppRouterPath.notice),
    ),
    _MenuItem(label: '알림장', icon: Icons.menu_book_outlined, onTap: () {}),
    _MenuItem(
      label: '앨범',
      icon: Icons.photo_library_outlined,
      onTap: () => context.go(AppRouterPath.album),
    ),
    _MenuItem(label: '어르신정보', icon: Icons.groups_outlined, onTap: () {}),
    _MenuItem(label: '직원출근부', icon: Icons.event_note_outlined, onTap: () {}),
    _MenuItem(label: '생활교육', icon: Icons.cast_for_education_outlined, onTap: () {}),
    _MenuItem(label: '오늘영상', icon: Icons.ondemand_video_outlined, onTap: () {}),
    _MenuItem(
      label: '승인/초대',
      icon: Icons.mail_outline,
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
        children: items.map((e) {
          return InkWell(
            onTap: e.onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppColors.greyF5F5F5,
                  child: Icon(e.icon, size: 22.sp, color: AppColors.grey4A4A4A),
                ),
                SizedBox(height: 8.h),
                Text(
                  e.label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: AppColors.black,
                  ),
                ),
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
        child: Text(
          '공동구매 배너\n자리입니다',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: AppColors.black,
          ),
        ),
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
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70.w,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Column(
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(width: 1.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        duration,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                          color: AppColors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        rightTop,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    meta,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
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
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  color: Colors.white,
                ),
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
    final headerStyle = TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      height: 1.2,
      color: AppColors.grey4A4A4A,
    );
    final cellStyle = TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      height: 1.2,
      color: AppColors.black,
    );

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
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 1.2,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
