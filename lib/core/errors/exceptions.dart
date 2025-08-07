import 'package:equatable/equatable.dart';

/// Base class for all application exceptions
abstract class AppException extends Equatable implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
    this.statusCode,
  });

  final int? statusCode;

  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.details,
    this.isSessionExpired = false,
  });

  final bool isSessionExpired;

  @override
  List<Object?> get props => [...super.props, isSessionExpired];
}

/// Validation-related exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
    this.fieldErrors,
  });

  final Map<String, String>? fieldErrors;

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

/// Storage-related exceptions
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.details,
    this.statusCode,
  });

  final int? statusCode;

  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// Unknown/Unexpected exceptions
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred',
    super.code,
    super.details,
    this.originalError,
    this.stackTrace,
  });

  final Object? originalError;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [...super.props, originalError, stackTrace];
}

/// Predefined common exceptions
class CommonExceptions {
  static const noInternet = NetworkException(
    message: 'No internet connection available',
    code: 'NO_INTERNET',
  );

  static const timeout = NetworkException(
    message: 'Request timeout',
    code: 'TIMEOUT',
  );

  static const sessionExpired = AuthException(
    message: 'Your session has expired. Please sign in again.',
    code: 'SESSION_EXPIRED',
    isSessionExpired: true,
  );

  static const invalidCredentials = AuthException(
    message: 'Invalid email or password',
    code: 'INVALID_CREDENTIALS',
  );

  static const accountNotVerified = AuthException(
    message: 'Please verify your account before signing in',
    code: 'ACCOUNT_NOT_VERIFIED',
  );

  static const serverError = ServerException(
    message: 'Server error occurred. Please try again later.',
    code: 'SERVER_ERROR',
    statusCode: 500,
  );

  static const notFound = ServerException(
    message: 'The requested resource was not found',
    code: 'NOT_FOUND',
    statusCode: 404,
  );

  static const unauthorized = ServerException(
    message: 'You are not authorized to perform this action',
    code: 'UNAUTHORIZED',
    statusCode: 401,
  );

  static const forbidden = ServerException(
    message: 'Access to this resource is forbidden',
    code: 'FORBIDDEN',
    statusCode: 403,
  );
}
