import 'package:flutter/material.dart';

/// Color palette for the application with Material Design 3 support
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary colors
  static const Color primaryLight = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF90CAF9);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onPrimaryDark = Color(0xFF0D47A1);

  // Secondary colors
  static const Color secondaryLight = Color(0xFF03DAC6);
  static const Color secondaryDark = Color(0xFF03DAC6);
  static const Color onSecondaryLight = Color(0xFF000000);
  static const Color onSecondaryDark = Color(0xFF000000);

  // Surface colors
  static const Color surfaceLight = Color(0xFFFFFBFE);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color onSurfaceLight = Color(0xFF1C1B1F);
  static const Color onSurfaceDark = Color(0xFFE6E1E5);

  // Background colors
  static const Color backgroundLight = Color(0xFFFFFBFE);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color onBackgroundLight = Color(0xFF1C1B1F);
  static const Color onBackgroundDark = Color(0xFFE6E1E5);

  // Error colors
  static const Color errorLight = Color(0xFFBA1A1A);
  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color onErrorDark = Color(0xFF690005);

  // Warning colors
  static const Color warningLight = Color(0xFFFF9800);
  static const Color warningDark = Color(0xFFFFB74D);
  static const Color onWarningLight = Color(0xFFFFFFFF);
  static const Color onWarningDark = Color(0xFF3E2723);

  // Success colors
  static const Color successLight = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF81C784);
  static const Color onSuccessLight = Color(0xFFFFFFFF);
  static const Color onSuccessDark = Color(0xFF1B5E20);

  // Info colors
  static const Color infoLight = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF64B5F6);
  static const Color onInfoLight = Color(0xFFFFFFFF);
  static const Color onInfoDark = Color(0xFF0D47A1);

  // Outline colors
  static const Color outlineLight = Color(0xFF79747E);
  static const Color outlineDark = Color(0xFF938F99);

  // Surface variant colors
  static const Color surfaceVariantLight = Color(0xFFE7E0EC);
  static const Color surfaceVariantDark = Color(0xFF49454F);
  static const Color onSurfaceVariantLight = Color(0xFF49454F);
  static const Color onSurfaceVariantDark = Color(0xFFCAC4D0);

  // Inverse colors
  static const Color inverseSurfaceLight = Color(0xFF313033);
  static const Color inverseSurfaceDark = Color(0xFFE6E1E5);
  static const Color onInverseSurfaceLight = Color(0xFFF4EFF4);
  static const Color onInverseSurfaceDark = Color(0xFF313033);
  static const Color inversePrimaryLight = Color(0xFF90CAF9);
  static const Color inversePrimaryDark = Color(0xFF1976D2);

  // Shadow and scrim
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  // Custom semantic colors
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  static const Color disabledLight = Color(0x61000000);
  static const Color disabledDark = Color(0x61FFFFFF);

  static const Color hintLight = Color(0x99000000);
  static const Color hintDark = Color(0x99FFFFFF);

  // Gradient colors
  static const List<Color> primaryGradientLight = [
    Color(0xFF1976D2),
    Color(0xFF1565C0),
  ];

  static const List<Color> primaryGradientDark = [
    Color(0xFF90CAF9),
    Color(0xFF64B5F6),
  ];

  static const List<Color> backgroundGradientLight = [
    Color(0xFFFFFBFE),
    Color(0xFFF5F5F5),
  ];

  static const List<Color> backgroundGradientDark = [
    Color(0xFF121212),
    Color(0xFF1E1E1E),
  ];

  // Status colors for different states
  static const Color onlineLight = Color(0xFF4CAF50);
  static const Color onlineDark = Color(0xFF81C784);

  static const Color offlineLight = Color(0xFF757575);
  static const Color offlineDark = Color(0xFFBDBDBD);

  static const Color pendingLight = Color(0xFFFF9800);
  static const Color pendingDark = Color(0xFFFFB74D);

  // Text colors with opacity
  static const Color highEmphasisLight = Color(0xDE000000);
  static const Color highEmphasisDark = Color(0xDEFFFFFF);

  static const Color mediumEmphasisLight = Color(0x99000000);
  static const Color mediumEmphasisDark = Color(0x99FFFFFF);

  static const Color lowEmphasisLight = Color(0x61000000);
  static const Color lowEmphasisDark = Color(0x61FFFFFF);

  // Utility methods
  static ColorScheme lightColorScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: onPrimaryLight,
      secondary: secondaryLight,
      onSecondary: onSecondaryLight,
      error: errorLight,
      onError: onErrorLight,
      surface: surfaceLight,
      onSurface: onSurfaceLight,
      background: backgroundLight,
      onBackground: onBackgroundLight,
      outline: outlineLight,
      surfaceVariant: surfaceVariantLight,
      onSurfaceVariant: onSurfaceVariantLight,
      inverseSurface: inverseSurfaceLight,
      onInverseSurface: onInverseSurfaceLight,
      inversePrimary: inversePrimaryLight,
      shadow: shadow,
      scrim: scrim,
    );
  }

  static ColorScheme darkColorScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: onPrimaryDark,
      secondary: secondaryDark,
      onSecondary: onSecondaryDark,
      error: errorDark,
      onError: onErrorDark,
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      background: backgroundDark,
      onBackground: onBackgroundDark,
      outline: outlineDark,
      surfaceVariant: surfaceVariantDark,
      onSurfaceVariant: onSurfaceVariantDark,
      inverseSurface: inverseSurfaceDark,
      onInverseSurface: onInverseSurfaceDark,
      inversePrimary: inversePrimaryDark,
      shadow: shadow,
      scrim: scrim,
    );
  }

  /// Get color based on current theme brightness
  static Color getColor(
      BuildContext context, Color lightColor, Color darkColor) {
    return Theme.of(context).brightness == Brightness.light
        ? lightColor
        : darkColor;
  }

  /// Get text color with emphasis
  static Color getTextColor(BuildContext context, {double emphasis = 1.0}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.white : Colors.black;
    return baseColor.withOpacity(emphasis);
  }
}
