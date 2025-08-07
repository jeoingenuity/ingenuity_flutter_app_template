import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/logger.dart';
import '../errors/result.dart';
import '../errors/failures.dart';
import 'amplify_service.dart';

/// Authentication states
enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  configuring,
}

/// User information model
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.isEmailVerified = false,
  });

  final String id;
  final String email;
  final String? name;
  final bool isEmailVerified;

  @override
  String toString() => 'AuthUser(id: $id, email: $email, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthUser &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.isEmailVerified == isEmailVerified;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ name.hashCode ^ isEmailVerified.hashCode;
  }
}

/// Authentication service using AWS Amplify Cognito
class AuthService {
  static const String _tag = LogTags.auth;
  static const _storage = FlutterSecureStorage();
  static const String _lastSignedInEmailKey = 'last_signed_in_email';

  final AmplifyService _amplifyService;
  
  AuthUser? _currentUser;
  AuthStatus _status = AuthStatus.unknown;

  AuthService(this._amplifyService);

  /// Current authentication status
  AuthStatus get status => _status;

  /// Current authenticated user
  AuthUser? get currentUser => _currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Initialize auth service and check current auth state
  Future<Result<AuthStatus>> initialize() async {
    try {
      AppLogger.info('Initializing Auth Service...', tag: _tag);
      
      // Ensure Amplify is configured
      final amplifyResult = await _amplifyService.ensureInitialized();
      if (amplifyResult.isFailure) {
        return Result.failure(amplifyResult.failure!);
      }

      _status = AuthStatus.configuring;
      
      // Check current auth session only if Amplify is properly configured
      if (_amplifyService.isConfigured) {
        final sessionResult = await getCurrentUser();
        if (sessionResult.isSuccess && sessionResult.data != null) {
          _currentUser = sessionResult.data;
          _status = AuthStatus.authenticated;
          AppLogger.info('User is authenticated: ${_currentUser?.email}', tag: _tag);
        } else {
          _status = AuthStatus.unauthenticated;
          AppLogger.info('User is not authenticated', tag: _tag);
        }
      } else {
        _status = AuthStatus.unauthenticated;
        AppLogger.warning('Amplify not fully configured, skipping auth check', tag: _tag);
      }

      return Result.success(_status);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize Auth Service: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      
      _status = AuthStatus.unknown;
      return Result.failure(
        AuthFailure(
          message: 'Failed to initialize authentication',
          code: 'AUTH_INIT_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Sign up a new user
  Future<Result<void>> signUp({
    required String email,
    required String password,
    Map<String, String>? userAttributes,
  }) async {
    try {
      AppLogger.info('Attempting to sign up user: $email', tag: _tag);

      final userAttributesMap = <AuthUserAttributeKey, String>{
        AuthUserAttributeKey.email: email,
      };
      
      // Add additional user attributes if provided
      if (userAttributes != null) {
        for (final entry in userAttributes.entries) {
          // Map common attribute names to AuthUserAttributeKey
          switch (entry.key.toLowerCase()) {
            case 'name':
            case 'given_name':
              userAttributesMap[AuthUserAttributeKey.givenName] = entry.value;
              break;
            case 'family_name':
              userAttributesMap[AuthUserAttributeKey.familyName] = entry.value;
              break;
            case 'phone_number':
              userAttributesMap[AuthUserAttributeKey.phoneNumber] = entry.value;
              break;
            // Add more attribute mappings as needed
          }
        }
      }

      final options = SignUpOptions(
        userAttributes: userAttributesMap,
      );

      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: options,
      );

      if (result.isSignUpComplete) {
        AppLogger.info('Sign up completed for: $email', tag: _tag);
      } else {
        AppLogger.info('Sign up requires confirmation for: $email', tag: _tag);
      }

      return const Result.success(null);
    } on AuthException catch (e) {
      AppLogger.error('Sign up failed: ${e.message}', tag: _tag, error: e);
      return Result.failure(_mapAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error during sign up: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        AuthFailure(
          message: 'Sign up failed due to unexpected error',
          code: 'SIGNUP_UNEXPECTED_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Confirm sign up with verification code
  Future<Result<void>> confirmSignUp({
    required String email,
    required String confirmationCode,
  }) async {
    try {
      AppLogger.info('Confirming sign up for: $email', tag: _tag);

      final result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );

      if (result.isSignUpComplete) {
        AppLogger.info('Sign up confirmed successfully for: $email', tag: _tag);
        return const Result.success(null);
      } else {
        AppLogger.warning('Sign up confirmation incomplete for: $email', tag: _tag);
        return Result.failure(
          const AuthFailure(
            message: 'Sign up confirmation is incomplete',
            code: 'CONFIRMATION_INCOMPLETE',
          ),
        );
      }
    } on AuthException catch (e) {
      AppLogger.error('Confirmation failed: ${e.message}', tag: _tag, error: e);
      return Result.failure(_mapAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error during confirmation: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        AuthFailure(
          message: 'Confirmation failed due to unexpected error',
          code: 'CONFIRMATION_UNEXPECTED_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Sign in user
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Attempting to sign in user: $email', tag: _tag);

      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        // Get user details
        final userResult = await getCurrentUser();
        if (userResult.isSuccess && userResult.data != null) {
          _currentUser = userResult.data;
          _status = AuthStatus.authenticated;
          
          // Store last signed in email
          await _storage.write(key: _lastSignedInEmailKey, value: email);
          
          AppLogger.info('Sign in successful for: $email', tag: _tag);
          return Result.success(_currentUser!);
        } else {
          return Result.failure(
            const AuthFailure(
              message: 'Failed to get user details after sign in',
              code: 'USER_DETAILS_ERROR',
            ),
          );
        }
      } else {
        AppLogger.warning('Sign in incomplete for: $email', tag: _tag);
        return Result.failure(
          const AuthFailure(
            message: 'Sign in is incomplete',
            code: 'SIGNIN_INCOMPLETE',
          ),
        );
      }
    } on AuthException catch (e) {
      AppLogger.error('Sign in failed: ${e.message}', tag: _tag, error: e);
      return Result.failure(_mapAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error during sign in: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        AuthFailure(
          message: 'Sign in failed due to unexpected error',
          code: 'SIGNIN_UNEXPECTED_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Sign out user
  Future<Result<void>> signOut() async {
    try {
      AppLogger.info('Signing out user: ${_currentUser?.email}', tag: _tag);

      await Amplify.Auth.signOut();
      
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
      
      AppLogger.info('Sign out successful', tag: _tag);
      return const Result.success(null);
    } on AuthException catch (e) {
      AppLogger.error('Sign out failed: ${e.message}', tag: _tag, error: e);
      return Result.failure(_mapAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error during sign out: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        AuthFailure(
          message: 'Sign out failed due to unexpected error',
          code: 'SIGNOUT_UNEXPECTED_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Get current user information
  Future<Result<AuthUser?>> getCurrentUser() async {
    try {
      // Check if Amplify is configured
      if (!Amplify.isConfigured) {
        AppLogger.warning('Amplify is not configured', tag: _tag);
        return const Result.success(null);
      }

      final authSession = await Amplify.Auth.fetchAuthSession();
      
      if (!authSession.isSignedIn) {
        return const Result.success(null);
      }

      final user = await Amplify.Auth.getCurrentUser();
      final userAttributes = await Amplify.Auth.fetchUserAttributes();
      
      String? email;
      String? name;
      bool isEmailVerified = false;

      for (final attribute in userAttributes) {
        switch (attribute.userAttributeKey) {
          case AuthUserAttributeKey.email:
            email = attribute.value;
            break;
          case AuthUserAttributeKey.name:
            name = attribute.value;
            break;
          case AuthUserAttributeKey.emailVerified:
            isEmailVerified = attribute.value.toLowerCase() == 'true';
            break;
        }
      }

      if (email == null) {
        return Result.failure(
          const AuthFailure(
            message: 'User email not found',
            code: 'USER_EMAIL_NOT_FOUND',
          ),
        );
      }

      final authUser = AuthUser(
        id: user.userId,
        email: email,
        name: name,
        isEmailVerified: isEmailVerified,
      );

      return Result.success(authUser);
    } on AuthException catch (e) {
      AppLogger.error('Get current user failed: ${e.message}', tag: _tag, error: e);
      return Result.failure(_mapAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error getting current user: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        AuthFailure(
          message: 'Failed to get current user',
          code: 'GET_USER_UNEXPECTED_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Reset password
  Future<Result<void>> resetPassword({required String email}) async {
    try {
      AppLogger.info('Requesting password reset for: $email', tag: _tag);

      await Amplify.Auth.resetPassword(username: email);
      
      AppLogger.info('Password reset initiated for: $email', tag: _tag);
      return const Result.success(null);
    } on AuthException catch (e) {
      AppLogger.error('Password reset failed: ${e.message}', tag: _tag, error: e);
      return Result.failure(_mapAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error during password reset: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        AuthFailure(
          message: 'Password reset failed due to unexpected error',
          code: 'RESET_PASSWORD_UNEXPECTED_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Confirm password reset with verification code
  Future<Result<void>> confirmResetPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  }) async {
    try {
      AppLogger.info('Confirming password reset for: $email', tag: _tag);

      await Amplify.Auth.confirmResetPassword(
        username: email,
        confirmationCode: confirmationCode,
        newPassword: newPassword,
      );
      
      AppLogger.info('Password reset confirmed for: $email', tag: _tag);
      return const Result.success(null);
    } on AuthException catch (e) {
      AppLogger.error('Password reset confirmation failed: ${e.message}', tag: _tag, error: e);
      return Result.failure(_mapAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error during password reset confirmation: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        AuthFailure(
          message: 'Password reset confirmation failed due to unexpected error',
          code: 'CONFIRM_RESET_PASSWORD_UNEXPECTED_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Get last signed in email
  Future<String?> getLastSignedInEmail() async {
    try {
      return await _storage.read(key: _lastSignedInEmailKey);
    } catch (e) {
      AppLogger.warning('Failed to get last signed in email: $e', tag: _tag);
      return null;
    }
  }

  /// Clear last signed in email
  Future<void> clearLastSignedInEmail() async {
    try {
      await _storage.delete(key: _lastSignedInEmailKey);
    } catch (e) {
      AppLogger.warning('Failed to clear last signed in email: $e', tag: _tag);
    }
  }

  /// Map Amplify Auth exceptions to domain failures
  AuthFailure _mapAuthException(AuthException exception) {
    final code = exception.underlyingException?.toString() ?? exception.runtimeType.toString();
    
    return AuthFailure(
      message: exception.message,
      code: code,
      details: {
        'recoverySuggestion': exception.recoverySuggestion,
        'underlyingException': exception.underlyingException?.toString(),
      },
    );
  }
}
