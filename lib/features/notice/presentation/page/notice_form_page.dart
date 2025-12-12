import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 공지사항 작성/수정 페이지
///
/// @param noticeId 공지사항 ID (null이면 작성 모드, 있으면 수정 모드)
class NoticeFormPage extends StatefulWidget {
  final String? noticeId;

  const NoticeFormPage({super.key, this.noticeId});

  @override
  State<NoticeFormPage> createState() => _NoticeFormPageState();
}

class _NoticeFormPageState extends State<NoticeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final List<String> _selectedImages = [];
  String _selectedScope = '전체 공개';

  late final bool isEditMode = widget.noticeId != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _loadNoticeData();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// 수정 모드일 때 기존 데이터 로드
  void _loadNoticeData() {
    // TODO: API 호출로 기존 공지사항 데이터 가져오기
    _titleController.text = '공지사항 제목입니다';
    _contentController.text = '공지사항 내용입니다.';
    _selectedScope = '전체 공개';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? '공지사항 수정' : '공지사항 작성'),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: Text(
              '완료',
              style: TextStyle(fontSize: 16.sp, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 입력
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: '제목',
                  hintText: '제목을 입력하세요',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                ),
                style: TextStyle(fontSize: 16.sp),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              // 공개범위 선택
              DropdownButtonFormField<String>(
                value: _selectedScope,
                decoration: InputDecoration(
                  labelText: '공개범위',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                ),
                items: ['전체 공개', '회원 공개', '비공개']
                    .map(
                      (scope) => DropdownMenuItem(
                        value: scope,
                        child: Text(scope, style: TextStyle(fontSize: 14.sp)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedScope = value;
                    });
                  }
                },
              ),
              SizedBox(height: 16.h),
              // 내용 입력
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: '내용',
                  hintText: '내용을 입력하세요',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  contentPadding: EdgeInsets.all(16.w),
                ),
                style: TextStyle(fontSize: 14.sp),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '내용을 입력해주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              // 첨부 이미지
              _buildImageSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// 첨부 이미지 섹션
  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '첨부 이미지',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            // 이미지 목록
            ..._selectedImages.asMap().entries.map((entry) {
              final index = entry.key;
              final image = entry.value;
              return _buildImageItem(image, index);
            }),
            // 이미지 추가 버튼
            if (_selectedImages.length < 10) _buildAddImageButton(),
          ],
        ),
      ],
    );
  }

  /// 이미지 아이템
  Widget _buildImageItem(String image, int index) {
    return Stack(
      children: [
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 30.sp, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        // 삭제 버튼
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedImages.removeAt(index);
              });
            },
            child: Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Icon(Icons.close, size: 16.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  /// 이미지 추가 버튼
  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _addImage,
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(Icons.add, size: 30.sp, color: Colors.grey),
      ),
    );
  }

  /// 이미지 추가
  void _addImage() {
    // TODO: 이미지 선택 기능 구현 (image_picker 등 사용)
    setState(() {
      _selectedImages.add('https://via.placeholder.com/200');
    });
  }

  /// 폼 제출
  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // TODO: API 호출로 공지사항 저장/수정
    if (isEditMode) {
      // 수정
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('공지사항이 수정되었습니다.')));
    } else {
      // 작성
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('공지사항이 작성되었습니다.')));
    }

    // 리스트 페이지로 이동
    context.pop();
  }
}
