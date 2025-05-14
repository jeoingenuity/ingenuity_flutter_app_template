import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'auth_service.dart';

class AWSAuthService implements AuthService {
  AWSAuthService() {
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      final authPlugin = AmplifyAuthCognito();
      await Amplify.addPlugin(authPlugin);
      await Amplify.configure('amplifyconfiguration');
    } catch (e) {
      print('Error configuring Amplify: $e');
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    try {
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
      );
      print('Sign up result: ${result.isSignUpComplete}');
    } catch (e) {
      print('Error signing up: $e');
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      print('Sign in result: ${result.isSignedIn}');
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      print('Signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      return session.isSignedIn;
    } catch (e) {
      print('Error fetching auth session: $e');
      return false;
    }
  }
}