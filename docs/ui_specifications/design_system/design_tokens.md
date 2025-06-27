# WorldChef Design Tokens Specification

**Status**: ✅ **SPECIFICATION COMPLETE**  
**Created**: 2025-06-24  
**Updated**: 2025-06-24 22:45:00Z  
**Plan Task**: t002 (IMPLEMENTATION)  
**Test Task**: t001 (TEST_CREATION - failing tests required first)  
**Global Event**: 129

---

## Overview

This document defines all design tokens for the WorldChef mobile application based on stakeholder input. These tokens eliminate all implicitness in design decisions and ensure consistency across the application.

## 🎯 **Stakeholder Input Resolved**

All clarifying questions from the UI planning have been answered through the provided design system files:
- ✅ Brand color palette defined
- ✅ Typography requirements specified  
- ✅ Image aspect ratios established
- ✅ Animation specifications provided
- ✅ Spacing requirements defined
- ✅ Error/loading/offline state visuals specified

## 1. Color System

### Primary Brand Colors
```dart
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
```

### Semantic Colors
```dart
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
```

### Neutrals & Text
```dart
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
```

### Dark Theme Colors
```dart
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
```

### Material Design 3 Role Mappings
```dart
// Material Design 3 Theme Integration
class WorldChefTheme {
  static ColorScheme get lightColorScheme => const ColorScheme.light(
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

  static ColorScheme get darkColorScheme => const ColorScheme.dark(
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
}
```

## 2. Typography System

### Font Families
```dart
// Font Families – Nunito (Unified)
class WorldChefFonts {
  // UI & Body - Clean, approachable for buttons, menus, ingredient lists
  static const String uiFont = 'Nunito';
  
  // Headlines - Consistent Nunito usage for headlines
  static const String headlineFont = 'Nunito';
  
  // Google Fonts Integration
  static const List<String> googleFontsLinks = [
    'https://fonts.googleapis.com/css2?family=Nunito:wght@400;700&display=swap',
  ];
  
  // Fallback Stacks
  static const String uiFontStack = 'Nunito, Poppins, sans-serif';
  static const String headlineFontStack = 'Nunito, Poppins, sans-serif';
}
```

### Typography Scale
```dart
// Typography Scale
class WorldChefTextStyles {
  // Display (Headlines with Lora)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: WorldChefFonts.headlineFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: WorldChefFonts.headlineFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontFamily: WorldChefFonts.headlineFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );
  
  // Headlines (Lora for dish names, section titles)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: WorldChefFonts.headlineFont,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: WorldChefFonts.headlineFont,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: WorldChefFonts.headlineFont,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );
  
  // Body (Nunito for UI, buttons, menus, ingredient lists)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: WorldChefFonts.uiFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: WorldChefFonts.uiFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: WorldChefFonts.uiFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  // Labels (Nunito for buttons, UI elements)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: WorldChefFonts.uiFont,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.5, // +0.5px for uppercase UI labels
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: WorldChefFonts.uiFont,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.5,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: WorldChefFonts.uiFont,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.5,
  );
}
```

## 3. Spacing System

### Base Unit & Scale
```dart
// Spacing Scale (8px base unit)
class WorldChefSpacing {
  static const double baseUnit = 8.0;
  
  // Spacing Tokens
  static const double xs = 4.0;   // 1/2 unit
  static const double sm = 8.0;   // 1 unit
  static const double md = 16.0;  // 2 units
  static const double lg = 24.0;  // 3 units
  static const double xl = 32.0;  // 4 units
  static const double xxl = 48.0; // 6 units
}
```

### Layout Spacing
```dart
// Layout Spacing
class WorldChefLayout {
  // Container Padding
  static const EdgeInsets mobileContainerPadding = EdgeInsets.symmetric(horizontal: WorldChefSpacing.md); // 16px
  static const EdgeInsets tabletContainerPadding = EdgeInsets.symmetric(horizontal: WorldChefSpacing.lg); // 24px
  
  // Grid Gutters
  static const double tightGridGutter = WorldChefSpacing.sm;     // 8px - category circles
  static const double standardGridGutter = WorldChefSpacing.md;  // 16px - diet tiles
  static const double wideGridGutter = WorldChefSpacing.lg;      // 24px - breathing room
  
  // Vertical Rhythm
  static const double headlineToGrid = WorldChefSpacing.lg;      // 24px
  static const double gridToGrid = WorldChefSpacing.xl;          // 32px
  
  // Card Padding
  static const EdgeInsets compactCardPadding = EdgeInsets.all(WorldChefSpacing.sm);     // 8px
  static const EdgeInsets standardCardPadding = EdgeInsets.all(WorldChefSpacing.md);    // 16px
  
  // Button Padding
  static const EdgeInsets primaryButtonPadding = EdgeInsets.symmetric(
    vertical: WorldChefSpacing.sm,   // 8px
    horizontal: WorldChefSpacing.md, // 16px
  );
  static const EdgeInsets secondaryButtonPadding = EdgeInsets.symmetric(
    vertical: 6.0,                   // 6px
    horizontal: 12.0,                // 12px
  );
  
  // Icon Spacing
  static const double iconPadding = WorldChefSpacing.md;        // 16px (24px icon → 48px container)
  static const double iconRowSpacing = WorldChefSpacing.sm;     // 8px between icons
  static const double labelIconGap = WorldChefSpacing.sm;       // 8px between label and icon
}
```

## 4. Component Dimensions

### Touch Targets & Heights
```dart
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
  
  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
}
```

## 5. Animation System

### Duration & Easing
```dart
// Animation System
class WorldChefAnimations {
  // Durations
  static const Duration fast = Duration(milliseconds: 100);     // Hover, press
  static const Duration medium = Duration(milliseconds: 200);   // Slide (drawers, menus)
  static const Duration slow = Duration(milliseconds: 300);     // Fade, page transitions
  static const Duration toast = Duration(milliseconds: 250);    // Toast/snackbar
  static const Duration shimmer = Duration(milliseconds: 1200); // Skeleton shimmer
  
  // Easing Curves
  static const Curve snapIn = Cubic(0.4, 0.0, 1.0, 1.0);      // Hover highlight, press down
  static const Curve snapOut = Cubic(0.0, 0.0, 0.2, 1.0);     // Press release, fade, toast
  static const Curve slide = Cubic(0.4, 0.0, 0.2, 1.0);       // Slide (drawers, menus, page transitions)
  static const Curve shimmerCurve = Curves.linear;             // Skeleton shimmer
  
  // Specific Animation Configurations
  static const AnimationConfig hoverHighlight = AnimationConfig(
    duration: fast,
    curve: snapIn,
  );
  
  static const AnimationConfig pressDown = AnimationConfig(
    duration: fast,
    curve: snapIn,
  );
  
  static const AnimationConfig pressRelease = AnimationConfig(
    duration: fast,
    curve: snapOut,
  );
  
  static const AnimationConfig fadeModal = AnimationConfig(
    duration: slow,
    curve: snapOut,
  );
  
  static const AnimationConfig slideDrawer = AnimationConfig(
    duration: medium,
    curve: slide,
  );
  
  static const AnimationConfig pageTransition = AnimationConfig(
    duration: slow,
    curve: slide,
  );
  
  static const AnimationConfig toastAnimation = AnimationConfig(
    duration: toast,
    curve: snapOut,
  );
}

// Animation Configuration Helper
class AnimationConfig {
  final Duration duration;
  final Curve curve;
  
  const AnimationConfig({
    required this.duration,
    required this.curve,
  });
}
```

## 6. Image & Media Specifications

### Aspect Ratios
```dart
// Image & Media Specifications
class WorldChefMedia {
  // Aspect Ratios
  static const double squareRatio = 1.0;      // 1:1 - Category circles, ingredient icons, nav icons
  static const double horizontalRatio = 4/3;  // 4:3 - Hero recipe cards (Protein muffins)
  static const double bannerRatio = 3/2;      // 3:2 - Recipe header banners (Jollof rice)
  static const double widescreenRatio = 16/9; // 16:9 - Diet grid tiles, video previews
  
  // Usage Guidelines
  static const Map<String, double> aspectRatioUsage = {
    'category_circles': squareRatio,
    'country_thumbnails': squareRatio,
    'ingredient_icons': squareRatio,
    'nav_icons': squareRatio,
    'donut_charts': squareRatio,
    'hero_recipe_cards': horizontalRatio,
    'recipe_header_banners': bannerRatio,
    'diet_grid_tiles': widescreenRatio,
    'video_previews': widescreenRatio,
  };
}
```

## 7. State-Specific Specifications

### Error States
```dart
// Error State Specifications
class WorldChefErrorStates {
  // Colors
  static const Color errorColor = WorldChefSemanticColors.error;
  static const Color errorBackground = Color(0xFFD32F2F);
  static const Color errorOnBackground = Colors.white;
  
  // Messaging Guidelines
  static const Map<String, String> errorMessages = {
    'network_error': "Oops! We couldn't load your recipes.",
    'generic_error': "We hit a snag",
    'form_error': "Please check the highlighted fields",
    'offline_error': "Cannot add to cart—no network.",
  };
  
  // Visual Specifications
  static const double errorBannerHeight = 48.0;
  static const EdgeInsets errorBannerPadding = EdgeInsets.symmetric(
    horizontal: WorldChefSpacing.md,
    vertical: WorldChefSpacing.sm,
  );
  
  // Button Styling
  static const ButtonStyle errorButtonStyle = ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(errorBackground),
    foregroundColor: MaterialStatePropertyAll(errorOnBackground),
  );
}
```

### Loading States
```dart
// Loading State Specifications
class WorldChefLoadingStates {
  // Skeleton Screen Colors
  static const Color skeletonBase = WorldChefNeutrals.background;
  static const Color skeletonHighlight = WorldChefNeutrals.dividers;
  
  // Spinner Specifications
  static const double spinnerSmall = 16.0;
  static const double spinnerMedium = 24.0;
  static const double spinnerLarge = 48.0;
  static const Color spinnerColor = WorldChefColors.brandBlue;
  
  // Overlay Specifications
  static const Color overlayColor = Color(0xB3FFFFFF); // rgba(255,255,255,0.7)
  
  // Animation
  static const Duration spinnerDuration = Duration(seconds: 1); // 60 rpm
  static const Duration shimmerDuration = WorldChefAnimations.shimmer;
}
```

### Offline States
```dart
// Offline State Specifications
class WorldChefOfflineStates {
  // Colors
  static const Color offlineBannerColor = WorldChefSemanticColors.warning;
  static const Color offlineTextColor = Colors.white;
  
  // Banner Specifications
  static const double offlineBannerHeight = 40.0;
  static const EdgeInsets offlineBannerPadding = EdgeInsets.symmetric(
    horizontal: WorldChefSpacing.md,
    vertical: WorldChefSpacing.sm,
  );
  
  // Toast Specifications
  static const double toastMinWidth = 280.0;
  static const double toastMaxWidthPercent = 0.9; // 90% of viewport
  static const double toastBorderRadius = WorldChefDimensions.radiusMedium;
  static const Duration toastDuration = Duration(seconds: 4); // 3-5s range
  
  // Messaging
  static const Map<String, String> offlineMessages = {
    'banner_primary': "You're offline",
    'banner_secondary': "Reconnect to sync your meal plans.",
    'toast_action': "Cannot add to cart—no network.",
  };
}
```

## 8. Accessibility Specifications

### WCAG Compliance
```dart
// Accessibility Specifications
class WorldChefAccessibility {
  // Minimum contrast ratios (WCAG AA)
  static const double minimumContrastRatio = 4.5;
  static const double largeTextContrastRatio = 3.0;
  
  // Touch target minimums
  static const double minimumTouchTarget = WorldChefDimensions.minimumTouchTarget;
  
  // Text size minimums
  static const double minimumTextSize = 12.0;
  static const double comfortableTextSize = 14.0;
  
  // Focus indicators
  static const double focusIndicatorWidth = 2.0;
  static const Color focusIndicatorColor = WorldChefColors.brandBlue;
  
  // Screen reader labels
  static const Map<String, String> semanticLabels = {
    'recipe_card': 'Recipe card',
    'favorite_button': 'Add to favorites',
    'share_button': 'Share recipe',
    'back_button': 'Go back',
    'search_field': 'Search recipes',
    'filter_button': 'Filter recipes',
  };
}
```

## 9. Logo & Branding

### Logo Specifications
```dart
// Logo & Branding (Placeholder)
class WorldChefBranding {
  // Logo (TBA - using placeholder)
  static const String logoAssetPath = 'assets/images/logo_placeholder.png';
  static const String logoText = 'WorldChef';
  
  // Logo Dimensions
  static const double logoSmall = 24.0;
  static const double logoMedium = 32.0;
  static const double logoLarge = 48.0;
  
  // Logo Usage
  static const EdgeInsets logoMargin = EdgeInsets.all(WorldChefSpacing.sm);
  
  // Brand Colors (Primary brand identifier)
  static const Color brandPrimary = WorldChefColors.brandBlue;
  static const Color brandSecondary = WorldChefColors.secondaryGreen;
}
```

## Implementation Notes

### Flutter Theme Integration
```dart
// Complete Theme Implementation
class WorldChefThemeData {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: WorldChefTheme.lightColorScheme,
    textTheme: TextTheme(
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
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: WorldChefLayout.primaryButtonPadding,
        minimumSize: Size.fromHeight(WorldChefDimensions.buttonLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WorldChefDimensions.radiusMedium),
        ),
      ),
    ),
    cardTheme: CardTheme(
      margin: EdgeInsets.all(WorldChefSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WorldChefDimensions.radiusLarge),
      ),
    ),
    appBarTheme: AppBarTheme(
      toolbarHeight: WorldChefDimensions.appBarHeight,
      backgroundColor: WorldChefColors.brandBlue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: WorldChefTheme.darkColorScheme,
    textTheme: TextTheme(
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
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: WorldChefLayout.primaryButtonPadding,
        minimumSize: Size.fromHeight(WorldChefDimensions.buttonLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WorldChefDimensions.radiusMedium),
        ),
      ),
    ),
    cardTheme: CardTheme(
      margin: EdgeInsets.all(WorldChefSpacing.sm),
      color: WorldChefDarkTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WorldChefDimensions.radiusLarge),
      ),
    ),
    appBarTheme: AppBarTheme(
      toolbarHeight: WorldChefDimensions.appBarHeight,
      backgroundColor: WorldChefDarkTheme.surface,
      foregroundColor: WorldChefDarkTheme.primaryText,
      elevation: 0,
    ),
  );
}
```

### Validation Requirements
- All color combinations must meet WCAG AA contrast requirements
- All touch targets must be minimum 44dp
- All animations must respect user's reduced motion preferences
- All text must be readable at 200% zoom
- All interactive elements must have proper semantic labels

### System UI Spacers (NEW)
Token | Value | Description
----- | ----- | -----------
`statusBarSpacer` | `44px` | Height of iOS-style status bar safe area spacer when drawing brand background
`bottomScrollSpacer` | `100px` | Extra scroll-space at bottom of long lists so final item clears bottom navigation bar

---

**Status**: ✅ **COMPLETE SPECIFICATION READY FOR IMPLEMENTATION**  
**Next Step**: Task t001 - Create failing validation tests for all design tokens  
**Implementation**: Task t002 - Implement design system using these specifications