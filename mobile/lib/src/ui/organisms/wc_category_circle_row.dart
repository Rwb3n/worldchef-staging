import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/ui/atoms/wc_circular_image.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';

/// Category data model for the row component
class CategoryData {
  final String name;
  final String? id;
  final String? imageUrl;
  final bool isCreateButton;

  CategoryData({
    required this.name,
    this.id,
    this.imageUrl,
    this.isCreateButton = false,
  });
}

/// WorldChef Category Circle Row Organism
/// 
/// A horizontal scrollable row of circular category images with labels.
/// Displays food categories in an engaging, visual format.
/// 
/// Design Specifications:
/// - Layout: Horizontal scroll with category circles
/// - Spacing: 8dp between items (WorldChefSpacing.sm)
/// - Circle Size: 60dp diameter as per design system
/// - Typography: Consistent with design tokens
/// - Special Handling: Create button with dotted border
/// 
/// Author: WorldChef Mobile Team
/// Date: 2025-06-26
/// Global Event: 161 (Implementation of WCCategoryCircleRow organism)
class WCCategoryCircleRow extends StatelessWidget {
  /// List of categories to display
  final List<CategoryData> categories;
  
  /// Callback when a category is tapped
  final Function(CategoryData) onCategoryTapped;
  
  /// Height of the entire row component
  final double height;

  const WCCategoryCircleRow({
    super.key,
    required this.categories,
    required this.onCategoryTapped,
    this.height = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: WorldChefSpacing.md),
        child: Row(
          children: categories.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            
            return Padding(
              padding: EdgeInsets.only(
                right: index < categories.length - 1 ? WorldChefSpacing.sm : 0,
              ),
              child: _CategoryItem(
                category: category,
                onTapped: () => onCategoryTapped(category),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Individual category item with circle and label
class _CategoryItem extends StatelessWidget {
  final CategoryData category;
  final VoidCallback onTapped;

  const _CategoryItem({
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
          _CreateButton(onTapped: onTapped)
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

/// Specialized create button variant
class _CreateButton extends StatelessWidget {
  final VoidCallback onTapped;

  const _CreateButton({required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTapped,
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: WorldChefColors.brandBlue,
              width: 2.0,
              style: BorderStyle.solid, // Note: Flutter doesn't support dotted borders natively
            ),
            color: Colors.transparent,
          ),
          child: Icon(
            Icons.add,
            color: WorldChefColors.brandBlue,
            size: 24.0,
          ),
        ),
      ),
    );
  }
} 