import 'package:flutter/material.dart';

/// From: docs/ui_specifications/design_system/design_tokens.md

// Primary Brand Colors
class WorldChefColors {
  // Brand Blue - Headers, navigation bars, major CTAs
  static const Color brandBlue = Color(0xFF0288D1);
  static const Color brandBlueHover = Color(0xFF027ABC);
  static const Color brandBlueActive = Color(0xFF026DA7);
  static const Color brandBlueDisabled = Color(0x800288D1); // 50% opacity
  
  // Secondary Green - Background badges, success highlights
  static const Color secondaryGreen = Color(0xFF89C247);
  static const Color secondaryGreenHover = Color(0xFF7EB23F);
  static const Color secondaryGreenActive = Color(0xFF70A236);
  static const Color secondaryGreenDisabled = Color(0x8089C247);
  
  // Accent Coral - Primary CTA buttons (Order Now)
  static const Color accentCoral = Color(0xFFFF7247);
  static const Color accentCoralHover = Color(0xFFE6633F);
  static const Color accentCoralActive = Color(0xFFCC5639);
  static const Color accentCoralDisabled = Color(0x80FF7247);
  
  // Accent Orange - Secondary CTAs, promos, warning highlights
  static const Color accentOrange = Color(0xFFFFA000);
  static const Color accentOrangeHover = Color(0xFFE68F00);
  static const Color accentOrangeActive = Color(0xFFCC7A00);
  static const Color accentOrangeDisabled = Color(0x80FFA000);
}

// Semantic Colors
class WorldChefSemanticColors {
  // Success - Success messages, confirmation badges
  static const Color success = Color(0xFF89C247);
  static const Color successHover = Color(0xFF7EB23F);
  static const Color successActive = Color(0xFF70A236);
  
  // Warning - Warnings, promotional banners
  static const Color warning = Color(0xFFFFA000);
  static const Color warningHover = Color(0xFFE68F00);
  static const Color warningActive = Color(0xFFCC7A00);
  
  // Error - Error states, critical alerts
  static const Color error = Color(0xFFD32F2F);
  static const Color errorHover = Color(0xFFC12C2C);
  static const Color errorActive = Color(0xFFA32828);
  
  // Info - Informational messages, tooltips
  static const Color info = Color(0xFF0288D1);
  static const Color infoHover = Color(0xFF027ABC);
  static const Color infoActive = Color(0xFF026DA7);
}

// Neutrals & Text
class WorldChefNeutrals {
  // Background
  static const Color background = Color(0xFFFAFAFA);
  
  // Text Colors
  static const Color primaryText = Color(0xFF212121);
  static const Color secondaryText = Color(0xFF757575);
  
  // UI Elements
  static const Color dividers = Color(0xFFE0E0E0);
}

// Dark Theme Colors
class WorldChefDarkTheme {
  // Background & Surface
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);

  // Text Colors
  static const Color primaryText = Color(0xFFE0E0E0);
  static const Color secondaryText = Color(0xFFB0B0B0);

  // UI Elements
  static const Color dividers = Color(0xFF2C2C2C);
}

// Dark Semantic Colors
class WorldChefDarkSemanticColors {
  // Success
  static const Color success = Color(0xFF81C784);
  static const Color successHover = Color(0xFF73B97B);
  static const Color successActive = Color(0xFF66A972);

  // Warning
  static const Color warning = Color(0xFFFFB300);
  static const Color warningHover = Color(0xFFE6A000);
  static const Color warningActive = Color(0xFFCC8F00);

  // Error
  static const Color error = Color(0xFFEF5350);
  static const Color errorHover = Color(0xFFE14A4A);
  static const Color errorActive = Color(0xFFC23E3E);

  // Info
  static const Color info = Color(0xFF64B5F6);
  static const Color infoHover = Color(0xFF5AA4D7);
  static const Color infoActive = Color(0xFF4F93B8);
}

// Material Design 3 Theme Integration
ColorScheme get lightColorScheme => const ColorScheme.light(
    primary: WorldChefColors.brandBlue,
    onPrimary: Colors.white,
    secondary: WorldChefColors.secondaryGreen,
    onSecondary: Colors.white,
    tertiary: WorldChefColors.accentCoral,
    onTertiary: Colors.white,
    error: WorldChefSemanticColors.error,
    onError: Colors.white,
    background: WorldChefNeutrals.background,
    onBackground: WorldChefNeutrals.primaryText,
    surface: Colors.white,
    onSurface: WorldChefNeutrals.primaryText,
    outline: WorldChefNeutrals.dividers,
  );

// A dark scheme can be defined here as well, for now we focus on light
ColorScheme get darkColorScheme => const ColorScheme.dark(
    primary: WorldChefColors.brandBlue,
    onPrimary: Colors.white,
    secondary: WorldChefColors.secondaryGreen,
    onSecondary: Colors.white,
    tertiary: WorldChefColors.accentCoral,
    onTertiary: Colors.white,
    error: WorldChefDarkSemanticColors.error,
    onError: Colors.black,
    background: WorldChefDarkTheme.background,
    onBackground: WorldChefDarkTheme.primaryText,
    surface: WorldChefDarkTheme.surface,
    onSurface: WorldChefDarkTheme.primaryText,
    outline: WorldChefDarkTheme.dividers,
  ); 