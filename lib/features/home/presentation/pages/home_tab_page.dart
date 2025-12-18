import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:flutter_hyotalk_app/features/album/data/models/album_item_model.dart';
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
  late final ScrollController _scrollController;
  double _savedScrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    AppLoggerService.i('HomeTabPage initState');
    _scrollController = ScrollController();

    // 최초 진입 시 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeBloc>().add(const HomeListRequested());
      }
    });
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
    AppLoggerService.i('HomeTabPage onTabResumed - 데이터 리로드');
    // 현재 스크롤 위치 저장
    if (_scrollController.hasClients) {
      _savedScrollPosition = _scrollController.offset;
    }
    context.read<HomeBloc>().add(const HomeTabResumed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppTexts.album)),
      backgroundColor: AppColors.orangeEB5E2B,
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoaded && _savedScrollPosition > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(_savedScrollPosition);
                _savedScrollPosition = 0.0;
              }
            });
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading && !state.isRefreshing) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeFailure) {
              return Center(child: Text(state.message));
            }
            final items = state is HomeLoaded ? state.homeList : const <AlbumItemModel>[];

            return ListView.separated(
              key: const PageStorageKey('album_scroll'),
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final album = items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      album.thumbnailUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(album.title),
                  subtitle: Text('사진 ${album.photoCount}장'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.pushNamed(
                      AppRouterName.albumDetailName,
                      pathParameters: {'id': album.id},
                      extra: album,
                    );
                  },
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemCount: items.length,
            );
          },
        ),
      ),
    );
  }
}
