import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:worldchef_mobile/src/screens/recipe_detail_screen.dart';
import 'package:worldchef_mobile/src/core/design_system/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_image_mock/network_image_mock.dart';

/// RED step for Task t004 – Recipe Detail pixel-perfect golden tests.
///
/// These tests intentionally **FAIL** until the `RecipeDetailScreen` layout
/// matches the latest Figma spec (figma_detail_screen.svg) within ≤5 pixel RMS
/// tolerance on the two target device sizes.
void main() {
  const Size iphone12Size = Size(390, 844); // iPhone 12/13
  const Size pixel5Size = Size(360, 800); // Google Pixel 5

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> _pumpRecipeDetail(
    WidgetTester tester,
    Size size,
  ) async {
    await loadAppFonts();
    await tester.pumpWidgetBuilder(
      const ProviderScope(child: RecipeDetailScreen()),
      wrapper: materialAppWrapper(
        theme: AppTheme.lightTheme,
        platform: TargetPlatform.android,
      ),
      surfaceSize: size,
    );
    await tester.pump(const Duration(seconds: 1));
  }

  group('RecipeDetailScreen – Pixel-perfect goldens', () {
    testGoldens('iPhone 12/13 dimensions', (tester) async {
      await mockNetworkImagesFor(() => _pumpRecipeDetail(tester, iphone12Size));
      await screenMatchesGolden(
        tester,
        'recipe_detail_pixel_perfect_iphone12',
        customPump: (tester) async => tester.pump(const Duration(milliseconds: 500)),
      );
    });

    testGoldens('Pixel 5 dimensions', (tester) async {
      await mockNetworkImagesFor(() => _pumpRecipeDetail(tester, pixel5Size));
      await screenMatchesGolden(
        tester,
        'recipe_detail_pixel_perfect_pixel5',
        customPump: (tester) async => tester.pump(const Duration(milliseconds: 500)),
      );
    });
  });
} 