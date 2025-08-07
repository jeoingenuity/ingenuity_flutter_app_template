import 'package:equatable/equatable.dart';
import 'failures.dart';

/// A generic class for representing the result of an operation
/// that can either succeed with data of type [T] or fail with a [Failure]
sealed class Result<T> extends Equatable {
  const Result();

  /// Creates a successful result
  const factory Result.success(T data) = Success<T>;

  /// Creates a failed result
  const factory Result.failure(Failure failure) = ResultFailure<T>;

  /// Returns true if the result is successful
  bool get isSuccess => this is Success<T>;

  /// Returns true if the result is a failure
  bool get isFailure => this is ResultFailure<T>;

  /// Gets the data if successful, otherwise returns null
  T? get data => switch (this) {
        Success(data: final data) => data,
        ResultFailure() => null,
      };

  /// Gets the failure if failed, otherwise returns null
  Failure? get failure => switch (this) {
        Success() => null,
        ResultFailure(failure: final failure) => failure,
      };

  /// Transforms the data if successful using the provided function
  Result<U> map<U>(U Function(T data) mapper) {
    return switch (this) {
      Success(data: final data) => Result.success(mapper(data)),
      ResultFailure(failure: final failure) => Result.failure(failure),
    };
  }

  /// Transforms the result using the provided function
  Result<U> flatMap<U>(Result<U> Function(T data) mapper) {
    return switch (this) {
      Success(data: final data) => mapper(data),
      ResultFailure(failure: final failure) => Result.failure(failure),
    };
  }

  /// Handles both success and failure cases
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) {
    return switch (this) {
      Success(data: final data) => onSuccess(data),
      ResultFailure(failure: final failure) => onFailure(failure),
    };
  }

  /// Executes the provided function if successful
  Result<T> onSuccess(void Function(T data) callback) {
    if (this is Success<T>) {
      callback((this as Success<T>).data);
    }
    return this;
  }

  /// Executes the provided function if failed
  Result<T> onFailure(void Function(Failure failure) callback) {
    if (this is ResultFailure<T>) {
      callback((this as ResultFailure<T>).failure);
    }
    return this;
  }

  /// Returns the data if successful, otherwise returns the provided default value
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success(data: final data) => data,
      ResultFailure() => defaultValue,
    };
  }

  /// Returns the data if successful, otherwise computes and returns a default value
  T getOrElseCompute(T Function() defaultValueComputer) {
    return switch (this) {
      Success(data: final data) => data,
      ResultFailure() => defaultValueComputer(),
    };
  }

  @override
  List<Object?> get props => switch (this) {
        Success(data: final data) => [data],
        ResultFailure(failure: final failure) => [failure],
      };
}

/// Represents a successful result
final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  String toString() => 'Success(data: $data)';
}

/// Represents a failed result
final class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);

  final Failure failure;

  @override
  String toString() => 'Failure(failure: $failure)';
}

/// Extension methods for Future<Result<T>>
extension FutureResultExtension<T> on Future<Result<T>> {
  /// Transforms the data if the future completes successfully
  Future<Result<U>> mapAsync<U>(Future<U> Function(T data) mapper) async {
    final result = await this;
    return switch (result) {
      Success(data: final data) => Result.success(await mapper(data)),
      ResultFailure(failure: final failure) => Result.failure(failure),
    };
  }

  /// Transforms the result using the provided async function
  Future<Result<U>> flatMapAsync<U>(
    Future<Result<U>> Function(T data) mapper,
  ) async {
    final result = await this;
    return switch (result) {
      Success(data: final data) => await mapper(data),
      ResultFailure(failure: final failure) => Result.failure(failure),
    };
  }

  /// Handles both success and failure cases asynchronously
  Future<R> foldAsync<R>(
    Future<R> Function(Failure failure) onFailure,
    Future<R> Function(T data) onSuccess,
  ) async {
    final result = await this;
    return switch (result) {
      Success(data: final data) => await onSuccess(data),
      ResultFailure(failure: final failure) => await onFailure(failure),
    };
  }
}

/// Utility functions for Result
class ResultUtils {
  /// Combines multiple results into a single result
  /// Returns success only if all results are successful
  static Result<List<T>> combine<T>(List<Result<T>> results) {
    final failures = <Failure>[];
    final successes = <T>[];

    for (final result in results) {
      switch (result) {
        case Success(data: final data):
          successes.add(data);
        case ResultFailure(failure: final failure):
          failures.add(failure);
      }
    }

    if (failures.isNotEmpty) {
      // Return the first failure or combine them
      return Result.failure(failures.first);
    }

    return Result.success(successes);
  }

  /// Catches exceptions and converts them to Result
  static Result<T> catching<T>(T Function() computation) {
    try {
      return Result.success(computation());
    } catch (e, stackTrace) {
      return Result.failure(
        UnknownFailure(
          message: e.toString(),
          details: {'error': e, 'stackTrace': stackTrace.toString()},
        ),
      );
    }
  }

  /// Catches async exceptions and converts them to Result
  static Future<Result<T>> catchingAsync<T>(
    Future<T> Function() computation,
  ) async {
    try {
      final result = await computation();
      return Result.success(result);
    } catch (e, stackTrace) {
      return Result.failure(
        UnknownFailure(
          message: e.toString(),
          details: {'error': e, 'stackTrace': stackTrace.toString()},
        ),
      );
    }
  }
}
