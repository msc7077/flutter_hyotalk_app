import 'package:flutter_hyotalk_app/router/app_router_path.dart';

/// 외부 딥링크 URI(hyotalk://, https://)를 앱 내부 라우트 location(/...)로 정규화한다.
class DeepLinkNormalizer {
  DeepLinkNormalizer._();

  static String? normalize(Uri uri) {
    // hyotalk://invitemsg?id=... , hyotalk://work-diary/1 ...
    if (uri.scheme == 'hyotalk') {
      final host = uri.host;
      final path = uri.path;

      // 초대 메시지: hyotalk://invitemsg?id=... -> /invite?id=...
      if (host == 'invitemsg' || host == 'invite') {
        return Uri(
          path: AppRouterPath.simpleRegister,
          queryParameters: uri.queryParameters.isEmpty ? null : uri.queryParameters,
        ).toString();
      }

      // 나머지는 host/path를 앱 경로로 그대로 매핑
      final mappedPath = '/$host$path';
      return Uri(
        path: mappedPath,
        queryParameters: uri.queryParameters.isEmpty ? null : uri.queryParameters,
        fragment: uri.fragment.isEmpty ? null : uri.fragment,
      ).toString();
    }

    // 2) universal/app links: https://hyotalk.silveredu.net/invite?... -> /invite?...
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      var path = uri.path.isEmpty ? '/' : uri.path;

      // 웹 초대 링크 호환: /invitemsg, /invite -> 앱 내부 라우트(/simple-register)로 매핑
      if (path == '/invitemsg' || path == '/invite') {
        path = AppRouterPath.simpleRegister;
      }

      return Uri(
        path: path,
        queryParameters: uri.queryParameters.isEmpty ? null : uri.queryParameters,
        fragment: uri.fragment.isEmpty ? null : uri.fragment,
      ).toString();
    }

    // 3) 그 외는 처리하지 않음
    return null;
  }
}
