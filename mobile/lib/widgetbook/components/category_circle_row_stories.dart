import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/ui/organisms/wc_category_circle_row.dart';

/// Widgetbook Story for WCCategoryCircleRow Organism
///
/// Validates horizontal scrolling behavior, category display, and create button variants.
/// Tests the organism's behavior with different category counts and configurations.
///
/// Author: WorldChef Mobile Team
/// Date: 2025-06-26
/// Global Event: 162 (Widgetbook story for WCCategoryCircleRow)

WidgetbookComponent categoryCircleRowStories() {
  return WidgetbookComponent(
    name: 'WCCategoryCircleRow',
    useCases: [
      // Default Usage - Standard category row
      WidgetbookUseCase(
        name: 'Default Usage',
        builder: (context) {
          final categories = [
            CategoryData(
                name: 'Breakfast',
                imageUrl: 'https://picsum.photos/id/292/60/60'),
            CategoryData(
                name: 'Lunch', imageUrl: 'https://picsum.photos/id/326/60/60'),
            CategoryData(
                name: 'Dinner', imageUrl: 'https://picsum.photos/id/365/60/60'),
            CategoryData(
                name: 'Desserts',
                imageUrl: 'https://picsum.photos/id/431/60/60'),
            CategoryData(
                name: 'Snacks', imageUrl: 'https://picsum.photos/id/488/60/60'),
            CategoryData(name: 'Create +', isCreateButton: true),
          ];

          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category Circle Row',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  WCCategoryCircleRow(
                    categories: categories,
                    onCategoryTapped: (category) {
                      debugPrint('Tapped: ${category.name}');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // Scrolling Behavior - Many categories to test horizontal scroll
      WidgetbookUseCase(
        name: 'Scrolling Behavior',
        builder: (context) {
          final categories = [
            CategoryData(
                name: 'Breakfast',
                imageUrl: 'https://picsum.photos/id/292/60/60'),
            CategoryData(
                name: 'Lunch', imageUrl: 'https://picsum.photos/id/326/60/60'),
            CategoryData(
                name: 'Dinner', imageUrl: 'https://picsum.photos/id/365/60/60'),
            CategoryData(
                name: 'Desserts',
                imageUrl: 'https://picsum.photos/id/431/60/60'),
            CategoryData(
                name: 'Snacks', imageUrl: 'https://picsum.photos/id/488/60/60'),
            CategoryData(
                name: 'Beverages',
                imageUrl: 'https://picsum.photos/id/225/60/60'),
            CategoryData(
                name: 'Vegetarian',
                imageUrl: 'https://picsum.photos/id/312/60/60'),
            CategoryData(
                name: 'Vegan', imageUrl: 'https://picsum.photos/id/385/60/60'),
            CategoryData(
                name: 'Gluten Free',
                imageUrl: 'https://picsum.photos/id/456/60/60'),
            CategoryData(
                name: 'Low Carb',
                imageUrl: 'https://picsum.photos/id/502/60/60'),
            CategoryData(name: 'Create +', isCreateButton: true),
          ];

          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Horizontal Scrolling Test (11 Categories)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Swipe horizontally to see all categories',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  WCCategoryCircleRow(
                    categories: categories,
                    onCategoryTapped: (category) {
                      debugPrint('Scrolling test - Tapped: ${category.name}');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // Interactive Testing - Different states and variations
      WidgetbookUseCase(
        name: 'Interactive Testing',
        builder: (context) {
          final showCreateButton = context.knobs.boolean(
            label: 'Show Create Button',
            initialValue: true,
          );

          final categoryCount = context.knobs.int.slider(
            label: 'Number of Categories',
            initialValue: 5,
            min: 1,
            max: 10,
          );

          final usePlaceholders = context.knobs.boolean(
            label: 'Use Placeholder Images',
            initialValue: false,
          );

          final categories = List.generate(categoryCount, (index) {
            final categoryNames = [
              'Breakfast',
              'Lunch',
              'Dinner',
              'Desserts',
              'Snacks',
              'Beverages',
              'Vegetarian',
              'Vegan',
              'Gluten Free',
              'Low Carb'
            ];
            final imageUrls = [
              'https://picsum.photos/id/292/60/60',
              'https://picsum.photos/id/326/60/60',
              'https://picsum.photos/id/365/60/60',
              'https://picsum.photos/id/431/60/60',
              'https://picsum.photos/id/488/60/60',
              'https://picsum.photos/id/225/60/60',
              'https://picsum.photos/id/312/60/60',
              'https://picsum.photos/id/385/60/60',
              'https://picsum.photos/id/456/60/60',
              'https://picsum.photos/id/502/60/60',
            ];

            return CategoryData(
              name: categoryNames[index % categoryNames.length],
              imageUrl:
                  usePlaceholders ? null : imageUrls[index % imageUrls.length],
            );
          }).toList();

          if (showCreateButton) {
            categories
                .add(CategoryData(name: 'Create +', isCreateButton: true));
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Interactive Configuration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Categories: ${categories.length}${showCreateButton ? ' (includes Create button)' : ''}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  if (usePlaceholders)
                    const Text(
                      'Using placeholder images to test error states',
                      style: TextStyle(fontSize: 12, color: Colors.orange),
                    ),
                  const SizedBox(height: 16),
                  WCCategoryCircleRow(
                    categories: categories,
                    onCategoryTapped: (category) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tapped: ${category.name}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tap any category to see feedback',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // Edge Cases - Minimal and empty states
      WidgetbookUseCase(
        name: 'Edge Cases',
        builder: (context) {
          final testCase = context.knobs.list(
            label: 'Test Case',
            options: [
              'Single Category',
              'Only Create Button',
              'Long Category Names'
            ],
            initialOption: 'Single Category',
          );

          List<CategoryData> categories;

          switch (testCase) {
            case 'Single Category':
              categories = [
                CategoryData(
                    name: 'Breakfast',
                    imageUrl: 'https://picsum.photos/id/292/60/60'),
              ];
              break;
            case 'Only Create Button':
              categories = [
                CategoryData(name: 'Create +', isCreateButton: true),
              ];
              break;
            case 'Long Category Names':
              categories = [
                CategoryData(
                    name: 'Very Long Category Name Test',
                    imageUrl: 'https://picsum.photos/id/292/60/60'),
                CategoryData(
                    name: 'Another Extremely Long Name',
                    imageUrl: 'https://picsum.photos/id/326/60/60'),
                CategoryData(
                    name: 'Short',
                    imageUrl: 'https://picsum.photos/id/365/60/60'),
                CategoryData(name: 'Create +', isCreateButton: true),
              ];
              break;
            default:
              categories = [];
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edge Case: $testCase',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  WCCategoryCircleRow(
                    categories: categories,
                    onCategoryTapped: (category) {
                      debugPrint('Edge case test - Tapped: ${category.name}');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );
}
