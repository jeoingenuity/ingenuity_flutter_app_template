import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  @override
  List<Object?> get props => [message, code, details];

  /// Convert failure to user-friendly message
  String get userMessage => message;

  @override
  String toString() =>
      'Failure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.details,
    this.statusCode,
  });

  final int? statusCode;

  @override
  List<Object?> get props => [...super.props, statusCode];

  @override
  String get userMessage {
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return 'Invalid request. Please check your input.';
        case 401:
          return 'You are not authorized. Please sign in again.';
        case 403:
          return 'Access denied. You don\'t have permission.';
        case 404:
          return 'The requested information was not found.';
        case 408:
          return 'Request timeout. Please try again.';
        case 500:
          return 'Server error. Please try again later.';
        case 502:
        case 503:
          return 'Service temporarily unavailable. Please try again later.';
        default:
          return 'Network error occurred. Please check your connection.';
      }
    }
    return message;
  }
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.details,
    this.isSessionExpired = false,
  });

  final bool isSessionExpired;

  @override
  List<Object?> get props => [...super.props, isSessionExpired];

  @override
  String get userMessage {
    if (isSessionExpired) {
      return 'Your session has expired. Please sign in again.';
    }

    switch (code) {
      case 'UserNotConfirmedException':
        return 'Please verify your account by clicking the link in your email.';
      case 'NotAuthorizedException':
        return 'Invalid email or password. Please try again.';
      case 'UserNotFoundException':
        return 'No account found with this email address.';
      case 'InvalidPasswordException':
        return 'Password must be at least 8 characters with uppercase, lowercase, and numbers.';
      case 'UsernameExistsException':
        return 'An account with this email already exists.';
      case 'LimitExceededException':
        return 'Too many attempts. Please try again later.';
      case 'TooManyRequestsException':
        return 'Too many requests. Please wait before trying again.';
      default:
        return message;
    }
  }
}

/// Validation-related failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.details,
    this.fieldErrors,
  });

  final Map<String, String>? fieldErrors;

  @override
  List<Object?> get props => [...super.props, fieldErrors];

  @override
  String get userMessage {
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      return fieldErrors!.values.first;
    }
    return message;
  }
}

/// Storage-related failures
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String get userMessage => 'Unable to save data. Please try again.';
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String get userMessage => 'Unable to load cached data.';
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.details,
    this.statusCode,
  });

  final int? statusCode;

  @override
  List<Object?> get props => [...super.props, statusCode];

  @override
  String get userMessage {
    switch (statusCode) {
      case 500:
        return 'Server error occurred. Please try again later.';
      case 502:
      case 503:
        return 'Service temporarily unavailable. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

/// Unknown/Unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred',
    super.code,
    super.details,
  });

  @override
  String get userMessage => 'Something unexpected happened. Please try again.';
}

/// Predefined common failures
class CommonFailures {
  static const noInternet = NetworkFailure(
    message: 'No internet connection available',
    code: 'NO_INTERNET',
  );

  static const timeout = NetworkFailure(
    message: 'Request timeout',
    code: 'TIMEOUT',
    statusCode: 408,
  );

  static const sessionExpired = AuthFailure(
    message: 'Session expired',
    code: 'SESSION_EXPIRED',
    isSessionExpired: true,
  );

  static const invalidCredentials = AuthFailure(
    message: 'Invalid credentials',
    code: 'INVALID_CREDENTIALS',
  );

  static const serverError = ServerFailure(
    message: 'Server error',
    code: 'SERVER_ERROR',
    statusCode: 500,
  );

  static const unknown = UnknownFailure();
}
