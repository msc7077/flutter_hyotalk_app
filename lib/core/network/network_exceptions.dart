class NetworkExceptions {
  static String getErrorMessage(dynamic error) {
    // 필요하면 DioError를 공통 메시지로 변환
    return error.toString();
  }
}
