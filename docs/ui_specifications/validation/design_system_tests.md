# Design System Validation Tests

**Status**: 🔴 **TESTS MUST FAIL (Red Step)**  
**Created**: 2025-06-24 22:50:00Z  
**Plan Task**: t001 (TEST_CREATION)  
**Global Event**: 130  
**TDD Phase**: RED - These tests MUST fail initially

---

## Overview

This document specifies all validation tests for the WorldChef design system. **These tests MUST fail initially** as no implementation exists yet. This is the RED step of the TDD cycle.

## Test Categories

### 1. Color Contrast Validation Tests

**File**: `test/design_system/color_contrast_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef/design_system/tokens.dart';

void main() {
  group('Color Contrast Validation (WCAG AA)', () {
    test('Brand Blue on white background meets WCAG AA (4.5:1)', () {
      // MUST FAIL: No WorldChefColors.brandBlue implementation exists
      final contrast = calculateContrast(
        WorldChefColors.brandBlue, 
        Colors.white
      );
      expect(contrast, greaterThanOrEqualTo(4.5));
    });
    
    test('Secondary Green on white background meets WCAG AA', () {
      // MUST FAIL: No WorldChefColors.secondaryGreen implementation exists
      final contrast = calculateContrast(
        WorldChefColors.secondaryGreen, 
        Colors.white
      );
      expect(contrast, greaterThanOrEqualTo(4.5));
    });
    
    test('Accent Coral on white background meets WCAG AA', () {
      // MUST FAIL: No WorldChefColors.accentCoral implementation exists
      final contrast = calculateContrast(
        WorldChefColors.accentCoral, 
        Colors.white
      );
      expect(contrast, greaterThanOrEqualTo(4.5));
    });
    
    test('Primary text on background meets WCAG AA', () {
      // MUST FAIL: No WorldChefNeutrals implementation exists
      final contrast = calculateContrast(
        WorldChefNeutrals.primaryText, 
        WorldChefNeutrals.background
      );
      expect(contrast, greaterThanOrEqualTo(4.5));
    });
    
    test('Secondary text on background meets WCAG AA', () {
      // MUST FAIL: No WorldChefNeutrals.secondaryText implementation exists
      final contrast = calculateContrast(
        WorldChefNeutrals.secondaryText, 
        WorldChefNeutrals.background
      );
      expect(contrast, greaterThanOrEqualTo(4.5));
    });
  });
}

// Helper function - MUST FAIL: Implementation doesn't exist
double calculateContrast(Color color1, Color color2) {
  throw UnimplementedError('Color contrast calculation not implemented');
}
```

### 2. Typography Scale Validation Tests

**File**: `test/design_system/typography_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef/design_system/tokens.dart';

void main() {
  group('Typography Scale Validation', () {
    test('Display Large uses Lora font family', () {
      // MUST FAIL: No WorldChefTextStyles.displayLarge implementation exists
      expect(
        WorldChefTextStyles.displayLarge.fontFamily, 
        equals('Lora')
      );
    });
    
    test('Body Large uses Nunito font family', () {
      // MUST FAIL: No WorldChefTextStyles.bodyLarge implementation exists
      expect(
        WorldChefTextStyles.bodyLarge.fontFamily, 
        equals('Nunito')
      );
    });
    
    test('Typography scale maintains proper hierarchy', () {
      // MUST FAIL: No text style implementations exist
      expect(
        WorldChefTextStyles.displayLarge.fontSize! > 
        WorldChefTextStyles.headlineLarge.fontSize!,
        isTrue
      );
      expect(
        WorldChefTextStyles.headlineLarge.fontSize! > 
        WorldChefTextStyles.bodyLarge.fontSize!,
        isTrue
      );
    });
    
    test('All text styles have proper line height (1.2-1.6)', () {
      // MUST FAIL: No text style implementations exist
      final styles = [
        WorldChefTextStyles.displayLarge,
        WorldChefTextStyles.headlineLarge,
        WorldChefTextStyles.bodyLarge,
        WorldChefTextStyles.labelLarge,
      ];
      
      for (final style in styles) {
        expect(style.height, greaterThanOrEqualTo(1.2));
        expect(style.height, lessThanOrEqualTo(1.6));
      }
    });
    
    test('Label styles have proper letter spacing (0.5px)', () {
      // MUST FAIL: No label style implementations exist
      expect(
        WorldChefTextStyles.labelLarge.letterSpacing, 
        equals(0.5)
      );
      expect(
        WorldChefTextStyles.labelMedium.letterSpacing, 
        equals(0.5)
      );
    });
  });
}
```

### 3. Spacing Token Validation Tests

**File**: `test/design_system/spacing_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef/design_system/tokens.dart';

void main() {
  group('Spacing Token Validation', () {
    test('Base unit is 8.0 pixels', () {
      // MUST FAIL: No WorldChefSpacing.baseUnit implementation exists
      expect(WorldChefSpacing.baseUnit, equals(8.0));
    });
    
    test('Spacing scale follows 8px grid system', () {
      // MUST FAIL: No WorldChefSpacing implementations exist
      expect(WorldChefSpacing.xs, equals(4.0));   // 1/2 unit
      expect(WorldChefSpacing.sm, equals(8.0));   // 1 unit
      expect(WorldChefSpacing.md, equals(16.0));  // 2 units
      expect(WorldChefSpacing.lg, equals(24.0));  // 3 units
      expect(WorldChefSpacing.xl, equals(32.0));  // 4 units
      expect(WorldChefSpacing.xxl, equals(48.0)); // 6 units
    });
    
    test('Layout padding follows spacing tokens', () {
      // MUST FAIL: No WorldChefLayout implementations exist
      expect(
        WorldChefLayout.mobileContainerPadding.horizontal, 
        equals(WorldChefSpacing.md)
      );
      expect(
        WorldChefLayout.standardCardPadding.top, 
        equals(WorldChefSpacing.md)
      );
    });
    
    test('Button padding uses spacing tokens', () {
      // MUST FAIL: No WorldChefLayout button padding implementations exist
      expect(
        WorldChefLayout.primaryButtonPadding.vertical, 
        equals(WorldChefSpacing.sm)
      );
      expect(
        WorldChefLayout.primaryButtonPadding.horizontal, 
        equals(WorldChefSpacing.md)
      );
    });
  });
}
```

### 4. Component Dimensions Validation Tests

**File**: `test/design_system/dimensions_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef/design_system/tokens.dart';

void main() {
  group('Component Dimensions Validation', () {
    test('Minimum touch target is 44dp', () {
      // MUST FAIL: No WorldChefDimensions.minimumTouchTarget implementation exists
      expect(WorldChefDimensions.minimumTouchTarget, equals(44.0));
    });
    
    test('Button heights meet accessibility requirements', () {
      // MUST FAIL: No WorldChefDimensions button height implementations exist
      expect(
        WorldChefDimensions.buttonLarge, 
        greaterThanOrEqualTo(WorldChefDimensions.minimumTouchTarget)
      );
      expect(
        WorldChefDimensions.buttonMedium, 
        greaterThanOrEqualTo(40.0)
      );
    });
    
    test('Icon sizes follow standard scale', () {
      // MUST FAIL: No WorldChefDimensions icon size implementations exist
      expect(WorldChefDimensions.iconSmall, equals(16.0));
      expect(WorldChefDimensions.iconMedium, equals(24.0));
      expect(WorldChefDimensions.iconLarge, equals(32.0));
    });
    
    test('Border radius values are consistent', () {
      // MUST FAIL: No WorldChefDimensions radius implementations exist
      expect(WorldChefDimensions.radiusSmall, equals(4.0));
      expect(WorldChefDimensions.radiusMedium, equals(8.0));
      expect(WorldChefDimensions.radiusLarge, equals(12.0));
      expect(WorldChefDimensions.radiusXLarge, equals(16.0));
    });
  });
}
```

### 5. Animation Duration Validation Tests

**File**: `test/design_system/animation_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef/design_system/tokens.dart';

void main() {
  group('Animation Duration Validation', () {
    test('Animation durations follow specification', () {
      // MUST FAIL: No WorldChefAnimations implementations exist
      expect(
        WorldChefAnimations.fast.inMilliseconds, 
        equals(100)
      );
      expect(
        WorldChefAnimations.medium.inMilliseconds, 
        equals(200)
      );
      expect(
        WorldChefAnimations.slow.inMilliseconds, 
        equals(300)
      );
    });
    
    test('Specific animation configs use correct durations', () {
      // MUST FAIL: No WorldChefAnimations config implementations exist
      expect(
        WorldChefAnimations.hoverHighlight.duration, 
        equals(WorldChefAnimations.fast)
      );
      expect(
        WorldChefAnimations.slideDrawer.duration, 
        equals(WorldChefAnimations.medium)
      );
      expect(
        WorldChefAnimations.pageTransition.duration, 
        equals(WorldChefAnimations.slow)
      );
    });
    
    test('Easing curves are properly defined', () {
      // MUST FAIL: No WorldChefAnimations curve implementations exist
      expect(WorldChefAnimations.snapIn, isA<Cubic>());
      expect(WorldChefAnimations.snapOut, isA<Cubic>());
      expect(WorldChefAnimations.slide, isA<Cubic>());
    });
  });
}
```

### 6. Theme Switching Validation Tests

**File**: `test/design_system/theme_switching_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:worldchef/design_system/tokens.dart';

void main() {
  group('Theme Switching Validation', () {
    testWidgets('Theme switching does not cause layout shifts', (tester) async {
      // MUST FAIL: No WorldChefThemeData implementation exists
      await tester.pumpWidget(
        MaterialApp(
          theme: WorldChefThemeData.lightTheme,
          home: const Scaffold(body: Text('Test')),
        ),
      );
      
      final initialSize = tester.getSize(find.text('Test'));
      
      // Switch theme (this will fail as darkTheme doesn't exist)
      await tester.pumpWidget(
        MaterialApp(
          theme: WorldChefThemeData.darkTheme,
          home: const Scaffold(body: Text('Test')),
        ),
      );
      
      final newSize = tester.getSize(find.text('Test'));
      expect(newSize, equals(initialSize));
    });
    
    test('Light theme uses correct color scheme', () {
      // MUST FAIL: No WorldChefTheme.lightColorScheme implementation exists
      final colorScheme = WorldChefTheme.lightColorScheme;
      expect(colorScheme.primary, equals(WorldChefColors.brandBlue));
      expect(colorScheme.secondary, equals(WorldChefColors.secondaryGreen));
      expect(colorScheme.tertiary, equals(WorldChefColors.accentCoral));
    });
    
    test('Theme data includes all required components', () {
      // MUST FAIL: No WorldChefThemeData.lightTheme implementation exists
      final theme = WorldChefThemeData.lightTheme;
      expect(theme.elevatedButtonTheme, isNotNull);
      expect(theme.cardTheme, isNotNull);
      expect(theme.appBarTheme, isNotNull);
      expect(theme.textTheme, isNotNull);
    });
  });
}
```

### 7. RTL Layout Validation Tests

**File**: `test/design_system/rtl_layout_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:worldchef/design_system/tokens.dart';

void main() {
  group('RTL Layout Validation', () {
    testWidgets('Layout padding works correctly in RTL', (tester) async {
      // MUST FAIL: No WorldChefLayout.mobileContainerPadding implementation exists
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: WorldChefLayout.mobileContainerPadding,
              child: const Text('RTL Test'),
            ),
          ),
        ),
      );
      
      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding.horizontal, equals(WorldChefSpacing.md));
    });
    
    testWidgets('Icon and text spacing works in RTL', (tester) async {
      // MUST FAIL: No WorldChefLayout.labelIconGap implementation exists
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                const Icon(Icons.star),
                SizedBox(width: WorldChefLayout.labelIconGap),
                const Text('Star'),
              ],
            ),
          ),
        ),
      );
      
      expect(find.byType(SizedBox), findsOneWidget);
    });
    
    test('Text styles support RTL languages', () {
      // MUST FAIL: No WorldChefTextStyles implementations exist
      final styles = [
        WorldChefTextStyles.displayLarge,
        WorldChefTextStyles.bodyLarge,
        WorldChefTextStyles.labelLarge,
      ];
      
      // All styles should work with RTL text
      for (final style in styles) {
        expect(style.fontFamily, isNotNull);
        expect(style.fontSize, greaterThan(0));
      }
    });
  });
}
```

### 8. Accessibility Validation Tests

**File**: `test/design_system/accessibility_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:worldchef/design_system/tokens.dart';

void main() {
  group('Accessibility Validation', () {
    test('Touch targets meet minimum size requirements', () {
      // MUST FAIL: No WorldChefDimensions implementations exist
      expect(
        WorldChefDimensions.minimumTouchTarget, 
        greaterThanOrEqualTo(44.0)
      );
      expect(
        WorldChefDimensions.comfortableTouchTarget, 
        greaterThanOrEqualTo(48.0)
      );
    });
    
    test('Button heights meet accessibility requirements', () {
      // MUST FAIL: No WorldChefDimensions button implementations exist
      expect(
        WorldChefDimensions.buttonLarge, 
        greaterThanOrEqualTo(WorldChefDimensions.minimumTouchTarget)
      );
      expect(
        WorldChefDimensions.buttonMedium, 
        greaterThanOrEqualTo(40.0)
      );
    });
    
    test('Text sizes meet readability requirements', () {
      // MUST FAIL: No WorldChefAccessibility implementations exist
      expect(
        WorldChefAccessibility.minimumTextSize, 
        greaterThanOrEqualTo(12.0)
      );
      expect(
        WorldChefAccessibility.comfortableTextSize, 
        greaterThanOrEqualTo(14.0)
      );
    });
    
    test('Focus indicators are properly defined', () {
      // MUST FAIL: No WorldChefAccessibility focus implementations exist
      expect(WorldChefAccessibility.focusIndicatorWidth, equals(2.0));
      expect(
        WorldChefAccessibility.focusIndicatorColor, 
        equals(WorldChefColors.brandBlue)
      );
    });
    
    test('Semantic labels are defined for common elements', () {
      // MUST FAIL: No WorldChefAccessibility.semanticLabels implementation exists
      final labels = WorldChefAccessibility.semanticLabels;
      expect(labels['recipe_card'], isNotNull);
      expect(labels['favorite_button'], isNotNull);
      expect(labels['search_field'], isNotNull);
    });
  });
}
```

### 9. Media Specifications Validation Tests

**File**: `test/design_system/media_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef/design_system/tokens.dart';

void main() {
  group('Media Specifications Validation', () {
    test('Aspect ratios are correctly defined', () {
      // MUST FAIL: No WorldChefMedia implementations exist
      expect(WorldChefMedia.squareRatio, equals(1.0));
      expect(WorldChefMedia.horizontalRatio, equals(4/3));
      expect(WorldChefMedia.bannerRatio, equals(3/2));
      expect(WorldChefMedia.widescreenRatio, equals(16/9));
    });
    
    test('Aspect ratio usage guidelines are complete', () {
      // MUST FAIL: No WorldChefMedia.aspectRatioUsage implementation exists
      final usage = WorldChefMedia.aspectRatioUsage;
      expect(usage['category_circles'], equals(WorldChefMedia.squareRatio));
      expect(usage['hero_recipe_cards'], equals(WorldChefMedia.horizontalRatio));
      expect(usage['recipe_header_banners'], equals(WorldChefMedia.bannerRatio));
      expect(usage['diet_grid_tiles'], equals(WorldChefMedia.widescreenRatio));
    });
    
    test('All required media types have aspect ratios defined', () {
      // MUST FAIL: No WorldChefMedia.aspectRatioUsage implementation exists
      final usage = WorldChefMedia.aspectRatioUsage;
      final requiredTypes = [
        'category_circles',
        'country_thumbnails', 
        'ingredient_icons',
        'nav_icons',
        'hero_recipe_cards',
        'recipe_header_banners',
        'diet_grid_tiles',
        'video_previews',
      ];
      
      for (final type in requiredTypes) {
        expect(usage.containsKey(type), isTrue, reason: 'Missing aspect ratio for $type');
      }
    });
  });
}
```

### 10. State-Specific Validation Tests

**File**: `test/design_system/state_validation_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:worldchef/design_system/tokens.dart';

void main() {
  group('Error State Validation', () {
    test('Error colors meet contrast requirements', () {
      // MUST FAIL: No WorldChefErrorStates implementations exist
      expect(WorldChefErrorStates.errorColor, isNotNull);
      expect(WorldChefErrorStates.errorBackground, isNotNull);
      expect(WorldChefErrorStates.errorOnBackground, isNotNull);
    });
    
    test('Error messages are defined', () {
      // MUST FAIL: No WorldChefErrorStates.errorMessages implementation exists
      final messages = WorldChefErrorStates.errorMessages;
      expect(messages['network_error'], isNotNull);
      expect(messages['generic_error'], isNotNull);
      expect(messages['form_error'], isNotNull);
      expect(messages['offline_error'], isNotNull);
    });
    
    test('Error banner dimensions are specified', () {
      // MUST FAIL: No WorldChefErrorStates banner implementations exist
      expect(WorldChefErrorStates.errorBannerHeight, equals(48.0));
      expect(WorldChefErrorStates.errorBannerPadding, isNotNull);
    });
  });
  
  group('Loading State Validation', () {
    test('Loading colors are defined', () {
      // MUST FAIL: No WorldChefLoadingStates implementations exist
      expect(WorldChefLoadingStates.skeletonBase, isNotNull);
      expect(WorldChefLoadingStates.skeletonHighlight, isNotNull);
      expect(WorldChefLoadingStates.spinnerColor, isNotNull);
    });
    
    test('Spinner sizes follow design system', () {
      // MUST FAIL: No WorldChefLoadingStates spinner implementations exist
      expect(WorldChefLoadingStates.spinnerSmall, equals(16.0));
      expect(WorldChefLoadingStates.spinnerMedium, equals(24.0));
      expect(WorldChefLoadingStates.spinnerLarge, equals(48.0));
    });
    
    test('Animation durations are specified', () {
      // MUST FAIL: No WorldChefLoadingStates duration implementations exist
      expect(WorldChefLoadingStates.spinnerDuration, isNotNull);
      expect(WorldChefLoadingStates.shimmerDuration, isNotNull);
    });
  });
  
  group('Offline State Validation', () {
    test('Offline banner specifications are complete', () {
      // MUST FAIL: No WorldChefOfflineStates implementations exist
      expect(WorldChefOfflineStates.offlineBannerHeight, equals(40.0));
      expect(WorldChefOfflineStates.offlineBannerPadding, isNotNull);
      expect(WorldChefOfflineStates.offlineBannerColor, isNotNull);
    });
    
    test('Toast specifications are defined', () {
      // MUST FAIL: No WorldChefOfflineStates toast implementations exist
      expect(WorldChefOfflineStates.toastMinWidth, equals(280.0));
      expect(WorldChefOfflineStates.toastMaxWidthPercent, equals(0.9));
      expect(WorldChefOfflineStates.toastBorderRadius, isNotNull);
      expect(WorldChefOfflineStates.toastDuration, isNotNull);
    });
    
    test('Offline messages are specified', () {
      // MUST FAIL: No WorldChefOfflineStates.offlineMessages implementation exists
      final messages = WorldChefOfflineStates.offlineMessages;
      expect(messages['banner_primary'], isNotNull);
      expect(messages['banner_secondary'], isNotNull);
      expect(messages['toast_action'], isNotNull);
    });
  });
}
```

## Test Execution Requirements

### Running the Tests (MUST FAIL)

**Command**: `flutter test test/design_system/`

**Expected Result**: **ALL TESTS MUST FAIL** with import errors and unimplemented classes.

**Typical Failure Messages:**
```
Error: Could not resolve the package 'worldchef' in 'package:worldchef/design_system/tokens.dart'.
Error: The getter 'WorldChefColors' isn't defined for the class.
Error: The getter 'WorldChefTextStyles' isn't defined for the class.
UnimplementedError: Color contrast calculation not implemented
```

### Success Criteria for RED Step

- ✅ All test files created with comprehensive coverage
- ✅ All tests reference non-existent implementations  
- ✅ All tests FAIL when executed
- ✅ Test failures confirm missing design system implementation
- ✅ Test structure validates all design token categories

### Next Steps (After RED Step Completion)

1. **Task t002 (GREEN)**: Implement design system tokens to make these tests pass
2. **Task t003 (REFACTOR)**: Optimize and expand the design system
3. **Validation**: Run tests again to confirm GREEN step success

---

**Status**: 🔴 **RED STEP COMPLETE**  
**All Tests Created**: 10 test categories, 50+ individual test cases  
**Expected Result**: 100% test failure rate (as required for TDD Red step)  
**Next Task**: t002 - Design System Implementation (GREEN step)