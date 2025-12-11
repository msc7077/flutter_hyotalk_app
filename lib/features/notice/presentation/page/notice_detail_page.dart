import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 공지사항 상세 페이지
///
/// @param noticeId 공지사항 ID
class NoticeDetailPage extends StatefulWidget {
  final String noticeId;

  const NoticeDetailPage({super.key, required this.noticeId});

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // 임시 데이터 (실제로는 API에서 가져옴)
  final String _title = '공지사항 제목입니다';
  final String _authorName = '홍길동';
  final String _authorImage = ''; // 이미지 URL 또는 경로
  final String _createdDate = '2024.01.15';
  final String _scope = '전체 공개';
  final int _viewCount = 123;
  final String _content =
      '공지사항 내용입니다.\n\n여러 줄의 내용을 표시할 수 있습니다.\n\n여러 줄의 내용을 표시할 수 있습니다.\n\n여러 줄의 내용을 표시할 수 있습니다.\n\n여러 줄의 내용을 표시할 수 있습니다.\n\n여러 줄의 내용을 표시할 수 있습니다.\n\n여러 줄의 내용을 표시할 수 있습니다.\n\n여러 줄의 내용을 표시할 수 있습니다.\n\n여러 줄의 내용을 표시할 수 있습니다.\n\n여러 줄의 내용을 표시할 수 있습니다.\n\n여러 줄의 내용을 표시할 수 있습니다.\n\n여러 줄의 내용을 표시할 수 있습니다.\n\n여러 줄의 내용을 표시할 수 있습니다.\n\n여러 줄의 내용을 표시할 수 있습니다.';
  final List<String> _attachedImages = [
    'https://via.placeholder.com/400x300',
    'https://via.placeholder.com/400x300',
  ];
  final List<Map<String, dynamic>> _comments = [
    {'id': '1', 'authorName': '김철수', 'createdDate': '2024.01.16', 'content': '좋은 공지사항이네요!'},
    {'id': '2', 'authorName': '이영희', 'createdDate': '2024.01.17', 'content': '확인했습니다.'},
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () => _showBottomSheet(context)),
        ],
      ),
      body: Column(
        children: [
          // 스크롤 가능한 본문 영역
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1파트: 헤더 영역
                  _buildHeaderSection(),
                  SizedBox(height: 24.h),
                  const Divider(),
                  SizedBox(height: 24.h),
                  // 2파트: 본문 영역
                  _buildContentSection(),
                  SizedBox(height: 24.h),
                  const Divider(),
                  SizedBox(height: 24.h),
                  // 3파트: 댓글 리스트
                  _buildCommentSection(),
                ],
              ),
            ),
          ),
          // 4파트: 댓글 입력 영역
          _buildCommentInputSection(),
        ],
      ),
    );
  }

  /// 1파트: 헤더 영역 (작성자 이미지, 제목, 작성자 이름, 작성일, 공개범위, 조회수, 메뉴 버튼)
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Text(
          _title,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        // 작성자 정보 및 메타 정보
        Row(
          children: [
            // 작성자 이미지
            CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.grey[300],
              backgroundImage: _authorImage.isNotEmpty ? NetworkImage(_authorImage) : null,
              child: _authorImage.isEmpty ? const Icon(Icons.person, color: Colors.grey) : null,
            ),
            SizedBox(width: 12.w),
            // 작성자 이름 및 메타 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _authorName,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        _createdDate,
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
                          _scope,
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
                            '$_viewCount',
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 2파트: 본문 영역 (첨부 이미지, 글 내용)
  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 첨부 이미지
        if (_attachedImages.isNotEmpty) ...[
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _attachedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 300.w,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      _attachedImages[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.image, size: 50.sp),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],
        // 글 내용
        Text(_content, style: TextStyle(fontSize: 14.sp, height: 1.6)),
      ],
    );
  }

  /// 3파트: 댓글 리스트
  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 댓글 헤더
        Row(
          children: [
            Text(
              '댓글',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8.w),
            Text(
              '${_comments.length}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // 댓글 리스트
        if (_comments.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32.h),
            child: Center(
              child: Text(
                '댓글이 없습니다.',
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ),
          )
        else
          ..._comments.map((comment) => _buildCommentItem(comment)),
      ],
    );
  }

  /// 댓글 아이템
  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 댓글 작성자 이미지
          CircleAvatar(
            radius: 16.r,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 18.sp, color: Colors.grey),
          ),
          SizedBox(width: 12.w),
          // 댓글 내용
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment['authorName'] as String,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      comment['createdDate'] as String,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(comment['content'] as String, style: TextStyle(fontSize: 14.sp, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 4파트: 댓글 입력 영역
  Widget _buildCommentInputSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 댓글 입력 필드
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: '댓글을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submitComment(),
              ),
            ),
            SizedBox(width: 8.w),
            // 전송 버튼
            IconButton(
              icon: const Icon(Icons.send),
              color: Colors.blue,
              onPressed: _submitComment,
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue[50],
                padding: EdgeInsets.all(12.w),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 댓글 전송
  void _submitComment() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    // TODO: API 호출로 댓글 등록
    setState(() {
      _comments.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'authorName': '나',
        'createdDate': '방금 전',
        'content': comment,
      });
      _commentController.clear();
    });

    // 댓글 영역으로 스크롤
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 바텀시트 표시 (게시글 수정, 삭제, 취소)
  void _showBottomSheet(BuildContext context) {
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
                Navigator.pop(context);
                // TODO: 게시글 수정 페이지로 이동
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('게시글 수정 기능')));
              },
            ),
            // 게시글 삭제
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('게시글 삭제', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmDialog(context);
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
  void _showDeleteConfirmDialog(BuildContext context) {
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
              Navigator.pop(context); // 상세 페이지 닫기
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
