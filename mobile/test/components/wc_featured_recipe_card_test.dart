import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef_mobile/src/ui/organisms/wc_featured_recipe_card.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_creator_info_row.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_star_rating_display.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/models/creator_data.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  Future<void> _runWithMockImages(Future<void> Function() body) => mockNetworkImagesFor(body);
  group('WCFeaturedRecipeCard', () {
    testWidgets('should render with correct 4:3 aspect ratio',
        (WidgetTester tester) async {
      await _runWithMockImages(() async {
      // Arrange
      final recipe = RecipeCardData(
        id: '1',
        title: 'Delicious Chocolate Cake',
        imageUrl: 'https://example.com/chocolate-cake.jpg',
        creator: CreatorData(
          name: 'Chef Mario',
          avatarUrl: 'https://example.com/chef-mario.jpg',
        ),
        rating: 4.5,
        reviewCount: 128,
        cookTime: '45 min',
        servings: 8,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300, // Fixed width to test aspect ratio
              child: WCFeaturedRecipeCard(
                recipe: recipe,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(WCFeaturedRecipeCard), findsOneWidget);

      // Should maintain 4:3 aspect ratio for main card container
      final aspectRatio = tester.widget<AspectRatio>(
        find.descendant(
          of: find.byType(WCFeaturedRecipeCard),
          matching: find.byType(AspectRatio),
        ),
      );
      expect(aspectRatio.aspectRatio, equals(4.0 / 3.0));
      });
    });

    testWidgets('should display recipe title with correct styling',
        (WidgetTester tester) async {
      await _runWithMockImages(() async {
      // Arrange
      final recipe = RecipeCardData(
        id: '1',
        title: 'Amazing Pasta Recipe',
        imageUrl: 'https://example.com/pasta.jpg',
        creator: CreatorData(
          name: 'Chef Luigi',
          avatarUrl: 'https://example.com/chef-luigi.jpg',
        ),
        rating: 4.8,
        reviewCount: 256,
        cookTime: '30 min',
        servings: 4,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCFeaturedRecipeCard(
              recipe: recipe,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Amazing Pasta Recipe'), findsOneWidget);

      // Should use headlineSmall style for recipe title
      final titleText = tester.widget<Text>(find.text('Amazing Pasta Recipe'));
      expect(titleText.style?.fontSize,
          equals(24.0)); // WorldChefTextStyles.headlineSmall
      });
    });

    testWidgets('should contain creator info row molecule',
        (WidgetTester tester) async {
      await _runWithMockImages(() async {
      // Arrange
      final recipe = RecipeCardData(
        id: '1',
        title: 'Test Recipe',
        imageUrl: 'https://example.com/test.jpg',
        creator: CreatorData(
          name: 'Test Chef',
          avatarUrl: 'https://example.com/test-chef.jpg',
        ),
        rating: 4.0,
        reviewCount: 50,
        cookTime: '20 min',
        servings: 2,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCFeaturedRecipeCard(
              recipe: recipe,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(WCCreatorInfoRow), findsOneWidget);

      // Creator info should display creator name
      expect(find.text('Test Chef'), findsOneWidget);
      });
    });

    testWidgets('should contain star rating display molecule',
        (WidgetTester tester) async {
      await _runWithMockImages(() async {
      // Arrange
      final recipe = RecipeCardData(
        id: '1',
        title: 'Test Recipe',
        imageUrl: 'https://example.com/test.jpg',
        creator: CreatorData(
          name: 'Test Chef',
          avatarUrl: 'https://example.com/test-chef.jpg',
        ),
        rating: 4.7,
        reviewCount: 89,
        cookTime: '25 min',
        servings: 6,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCFeaturedRecipeCard(
              recipe: recipe,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(WCStarRatingDisplay), findsOneWidget);

      // Rating display should show the rating value
      expect(find.text('4.7'), findsOneWidget);
      expect(find.text('(89)'), findsOneWidget);
      });
    });

    testWidgets('should display recipe metadata (cook time and servings)',
        (WidgetTester tester) async {
      await _runWithMockImages(() async {
      // Arrange
      final recipe = RecipeCardData(
        id: '1',
        title: 'Test Recipe',
        imageUrl: 'https://example.com/test.jpg',
        creator: CreatorData(
          name: 'Test Chef',
          avatarUrl: 'https://example.com/test-chef.jpg',
        ),
        rating: 4.0,
        reviewCount: 25,
        cookTime: '60 min',
        servings: 12,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCFeaturedRecipeCard(
              recipe: recipe,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('60 min'), findsOneWidget);
      expect(find.text('12 servings'), findsOneWidget);
      });
    });

    testWidgets('should handle tap events correctly',
        (WidgetTester tester) async {
      await _runWithMockImages(() async {
      // Arrange
      bool wasTapped = false;
      final recipe = RecipeCardData(
        id: '1',
        title: 'Tappable Recipe',
        imageUrl: 'https://example.com/tappable.jpg',
        creator: CreatorData(
          name: 'Chef Tap',
          avatarUrl: 'https://example.com/chef-tap.jpg',
        ),
        rating: 5.0,
        reviewCount: 1,
        cookTime: '5 min',
        servings: 1,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCFeaturedRecipeCard(
              recipe: recipe,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      // Tap on the card
      await tester.tap(find.byType(WCFeaturedRecipeCard));
      await tester.pump();

      // Assert
      expect(wasTapped, isTrue);
      });
    });

    testWidgets('should have proper spacing and layout',
        (WidgetTester tester) async {
      await _runWithMockImages(() async {
      // Arrange
      final recipe = RecipeCardData(
        id: '1',
        title: 'Layout Test Recipe',
        imageUrl: 'https://example.com/layout.jpg',
        creator: CreatorData(
          name: 'Layout Chef',
          avatarUrl: 'https://example.com/layout-chef.jpg',
        ),
        rating: 3.5,
        reviewCount: 10,
        cookTime: '15 min',
        servings: 3,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCFeaturedRecipeCard(
              recipe: recipe,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(WCFeaturedRecipeCard), findsOneWidget);

      // Should use proper spacing tokens throughout the layout
      // This will be validated when the component is implemented
      // Spacing should follow WorldChefSpacing.sm, WorldChefSpacing.md patterns
      });
    });
  });

  group('WCCreatorInfoRow', () {
    testWidgets('should display creator avatar and name',
        (WidgetTester tester) async {
      await _runWithMockImages(() async {
      // Arrange
      final creator = CreatorData(
        name: 'Chef Gordon',
        avatarUrl: 'https://example.com/chef-gordon.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCCreatorInfoRow(
              creator: creator,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(WCCreatorInfoRow), findsOneWidget);
      expect(find.text('Chef Gordon'), findsOneWidget);

      // Should contain a circular avatar image
      expect(find.byType(CircleAvatar), findsOneWidget);
      });
    });

    testWidgets('should handle missing avatar gracefully',
        (WidgetTester tester) async {
      await _runWithMockImages(() async {
      // Arrange
      final creator = CreatorData(
        name: 'Chef No Avatar',
        avatarUrl: null,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCCreatorInfoRow(
              creator: creator,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(WCCreatorInfoRow), findsOneWidget);
      expect(find.text('Chef No Avatar'), findsOneWidget);

      // Should still display a placeholder avatar
      expect(find.byType(CircleAvatar), findsOneWidget);
      });
    });
  });

  group('WCStarRatingDisplay', () {
    testWidgets('should display correct number of stars for rating',
        (WidgetTester tester) async {
      await _runWithMockImages(() async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCStarRatingDisplay(
              rating: 4.5,
              reviewCount: 100,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(WCStarRatingDisplay), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('(100)'), findsOneWidget);

      // Should display star icons (exact implementation depends on design)
      expect(find.byIcon(Icons.star), findsAtLeastNWidgets(4));
      });
    });

    testWidgets('should handle zero rating', (WidgetTester tester) async {
      await _runWithMockImages(() async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCStarRatingDisplay(
              rating: 0.0,
              reviewCount: 0,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(WCStarRatingDisplay), findsOneWidget);
      expect(find.text('0.0'), findsOneWidget);
      expect(find.text('(0)'), findsOneWidget);
      });
    });

    testWidgets('should handle high ratings correctly',
        (WidgetTester tester) async {
      await _runWithMockImages(() async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCStarRatingDisplay(
              rating: 5.0,
              reviewCount: 999,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(WCStarRatingDisplay), findsOneWidget);
      expect(find.text('5.0'), findsOneWidget);
      expect(find.text('(999)'), findsOneWidget);
      });
    });
  });
}

// NOTE: Duplicate data models removed. Use RecipeCardData from production
// `wc_featured_recipe_card.dart` and CreatorData from `src/models/creator_data.dart`.
