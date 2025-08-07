import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/shorebird_service.dart';
import '../../core/utils/logger.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../counter/counter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      AppLogger.info('Initializing app services...', tag: 'SPLASH');

      // Wait for minimum splash duration
      await Future.delayed(const Duration(milliseconds: 1500));

      // Check for updates
      final shorebirdService = GetIt.instance<ShorebirdService>();
      final updateResult = await shorebirdService.checkForUpdates();

      if (updateResult.isSuccess &&
          updateResult.data?.isUpdateAvailable == true) {
        AppLogger.info('Update available, downloading...', tag: 'SPLASH');
        await shorebirdService.downloadUpdate();
      }

      // Check auth state
      final authService = GetIt.instance<AuthService>();
      final authResult = await authService.initialize();

      if (authResult.isSuccess) {
        AppLogger.info('Auth initialized: ${authResult.data}', tag: 'SPLASH');
      }

      // Navigate to appropriate screen
      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'App initialization failed: $e',
        tag: 'SPLASH',
        error: e,
        stackTrace: stackTrace,
      );

      if (mounted) {
        _navigateToNextScreen();
      }
    }
  }

  void _navigateToNextScreen() {
    final authService = GetIt.instance<AuthService>();

    Widget nextScreen;
    if (authService.isAuthenticated) {
      AppLogger.info('[SPLASH] User authenticated, navigating to counter',
          tag: 'SPLASH');
      nextScreen = const CounterPage();
    } else {
      AppLogger.info('[SPLASH] User not authenticated, navigating to login',
          tag: 'SPLASH');
      nextScreen = const LoginPage();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo animation
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: size.width * 0.3,
                        height: size.width * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.rocket_launch,
                          color: theme.colorScheme.onPrimary,
                          size: size.width * 0.15,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // App title
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Ingenuity',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              // Subtitle
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Flutter App Template',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              // Loading indicator
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Loading text
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Initializing...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
