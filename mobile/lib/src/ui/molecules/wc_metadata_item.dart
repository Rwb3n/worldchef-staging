import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/app_theme.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';

/// WCMetadataItem - A molecule for displaying an icon and a text label.
///
/// Used for items like cook time, servings, etc.
///
/// Design Specifications:
/// - Icon: WCIconSmall (16dp)
/// - Text: WCBodySmall
/// - Spacing: WorldChefSpacing.sm (8dp) between icon and text.
class WCMetadataItem extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// The text label.
  final String label;

  const WCMetadataItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: WorldChefDimensions.iconSmall,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: WorldChefSpacing.sm),
        Text(
          label,
          style: WorldChefTextStyles.bodySmall,
        ),
      ],
    );
  }
}
