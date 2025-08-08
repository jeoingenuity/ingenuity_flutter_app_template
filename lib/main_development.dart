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

  // Bootstrap the app (includes WidgetsFlutterBinding.ensureInitialized())
  await bootstrap(() async {
    // Initialize dependencies after Flutter binding is ready
    await initializeDependencies();
    
    return const App();
  });
}
