import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/logger.dart';
import '../../l10n/arb/app_localizations.dart';
import '../../views/splash/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Add MultiBlocProvider when global blocs are implemented
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider<AuthBloc>(
    //       create: (context) => GetIt.instance<AuthBloc>(),
    //     ),
    //     BlocProvider<ThemeBloc>(
    //       create: (context) => GetIt.instance<ThemeBloc>(),
    //     ),
    //   ],
    //   child: const AppView(),
    // );

    return const AppView();
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      // Additional app initialization can go here
      AppLogger.info('App initialization completed', tag: 'APP');
    } catch (e, stackTrace) {
      AppLogger.error(
        'App initialization failed: $e',
        tag: 'APP',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    AppLogger.debug('App lifecycle state changed: $state', tag: 'APP');

    switch (state) {
      case AppLifecycleState.resumed:
        // App resumed from background
        _handleAppResume();
        break;
      case AppLifecycleState.paused:
        // App paused/minimized
        _handleAppPause();
        break;
      case AppLifecycleState.detached:
        // App is about to be destroyed
        _handleAppDetached();
        break;
      case AppLifecycleState.inactive:
        // App is inactive (transitioning)
        break;
      case AppLifecycleState.hidden:
        // App is hidden
        break;
    }
  }

  void _handleAppResume() {
    AppLogger.info('App resumed', tag: 'APP');
    // Check for updates, refresh auth state, etc.
  }

  void _handleAppPause() {
    AppLogger.info('App paused', tag: 'APP');
    // Save state, pause timers, etc.
  }

  void _handleAppDetached() {
    AppLogger.info('App detached', tag: 'APP');
    // Cleanup resources
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ingenuity Flutter App',

      // Theming
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // TODO: Make this configurable via Bloc

      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fil', ''),
      ],
      locale: null, // TODO: Make this configurable via Bloc

      // Disable debug banner in release mode
      debugShowCheckedModeBanner: false,

      // Builder for global error handling and overlays
      builder: (context, child) {
        return MediaQuery(
          // Disable text scaling to maintain consistent UI
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },

      // Navigation
      home: const SplashScreen(),

      // Global navigation key for programmatic navigation
      // navigatorKey: NavigationService.navigatorKey, // TODO: Implement navigation service

      // Route configuration
      // onGenerateRoute: AppRouter.onGenerateRoute, // TODO: Implement app router
      // onUnknownRoute: AppRouter.onUnknownRoute,

      // Performance optimization
      checkerboardRasterCacheImages: false,
      checkerboardOffscreenLayers: false,
      showPerformanceOverlay: false,
    );
  }
}
