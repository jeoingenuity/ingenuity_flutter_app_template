import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ingenuity_flutter_app_template/amplifyconfiguration.dart';
import 'package:ingenuity_flutter_app_template/l10n/l10n.dart';
import 'package:ingenuity_flutter_app_template/presentation/counter/counter.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      if (!Amplify.isConfigured) {
        await Amplify.addPlugin(AmplifyAuthCognito());
        await Amplify.configure(amplifyconfig);
      }
      setState(() {
        _amplifyConfigured = true;
      });
      debugPrint('AWS Amplify configuration Success!');
    } catch (e) {
      // Handle error or show a message
      debugPrint('Amplify configuration failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_amplifyConfigured) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CounterPage(),
    );
  }
}
