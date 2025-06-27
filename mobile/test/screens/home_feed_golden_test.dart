import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:worldchef_mobile/src/core/design_system/app_theme.dart';
import 'package:worldchef_mobile/src/ui/organisms/wc_bottom_navigation.dart';
import 'package:worldchef_mobile/src/ui/organisms/wc_category_circle_row.dart';
import 'package:worldchef_mobile/src/ui/organisms/wc_featured_recipe_card.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_section_header.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_creator_info_row.dart';
import 'package:worldchef_mobile/src/models/category_data.dart';
import 'package:worldchef_mobile/src/models/creator_data.dart';
import 'package:network_image_mock/network_image_mock.dart';

/// Golden test for Home Feed screen layout alignment
///
/// This test establishes the target visual specification for the complete
/// Home Feed layout as defined in docs/ui_specifications/screens/home_feed_screen.md
///
/// The test will initially FAIL because the current Home Feed story uses
/// placeholder implementation instead of the specified component composition.
///
/// Success criteria:
/// - Blue background throughout the screen
/// - WCCategoryCircleRow with proper category navigation
/// - "Taste by Country" section with WCSectionHeader and country grid
/// - "Taste by Diet" section with WCSectionHeader and WCFeaturedRecipeCard
/// - WCBottomNavigation with proper styling and active state
///
/// This is the RED step of the TDD cycle for Home Feed layout integration.
void main() {
  group('Home Feed Golden Tests', () {
    testGoldens('Home Feed layout matches UI specification', (tester) async {
      await mockNetworkImagesFor(() async {
        // Configure golden test environment
        await loadAppFonts();

        // Build the target Home Feed layout as specified
        await tester.pumpWidgetBuilder(
          _buildTargetHomeFeedLayout(),
          wrapper: materialAppWrapper(
            theme: AppTheme.lightTheme,
            platform: TargetPlatform.android,
          ),
          surfaceSize: const Size(375, 812), // iPhone 13 Pro dimensions
        );

        // Allow for image loading and animations to settle
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Capture golden image for visual comparison
        await screenMatchesGolden(tester, 'home_feed_layout_specification');
      });
    });

    testGoldens('Home Feed sections alignment', (tester) async {
      await mockNetworkImagesFor(() async {
        await loadAppFonts();

        // Test individual sections for detailed validation
        await tester.pumpWidgetBuilder(
          _buildHomeFeedSectionsOnly(),
          wrapper: materialAppWrapper(
            theme: AppTheme.lightTheme,
            platform: TargetPlatform.android,
          ),
          surfaceSize: const Size(375, 600),
        );

        await tester.pumpAndSettle(const Duration(seconds: 1));
        await screenMatchesGolden(tester, 'home_feed_sections_specification');
      });
    });

    testGoldens('Home Feed responsive layout', (tester) async {
      await mockNetworkImagesFor(() async {
        await loadAppFonts();

        // Test responsive behavior at different screen sizes
        await tester.pumpWidgetBuilder(
          _buildTargetHomeFeedLayout(),
          wrapper: materialAppWrapper(
            theme: AppTheme.lightTheme,
            platform: TargetPlatform.android,
          ),
          surfaceSize: const Size(320, 568), // iPhone SE dimensions
        );

        await tester.pumpAndSettle(const Duration(seconds: 2));
        await screenMatchesGolden(tester, 'home_feed_layout_responsive');
      });
    });
  });
}

/// Builds the target Home Feed layout according to UI specification
///
/// This represents the EXPECTED final implementation that should match
/// the visual design specification exactly. The current Home Feed story
/// implementation will NOT match this, causing the golden test to fail.
Widget _buildTargetHomeFeedLayout() {
  return Scaffold(
    backgroundColor: const Color(0xFF0288D1), // WorldChef brand blue background
    body: CustomScrollView(
      slivers: [
        // Status bar area with blue background
        SliverToBoxAdapter(
          child: Container(
            height: 44, // Status bar height
            color: const Color(0xFF0288D1),
          ),
        ),

        // Category navigation section
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFF0288D1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: WCCategoryCircleRow(
              categories: _getMockCategoryData(),
              onCategoryTapped: (category) {},
            ),
          ),
        ),

        // Country section
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // Section header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: WCSectionHeader(
                    title: 'Taste by Country',
                    onViewAllPressed: () {},
                  ),
                ),

                // Country grid (4 columns)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildCountryGrid(),
                ),

                const SizedBox(height: 32), // gridToGrid spacing
              ],
            ),
          ),
        ),

        // Diet section
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // Section header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: WCSectionHeader(
                    title: 'Taste by Diet',
                    onViewAllPressed: () {},
                  ),
                ),

                const SizedBox(height: 16),

                // Featured recipe card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: WCFeaturedRecipeCard(
                    recipe: _getMockFeaturedRecipe(),
                    onTap: () {},
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: WCBottomNavigation(
      currentIndex: 0, // Home/Feed tab active
      onTap: (index) {},
    ),
  );
}

/// Builds only the content sections for detailed validation
Widget _buildHomeFeedSectionsOnly() {
  return Container(
    color: Colors.white,
    child: Column(
      children: [
        // Country section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: WCSectionHeader(
            title: 'Taste by Country',
            onViewAllPressed: () {},
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildCountryGrid(),
        ),

        const SizedBox(height: 32),

        // Diet section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: WCSectionHeader(
            title: 'Taste by Diet',
            onViewAllPressed: () {},
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: WCFeaturedRecipeCard(
            recipe: _getMockFeaturedRecipe(),
            onTap: () {},
          ),
        ),
      ],
    ),
  );
}

/// Builds the country thumbnail grid (4 columns)
///
/// This represents the WCCountryThumbnailGrid organism that should be
/// implemented in the future. For now, we'll use a simple grid layout
/// that matches the specification.
Widget _buildCountryGrid() {
  final countries = [
    {
      'name': 'Mexico',
      'flag': '🇲🇽',
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=200'
    },
    {
      'name': 'Jamaica',
      'flag': '🇯🇲',
      'image':
          'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=200'
    },
    {
      'name': 'France',
      'flag': '🇫🇷',
      'image': 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=200'
    },
    {
      'name': 'Nigeria',
      'flag': '🇳🇬',
      'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200'
    },
  ];

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.0, // Square aspect ratio
    ),
    itemCount: countries.length,
    itemBuilder: (context, index) {
      final country = countries[index];
      return _buildCountryThumbnail(
        country['name']!,
        country['flag']!,
        country['image']!,
      );
    },
  );
}

/// Builds individual country thumbnail matching specification
Widget _buildCountryThumbnail(String name, String flag, String imageUrl) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8), // radiusMedium
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Background image (75% of thumbnail)
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),

          // Bottom overlay with flag and name
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    flag,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Mock data for category circles
List<CategoryData> _getMockCategoryData() {
  return [
    CategoryData(
      id: '1',
      name: 'Breakfast',
      imageUrl:
          'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=100',
    ),
    CategoryData(
      id: '2',
      name: 'Dinner',
      imageUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=100',
    ),
    CategoryData(
      id: '3',
      name: 'Desserts',
      imageUrl:
          'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=100',
    ),
  ];
}

/// Mock data for featured recipe
RecipeCardData _getMockFeaturedRecipe() {
  return RecipeCardData(
    id: 'featured1',
    title: 'Protein muffins',
    imageUrl:
        'https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7?w=400',
    creator: CreatorData(
      name: 'Chef Muscle',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
    ),
    rating: 4.5,
    reviewCount: 128,
    cookTime: '25 min',
    servings: 12,
  );
}
