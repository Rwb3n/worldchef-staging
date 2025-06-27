import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/ui/organisms/wc_featured_recipe_card.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_creator_info_row.dart';
import 'package:worldchef_mobile/src/models/creator_data.dart';

/// Widgetbook stories for WCFeaturedRecipeCard organism
///
/// This story collection provides comprehensive visual validation for the
/// WCFeaturedRecipeCard component with various states, content variations,
/// and interactive testing capabilities.
///
/// Story Categories:
/// 1. Default Featured Recipe Card - Common usage patterns
/// 2. Recipe Card Variants - Different content lengths and rating states
/// 3. Interactive Recipe Card - Live tap testing and state management
/// 4. Error and Loading States - Edge case validation
///
/// Each story uses Widgetbook knobs for dynamic content testing and
/// demonstrates proper component composition with design token compliance.

List<WidgetbookComponent> buildFeaturedRecipeCardStories() {
  return [
    WidgetbookComponent(
      name: 'WCFeaturedRecipeCard',
      useCases: [
        // Story 1: Default Featured Recipe Card
        WidgetbookUseCase(
          name: 'Default Recipe Card',
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                children: [
                  const Text(
                    'Default Featured Recipe Card',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 320, // Fixed width to demonstrate aspect ratio
                    child: WCFeaturedRecipeCard(
                      recipe: RecipeCardData(
                        id: '1',
                        title: 'Classic Chocolate Chip Cookies',
                        imageUrl:
                            'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400',
                        creator: CreatorData(
                          name: 'Chef Sarah',
                          avatarUrl:
                              'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100',
                        ),
                        rating: 4.8,
                        reviewCount: 234,
                        cookTime: '25 min',
                        servings: 12,
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Recipe card tapped!')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Standard recipe card with optimal content length and high rating',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),

        // Story 2: Recipe Card Variants
        WidgetbookUseCase(
          name: 'Recipe Card Variants',
          builder: (context) {
            final titleLength = context.knobs.list(
              label: 'Title Length',
              options: ['Short', 'Medium', 'Long'],
              initialOption: 'Medium',
            );

            final ratingValue = context.knobs.double.slider(
              label: 'Rating',
              initialValue: 4.2,
              min: 0.0,
              max: 5.0,
              divisions: 50,
            );

            final reviewCount = context.knobs.int.slider(
              label: 'Review Count',
              initialValue: 89,
              min: 0,
              max: 999,
            );

            final creatorName = context.knobs.string(
              label: 'Creator Name',
              initialValue: 'Chef Marco',
            );

            final cookTime = context.knobs.list(
              label: 'Cook Time',
              options: ['15 min', '30 min', '45 min', '1 hr', '2 hrs'],
              initialOption: '30 min',
            );

            final servings = context.knobs.int.slider(
              label: 'Servings',
              initialValue: 4,
              min: 1,
              max: 12,
            );

            // Title variations based on length selection
            final titles = {
              'Short': 'Pasta',
              'Medium': 'Creamy Mushroom Risotto',
              'Long':
                  'Authentic Italian Truffle and Wild Mushroom Risotto with Parmesan',
            };

            return Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                children: [
                  const Text(
                    'Interactive Recipe Card Variants',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 320,
                    child: WCFeaturedRecipeCard(
                      recipe: RecipeCardData(
                        id: '2',
                        title: titles[titleLength]!,
                        imageUrl:
                            'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
                        creator: CreatorData(
                          name: creatorName,
                          avatarUrl:
                              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                        ),
                        rating: ratingValue,
                        reviewCount: reviewCount,
                        cookTime: cookTime,
                        servings: servings,
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Tapped: ${titles[titleLength]}')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Use knobs above to test different content variations',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),

        // Story 3: Interactive Recipe Card with State Management
        WidgetbookUseCase(
          name: 'Interactive Recipe Card',
          builder: (context) {
            return StatefulWrapper(
              child: _InteractiveRecipeCardDemo(),
            );
          },
        ),

        // Story 4: Error and Edge Cases
        WidgetbookUseCase(
          name: 'Error and Edge Cases',
          builder: (context) {
            final errorType = context.knobs.list(
              label: 'Error Type',
              options: [
                'No Avatar',
                'Zero Rating',
                'Long Creator Name',
                'Invalid Image'
              ],
              initialOption: 'No Avatar',
            );

            RecipeCardData getRecipeForErrorType(String type) {
              switch (type) {
                case 'No Avatar':
                  return RecipeCardData(
                    id: '3',
                    title: 'Recipe with Creator Without Avatar',
                    imageUrl:
                        'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400',
                    creator: CreatorData(
                      name: 'Anonymous Chef',
                      avatarUrl: null, // No avatar URL
                    ),
                    rating: 3.5,
                    reviewCount: 12,
                    cookTime: '20 min',
                    servings: 2,
                  );
                case 'Zero Rating':
                  return RecipeCardData(
                    id: '4',
                    title: 'New Recipe with No Reviews',
                    imageUrl:
                        'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=400',
                    creator: CreatorData(
                      name: 'New Chef',
                      avatarUrl:
                          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
                    ),
                    rating: 0.0,
                    reviewCount: 0,
                    cookTime: '10 min',
                    servings: 1,
                  );
                case 'Long Creator Name':
                  return RecipeCardData(
                    id: '5',
                    title: 'Recipe by Chef with Very Long Name',
                    imageUrl:
                        'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400',
                    creator: CreatorData(
                      name: 'Chef Alessandro Giuseppe Francesca Maria',
                      avatarUrl:
                          'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=100',
                    ),
                    rating: 4.9,
                    reviewCount: 567,
                    cookTime: '90 min',
                    servings: 8,
                  );
                case 'Invalid Image':
                  return RecipeCardData(
                    id: '6',
                    title: 'Recipe with Broken Image',
                    imageUrl:
                        'https://invalid-url-that-will-fail.com/image.jpg',
                    creator: CreatorData(
                      name: 'Chef Error',
                      avatarUrl:
                          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
                    ),
                    rating: 2.5,
                    reviewCount: 3,
                    cookTime: '5 min',
                    servings: 1,
                  );
                default:
                  return RecipeCardData(
                    id: '7',
                    title: 'Default Recipe',
                    imageUrl:
                        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
                    creator: CreatorData(
                      name: 'Default Chef',
                      avatarUrl:
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
                    ),
                    rating: 4.0,
                    reviewCount: 50,
                    cookTime: '30 min',
                    servings: 4,
                  );
              }
            }

            return Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                children: [
                  const Text(
                    'Error and Edge Case Testing',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 320,
                    child: WCFeaturedRecipeCard(
                      recipe: getRecipeForErrorType(errorType),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error case tapped: $errorType')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Current test: $errorType',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  ];
}

/// Interactive demo widget with state management for testing user interactions
class _InteractiveRecipeCardDemo extends StatefulWidget {
  @override
  _InteractiveRecipeCardDemoState createState() =>
      _InteractiveRecipeCardDemoState();
}

class _InteractiveRecipeCardDemoState
    extends State<_InteractiveRecipeCardDemo> {
  int tapCount = 0;
  String lastTappedRecipe = 'None';

  final List<RecipeCardData> recipes = [
    RecipeCardData(
      id: 'demo1',
      title: 'Mediterranean Quinoa Bowl',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
      creator: CreatorData(
        name: 'Chef Elena',
        avatarUrl:
            'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=100',
      ),
      rating: 4.6,
      reviewCount: 178,
      cookTime: '20 min',
      servings: 2,
    ),
    RecipeCardData(
      id: 'demo2',
      title: 'Spicy Thai Green Curry',
      imageUrl:
          'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=400',
      creator: CreatorData(
        name: 'Chef Somchai',
        avatarUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
      ),
      rating: 4.9,
      reviewCount: 342,
      cookTime: '35 min',
      servings: 4,
    ),
    RecipeCardData(
      id: 'demo3',
      title: 'Classic French Croissants',
      imageUrl:
          'https://images.unsplash.com/photo-1555507036-ab794f4d4d94?w=400',
      creator: CreatorData(
        name: 'Chef Pierre',
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
      ),
      rating: 4.3,
      reviewCount: 89,
      cookTime: '3 hrs',
      servings: 6,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        children: [
          const Text(
            'Interactive Recipe Cards with State',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap Count: $tapCount | Last Tapped: $lastTappedRecipe',
            style: const TextStyle(fontSize: 14, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          ...recipes
              .map((recipe) => Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    width: 320,
                    child: WCFeaturedRecipeCard(
                      recipe: recipe,
                      onTap: () {
                        setState(() {
                          tapCount++;
                          lastTappedRecipe = recipe.title;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Tapped: ${recipe.title} (Total: $tapCount)'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ))
              .toList(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                tapCount = 0;
                lastTappedRecipe = 'None';
              });
            },
            child: const Text('Reset Counter'),
          ),
        ],
      ),
    );
  }
}

/// Utility widget to wrap StatefulWidget for Widgetbook
class StatefulWrapper extends StatelessWidget {
  final Widget child;

  const StatefulWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}
