import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';

/// From: docs/ui_specifications/design_system/design_tokens.md
/// Assembles the final ThemeData objects from the design tokens.

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: appTextTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: WorldChefLayout.primaryButtonPadding,
          minimumSize: const Size.fromHeight(AppDimensions.buttonLarge),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        margin: const EdgeInsets.all(AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
      ),
      appBarTheme: AppBarTheme(
        toolbarHeight: AppDimensions.appBarHeight,
        backgroundColor: WorldChefColors.brandBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    // Extending the dark theme with component themes
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: appTextTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: WorldChefLayout.primaryButtonPadding,
          minimumSize: const Size.fromHeight(AppDimensions.buttonLarge),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        margin: const EdgeInsets.all(AppSpacing.sm),
        color: WorldChefDarkTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
      ),
      appBarTheme: AppBarTheme(
        toolbarHeight: AppDimensions.appBarHeight,
        backgroundColor: WorldChefDarkTheme.surface,
        foregroundColor: WorldChefDarkTheme.primaryText,
        elevation: 0,
      ),
    );
  }
} 