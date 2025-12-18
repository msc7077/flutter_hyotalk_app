import 'dart:math';

/// 실제 API 응답처럼 보이도록 만드는 mock 유틸
///
/// - requestId / serverTime 같은 메타를 포함
/// - 네트워크 지연 시뮬레이션
class MockApiEnvelope<T> {
  final int status;
  final bool success;
  final String message;
  final T data;
  final MockApiMeta meta;

  const MockApiEnvelope({
    required this.status,
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });
}

class MockApiMeta {
  final String requestId;
  final DateTime serverTime;
  final int latencyMs;

  const MockApiMeta({required this.requestId, required this.serverTime, required this.latencyMs});
}

class MockApi {
  MockApi._();

  static final Random _r = Random();

  static String requestId({String prefix = 'req'}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final n = _r.nextInt(999999);
    return '$prefix-$now-$n';
  }

  static Future<MockApiMeta> delay({
    int minMs = 250,
    int maxMs = 750,
    String prefix = 'req',
  }) async {
    final latency = minMs + _r.nextInt(max(1, maxMs - minMs + 1));
    await Future.delayed(Duration(milliseconds: latency));
    return MockApiMeta(
      requestId: requestId(prefix: prefix),
      serverTime: DateTime.now(),
      latencyMs: latency,
    );
  }
}
