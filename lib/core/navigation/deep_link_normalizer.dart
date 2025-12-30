import 'package:flutter_hyotalk_app/router/app_router_path.dart';

/// 외부 링크(딥링크/푸시 페이로드 등)를 앱 내부 라우트 location(`/...`)로 정규화한다.
///
/// - 입력은 `hyotalk://...`, `https://...`, 또는 `/work-diary/1` 같은 내부 경로일 수도 있다.
/// - 출력은 항상 go_router에 바로 넘길 수 있는 내부 location 문자열을 목표로 한다.
class DeepLinkNormalizer {
  DeepLinkNormalizer._();

  /// raw 문자열을 정규화한다.
  ///
  /// - `/...`로 시작하면 내부 경로로 보고 그대로 반환한다.
  /// - 그 외는 `Uri.parse` 후 [normalize]로 처리한다.
  static String? normalizeString(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    // 이미 앱 내부 라우트로 온 경우(푸시 payload에서 흔함)
    if (trimmed.startsWith('/')) return trimmed;

    try {
      return normalize(Uri.parse(trimmed));
    } catch (_) {
      return null;
    }
  }

  /// Uri를 앱 내부 라우트 location(`/...`)로 정규화한다.
  static String? normalize(Uri uri) {
    // hyotalk://invitemsg?id=... , hyotalk://work-diary/1 ...
    if (uri.scheme == 'hyotalk') {
      final host = uri.host;
      final path = uri.path;

      // 초대 메시지: hyotalk://invitemsg?id=... -> /inviteRegister?id=...
      if (host == 'invitemsg' || host == 'invite') {
        return Uri(
          path: AppRouterPath.inviteRegister,
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

    // universal/app links: https://hyotalk.silveredu.net/invite?... -> /inviteRegister?...
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      var path = uri.path.isEmpty ? '/' : uri.path;

      // 웹 초대 링크 호환: /invitemsg, /invite -> 앱 내부 라우트로 매핑
      if (path == '/invitemsg' || path == '/invite') {
        path = AppRouterPath.inviteRegister;
      }

      return Uri(
        path: path,
        queryParameters: uri.queryParameters.isEmpty ? null : uri.queryParameters,
        fragment: uri.fragment.isEmpty ? null : uri.fragment,
      ).toString();
    }

    // 그 외는 처리하지 않음
    return null;
  }
}


