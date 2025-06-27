library dimensions;

/// From: docs/ui_specifications/design_system/design_tokens.md

// Component Dimensions
class WorldChefDimensions {
  // Touch Targets
  static const double minimumTouchTarget = 44.0;
  static const double comfortableTouchTarget = 48.0;

  // Button Heights
  static const double buttonSmall = 32.0;
  static const double buttonMedium = 40.0;
  static const double buttonLarge = 48.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;

  // Container Heights
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 56.0;
  static const double cardMinHeight = 120.0;

  // System UI Spacers
  /// Fixed-height spacer equivalent to typical iOS safe-area top inset
  /// used in scrollable screens that intentionally overlay a colored
  /// background under the status bar. Extracted during pixel-perfect
  /// alignment (see plan_mobile_refinement_pixel_backend t003).
  static const double statusBarSpacer = 44.0;

  /// Breathing room at the bottom of long scroll views to allow the
  /// final item to clear the bottom navigation bar without being
  /// obscured. Value derived from design spec margin (100px).
  static const double bottomScrollSpacer = 100.0;

  // ----------------------------------------------------------------------------
  // Recipe Detail Screen Specific
  // ----------------------------------------------------------------------------
  /// Default expanded height for hero image (4:3) on 390×844 devices
  static const double recipeHeroHeight = 276.0;

  /// Gap between info chips (⏱ time • 🍽 servings)
  static const double recipeInfoChipGap = 26.0;

  /// Ingredient thumbnail square size
  static const double ingredientImageSize = 63.0;

  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
}
