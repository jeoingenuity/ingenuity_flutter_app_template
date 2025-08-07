import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter/foundation.dart';

/// Custom log levels with color coding and filtering
enum LogLevel {
  verbose(0),
  debug(1),
  info(2),
  warning(3),
  error(4),
  critical(5);

  const LogLevel(this.value);
  final int value;
}

/// Logger tags for filtering and categorization
class LogTags {
  static const String auth = 'AUTH';
  static const String api = 'API';
  static const String ui = 'UI';
  static const String navigation = 'NAV';
  static const String storage = 'STORAGE';
  static const String amplify = 'AMPLIFY';
  static const String shorebird = 'SHOREBIRD';
  static const String bloc = 'BLOC';
  static const String error = 'ERROR';
  static const String performance = 'PERF';
}

/// Advanced logging system using Talker with custom formatting and filtering
class AppLogger {
  static late Talker _talker;
  static LogLevel _minLogLevel = kDebugMode ? LogLevel.verbose : LogLevel.info;

  /// Initialize the logging system
  static void initialize({
    LogLevel minLogLevel = LogLevel.info,
    bool enableInAppViewer = true,
  }) {
    _minLogLevel = minLogLevel;
    
    _talker = TalkerFlutter.init(
      settings: TalkerSettings(
        enabled: true,
        useConsoleLogs: kDebugMode,
        maxHistoryItems: 1000,
        useHistory: true,
      ),
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(
          enableColors: true,
          lineSymbol: '│',
        ),
      ),
    );

    // Add custom observers for different log types
    _talker.configure(
      settings: _talker.settings.copyWith(
        enabled: true,
        useConsoleLogs: kDebugMode,
      ),
    );
  }

  /// Get the Talker instance for advanced usage (like in-app viewer)
  static Talker get talker => _talker;

  /// Verbose logging for detailed debugging
  static void verbose(
    String message, {
    String tag = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_shouldLog(LogLevel.verbose)) {
      _log('VERBOSE', message, tag: tag, error: error, stackTrace: stackTrace);
    }
  }

  /// Debug logging for development information
  static void debug(
    String message, {
    String tag = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_shouldLog(LogLevel.debug)) {
      _log('DEBUG', message, tag: tag, error: error, stackTrace: stackTrace);
    }
  }

  /// Info logging for general information
  static void info(
    String message, {
    String tag = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_shouldLog(LogLevel.info)) {
      _log('INFO', message, tag: tag, error: error, stackTrace: stackTrace);
    }
  }

  /// Warning logging for potential issues
  static void warning(
    String message, {
    String tag = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_shouldLog(LogLevel.warning)) {
      _log('WARNING', message, tag: tag, error: error, stackTrace: stackTrace);
    }
  }

  /// Error logging for recoverable errors
  static void error(
    String message, {
    String tag = LogTags.error,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_shouldLog(LogLevel.error)) {
      _log('ERROR', message, tag: tag, error: error, stackTrace: stackTrace);
    }
  }

  /// Critical logging for unrecoverable errors
  static void critical(
    String message, {
    String tag = LogTags.error,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_shouldLog(LogLevel.critical)) {
      _log('CRITICAL', message, tag: tag, error: error, stackTrace: stackTrace);
    }
  }

  /// Log API requests and responses
  static void api(
    String message, {
    String? url,
    int? statusCode,
    String? method,
    Object? data,
  }) {
    if (_shouldLog(LogLevel.debug)) {
      final details = [
        if (method != null) 'Method: $method',
        if (url != null) 'URL: $url',
        if (statusCode != null) 'Status: $statusCode',
        if (data != null) 'Data: $data',
      ].join(' | ');
      
      _log('API', '$message${details.isNotEmpty ? ' - $details' : ''}', 
           tag: LogTags.api);
    }
  }

  /// Log authentication events
  static void auth(String message, {Object? error, StackTrace? stackTrace}) {
    info(message, tag: LogTags.auth, error: error, stackTrace: stackTrace);
  }

  /// Log navigation events
  static void navigation(String message) {
    debug(message, tag: LogTags.navigation);
  }

  /// Log bloc state changes
  static void bloc(String message, {String? blocName}) {
    debug('${blocName ?? 'Bloc'}: $message', tag: LogTags.bloc);
  }

  /// Log performance metrics
  static void performance(String message, {Duration? duration}) {
    final durationText = duration != null ? ' (${duration.inMilliseconds}ms)' : '';
    debug('$message$durationText', tag: LogTags.performance);
  }

  /// Private helper methods
  static bool _shouldLog(LogLevel level) {
    return level.value >= _minLogLevel.value;
  }

  static void _log(
    String level,
    String message, {
    String tag = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    final tagText = tag.isNotEmpty ? '[$tag] ' : '';
    final fullMessage = '$tagText$message';
    
    switch (level) {
      case 'VERBOSE':
        _talker.verbose(fullMessage);
        break;
      case 'DEBUG':
        _talker.debug(fullMessage);
        break;
      case 'INFO':
        _talker.info(fullMessage);
        break;
      case 'WARNING':
        _talker.warning(fullMessage);
        break;
      case 'ERROR':
        _talker.error(fullMessage, error, stackTrace);
        break;
      case 'CRITICAL':
        _talker.critical(fullMessage, error, stackTrace);
        break;
    }
  }

  /// Clear all logs
  static void clearLogs() {
    _talker.cleanHistory();
  }

  /// Get all logs
  static List<TalkerDataInterface> getAllLogs() {
    return _talker.history;
  }

  /// Filter logs by tag
  static List<TalkerDataInterface> getLogsByTag(String tag) {
    return _talker.history.where((log) {
      return log.message?.contains('[$tag]') ?? false;
    }).toList();
  }

  /// Set minimum log level
  static void setMinLogLevel(LogLevel level) {
    _minLogLevel = level;
  }
}

/// Extension for easy logging from any class
extension LoggerExtension on Object {
  void logVerbose(String message, [String tag = '']) {
    AppLogger.verbose(message, tag: tag);
  }

  void logDebug(String message, [String tag = '']) {
    AppLogger.debug(message, tag: tag);
  }

  void logInfo(String message, [String tag = '']) {
    AppLogger.info(message, tag: tag);
  }

  void logWarning(String message, [String tag = '']) {
    AppLogger.warning(message, tag: tag);
  }

  void logError(String message, {Object? error, StackTrace? stackTrace, String tag = ''}) {
    AppLogger.error(message, error: error, stackTrace: stackTrace, tag: tag);
  }
}
