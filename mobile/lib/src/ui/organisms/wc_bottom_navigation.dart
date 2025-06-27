import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';
import 'package:worldchef_mobile/src/models/bottom_nav_item_data.dart';

/// Token-compliant bottom navigation bar used across all screens.
class WCBottomNavigation extends StatelessWidget {
  const WCBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    List<BottomNavItemData>? items,
  })  : items = items ?? _defaultItems,
        super(key: key);

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItemData> items;

  // Fallback list used by legacy tests that instantiate WCBottomNavigation
  // without passing explicit items.
  static const List<BottomNavItemData> _defaultItems = [
    BottomNavItemData(label: 'Home', icon: Icons.home),
    BottomNavItemData(label: 'Explore', icon: Icons.travel_explore),
    BottomNavItemData(label: 'Planner', icon: Icons.calendar_month),
    BottomNavItemData(label: 'Profile', icon: Icons.account_circle),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: WorldChefColors.brandBlue,
      child: SizedBox(
        height: WorldChefDimensions.bottomNavHeight,
        child: Row(
          children: List.generate(items.length, (index) {
            final isActive = index == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[index].icon,
                      size: WorldChefDimensions.iconMedium,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[index].label,
                      style: WorldChefTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
