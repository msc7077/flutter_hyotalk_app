import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/init/app_initializer.dart';
import 'package:flutter_hyotalk_app/features/album/data/repositories/album_repository.dart';
import 'package:flutter_hyotalk_app/features/album/presentation/bloc/album_bloc.dart';
import 'package:flutter_hyotalk_app/features/home/data/repositories/home_repository.dart';
import 'package:flutter_hyotalk_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_hyotalk_app/features/work_diary/data/repositories/work_diary_repository.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/bloc/work_diary_bloc.dart';

/// MainScope
///
/// 로그인 이후 "메인(탭 유지) 영역"에서 공유되어야 하는 Repository/Bloc을 제공한다.
/// - Router: 라우팅만 담당
/// - Scope: DI(Repository/Bloc) 담당
class MainScope extends StatelessWidget {
  final Widget child;

  const MainScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final hyotalkDio = AppInitializer.instance.hyotalkDio;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => HomeRepository(hyotalkDio: hyotalkDio)),
        RepositoryProvider(create: (_) => AlbumRepository(hyotalkDio: hyotalkDio)),
        RepositoryProvider(create: (_) => WorkDiaryRepository(hyotalkDio: hyotalkDio)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(homeRepository: context.read<HomeRepository>()),
          ),
          BlocProvider(
            create: (context) => AlbumBloc(albumRepository: context.read<AlbumRepository>()),
          ),
          BlocProvider(
            create: (context) => WorkDiaryBloc(context.read<WorkDiaryRepository>()),
          ),
        ],
        child: child,
      ),
    );
  }
}


