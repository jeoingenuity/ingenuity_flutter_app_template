// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get counterAppBarTitle => 'Counter';

  @override
  String get appTitle => 'Ingenuity Flutter App';

  @override
  String get welcome => 'Welcome';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email address';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordNotImplemented =>
      'Forgot password feature coming soon';

  @override
  String get loginSubtitle => 'Sign in to access your account';

  @override
  String get loginFooter => 'Secure authentication powered by AWS Cognito';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign Up';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemMode => 'System';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get filipino => 'Filipino';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  @override
  String get retry => 'Retry';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get sessionExpired => 'Session expired. Please sign in again.';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get accountNotVerified =>
      'Please verify your account before signing in';

  @override
  String get serverError => 'Server error occurred. Please try again later.';

  @override
  String get unexpectedError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Invalid email format';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get verify => 'Verify';

  @override
  String get checkEmail => 'Check your email for the verification code';

  @override
  String get signUpSuccess => 'Sign up successful. Please verify your email.';

  @override
  String get signInSuccess => 'Sign in successful';

  @override
  String get signOutSuccess => 'Sign out successful';

  @override
  String get passwordResetSuccess => 'Password reset link sent to your email';

  @override
  String get updateAvailable => 'Update available';

  @override
  String get updateDownloading => 'Downloading update...';

  @override
  String get updateInstalling => 'Installing update...';

  @override
  String get updateComplete => 'Update complete';

  @override
  String get restartRequired => 'Restart required';
}
