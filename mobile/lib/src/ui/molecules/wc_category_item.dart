import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/ui/atoms/wc_circular_image.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';
import 'package:worldchef_mobile/src/models/category_data.dart'; // Import CategoryData
import 'package:worldchef_mobile/src/ui/atoms/wc_create_button.dart'; // Import WCCreateButton

/// Individual category item with circle and label
class WCCategoryItem extends StatelessWidget {
  final CategoryData category;
  final VoidCallback onTapped;

  const WCCategoryItem({
    super.key,
    required this.category,
    required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Category Circle
        if (category.isCreateButton)
          WCCreateButton(onTapped: onTapped) // Use WCCreateButton
        else
          WCCircularImage(
            imageUrl: category.imageUrl ?? '',
            size: 60.0,
            onTap: onTapped,
            semanticLabel: '${category.name} category',
            placeholder: category.imageUrl == null ? _buildPlaceholder() : null,
          ),

        // Category Label
        SizedBox(height: WorldChefSpacing.xs),
        SizedBox(
          width: 70.0, // Slightly larger than circle for text wrapping
          child: Text(
            category.name,
            style: WorldChefTextStyles.bodySmall.copyWith(
              color: WorldChefColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: WorldChefColors.surfaceVariant,
        border: Border.all(
          color: WorldChefColors.outline,
          width: 1.0,
        ),
      ),
      child: Icon(
        Icons.image,
        color: WorldChefColors.textSecondary,
        size: 24.0,
      ),
    );
  }
}