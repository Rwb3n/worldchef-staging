import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:worldchef_mobile/src/screens/home_feed_screen.dart';
import 'package:worldchef_mobile/src/core/design_system/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:worldchef_mobile/src/core/providers/offline_provider.dart';

/// RED step for Task t001 – Home Feed pixel-perfect golden tests.
///
/// These tests intentionally fail until the HomeFeedScreen implementation
/// matches the latest Figma spec (figma_home_screen.svg) within ≤5 pixel
/// RMS tolerance on the two target device sizes.
void main() {
  const Size iphone12Size = Size(390, 844); // iPhone 12/13
  const Size pixel5Size = Size(360, 800);  // Google Pixel 5

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> _pumpHomeFeed(
    WidgetTester tester,
    Size size,
  ) async {
    await loadAppFonts();
    await tester.pumpWidgetBuilder(
      ProviderScope(
        overrides: [offlineProvider.overrideWith((ref) => Stream.value(false))],
        child: const HomeFeedScreen(),
      ),
      wrapper: materialAppWrapper(
        theme: AppTheme.lightTheme,
        platform: TargetPlatform.android,
      ),
      surfaceSize: size,
    );
    await tester.pump(const Duration(seconds: 1));
  }

  group('HomeFeedScreen – Pixel-perfect goldens', () {
    testGoldens('iPhone 12/13 dimensions', (tester) async {
      await mockNetworkImagesFor(() => _pumpHomeFeed(tester, iphone12Size));
      await screenMatchesGolden(
        tester,
        'home_feed_pixel_perfect_iphone12',
        customPump: (tester) async {
          await tester.pump(const Duration(milliseconds: 500));
        },
      );
    });

    testGoldens('Pixel 5 dimensions', (tester) async {
      await mockNetworkImagesFor(() => _pumpHomeFeed(tester, pixel5Size));
      await screenMatchesGolden(
        tester,
        'home_feed_pixel_perfect_pixel5',
        customPump: (tester) async {
          await tester.pump(const Duration(milliseconds: 500));
        },
      );
    });
  });
} 