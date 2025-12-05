import 'package:dio/dio.dart';
import 'package:flutter_hyotalk_app/core/network/dio_factory.dart';
import 'package:flutter_hyotalk_app/core/service/app_preference_service.dart';

class AppInitializer {
  AppInitializer._internal();
  static final instance = AppInitializer._internal();

  late final Dio authDio;
  late final Dio homeDio;
  final prefs = AppPreferenceService.instance;

  Future<void> init() async {
    authDio = DioFactory.createAuthClient();
    homeDio = DioFactory.createHyotalkClient();
    await prefs.init();
  }
}
