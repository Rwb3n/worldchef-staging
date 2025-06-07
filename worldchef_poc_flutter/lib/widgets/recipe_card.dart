/* ANNOTATION_BLOCK_START
{
  "artifact_id": "flutter_recipe_card_widget",
  "version_tag": "1.0.0",
  "g_created": 14,
  "g_last_modified": 14,
  "description": "AI-generated recipe card widget using Material Design 3 with cached image loading, performance optimization, and accessibility features for WorldChef PoC.",
  "artifact_type": "UI_COMPONENT",
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Provides a reusable, performant recipe card component with cached image loading, Material Design 3 styling, and comprehensive accessibility support for the recipe list screen.",
  "key_logic_points": [
    "Material Design 3 card with elevation and rounded corners",
    "Cached network image loading with placeholder and error handling",
    "Responsive layout adapting to different screen sizes",
    "Proper semantic labels and accessibility support",
    "Efficient widget construction with const constructors",
    "Interactive touch feedback with hero animation support",
    "Star rating display with visual accessibility",
    "Time formatting and category badge display"
  ],
  "interfaces_provided": [
    {
      "name": "RecipeCard",
      "interface_type": "UI_WIDGET",
      "details": "Stateless widget displaying recipe information in card format with tap handling",
      "notes": "Designed for use in ListView.builder with optimal performance characteristics"
    }
  ],
  "requisites": [
    { "description": "Recipe model with image URL and metadata", "type": "DATA_MODEL" },
    { "description": "Material Design 3 theme configuration", "type": "UI_THEME" },
    { "description": "Network connectivity for image loading", "type": "RUNTIME_DEPENDENCY" }
  ],
  "external_dependencies": [
    { "name": "cached_network_image", "version": "^3.3.1", "reason": "Optimized image loading and caching for recipe photos" },
    { "name": "flutter_material", "version": "SDK", "reason": "Material Design 3 components and theming" }
  ],
  "internal_dependencies": ["flutter_recipe_models_manual"],
  "dependents": ["flutter_recipe_list_screen"],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "PLANNED - Widget testing for UI behavior and accessibility",
    "manual_review_comment": "AI-generated recipe card with Material Design 3, cached images, and performance optimization for Task F003."
  }
}
ANNOTATION_BLOCK_END */

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/recipe_manual.dart';
import '../l10n/app_localizations_helper.dart';

/// Recipe card widget with Material Design 3 styling and cached image loading.
/// 
/// Displays recipe information in a visually appealing card format with:
/// - Cached network image with placeholder and error handling
/// - Recipe title, rating, cook time, and category
/// - Interactive touch feedback and hero animation support
/// - Full accessibility support with semantic labels
/// - Responsive design for various screen sizes
class RecipeCard extends StatelessWidget {
  /// The recipe data to display
  final Recipe recipe;
  
  /// Callback when the card is tapped
  final VoidCallback? onTap;
  
  /// Optional hero tag for navigation animations
  final String? heroTag;
  
  /// Card elevation for Material Design
  final double elevation;
  
  /// Custom border radius (defaults to Material Design 3 standard)
  final BorderRadius? borderRadius;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.heroTag,
    this.elevation = 2.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    // Responsive card dimensions
    final cardBorderRadius = borderRadius ?? BorderRadius.circular(16.0);
    
    return Semantics(
      button: true,
      label: 'Recipe: ${recipe.title}, ${context.l10nInterpolate('rating', {'rating': recipe.ratingFormatted})}, ${recipe.totalTimeFormatted} cooking time, ${recipe.difficulty} difficulty',
      hint: 'Tap to view full recipe details and cooking instructions',
      child: Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: cardBorderRadius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe image with cached loading
              _buildRecipeImage(context),
              
              // Recipe content section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and category row
                    _buildTitleAndCategory(context, textTheme, colorScheme),
                    
                    const SizedBox(height: 8.0),
                    
                    // Rating and time row
                    _buildRatingAndTime(context, textTheme, colorScheme),
                    
                    const SizedBox(height: 4.0),
                    
                    // Difficulty badge
                    _buildDifficultyBadge(context, colorScheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the recipe image section with cached loading and accessibility
  Widget _buildRecipeImage(BuildContext context) {
    final imageWidget = Semantics(
      label: context.l10nInterpolate('recipeImage', {'recipeName': recipe.title}),
      image: true,
      child: CachedNetworkImage(
        imageUrl: recipe.imageUrl,
        height: 180.0,
        width: double.infinity,
        fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: 180.0,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: 180.0,
        color: Theme.of(context).colorScheme.errorContainer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 48.0,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Image unavailable',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
      memCacheHeight: 360, // 2x for retina displays
      maxWidthDiskCache: 800, // Reasonable cache size
      ),
    );

    // Wrap with hero animation if hero tag provided
    if (heroTag != null) {
      return Hero(
        tag: heroTag!,
        child: imageWidget,
      );
    }
    
    return imageWidget;
  }

  /// Builds title and category section
  Widget _buildTitleAndCategory(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recipe title (flexible to allow wrapping)
        Expanded(
          child: Text(
            recipe.title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            semanticsLabel: 'Recipe title: ${recipe.title}',
          ),
        ),
        
        const SizedBox(width: 8.0),
        
        // Category chip
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            recipe.category,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
            semanticsLabel: 'Category: ${recipe.category}',
          ),
        ),
      ],
    );
  }

  /// Builds rating and cooking time section
  Widget _buildRatingAndTime(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        // Star rating
        Semantics(
          label: 'Rating: ${recipe.ratingFormatted} out of 5 stars',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star,
                size: 16.0,
                color: Colors.amber[600],
              ),
              const SizedBox(width: 4.0),
              Text(
                recipe.ratingFormatted,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4.0),
              Text(
                '(${recipe.reviewCountFormatted})',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Cooking time
        Semantics(
          label: 'Total cooking time: ${recipe.totalTimeFormatted}',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                size: 16.0,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4.0),
              Text(
                recipe.totalTimeFormatted,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds difficulty level badge
  Widget _buildDifficultyBadge(BuildContext context, ColorScheme colorScheme) {
    final difficulty = recipe.difficultyLevel;
    
    // Determine colors based on difficulty
    Color badgeColor;
    Color textColor;
    
    switch (difficulty) {
      case RecipeDifficulty.easy:
        badgeColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case RecipeDifficulty.medium:
        badgeColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case RecipeDifficulty.hard:
        badgeColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
    }

    return Semantics(
      label: 'Difficulty level: ${difficulty.displayName}',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 2.0,
        ),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bar_chart,
              size: 12.0,
              color: textColor,
            ),
            const SizedBox(width: 4.0),
            Text(
              difficulty.displayName,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick recipe indicator badge for recipes under 30 minutes
class QuickRecipeBadge extends StatelessWidget {
  const QuickRecipeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Semantics(
      label: 'Quick recipe under 30 minutes',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6.0,
          vertical: 2.0,
        ),
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flash_on,
              size: 10.0,
              color: Colors.white,
            ),
            const SizedBox(width: 2.0),
            Text(
              'QUICK',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension for additional recipe card variations
extension RecipeCardVariations on RecipeCard {
  /// Creates a compact version of the recipe card for dense layouts
  static Widget compact({
    required Recipe recipe,
    VoidCallback? onTap,
    String? heroTag,
  }) {
    return SizedBox(
      height: 120.0,
      child: RecipeCard(
        recipe: recipe,
        onTap: onTap,
        heroTag: heroTag,
        elevation: 1.0,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
  
  /// Creates a featured version with larger images and enhanced styling
  static Widget featured({
    required Recipe recipe,
    VoidCallback? onTap,
    String? heroTag,
  }) {
    return RecipeCard(
      recipe: recipe,
      onTap: onTap,
      heroTag: heroTag,
      elevation: 8.0,
      borderRadius: BorderRadius.circular(20.0),
    );
  }
} 