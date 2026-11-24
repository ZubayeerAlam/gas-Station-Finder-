/// Typed, user-presentable failures. Thrown into Riverpod `AsyncError`s and
/// carried by [Result]. Never contains secrets.
sealed class AppFailure implements Exception {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'No internet connection. Check your network and try again.']);
}

final class TimeoutFailure extends AppFailure {
  const TimeoutFailure([super.message = 'The server took too long to respond. Please try again.']);
}

final class ServerFailure extends AppFailure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = 'Nothing was found.']);
}

final class ConfigFailure extends AppFailure {
  const ConfigFailure(super.message);
}

enum LocationFailureReason { serviceDisabled, denied, deniedForever, unavailable }

final class LocationFailure extends AppFailure {
  const LocationFailure(this.reason, super.message);

  final LocationFailureReason reason;
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'Something went wrong. Please try again.']);
}
