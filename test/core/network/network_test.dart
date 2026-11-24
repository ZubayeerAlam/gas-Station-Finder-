import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/core/error/app_failure.dart';
import 'package:gas_station_finder/core/error/result.dart';
import 'package:gas_station_finder/core/network/dio_client.dart';
import 'package:gas_station_finder/core/network/failure_mapper.dart';

/// Scripted adapter: returns queued (status, body) pairs or throws.
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this.script);

  final List<Object> script; // int status | DioExceptionType
  int calls = 0;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final step = script[calls.clamp(0, script.length - 1)];
    calls++;
    if (step is DioExceptionType) {
      throw DioException(requestOptions: options, type: step);
    }
    return ResponseBody.fromString(
      jsonEncode({'ok': true}),
      step as int,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dio(_ScriptedAdapter adapter, {int maxRetries = 2}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
  dio.interceptors.add(RetryInterceptor(dio: dio, maxRetries: maxRetries, delay: (_) async {}));
  return dio;
}

void main() {
  group('RetryInterceptor', () {
    test('retries a GET on 503 and succeeds', () async {
      final adapter = _ScriptedAdapter([503, 503, 200]);
      final res = await _dio(adapter).get<dynamic>('/x');
      expect(res.statusCode, 200);
      expect(adapter.calls, 3);
    });

    test('gives up after maxRetries', () async {
      final adapter = _ScriptedAdapter([503]);
      await expectLater(_dio(adapter).get<dynamic>('/x'), throwsA(isA<DioException>()));
      expect(adapter.calls, 3); // 1 + 2 retries
    });

    test('retries connection timeouts', () async {
      final adapter = _ScriptedAdapter([DioExceptionType.connectionTimeout, 200]);
      final res = await _dio(adapter).get<dynamic>('/x');
      expect(res.statusCode, 200);
      expect(adapter.calls, 2);
    });

    test('does not retry 4xx', () async {
      final adapter = _ScriptedAdapter([400]);
      await expectLater(_dio(adapter).get<dynamic>('/x'), throwsA(isA<DioException>()));
      expect(adapter.calls, 1);
    });

    test('does not retry non-idempotent POST', () async {
      final adapter = _ScriptedAdapter([503, 200]);
      await expectLater(_dio(adapter).post<dynamic>('/x'), throwsA(isA<DioException>()));
      expect(adapter.calls, 1);
    });

    test('retries POST flagged idempotent', () async {
      final adapter = _ScriptedAdapter([503, 200]);
      final res = await _dio(adapter).post<dynamic>('/x', options: Options(extra: {kIdempotentExtra: true}));
      expect(res.statusCode, 200);
      expect(adapter.calls, 2);
    });
  });

  group('mapToFailure', () {
    final ro = RequestOptions(path: '/x');
    DioException bad(int status) => DioException(
          requestOptions: ro,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(requestOptions: ro, statusCode: status),
        );

    test('timeouts → TimeoutFailure', () {
      expect(mapToFailure(DioException(requestOptions: ro, type: DioExceptionType.receiveTimeout)),
          isA<TimeoutFailure>());
    });
    test('connection error / socket → NetworkFailure', () {
      expect(mapToFailure(DioException(requestOptions: ro, type: DioExceptionType.connectionError)),
          isA<NetworkFailure>());
      expect(mapToFailure(const SocketException('x')), isA<NetworkFailure>());
    });
    test('404 → NotFoundFailure, 403 → ServerFailure(403)', () {
      expect(mapToFailure(bad(404)), isA<NotFoundFailure>());
      final f = mapToFailure(bad(403));
      expect(f, isA<ServerFailure>());
      expect((f as ServerFailure).statusCode, 403);
    });
    test('parse errors → ServerFailure', () {
      expect(mapToFailure(const FormatException('bad')), isA<ServerFailure>());
    });
    test('AppFailure passes through unchanged', () {
      const f = NotFoundFailure('none');
      expect(mapToFailure(f), same(f));
    });
    test('guardResult wraps values and errors', () async {
      expect((await guardResult(() async => 1)).getOrThrow(), 1);
      final err = await guardResult<int>(() async => throw const FormatException());
      expect(err, isA<Err<int>>());
    });
  });

  test('redactUri hides key-like query params', () {
    final out = redactUri(Uri.parse('https://a.test/p?key=SECRET&q=1'));
    expect(out, isNot(contains('SECRET')));
    expect(out, contains('key=REDACTED'));
    expect(out, contains('q=1'));
  });
}
