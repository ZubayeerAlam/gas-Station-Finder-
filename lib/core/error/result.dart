import 'app_failure.dart';

/// Either-style result returned by repositories. UI-facing layers either
/// pattern-match on it or call [getOrThrow] inside Riverpod providers.
sealed class Result<T> {
  const Result();

  bool get isOk => this is Ok<T>;

  R when<R>({
    required R Function(T value) ok,
    required R Function(AppFailure failure) err,
  }) =>
      switch (this) {
        Ok<T>(:final value) => ok(value),
        Err<T>(:final failure) => err(failure),
      };

  T getOrThrow() => switch (this) {
        Ok<T>(:final value) => value,
        Err<T>(:final failure) => throw failure,
      };

  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Ok<T>(:final value) => Ok(transform(value)),
        Err<T>(:final failure) => Err(failure),
      };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final AppFailure failure;
}
