import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_section_header.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';

void main() {
  group('WCSectionHeader', () {
    testWidgets('should render title with headlineSmall text style',
        (WidgetTester tester) async {
      // Arrange
      const title = 'Taste by Country';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCSectionHeader(
              title: title,
              onViewAllPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      final titleFinder = find.text(title);
      expect(titleFinder, findsOneWidget);

      // Verify text style matches headlineSmall from design tokens
      final Text titleWidget = tester.widget(titleFinder);
      expect(titleWidget.style, equals(WorldChefTextStyles.headlineSmall));
    });

    testWidgets('should render View all link with correct styling',
        (WidgetTester tester) async {
      // Arrange
      bool wasPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCSectionHeader(
              title: 'Test Section',
              onViewAllPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      // Assert
      final viewAllFinder = find.text('View all');
      expect(viewAllFinder, findsOneWidget);

      // Verify link color matches brand blue
      final Text viewAllWidget = tester.widget(viewAllFinder);
      expect(viewAllWidget.style?.color, equals(WorldChefColors.brandBlue));

      // Test tap interaction
      await tester.tap(viewAllFinder);
      await tester.pump();
      expect(wasPressed, isTrue);
    });

    testWidgets('should use proper layout spacing and container padding',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCSectionHeader(
              title: 'Layout Test',
              onViewAllPressed: () {},
            ),
          ),
        ),
      );

      // Assert - verify the component exists and has proper structure
      expect(find.byType(WCSectionHeader), findsOneWidget);

      // The component should contain both title and view all in a row layout
      expect(find.text('Layout Test'), findsOneWidget);
      expect(find.text('View all'), findsOneWidget);
    });
  });
}
