import 'package:flutter/material.dart';

/// From: docs/ui_specifications/design_system/design_tokens.md

// Spacing Scale (8px base unit)
class WorldChefSpacing {
  static const double baseUnit = 8.0;

  // Spacing Tokens
  static const double xs = 4.0; // 1/2 unit
  static const double sm = 8.0; // 1 unit
  static const double md = 16.0; // 2 units
  static const double lg = 24.0; // 3 units
  static const double xl = 32.0; // 4 units
  static const double xxl = 48.0; // 6 units
}

// Layout Spacing
class WorldChefLayout {
  // Container Padding
  static const EdgeInsets mobileContainerPadding =
      EdgeInsets.symmetric(horizontal: WorldChefSpacing.md); // 16px
  static const EdgeInsets tabletContainerPadding =
      EdgeInsets.symmetric(horizontal: WorldChefSpacing.lg); // 24px

  // Grid Gutters
  static const double tightGridGutter =
      WorldChefSpacing.sm; // 8px - category circles
  static const double standardGridGutter =
      WorldChefSpacing.md; // 16px - diet tiles
  static const double wideGridGutter =
      WorldChefSpacing.lg; // 24px - breathing room

  // Vertical Rhythm
  static const double headlineToGrid = WorldChefSpacing.lg; // 24px
  static const double gridToGrid = WorldChefSpacing.xl; // 32px

  // Card Padding
  static const EdgeInsets compactCardPadding =
      EdgeInsets.all(WorldChefSpacing.sm); // 8px
  static const EdgeInsets standardCardPadding =
      EdgeInsets.all(WorldChefSpacing.md); // 16px

  // Button Padding
  static const EdgeInsets primaryButtonPadding = EdgeInsets.symmetric(
    vertical: WorldChefSpacing.sm, // 8px
    horizontal: WorldChefSpacing.md, // 16px
  );
  static const EdgeInsets secondaryButtonPadding = EdgeInsets.symmetric(
    vertical: WorldChefSpacing.sm, // 8px
    horizontal: WorldChefSpacing.md, // 16px
  );

  // Icon Spacing
  static const double iconPadding =
      WorldChefSpacing.md; // 16px (24px icon → 48px container)
  static const double iconRowSpacing = WorldChefSpacing.sm; // 8px between icons
  static const double labelIconGap =
      WorldChefSpacing.sm; // 8px between label and icon
}
