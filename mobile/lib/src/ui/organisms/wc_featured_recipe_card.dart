import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/app_theme.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_creator_info_row.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_star_rating_display.dart';
import 'package:worldchef_mobile/src/models/creator_data.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';

/// Data model for recipe card information
class RecipeCardData {
  final String id;
  final String title;
  final String imageUrl;
  final CreatorData creator;
  final double rating;
  final int reviewCount;
  final String cookTime;
  final int servings;

  RecipeCardData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.creator,
    required this.rating,
    required this.reviewCount,
    required this.cookTime,
    required this.servings,
  });
}

/// WCFeaturedRecipeCard - Organism component that displays a featured recipe card
/// 
/// This organism follows the atomic design pattern and uses WorldChef design tokens
/// for consistent spacing, typography, and colors throughout the application.
/// 
/// Design System Compliance:
/// - Uses WorldChefMedia.horizontalRatio (4:3) for card aspect ratio
/// - Uses WorldChefDimensions.radiusLarge (12dp) for card border radius
/// - Uses WorldChefSpacing tokens for consistent internal spacing
/// - Uses WorldChefTextStyles.headlineSmall for recipe title
/// - Composes WCCreatorInfoRow and WCStarRatingDisplay molecules
/// 
/// Features:
/// - 4:3 aspect ratio container with hero image background
/// - Recipe title with proper typography
/// - Creator information with avatar and name
/// - Star rating display with review count
/// - Cook time and servings metadata
/// - Tap handling for navigation
/// - Image loading with error handling
class WCFeaturedRecipeCard extends StatelessWidget {
  /// Recipe data to display
  final RecipeCardData recipe;
  
  /// Callback for when the card is tapped
  final VoidCallback onTap;

  const WCFeaturedRecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 4.0 / 3.0, // 4:3 aspect ratio as per design spec
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(WorldChefDimensions.radiusLarge), // 12dp
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(WorldChefDimensions.radiusLarge),
            child: Stack(
              children: [
                // Hero image background
                Positioned.fill(
                  child: Image.network(
                    recipe.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: WorldChefColors.neutralGray,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: WorldChefColors.textSecondary,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: WorldChefColors.neutralGray,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: WorldChefColors.brandBlue,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Gradient overlay for text readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                ),
                
                // Content overlay
                Positioned(
                  left: WorldChefSpacing.md, // 16dp padding
                  right: WorldChefSpacing.md,
                  bottom: WorldChefSpacing.md,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe title
                      Text(
                        recipe.title,
                        style: WorldChefTextStyles.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: WorldChefSpacing.sm), // 8dp spacing
                      
                      // Creator info row
                      Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: Theme.of(context).textTheme.apply(
                            bodyColor: Colors.white,
                            displayColor: Colors.white,
                          ),
                        ),
                        child: WCCreatorInfoRow(creator: recipe.creator),
                      ),
                      
                      SizedBox(height: WorldChefSpacing.xs), // 4dp spacing
                      
                      // Rating and metadata row
                      Row(
                        children: [
                          // Star rating display
                          Theme(
                            data: Theme.of(context).copyWith(
                              textTheme: Theme.of(context).textTheme.apply(
                                bodyColor: Colors.white,
                                displayColor: Colors.white,
                              ),
                            ),
                            child: WCStarRatingDisplay(
                              rating: recipe.rating,
                              reviewCount: recipe.reviewCount,
                            ),
                          ),
                          
                          const Spacer(),
                          
                          // Cook time
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: WorldChefDimensions.iconSmall, // 16dp
                                color: Colors.white.withOpacity(0.9),
                              ),
                              SizedBox(width: WorldChefSpacing.xs / 2), // 2dp spacing
                              Text(
                                recipe.cookTime,
                                style: WorldChefTextStyles.bodySmall.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(width: WorldChefSpacing.sm), // 8dp spacing
                          
                          // Servings
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people,
                                size: WorldChefDimensions.iconSmall, // 16dp
                                color: Colors.white.withOpacity(0.9),
                              ),
                              SizedBox(width: WorldChefSpacing.xs / 2), // 2dp spacing
                              Text(
                                '${recipe.servings} servings',
                                style: WorldChefTextStyles.bodySmall.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 