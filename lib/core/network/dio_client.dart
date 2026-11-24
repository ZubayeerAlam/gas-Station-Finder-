import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Builds a configured [Dio] with timeouts, controlled retries and
/// secret-redacting debug logging.
Dio buildDio({
  required String baseUrl,
  Map<String, String> headers = const {},
  Duration connectTimeout = const Duration(seconds: 10),
  Duration receiveTimeout = const Duration(seconds: 15),
  int maxRetries = 2,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: const Duration(seconds: 10),
      headers: headers,
      responseType: ResponseType.json,
    ),
  );
  dio.interceptors.add(RetryInterceptor(dio: dio, maxRetries: maxRetries));
  if (kDebugMode) dio.interceptors.add(RedactingLogInterceptor());
  return dio;
}

/// Request-option flag: mark a non-GET request as safe to retry
/// (e.g. Places `searchNearby` POST, which has no side effects).
const kIdempotentExtra = 'idempotent';
const _attemptExtra = 'retry_attempt';

/// Retries transient failures (timeouts, connection errors, 429, 5xx) with
/// exponential backoff. Only GETs or requests flagged [kIdempotentExtra].
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 2,
    this.baseDelay = const Duration(milliseconds: 400),
    Future<void> Function(Duration)? delay,
  }) : _delay = delay ?? Future<void>.delayed;

  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;
  final Future<void> Function(Duration) _delay;

  static bool isRetryable(DioException e) {
    final options = e.requestOptions;
    final idempotent =
        options.method.toUpperCase() == 'GET' || options.extra[kIdempotentExtra] == true;
    if (!idempotent) return false;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.transformTimeout:
        return false;
      case DioExceptionType.badResponse:
        final s = e.response?.statusCode ?? 0;
        return s == 429 || s >= 500;
      case DioExceptionType.unknown:
        return e.error is SocketException;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
        return false;
    }
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final attempt = (err.requestOptions.extra[_attemptExtra] as int?) ?? 0;
    if (attempt >= maxRetries || !isRetryable(err)) {
      return handler.next(err);
    }
    await _delay(baseDelay * (1 << attempt));
    final options = err.requestOptions..extra[_attemptExtra] = attempt + 1;
    try {
      final response = await dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}

/// Debug-only logger that never prints headers, bodies or API keys.
class RedactingLogInterceptor extends Interceptor {
  final _started = <RequestOptions, Stopwatch>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _started[options] = Stopwatch()..start();
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _log(response.requestOptions, response.statusCode?.toString() ?? '-');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(err.requestOptions, 'ERR ${err.type.name} ${err.response?.statusCode ?? ''}');
    handler.next(err);
  }

  void _log(RequestOptions o, String status) {
    final ms = _started.remove(o)?.elapsedMilliseconds;
    debugPrint('[http] ${o.method} ${redactUri(o.uri)} → $status (${ms ?? '?'} ms)');
  }
}

/// Removes credential-like query parameters from a URI for logging.
String redactUri(Uri uri) {
  const sensitive = {'key', 'api_key', 'apikey', 'token', 'access_token'};
  if (uri.queryParameters.keys.every((k) => !sensitive.contains(k.toLowerCase()))) {
    return uri.toString();
  }
  final redacted = {
    for (final entry in uri.queryParameters.entries)
      entry.key: sensitive.contains(entry.key.toLowerCase()) ? 'REDACTED' : entry.value,
  };
  return uri.replace(queryParameters: redacted).toString();
}
