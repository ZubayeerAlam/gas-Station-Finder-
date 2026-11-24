import 'dart:io';

import 'package:dio/dio.dart';

import '../error/app_failure.dart';
import '../error/result.dart';

/// Maps any exception from the data layer into a typed [AppFailure].
AppFailure mapToFailure(Object error) {
  if (error is AppFailure) return error;
  if (error is DioException) return _fromDio(error);
  if (error is SocketException) return const NetworkFailure();
  if (error is FormatException || error is TypeError) {
    return const ServerFailure('Received an unexpected response from the server.');
  }
  return const UnknownFailure();
}

/// Runs [body] and converts thrown errors into [Err].
Future<Result<T>> guardResult<T>(Future<T> Function() body) async {
  try {
    return Ok(await body());
  } catch (e) {
    return Err(mapToFailure(e));
  }
}

AppFailure _fromDio(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return const NetworkFailure();
    case DioExceptionType.cancel:
      return const UnknownFailure('Request was cancelled.');
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      if (status == 404) return const NotFoundFailure();
      if (status == 401 || status == 403) {
        return ServerFailure(
          'The map service rejected the request. Check the API key and its restrictions.',
          statusCode: status,
        );
      }
      if (status == 429) {
        return ServerFailure('Too many requests. Please wait a moment.', statusCode: status);
      }
      return ServerFailure('Server error (${status ?? 'unknown'}). Please try again.', statusCode: status);
    case DioExceptionType.unknown:
      if (e.error is SocketException) return const NetworkFailure();
      return const UnknownFailure();
  }
}
