import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:flutter_hyotalk_app/features/work_diary/data/models/work_diary_item_model.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/bloc/work_diary_bloc.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/bloc/work_diary_event.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/bloc/work_diary_state.dart';
import 'package:flutter_hyotalk_app/router/app_router_name.dart';
import 'package:go_router/go_router.dart';

/// 업무일지 탭 페이지
class WorkDiaryTabPage extends StatefulWidget {
  const WorkDiaryTabPage({super.key});

  @override
  State<WorkDiaryTabPage> createState() => _WorkDiaryTabPageState();
}

class _WorkDiaryTabPageState extends State<WorkDiaryTabPage> {
  late final ScrollController _scrollController;
  double _savedScrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    AppLoggerService.i('WorkDiaryTabPage initState');
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<WorkDiaryBloc>().add(const WorkDiaryListRequested());
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
    AppLoggerService.i('WorkDiaryTabPage onTabResumed - 데이터 리로드');
    // 현재 스크롤 위치 저장
    if (_scrollController.hasClients) {
      _savedScrollPosition = _scrollController.offset;
    }
    context.read<WorkDiaryBloc>().add(const WorkDiaryTabResumed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppTexts.workDiary)),
      backgroundColor: AppColors.background,
      body: BlocListener<WorkDiaryBloc, WorkDiaryState>(
        listener: (context, state) {
          if (state is WorkDiaryLoaded && _savedScrollPosition > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(_savedScrollPosition);
                _savedScrollPosition = 0.0;
              }
            });
          }
        },
        child: BlocBuilder<WorkDiaryBloc, WorkDiaryState>(
          builder: (context, state) {
            if (state is WorkDiaryLoading && !state.isRefreshing) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is WorkDiaryFailure) {
              return Center(child: Text(state.message));
            }
            final items = state is WorkDiaryLoaded
                ? state.workDiaryList
                : const <WorkDiaryItemModel>[];

            return ListView.separated(
              key: const PageStorageKey('work_diary_scroll'),
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.title),
                  subtitle: Text('${item.authorName} · ${item.date.toLocal()}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.pushNamed(
                      AppRouterName.workDiaryDetailName,
                      pathParameters: {'id': item.id},
                      extra: item,
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
