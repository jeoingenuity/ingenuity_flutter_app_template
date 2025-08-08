import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/utils/logger.dart';
import '../core/services/auth_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthStatusChanged extends AuthEvent {
  final AuthStatus status;

  const AuthStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  final String? code;

  const AuthError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const String _tag = 'AUTH_BLOC';
  final AuthService _authService;

  AuthBloc({
    required AuthService authService,
  })  : _authService = authService,
        super(const AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);
  }

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      AppLogger.info('Checking auth status...', tag: _tag);
      emit(const AuthLoading());

      final currentUser = _authService.currentUser;
      final status = _authService.status;

      AppLogger.debug('Auth status: $status', tag: _tag);

      switch (status) {
        case AuthStatus.authenticated:
          if (currentUser != null) {
            emit(AuthAuthenticated(currentUser));
          } else {
            emit(const AuthUnauthenticated());
          }
          break;
        case AuthStatus.unauthenticated:
          emit(const AuthUnauthenticated());
          break;
        default:
          emit(const AuthUnauthenticated());
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error checking auth status: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      emit(AuthError(message: 'Failed to check authentication status'));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      AppLogger.info('Login requested for: ${event.email}', tag: _tag);
      emit(const AuthLoading());

      final result = await _authService.signIn(
        email: event.email,
        password: event.password,
      );

      if (result.isSuccess && result.data != null) {
        AppLogger.info('Login successful', tag: _tag);
        emit(AuthAuthenticated(result.data!));
      } else {
        final failure = result.failure;
        AppLogger.warning('Login failed: ${failure?.message}', tag: _tag);
        emit(AuthError(
          message: failure?.message ?? 'Login failed',
          code: failure?.code,
        ));
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error during login: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      emit(const AuthError(
          message: 'An unexpected error occurred during login'));
    }
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      AppLogger.info('Sign up requested for: ${event.email}', tag: _tag);
      emit(const AuthLoading());

      final result = await _authService.signUp(
        email: event.email,
        password: event.password,
        userAttributes: {'name': event.name},
      );

      if (result.isSuccess) {
        AppLogger.info('Sign up successful', tag: _tag);
        emit(const AuthUnauthenticated()); // User needs to verify email
      } else {
        final failure = result.failure;
        AppLogger.warning('Sign up failed: ${failure?.message}', tag: _tag);
        emit(AuthError(
          message: failure?.message ?? 'Sign up failed',
          code: failure?.code,
        ));
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error during sign up: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      emit(const AuthError(
          message: 'An unexpected error occurred during sign up'));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      AppLogger.info('Logout requested', tag: _tag);
      emit(const AuthLoading());

      final result = await _authService.signOut();

      if (result.isSuccess) {
        AppLogger.info('Logout successful', tag: _tag);
        emit(const AuthUnauthenticated());
      } else {
        final failure = result.failure;
        AppLogger.warning('Logout failed: ${failure?.message}', tag: _tag);
        emit(AuthError(
          message: failure?.message ?? 'Logout failed',
          code: failure?.code,
        ));
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error during logout: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      emit(const AuthError(
          message: 'An unexpected error occurred during logout'));
    }
  }

  Future<void> _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.debug('Auth status changed: ${event.status}', tag: _tag);

    switch (event.status) {
      case AuthStatus.authenticated:
        final currentUser = _authService.currentUser;
        if (currentUser != null) {
          emit(AuthAuthenticated(currentUser));
        } else {
          emit(const AuthUnauthenticated());
        }
        break;
      case AuthStatus.unauthenticated:
        emit(const AuthUnauthenticated());
        break;
      default:
        emit(const AuthUnauthenticated());
    }
  }
}
