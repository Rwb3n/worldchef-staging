import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';

/// Token-compliant bottom navigation bar used across all screens.
class WCBottomNavigation extends StatelessWidget {
  const WCBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const navLabels = ['feed', 'Explore', '+', 'Plans', 'You'];
    const navIcons = [
      Icons.rss_feed_outlined,
      Icons.search_outlined,
      Icons.add,
      Icons.calendar_today_outlined,
      Icons.person_outline,
    ];

    return Material(
      color: WorldChefColors.brandBlue,
      child: SizedBox(
        height: WorldChefDimensions.bottomNavHeight,
        child: Row(
          children: List.generate(navIcons.length, (index) {
            final isActive = index == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      navIcons[index],
                      size: WorldChefDimensions.iconMedium,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      navLabels[index],
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