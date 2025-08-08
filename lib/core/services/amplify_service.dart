import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/widgets.dart';
import '../../amplifyconfiguration.dart';
import '../utils/logger.dart';
import '../errors/result.dart';
import '../errors/failures.dart';

/// Service for managing AWS Amplify configuration and initialization
class AmplifyService {
  static const String _tag = LogTags.amplify;
  bool _isConfigured = false;

  /// Check if Amplify is configured
  bool get isConfigured => _isConfigured;

  /// Initialize Amplify with configuration
  Future<Result<void>> initialize({String? config}) async {
    try {
      AppLogger.info('Initializing AWS Amplify...', tag: _tag);

      // Ensure Flutter binding is initialized (should be done in bootstrap)
      try {
        WidgetsFlutterBinding.ensureInitialized();
        AppLogger.debug('Flutter binding ensured', tag: _tag);
      } catch (e) {
        AppLogger.warning(
          'Flutter binding issue: $e',
          tag: _tag,
        );
      }

      if (Amplify.isConfigured) {
        AppLogger.warning('Amplify is already configured', tag: _tag);
        _isConfigured = true;
        return const Result.success(null);
      }

      // Add Auth plugin
      await Amplify.addPlugin(AmplifyAuthCognito());
      AppLogger.debug('Added Auth Cognito plugin', tag: _tag);

      // Configure Amplify
      if (config != null) {
        await Amplify.configure(config);
      } else {
        // Use default amplify configuration
        AppLogger.debug('Using default amplify configuration', tag: _tag);
        await Amplify.configure(amplifyconfig);
      }

      _isConfigured = true;
      AppLogger.info('AWS Amplify initialized successfully', tag: _tag);

      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize Amplify: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );

      return Result.failure(
        ServerFailure(
          message: 'Failed to initialize AWS Amplify',
          code: 'AMPLIFY_INIT_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Reset Amplify configuration (useful for testing)
  Future<Result<void>> reset() async {
    try {
      AppLogger.info('Resetting Amplify configuration...', tag: _tag);

      // Note: Amplify doesn't provide a direct reset method
      // This is mainly for testing purposes
      _isConfigured = false;

      AppLogger.info('Amplify reset completed', tag: _tag);
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to reset Amplify: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );

      return Result.failure(
        ServerFailure(
          message: 'Failed to reset AWS Amplify',
          code: 'AMPLIFY_RESET_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Get current Amplify configuration status
  Map<String, dynamic> getStatus() {
    return {
      'isConfigured': _isConfigured,
      'isAmplifyConfigured': Amplify.isConfigured,
      'authPluginCount': Amplify.Auth.plugins.length,
    };
  }

  /// Ensure Amplify is initialized before operations
  Future<Result<void>> ensureInitialized() async {
    if (!_isConfigured || !Amplify.isConfigured) {
      AppLogger.warning(
        'Amplify not initialized, attempting to initialize...',
        tag: _tag,
      );
      return await initialize();
    }
    return const Result.success(null);
  }
}
