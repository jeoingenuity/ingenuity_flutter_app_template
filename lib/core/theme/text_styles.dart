import 'package:flutter/material.dart';

/// Typography system based on Material Design 3
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Font family
  static const String fontFamily = 'Roboto';

  // Display styles - Large, attention-grabbing text
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.12,
    letterSpacing: -0.25,
    fontFamily: fontFamily,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.16,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.22,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );

  // Headline styles - High-emphasis text
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.25,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.29,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );

  // Title styles - Medium-emphasis text
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.27,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.50,
    letterSpacing: 0.15,
    fontFamily: fontFamily,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    fontFamily: fontFamily,
  );

  // Label styles - Small text for buttons, tabs, etc.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    fontFamily: fontFamily,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
    fontFamily: fontFamily,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.5,
    fontFamily: fontFamily,
  );

  // Body styles - Regular text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0.15,
    fontFamily: fontFamily,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    fontFamily: fontFamily,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    fontFamily: fontFamily,
  );

  // Custom semantic styles
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    fontFamily: fontFamily,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    fontFamily: fontFamily,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 1.5,
    fontFamily: fontFamily,
  );

  // Input field styles
  static const TextStyle inputLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0.15,
    fontFamily: fontFamily,
  );

  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0.15,
    fontFamily: fontFamily,
  );

  static const TextStyle inputHint = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0.15,
    fontFamily: fontFamily,
  );

  static const TextStyle inputError = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    fontFamily: fontFamily,
  );

  // Navigation styles
  static const TextStyle navigationLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
    fontFamily: fontFamily,
  );

  static const TextStyle tabLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    fontFamily: fontFamily,
  );

  // App bar styles
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.27,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );

  static const TextStyle appBarSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    fontFamily: fontFamily,
  );

  // Dialog styles
  static const TextStyle dialogTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );

  static const TextStyle dialogContent = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0.15,
    fontFamily: fontFamily,
  );

  // Card styles
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.50,
    letterSpacing: 0.15,
    fontFamily: fontFamily,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    fontFamily: fontFamily,
  );

  // List tile styles
  static const TextStyle listTileTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.50,
    letterSpacing: 0.15,
    fontFamily: fontFamily,
  );

  static const TextStyle listTileSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    fontFamily: fontFamily,
  );

  // Utility methods
  static TextTheme lightTextTheme() {
    return const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }

  static TextTheme darkTextTheme() {
    return lightTextTheme();
  }

  /// Apply color to text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply emphasis to text style (opacity)
  static TextStyle withEmphasis(TextStyle style, double emphasis) {
    return style.copyWith(color: style.color?.withOpacity(emphasis));
  }

  /// Apply weight to text style
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Apply size to text style
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}
