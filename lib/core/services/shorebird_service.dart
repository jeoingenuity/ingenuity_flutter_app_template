import 'package:shorebird_code_push/shorebird_code_push.dart';
import '../utils/logger.dart';
import '../errors/result.dart';
import '../errors/failures.dart';

/// Update status for the app
enum UpdateStatus {
  unknown,
  upToDate,
  updateAvailable,
  downloading,
  downloaded,
  installing,
  restartRequired,
  error,
}

/// Update information
class UpdateInfo {
  const UpdateInfo({
    required this.isUpdateAvailable,
    this.updateSize,
    this.description,
    this.version,
    this.isDownloaded = false,
  });

  final bool isUpdateAvailable;
  final int? updateSize;
  final String? description;
  final String? version;
  final bool isDownloaded;

  @override
  String toString() => 'UpdateInfo(available: $isUpdateAvailable, downloaded: $isDownloaded)';
}

/// Service for managing over-the-air updates using Shorebird
class ShorebirdService {
  static const String _tag = LogTags.shorebird;
  
  final ShorebirdCodePush _codePush = ShorebirdCodePush();
  UpdateStatus _status = UpdateStatus.unknown;
  UpdateInfo? _lastUpdateInfo;

  /// Current update status
  UpdateStatus get status => _status;

  /// Last update information
  UpdateInfo? get lastUpdateInfo => _lastUpdateInfo;

  /// Initialize Shorebird service
  Future<Result<void>> initialize() async {
    try {
      AppLogger.info('Initializing Shorebird service...', tag: _tag);
      
      // Check if code push is available
      final isAvailable = await _codePush.isNewPatchAvailableForDownload();
      
      if (isAvailable) {
        _status = UpdateStatus.updateAvailable;
        AppLogger.info('Update is available', tag: _tag);
      } else {
        _status = UpdateStatus.upToDate;
        AppLogger.info('App is up to date', tag: _tag);
      }
      
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize Shorebird: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      
      _status = UpdateStatus.error;
      return Result.failure(
        ServerFailure(
          message: 'Failed to initialize update service',
          code: 'SHOREBIRD_INIT_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Check for available updates
  Future<Result<UpdateInfo>> checkForUpdates() async {
    try {
      AppLogger.info('Checking for updates...', tag: _tag);
      
      final isAvailable = await _codePush.isNewPatchAvailableForDownload();
      
      final updateInfo = UpdateInfo(
        isUpdateAvailable: isAvailable,
        // Note: Shorebird doesn't provide size/description info directly
        // These would need to be managed separately if needed
      );
      
      _lastUpdateInfo = updateInfo;
      
      if (isAvailable) {
        _status = UpdateStatus.updateAvailable;
        AppLogger.info('Update is available', tag: _tag);
      } else {
        _status = UpdateStatus.upToDate;
        AppLogger.info('No updates available', tag: _tag);
      }
      
      return Result.success(updateInfo);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to check for updates: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      
      _status = UpdateStatus.error;
      return Result.failure(
        NetworkFailure(
          message: 'Failed to check for updates',
          code: 'UPDATE_CHECK_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Download available update
  Future<Result<void>> downloadUpdate() async {
    try {
      AppLogger.info('Downloading update...', tag: _tag);
      
      if (_status != UpdateStatus.updateAvailable) {
        return Result.failure(
          const ValidationFailure(
            message: 'No update available to download',
            code: 'NO_UPDATE_AVAILABLE',
          ),
        );
      }
      
      _status = UpdateStatus.downloading;
      
      // Download the patch
      await _codePush.downloadUpdateIfAvailable();
      
      // Check if patch was downloaded and ready to install
      final isReady = await _codePush.isNewPatchReadyToInstall();
      
      if (isReady) {
        _status = UpdateStatus.downloaded;
        _lastUpdateInfo = UpdateInfo(
          isUpdateAvailable: true,
          isDownloaded: true,
        );
        AppLogger.info('Update downloaded successfully', tag: _tag);
        return const Result.success(null);
      } else {
        _status = UpdateStatus.error;
        return Result.failure(
          const ServerFailure(
            message: 'Update download failed or incomplete',
            code: 'DOWNLOAD_INCOMPLETE',
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to download update: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      
      _status = UpdateStatus.error;
      return Result.failure(
        NetworkFailure(
          message: 'Failed to download update',
          code: 'UPDATE_DOWNLOAD_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Install downloaded update
  Future<Result<void>> installUpdate() async {
    try {
      AppLogger.info('Installing update...', tag: _tag);
      
      if (_status != UpdateStatus.downloaded) {
        return Result.failure(
          const ValidationFailure(
            message: 'No downloaded update available to install',
            code: 'NO_DOWNLOADED_UPDATE',
          ),
        );
      }
      
      _status = UpdateStatus.installing;
      
      // Check if patch is ready and can be installed
      final isReady = await _codePush.isNewPatchReadyToInstall();
      if (!isReady) {
        return Result.failure(
          const ValidationFailure(
            message: 'Update is not ready to install',
            code: 'UPDATE_NOT_READY',
          ),
        );
      }
      
      _status = UpdateStatus.restartRequired;
      AppLogger.info('Update is ready, restart required to apply', tag: _tag);
      
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to install update: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      
      _status = UpdateStatus.error;
      return Result.failure(
        ServerFailure(
          message: 'Failed to install update',
          code: 'UPDATE_INSTALL_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Check if a new patch is ready to install
  Future<Result<bool>> isUpdateReadyToInstall() async {
    try {
      final isReady = await _codePush.isNewPatchReadyToInstall();
      
      if (isReady && _status != UpdateStatus.downloaded) {
        _status = UpdateStatus.downloaded;
      }
      
      return Result.success(isReady);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to check if update is ready: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      
      return Result.failure(
        ServerFailure(
          message: 'Failed to check update status',
          code: 'UPDATE_STATUS_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Get current patch information
  Future<Result<Map<String, dynamic>>> getCurrentPatchInfo() async {
    try {
      // Note: Shorebird doesn't provide direct patch info methods
      // This would need to be implemented based on available APIs
      final info = {
        'status': _status.name,
        'lastUpdateInfo': _lastUpdateInfo?.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      return Result.success(info);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get patch info: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      
      return Result.failure(
        ServerFailure(
          message: 'Failed to get patch information',
          code: 'PATCH_INFO_ERROR',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Reset update status (useful for testing)
  void resetStatus() {
    _status = UpdateStatus.unknown;
    _lastUpdateInfo = null;
    AppLogger.info('Update status reset', tag: _tag);
  }
}
