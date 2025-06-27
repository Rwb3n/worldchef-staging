import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// From: docs/ui_specifications/design_system/design_tokens.md

// Font Families - Nunito (Unified)
class WorldChefFonts {
  // UI & Body - Clean, approachable for buttons, menus, ingredient lists
  static const String uiFont = 'Nunito';

  // Headlines - Use Nunito consistently for section titles
  static const String headlineFont = 'Nunito';
}

// Typography Scale
class WorldChefTextStyles {
  // Display (Headlines with Nunito)
  static final TextStyle displayLarge = GoogleFonts.nunito(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static final TextStyle displayMedium = GoogleFonts.nunito(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static final TextStyle displaySmall = GoogleFonts.nunito(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  // Headlines (Nunito for dish names, section titles)
  static final TextStyle headlineLarge = GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static final TextStyle headlineMedium = GoogleFonts.nunito(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static final TextStyle headlineSmall = GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  // Body (Nunito for UI, buttons, menus, ingredient lists)
  static final TextStyle bodyLarge = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle bodySmall = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Labels (Nunito for buttons, UI elements)
  static final TextStyle labelLarge = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.5, // +0.5px for uppercase UI labels
  );

  static final TextStyle labelMedium = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static final TextStyle labelSmall = GoogleFonts.nunito(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.5,
  );
}

// Create a TextTheme to be used in ThemeData
TextTheme get appTextTheme => TextTheme(
      displayLarge: WorldChefTextStyles.displayLarge,
      displayMedium: WorldChefTextStyles.displayMedium,
      displaySmall: WorldChefTextStyles.displaySmall,
      headlineLarge: WorldChefTextStyles.headlineLarge,
      headlineMedium: WorldChefTextStyles.headlineMedium,
      headlineSmall: WorldChefTextStyles.headlineSmall,
      bodyLarge: WorldChefTextStyles.bodyLarge,
      bodyMedium: WorldChefTextStyles.bodyMedium,
      bodySmall: WorldChefTextStyles.bodySmall,
      labelLarge: WorldChefTextStyles.labelLarge,
      labelMedium: WorldChefTextStyles.labelMedium,
      labelSmall: WorldChefTextStyles.labelSmall,
    );
