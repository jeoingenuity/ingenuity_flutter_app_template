import 'package:ingenuity_flutter_app_template/app/app.dart';
import 'package:ingenuity_flutter_app_template/bootstrap.dart';
import 'package:ingenuity_flutter_app_template/core/di/injection_container.dart';
import 'package:ingenuity_flutter_app_template/core/utils/logger.dart' as app_logger;

void main() async {
  // Initialize logger first
  app_logger.AppLogger.initialize(
    minLogLevel: app_logger.LogLevel.warning, // Warning level for production
    enableInAppViewer: false,
  );

  app_logger.AppLogger.info('Starting Ingenuity Flutter App (Production)');

  // Bootstrap the app (includes WidgetsFlutterBinding.ensureInitialized())
  await bootstrap(() async {
    // Initialize dependencies after Flutter binding is ready
    await initializeDependencies();
    
    return const App();
  });
}
