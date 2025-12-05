import 'package:dio/dio.dart';

import 'network_exceptions.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<T> get<T>(String path) async {
    try {
      final response = await dio.get(path);
      return response.data as T;
    } catch (e) {
      throw NetworkExceptions.getErrorMessage(e);
    }
  }

  Future<T> post<T>(String path, dynamic data) async {
    try {
      final response = await dio.post(path, data: data);
      return response.data as T;
    } catch (e) {
      throw NetworkExceptions.getErrorMessage(e);
    }
  }
}
