import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/app_theme.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';

/// WCStarRatingDisplay - Molecule component that displays star rating with value and count
///
/// This molecule follows the atomic design pattern and uses WorldChef design tokens
/// for consistent spacing, typography, and colors throughout the application.
///
/// Design System Compliance:
/// - Uses WorldChefSpacing.xs (4dp) for spacing between elements
/// - Uses WorldChefTextStyles.bodyMedium for rating text
/// - Uses WorldChefTextStyles.bodySmall for review count
/// - Uses WorldChefColors.accentOrange for star color
/// - Star size follows WorldChefDimensions.iconSmall (16dp)
class WCStarRatingDisplay extends StatelessWidget {
  /// Rating value (0.0 to 5.0)
  final double rating;

  /// Number of reviews
  final int reviewCount;

  const WCStarRatingDisplay({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Star icons display
        ..._buildStars(),

        SizedBox(width: WorldChefSpacing.xs), // 4dp spacing

        // Rating value
        Text(
          rating.toStringAsFixed(1),
          style: WorldChefTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(width: WorldChefSpacing.xs), // 4dp spacing

        // Review count in parentheses
        Text(
          '($reviewCount)',
          style: WorldChefTextStyles.bodySmall.copyWith(
            color: WorldChefColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Builds the star icons based on the rating value
  /// Creates 5 stars with appropriate fill state
  List<Widget> _buildStars() {
    List<Widget> stars = [];

    for (int i = 0; i < 5; i++) {
      Icon star;

      if (i < rating.floor()) {
        // Full star
        star = Icon(
          Icons.star,
          size: WorldChefDimensions.iconSmall, // 16dp
          color: WorldChefColors.accentOrange,
        );
      } else if (i < rating.ceil() && rating % 1 >= 0.5) {
        // Half star
        star = Icon(
          Icons.star_half,
          size: WorldChefDimensions.iconSmall, // 16dp
          color: WorldChefColors.accentOrange,
        );
      } else {
        // Empty star
        star = Icon(
          Icons.star_border,
          size: WorldChefDimensions.iconSmall, // 16dp
          color: WorldChefColors.neutralGray,
        );
      }

      stars.add(star);

      // Add small spacing between stars except for the last one
      if (i < 4) {
        stars.add(SizedBox(
            width: WorldChefSpacing.xs / 2)); // 2dp spacing between stars
      }
    }

    return stars;
  }
}
