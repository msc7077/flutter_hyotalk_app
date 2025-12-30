import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/extensions/context_media_query_extension.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:flutter_hyotalk_app/features/album/data/models/album_item_model.dart';
import 'package:flutter_hyotalk_app/features/album/presentation/bloc/album_bloc.dart';
import 'package:flutter_hyotalk_app/features/album/presentation/bloc/album_event.dart';
import 'package:flutter_hyotalk_app/features/album/presentation/bloc/album_state.dart';
import 'package:flutter_hyotalk_app/router/app_router_name.dart';
import 'package:go_router/go_router.dart';

/// 앨범 탭 페이지
class AlbumTabPage extends StatefulWidget {
  const AlbumTabPage({super.key});

  @override
  State<AlbumTabPage> createState() => _AlbumTabPageState();
}

class _AlbumTabPageState extends State<AlbumTabPage> {
  late final ScrollController _scrollController;
  double _savedScrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    AppLoggerService.i('AlbumTabPage initState');
    _scrollController = ScrollController();

    // 최초 진입 시 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AlbumBloc>().add(const AlbumListRequested());
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
    AppLoggerService.i('AlbumTabPage onTabResumed - 데이터 리로드');
    // 현재 스크롤 위치 저장
    if (_scrollController.hasClients) {
      _savedScrollPosition = _scrollController.offset;
    }
    context.read<AlbumBloc>().add(const AlbumTabResumed());
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = context.safePadding.top;
    final maxHeaderHeight = (kToolbarHeight + 24) + topPadding; // 살짝 여유 있는 헤더
    final minHeaderHeight = kToolbarHeight + topPadding;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AlbumBloc, AlbumState>(
        listener: (context, state) {
          if (state is AlbumLoaded && _savedScrollPosition > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(_savedScrollPosition);
                _savedScrollPosition = 0.0;
              }
            });
          }
        },
        child: BlocBuilder<AlbumBloc, AlbumState>(
          builder: (context, state) {
            final items = state is AlbumLoaded ? state.albumList : const <AlbumItemModel>[];

            return Stack(
              children: [
                // body
                Positioned.fill(
                  child: Builder(
                    builder: (context) {
                      if (state is AlbumLoading && !state.isRefreshing) {
                        return Padding(
                          padding: EdgeInsets.only(top: maxHeaderHeight),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (state is AlbumFailure) {
                        return Padding(
                          padding: EdgeInsets.only(top: maxHeaderHeight),
                          child: Center(child: Text(state.message)),
                        );
                      }

                      return ListView.separated(
                        key: const PageStorageKey('album_scroll'),
                        controller: _scrollController,
                        padding: EdgeInsets.fromLTRB(16, maxHeaderHeight + 16, 16, 16),
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

                // header (pinned + collapsible)
                _AlbumCollapsingHeader(
                  controller: _scrollController,
                  maxHeight: maxHeaderHeight,
                  minHeight: minHeaderHeight,
                  title: AppTexts.album,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AlbumCollapsingHeader extends AnimatedWidget {
  const _AlbumCollapsingHeader({
    required ScrollController controller,
    required this.maxHeight,
    required this.minHeight,
    required this.title,
  }) : super(listenable: controller);

  ScrollController get _controller => listenable as ScrollController;

  final double maxHeight;
  final double minHeight;
  final String title;

  @override
  Widget build(BuildContext context) {
    final offset = _controller.hasClients ? _controller.offset : 0.0;
    final collapseRange = (maxHeight - minHeight).clamp(1.0, double.infinity);
    final t = (offset / collapseRange).clamp(0.0, 1.0);

    final currentHeight = lerpDouble(maxHeight, minHeight, t)!;
    final bottomPad = lerpDouble(12.0, 0.0, t)!;

    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      height: currentHeight,
      child: Container(
        color:
            Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: bottomPad),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                height: kToolbarHeight,
                child: Row(
                  children: [
                    Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
