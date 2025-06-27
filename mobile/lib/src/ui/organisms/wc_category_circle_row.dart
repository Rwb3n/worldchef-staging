import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/models/category_data.dart'; // Import CategoryData
import 'package:worldchef_mobile/src/ui/molecules/wc_category_item.dart'; // Import WCCategoryItem

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
              child: WCCategoryItem( // Use WCCategoryItem
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
