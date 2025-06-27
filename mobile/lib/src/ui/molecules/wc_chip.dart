import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';

class WCChip extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool enabled;
  final bool isSelected;

  const WCChip({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.enabled = true,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = WorldChefColors.accentOrange;
    final Color unselectedColor = WorldChefColors.accentOrange.withOpacity(0.1);

    final Color selectedForegroundColor = Colors.white;
    final Color unselectedForegroundColor = WorldChefColors.accentOrange;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected ? selectedColor : unselectedColor,
        borderRadius: BorderRadius.circular(WorldChefDimensions.radiusSmall),
      ),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(WorldChefDimensions.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: WorldChefDimensions.iconSmall,
                  color: isSelected
                      ? selectedForegroundColor
                      : unselectedForegroundColor,
                ),
                const SizedBox(width: WorldChefSpacing.xs),
              ],
              Text(
                label,
                style: WorldChefTextStyles.labelSmall.copyWith(
                  color: isSelected
                      ? selectedForegroundColor
                      : unselectedForegroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
