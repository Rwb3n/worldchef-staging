import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/models/creator_data.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/app_theme.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';

/// WCCreatorInfoRow - Molecule component that displays creator avatar and name
///
/// This molecule follows the atomic design pattern and uses WorldChef design tokens
/// for consistent spacing, typography, and colors throughout the application.
///
/// Design System Compliance:
/// - Uses WorldChefSpacing.sm (8dp) for spacing between avatar and name
/// - Uses WorldChefTextStyles.bodyMedium for creator name text
/// - Avatar size follows material design guidelines (24dp for compact display)
/// - Handles missing avatar URLs gracefully with initials fallback
class WCCreatorInfoRow extends StatelessWidget {
  /// Creator data containing name and optional avatar URL
  final CreatorData creator;

  const WCCreatorInfoRow({
    super.key,
    required this.creator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Creator avatar - uses CircleAvatar with network image or initials fallback
        CircleAvatar(
          radius: 12, // 24dp diameter for compact display
          backgroundColor: WorldChefColors.neutralGray,
          backgroundImage: creator.avatarUrl != null
              ? NetworkImage(creator.avatarUrl!)
              : null,
          child: creator.avatarUrl == null
              ? Text(
                  _getInitials(creator.name),
                  style: WorldChefTextStyles.labelSmall.copyWith(
                    color: WorldChefColors.textSecondary,
                  ),
                )
              : null,
        ),

        SizedBox(
            width: WorldChefSpacing.sm), // 8dp spacing between avatar and name

        // Creator name
        Flexible(
          child: Text(
            creator.name,
            style: WorldChefTextStyles.bodyMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  /// Extracts initials from the creator name for avatar fallback
  /// Takes first letter of first two words, uppercase
  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
}
