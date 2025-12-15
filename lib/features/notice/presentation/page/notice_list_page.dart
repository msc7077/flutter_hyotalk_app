import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/router/app_router_name.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 공지사항 리스트 페이지
class NoticeListPage extends StatelessWidget {
  const NoticeListPage({super.key});

  // 임시 데이터 (실제로는 API에서 가져옴)
  final List<Map<String, dynamic>> _notices = const [
    {
      'id': '1',
      'title': '공지사항 제목 1',
      'authorName': '홍길동',
      'authorImage': '',
      'createdDate': '2024.01.15',
      'scope': '전체 공개',
      'viewCount': 123,
      'commentCount': 5,
      'content': '공지사항 내용입니다. 여러 줄의 내용을 표시할 수 있습니다.',
      'attachedImages': [
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
      ],
    },
    {
      'id': '2',
      'title': '공지사항 제목 2',
      'authorName': '김철수',
      'authorImage': '',
      'createdDate': '2024.01.16',
      'scope': '회원 공개',
      'viewCount': 456,
      'commentCount': 12,
      'content': '공지사항 내용입니다. 여러 줄의 내용을 표시할 수 있습니다. 더 많은 내용이 있습니다.',
      'attachedImages': ['https://via.placeholder.com/200', 'https://via.placeholder.com/200'],
    },
    {
      'id': '3',
      'title': '공지사항 제목 3',
      'authorName': '이영희',
      'authorImage': '',
      'createdDate': '2024.01.17',
      'scope': '전체 공개',
      'viewCount': 789,
      'commentCount': 8,
      'content': '공지사항 내용입니다.',
      'attachedImages': [
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
      ],
    },
    {
      'id': '4',
      'title': '공지사항 제목 4',
      'authorName': '박민수',
      'authorImage': '',
      'createdDate': '2024.01.18',
      'scope': '전체 공개',
      'viewCount': 234,
      'commentCount': 3,
      'content': '공지사항 내용입니다. 여러 줄의 내용을 표시할 수 있습니다. 더 많은 내용이 있습니다. 계속해서 더 많은 내용이 있습니다.',
      'attachedImages': [],
    },
    {
      'id': '5',
      'title': '공지사항 제목 5',
      'authorName': '최지영',
      'authorImage': '',
      'createdDate': '2024.01.19',
      'scope': '회원 공개',
      'viewCount': 567,
      'commentCount': 15,
      'content': '공지사항 내용입니다.',
      'attachedImages': ['https://via.placeholder.com/200'],
    },
    {
      'id': '6',
      'title': '공지사항 제목 6',
      'authorName': '정대현',
      'authorImage': '',
      'createdDate': '2024.01.20',
      'scope': '전체 공개',
      'viewCount': 890,
      'commentCount': 20,
      'content': '공지사항 내용입니다. 여러 줄의 내용을 표시할 수 있습니다.',
      'attachedImages': [
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
        'https://via.placeholder.com/200',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공지사항')),
      backgroundColor: AppColors.background,
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: _notices.length,
        itemBuilder: (context, index) {
          final notice = _notices[index];
          return _buildNoticeItem(context, notice);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(AppRouterName.noticeFormName);
        },
        child: const Icon(Icons.mode_edit),
      ),
    );
  }

  /// 공지사항 아이템
  Widget _buildNoticeItem(BuildContext context, Map<String, dynamic> notice) {
    return Card(
      color: AppColors.surface,
      margin: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            AppRouterName.noticeDetailName,
            pathParameters: {'id': notice['id'] as String},
          );
        },
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 영역 (작성자 정보, 메뉴 버튼)
              Row(
                children: [
                  // 작성자 이미지
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.greyE0E0E0,
                    backgroundImage: (notice['authorImage'] as String).isNotEmpty
                        ? NetworkImage(notice['authorImage'] as String)
                        : null,
                    child: (notice['authorImage'] as String).isEmpty
                        ? const Icon(Icons.person, color: AppColors.grey9E9E9E)
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  // 작성자 이름 및 메타 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notice['authorName'] as String,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              notice['createdDate'] as String,
                              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                notice['scope'] as String,
                                style: TextStyle(fontSize: 11.sp, color: Colors.blue[700]),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.visibility, size: 14.sp, color: Colors.grey[600]),
                                SizedBox(width: 4.w),
                                Text(
                                  '${notice['viewCount']}',
                                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 메뉴 버튼
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showBottomSheet(context, notice),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // 제목 (최대 2줄)
              Text(
                notice['title'] as String,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),
              // 텍스트 내용 (최대 3줄)
              if (notice['content'] != null && (notice['content'] as String).isNotEmpty)
                Text(
                  notice['content'] as String,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700], height: 1.4),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              // 첨부 이미지 (최대 5개)
              if (notice['attachedImages'] != null &&
                  (notice['attachedImages'] as List).isNotEmpty) ...[
                SizedBox(height: 12.h),
                _buildAttachedImages(notice['attachedImages'] as List<String>),
              ],
              SizedBox(height: 12.h),
              // 하단 영역 (댓글 수)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.comment, size: 16.sp, color: Colors.grey[600]),
                      SizedBox(width: 4.w),
                      Text(
                        '${notice['commentCount']}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 첨부 이미지 표시 (최대 5개, 마지막에 더 있음 표시)
  Widget _buildAttachedImages(List<String> images) {
    if (images.isEmpty) return const SizedBox.shrink();

    final displayImages = images.take(5).toList();
    final hasMore = images.length > 5;

    return SizedBox(
      height: 80.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: displayImages.length,
        itemBuilder: (context, index) {
          final isLast = index == displayImages.length - 1;
          final isMoreIndicator = isLast && hasMore;

          return Container(
            width: 80.w,
            height: 80.h,
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    displayImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.image, size: 30.sp, color: Colors.grey),
                      );
                    },
                  ),
                  // 더 있음 표시 오버레이
                  if (isMoreIndicator)
                    Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Center(
                        child: Text(
                          '+${images.length - 4}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 바텀시트 표시 (게시글 수정, 삭제, 취소)
  void _showBottomSheet(BuildContext context, Map<String, dynamic> notice) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 게시글 수정
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('게시글 수정'),
              onTap: () {
                context.pushNamed(
                  AppRouterName.noticeEditName,
                  pathParameters: {'id': notice['id'] as String},
                );
                Navigator.pop(context);
              },
            ),
            // 게시글 삭제
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('게시글 삭제', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmDialog(context, notice);
              },
            ),
            // 취소
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('취소'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  /// 삭제 확인 다이얼로그
  void _showDeleteConfirmDialog(BuildContext context, Map<String, dynamic> notice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('게시글 삭제'),
        content: const Text('정말로 이 게시글을 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: API 호출로 게시글 삭제
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('게시글이 삭제되었습니다.')));
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
