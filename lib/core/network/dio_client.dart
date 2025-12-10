import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hyotalk_app/core/storage/app_secure_storage.dart';

/// HTTP 클라이언트(Dio)
///
/// 모든 HTTP 요청을 처리하는 클라이언트
class DioClient {
  DioClient._();

  /// Auth API
  ///
  /// @return Dio
  static Dio createAuthClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['SILVER_AUTH_API_URL']!,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _attachCommonInterceptors(dio);
    return dio;
  }

  /// Hyotalk API
  ///
  /// @return Dio
  static Dio createHyotalkClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['HYOTALK_API_URL']!,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _attachCommonInterceptors(dio);
    return dio;
  }

  static void _attachCommonInterceptors(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AppSecureStorage.instance.getString(
            AppSecureStorageKey.token,
          );
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          String errorMessage = '네트워크 연결에 실패했습니다. 잠시 후 다시 시도해주세요.';

          switch (e.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              errorMessage = '네트워크 응답이 지연되고 있습니다. 다시 시도해주세요.';
              break;
            case DioExceptionType.connectionError:
            case DioExceptionType.badCertificate:
              errorMessage = '서버에 연결할 수 없습니다. 인터넷 연결을 확인해주세요.';
              break;
            case DioExceptionType.unknown:
              if (e.error is SocketException) {
                errorMessage = '인터넷 연결을 확인한 후 다시 시도해주세요.';
              }
              break;
            default:
              errorMessage = '네트워크 통신 중 문제가 발생했습니다.';
          }

          e.requestOptions.extra['customErrorMessage'] = errorMessage;
          handler.next(e);
        },
      ),
    );
  }
}
