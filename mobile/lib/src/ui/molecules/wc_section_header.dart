import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';

/// WCSectionHeader - Molecule-level component for section titles with optional "View all" action
/// 
/// From: docs/ui_specifications/design_system/atomic_design_components.md
/// Usage: Home Feed sections, Recipe Detail sections
/// 
/// Design token compliance:
/// - Title: WorldChefTextStyles.headlineSmall
/// - Link: WorldChefColors.brandBlue  
/// - Padding: WorldChefLayout.mobileContainerPadding
class WCSectionHeader extends StatelessWidget {
  const WCSectionHeader({
    super.key,
    required this.title,
    required this.onViewAllPressed,
    this.showViewAll = true,
  });

  final String title;
  final VoidCallback onViewAllPressed;
  final bool showViewAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: WorldChefSpacing.md, // 16dp mobile container padding
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            title,
            style: WorldChefTextStyles.headlineSmall,
          ),
          if (showViewAll)
            GestureDetector(
              onTap: onViewAllPressed,
              child: Text(
                'View all',
                style: TextStyle(
                  color: WorldChefColors.brandBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 