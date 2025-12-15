import 'package:dio/dio.dart';
// import 'package:flutter_hyotalk_app/core/network/api_endpoints.dart'; // TODO: 실제 API 사용 시 주석 해제
import 'package:flutter_hyotalk_app/features/home/data/models/home_model.dart';

/// Home 관련 네트워크 요청 처리
class HomeRepository {
  final Dio homeDio;

  HomeRepository({required this.homeDio});

  /// 기관 정보 조회 (기관 아이디로)
  ///
  /// @param agencyId 기관 아이디
  /// @return HomeModel 기관 정보 (아이콘, 배경, 메뉴 리스트)
  Future<HomeModel> getAgencyInfo(String agencyId) async {
    // TODO: 실제 API 호출
    // final res = await homeDio.get(
    //   '${ApiEndpoints.homeMenus}/$agencyId',
    // );
    //
    // if (res.statusCode != 200) {
    //   throw DioException(
    //     requestOptions: res.requestOptions,
    //     response: res,
    //     message: '기관 정보를 불러오는데 실패했습니다.',
    //     type: DioExceptionType.badResponse,
    //   );
    // }
    //
    // final data = res.data;
    // if (data is! Map<String, dynamic>) {
    //   throw DioException(
    //     requestOptions: res.requestOptions,
    //     response: res,
    //     message: '알 수 없는 응답 형식입니다.',
    //     type: DioExceptionType.badResponse,
    //   );
    // }
    //
    // return HomeModel.fromJson(data);

    // 임시 데이터 (실제 API 응답 형식)
    await Future.delayed(const Duration(milliseconds: 500));
    return HomeModel.fromJson({
      'agency_id': agencyId,
      'agency_icon_url': 'https://picsum.photos/200/200',
      'agency_background_url': 'https://picsum.photos/800/600',
      'menu_categories': [
        {
          'id': '1',
          'name': '공지사항',
          'icon': 'notice',
          'route': '/notice-list',
        },
        {
          'id': '2',
          'name': '알림장',
          'icon': 'note',
          'route': '/note-list',
        },
        {
          'id': '3',
          'name': '어르신정보',
          'icon': 'senior',
          'route': '/senior-info',
        },
        {
          'id': '4',
          'name': '직원출근부',
          'icon': 'attendance',
          'route': '/attendance',
        },
        {
          'id': '5',
          'name': '생활교육',
          'icon': 'education',
          'route': '/education',
        },
        {
          'id': '6',
          'name': '오늘의 영상',
          'icon': 'video',
          'route': '/video',
        },
      ],
    });
  }
}

