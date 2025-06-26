import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef_mobile/src/ui/organisms/wc_category_circle_row.dart';
import 'package:worldchef_mobile/src/ui/atoms/wc_circular_image.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';

void main() {
  group('WCCategoryCircleRow', () {
    testWidgets('should render horizontal scrollable row of category circles', (WidgetTester tester) async {
      // Arrange
      final categories = [
        CategoryData(name: 'Breakfast', imageUrl: 'assets/breakfast.jpg'),
        CategoryData(name: 'Dinner', imageUrl: 'assets/dinner.jpg'),
        CategoryData(name: 'Desserts', imageUrl: 'assets/desserts.jpg'),
        CategoryData(name: 'Create +', imageUrl: null, isCreateButton: true),
      ];
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCCategoryCircleRow(
              categories: categories,
              onCategoryTapped: (category) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(WCCategoryCircleRow), findsOneWidget);
      
      // Should contain a horizontal scrollable widget
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      final scrollView = tester.widget<SingleChildScrollView>(find.byType(SingleChildScrollView));
      expect(scrollView.scrollDirection, equals(Axis.horizontal));
      
      // Should contain circular image widgets
      expect(find.byType(WCCircularImage), findsNWidgets(4));
      
      // Should display category names
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('Dinner'), findsOneWidget);
      expect(find.text('Desserts'), findsOneWidget);
      expect(find.text('Create +'), findsOneWidget);
    });

    testWidgets('should use correct dimensions for circular images', (WidgetTester tester) async {
      // Arrange
      final categories = [
        CategoryData(name: 'Test', imageUrl: 'assets/test.jpg'),
      ];
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCCategoryCircleRow(
              categories: categories,
              onCategoryTapped: (category) {},
            ),
          ),
        ),
      );

      // Assert
      final circularImage = tester.widget<WCCircularImage>(find.byType(WCCircularImage));
      expect(circularImage.size, equals(60.0)); // 60dp as per specification
    });

    testWidgets('should apply correct spacing between category items', (WidgetTester tester) async {
      // Arrange
      final categories = [
        CategoryData(name: 'Cat1', imageUrl: 'assets/cat1.jpg'),
        CategoryData(name: 'Cat2', imageUrl: 'assets/cat2.jpg'),
      ];
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCCategoryCircleRow(
              categories: categories,
              onCategoryTapped: (category) {},
            ),
          ),
        ),
      );

      // Assert - verify spacing between items matches WorldChefSpacing.sm (8dp)
      expect(find.byType(WCCategoryCircleRow), findsOneWidget);
      
      // The component should use WorldChefSpacing.sm for item spacing
      // This will be validated when the component is implemented
    });

    testWidgets('should handle tap callbacks correctly', (WidgetTester tester) async {
      // Arrange
      CategoryData? tappedCategory;
      final categories = [
        CategoryData(name: 'Tappable', imageUrl: 'assets/tappable.jpg'),
      ];
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCCategoryCircleRow(
              categories: categories,
              onCategoryTapped: (category) {
                tappedCategory = category;
              },
            ),
          ),
        ),
      );

      // Tap on the category circle
      await tester.tap(find.byType(WCCircularImage));
      await tester.pump();

      // Assert
      expect(tappedCategory, isNotNull);
      expect(tappedCategory!.name, equals('Tappable'));
    });

    testWidgets('should render create button variant differently', (WidgetTester tester) async {
      // Arrange
      final categories = [
        CategoryData(name: 'Create +', imageUrl: null, isCreateButton: true),
      ];
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCCategoryCircleRow(
              categories: categories,
              onCategoryTapped: (category) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(WCCategoryCircleRow), findsOneWidget);
      expect(find.text('Create +'), findsOneWidget);
      
      // Create button should have different styling (dotted border, plus icon)
      // This will be validated when the component is implemented
    });
  });

  group('WCCircularImage', () {
    testWidgets('should render with correct size and border radius', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCCircularImage(
              imageUrl: 'assets/test.jpg',
              size: 60.0,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(WCCircularImage), findsOneWidget);
      
      // Should be a perfect circle with 60dp diameter
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(WCCircularImage),
          matching: find.byType(Container),
        ),
      );
      expect(container.constraints?.maxWidth, equals(60.0));
      expect(container.constraints?.maxHeight, equals(60.0));
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      // Arrange
      bool wasTapped = false;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCCircularImage(
              imageUrl: 'assets/test.jpg',
              size: 60.0,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(WCCircularImage));
      await tester.pump();

      // Assert
      expect(wasTapped, isTrue);
    });
  });
}

/// Data model for category information
/// This model will be created as part of the implementation
class CategoryData {
  final String name;
  final String? imageUrl;
  final bool isCreateButton;

  CategoryData({
    required this.name,
    this.imageUrl,
    this.isCreateButton = false,
  });
} 