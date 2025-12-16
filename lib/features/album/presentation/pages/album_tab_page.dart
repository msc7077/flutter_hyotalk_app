import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';

/// 앨범 탭 페이지
class AlbumTabPage extends StatefulWidget {
  const AlbumTabPage({super.key});

  @override
  State<AlbumTabPage> createState() => _AlbumTabPageState();
}

class _AlbumTabPageState extends State<AlbumTabPage> with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  double _savedScrollPosition = 0.0;

  /// 탭 이동 시에도 상태 유지
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    AppLoggerService.i('AlbumTabPage initState');
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 탭으로 돌아왔을 때 호출 (MainPage에서 호출)
  ///
  /// 데이터를 최신 상태로 갱신합니다.
  /// 스크롤 위치는 저장되어 유지됩니다.
  void onTabResumed() {
    AppLoggerService.i('AlbumTabPage onTabResumed - 데이터 리로드');
    // 현재 스크롤 위치 저장
    if (_scrollController.hasClients) {
      _savedScrollPosition = _scrollController.offset;
    }
    // TODO: 앨범 리스트 리로드 로직 추가
    // 예: _albumBloc.add(AlbumListLoadRequested());

    // 데이터 리로드 완료 후 스크롤 위치 복원 (Bloc 사용 시 BlocListener에서 처리)
    // 현재는 즉시 복원
    if (_savedScrollPosition > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_savedScrollPosition);
          _savedScrollPosition = 0.0; // 복원 후 초기화
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // AutomaticKeepAliveClientMixin을 사용할 때 필수
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text('앨범')),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        key: const PageStorageKey('album_scroll'),
        controller: _scrollController,
        child: Column(
          key: const ValueKey('album_content'),
          children: [
            // 그리드뷰 카테고리
            _buildCategoryGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'id': 'shop1', 'name': '앨범 카테고리 1', 'icon': Icons.alarm},
      {'id': 'shop2', 'name': '앨범 카테고리 2', 'icon': Icons.alarm},
      {'id': 'shop3', 'name': '앨범 카테고리 3', 'icon': Icons.alarm},
      {'id': 'shop4', 'name': '앨범 카테고리 4', 'icon': Icons.alarm},
      {'id': 'shop5', 'name': '앨범 카테고리 5', 'icon': Icons.alarm},
      {'id': 'shop6', 'name': '앨범 카테고리 6', 'icon': Icons.alarm},
    ];

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
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(
            category['id'] as String,
            category['name'] as String,
            category['icon'] as IconData,
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(String id, String name, IconData icon) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.orange),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
