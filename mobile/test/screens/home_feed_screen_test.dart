import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef_mobile/src/screens/home_feed_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Home Feed Screen Tests', () {
    testWidgets('should display main layout components',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeFeedScreen(),
          ),
        ),
      );

      // Test based on Home Feed Screen Specification v0.2

      // 1. Category Navigation Row should be present
      expect(find.text('Category Navigation'), findsOneWidget);

      // 2. "Taste by Country" section should be present
      expect(find.text('Taste by Country'), findsOneWidget);
      expect(find.text('View all'), findsAtLeastNWidgets(1));

      // 3. "Taste by Diet" section should be present
      expect(find.text('Taste by Diet'), findsOneWidget);

      // 4. Bottom Navigation should be present
      expect(find.text('feed'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('+'), findsOneWidget);
      expect(find.text('Plans'), findsOneWidget);
      expect(find.text('You'), findsOneWidget);
    });

    testWidgets('should have proper accessibility labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeFeedScreen(),
          ),
        ),
      );

      // Test accessibility based on spec section 7.1
      expect(find.text('Category Navigation'), findsOneWidget);
      expect(find.text('Country Grid Placeholder'), findsOneWidget);
      expect(find.text('feed'), findsOneWidget);
    });
  });
}
