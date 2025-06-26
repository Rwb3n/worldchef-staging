import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';

/// WorldChef Thumbnail Image Atom
///
/// A reusable square image component with rounded corners.
/// Used for displaying content like countries or ingredients.
///
/// Design Specifications:
/// - Aspect Ratio: 1:1 (Square)
/// - Border Radius: WorldChefDimensions.radiusMedium (8dp)
/// - Child: Can contain overlays, text, or other widgets.
class WCThumbnailImage extends StatelessWidget {
  /// The image URL to display.
  final String imageUrl;

  /// The widget to display on top of the image (e.g., a label).
  final Widget? overlay;

  /// The size (width and height) of the square thumbnail.
  final double size;

  /// Callback for tap events.
  final VoidCallback? onTap;
  
  /// Semantic label for accessibility.
  final String? semanticLabel;

  const WCThumbnailImage({
    super.key,
    required this.imageUrl,
    this.overlay,
    this.size = 80.0,
    this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(WorldChefDimensions.radiusMedium),
          child: Container(
            width: size,
            height: size,
            color: Colors.grey.shade200, // Placeholder background
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, color: Colors.grey);
                  },
                ),
                if (overlay != null)
                  Positioned.fill(
                    child: overlay!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 