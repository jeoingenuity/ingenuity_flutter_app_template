import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Core services
import '../services/amplify_service.dart';
import '../services/auth_service.dart';
import '../services/shorebird_service.dart';
import '../utils/logger.dart';

// Feature dependencies
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// TODO: Import feature dependencies when they are created
// import '../../features/auth/domain/repositories/auth_repository.dart';
// import '../../features/auth/domain/usecases/sign_in_usecase.dart';
// import '../../features/auth/presentation/bloc/auth_bloc.dart';

/// Dependency injection container using GetIt
final GetIt getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  AppLogger.info('Initializing dependencies...', tag: 'DI');

  // Register core utilities
  _registerCoreUtilities();

  // Register external services
  _registerExternalServices();

  // Register core services
  await _registerCoreServices();

  // Register feature dependencies
  _registerAuthFeature();

  // TODO: Register feature dependencies
  // _registerAuthFeature();
  // _registerHomeFeature();

  AppLogger.info('Dependencies initialized successfully', tag: 'DI');
}

/// Register core utilities (Logger, Storage, etc.)
void _registerCoreUtilities() {
  // Secure storage
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  );

  // HTTP client with interceptors
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    
    // Add logging interceptor in debug mode
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) {
          AppLogger.api(object.toString());
        },
      ),
    );

    // Add common headers
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Set timeouts
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);

    return dio;
  });
}

/// Register external services (Third-party APIs, etc.)
void _registerExternalServices() {
  // TODO: Register external API clients, analytics, etc.
  // Example:
  // getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  // getIt.registerLazySingleton<CrashReportingService>(() => CrashReportingService());
}

/// Register core application services
Future<void> _registerCoreServices() async {
  // Amplify service
  getIt.registerLazySingleton<AmplifyService>(() => AmplifyService());

  // Auth service (depends on Amplify)
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<AmplifyService>()),
  );

  // Shorebird service
  getIt.registerLazySingleton<ShorebirdService>(() => ShorebirdService());

  // Initialize core services
  await _initializeCoreServices();
}

/// Initialize core services that require async setup
Future<void> _initializeCoreServices() async {
  try {
    // Initialize Amplify first
    final amplifyService = getIt<AmplifyService>();
    final amplifyResult = await amplifyService.initialize();
    if (amplifyResult.isFailure) {
      AppLogger.error(
        'Amplify initialization failed: ${amplifyResult.failure?.message}',
        tag: 'DI',
      );
      // Don't proceed with auth initialization if Amplify fails
      return;
    }

    // Initialize Auth only if Amplify succeeded
    final authService = getIt<AuthService>();
    final authResult = await authService.initialize();
    if (authResult.isFailure) {
      AppLogger.warning(
        'Auth initialization failed: ${authResult.failure?.message}',
        tag: 'DI',
      );
    }

    // Initialize Shorebird (independent of Amplify/Auth)
    final shorebirdService = getIt<ShorebirdService>();
    final shorebirdResult = await shorebirdService.initialize();
    if (shorebirdResult.isFailure) {
      AppLogger.warning(
        'Shorebird initialization failed: ${shorebirdResult.failure?.message}',
        tag: 'DI',
      );
    }
  } catch (e, stackTrace) {
    AppLogger.error(
      'Error during service initialization: $e',
      tag: 'DI',
      error: e,
      stackTrace: stackTrace,
    );
  }
}

/// Register auth feature dependencies
void _registerAuthFeature() {
  // Blocs (as factories since they should be created new each time)
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      authService: getIt<AuthService>(),
    ),
  );
}

/// TODO: Register auth feature dependencies
/*
void _registerAuthFeature() {
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dio: getIt<Dio>(),
      secureStorage: getIt<FlutterSecureStorage>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      authService: getIt<AuthService>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(repository: getIt<AuthRepository>()),
  );

  // Blocs (as factories since they should be created new each time)
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      signInUseCase: getIt<SignInUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    ),
  );
}
*/

/// TODO: Register home feature dependencies
/*
void _registerHomeFeature() {
  // Similar pattern for home feature
  // Register data sources, repositories, use cases, and blocs
}
*/

/// Clean up all dependencies (useful for testing)
Future<void> cleanupDependencies() async {
  AppLogger.info('Cleaning up dependencies...', tag: 'DI');
  
  await getIt.reset();
  
  AppLogger.info('Dependencies cleaned up', tag: 'DI');
}

/// Get a dependency from the container
T getDependency<T extends Object>() {
  return getIt<T>();
}

/// Check if a dependency is registered
bool isDependencyRegistered<T extends Object>() {
  return getIt.isRegistered<T>();
}

/// Reset a specific dependency (useful for testing)
Future<void> resetDependency<T extends Object>() async {
  if (getIt.isRegistered<T>()) {
    await getIt.unregister<T>();
  }
}

/// Register a test dependency (useful for testing)
void registerTestDependency<T extends Object>(T instance) {
  if (getIt.isRegistered<T>()) {
    getIt.unregister<T>();
  }
  getIt.registerSingleton<T>(instance);
}

/// Dependency injection helper extension
extension DIExtension on Object {
  /// Get a dependency from the container
  T getDep<T extends Object>() => getDependency<T>();
}
