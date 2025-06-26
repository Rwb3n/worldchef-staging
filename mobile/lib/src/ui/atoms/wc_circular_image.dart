import 'package:flutter/material.dart';

/// WorldChef Circular Image Atom
/// 
/// A reusable circular image component that maintains perfect circle proportions
/// and handles user interactions. Used primarily in category displays.
/// 
/// Design Specifications:
/// - Size: Configurable, typically 60dp for categories
/// - Shape: Perfect circle with appropriate clipping
/// - Interaction: Tap handling with visual feedback
/// - Accessibility: Semantic labels and tap targets
/// 
/// Author: WorldChef Mobile Team
/// Date: 2025-06-26
/// Global Event: 161 (Implementation of WCCircularImage atom)
class WCCircularImage extends StatelessWidget {
  /// The image URL to display in the circle
  final String imageUrl;
  
  /// The diameter of the circular image
  final double size;
  
  /// Callback for tap events
  final VoidCallback onTap;
  
  /// Optional placeholder widget when image fails to load
  final Widget? placeholder;
  
  /// Optional semantic label for accessibility
  final String? semanticLabel;

  const WCCircularImage({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.onTap,
    this.placeholder,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Circular image',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size / 2),
          child: Container(
            width: size,
            height: size,
            constraints: BoxConstraints(
              maxWidth: size,
              maxHeight: size,
              minWidth: size,
              minHeight: size,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // Error handling for failed image loads
                  debugPrint('Failed to load image: $imageUrl');
                },
              ),
            ),
            child: placeholder != null 
                ? Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Center(child: placeholder),
                  )
                : null,
          ),
        ),
      ),
    );
  }
} 