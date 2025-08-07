import 'app/app.dart';
import 'bootstrap.dart';
import 'core/di/injection_container.dart';
import 'core/utils/logger.dart' as app_logger;

void main() async {
  // Initialize logger first
  app_logger.AppLogger.initialize(
    minLogLevel: app_logger.LogLevel.verbose, // Verbose for development
    enableInAppViewer: true,
  );

  app_logger.AppLogger.info('Starting Ingenuity Flutter App (Development)');

  // Initialize dependencies
  await initializeDependencies();

  // Bootstrap the app
  bootstrap(() => const App());
}
