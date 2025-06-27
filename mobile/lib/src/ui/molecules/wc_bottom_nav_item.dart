import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/app_theme.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';

/// WCBottomNavItem - An individual item for the bottom navigation bar.
///
/// Handles selection state and tap events with animations.
class WCBottomNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool enabled;

  const WCBottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.enabled = true,
  });

  @override
  State<WCBottomNavItem> createState() => _WCBottomNavItemState();
}

class _WCBottomNavItemState extends State<WCBottomNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<FontWeight> _fontWeightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant WCBottomNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    _colorAnimation = ColorTween(
      begin: colorScheme.onSurfaceVariant,
      end: colorScheme.primary,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fontWeightAnimation =
        Tween<FontWeight>(begin: FontWeight.normal, end: FontWeight.bold)
            .animate(_controller);

    return InkWell(
      onTap: widget.enabled ? widget.onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final color = _colorAnimation.value;
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon,
                      color: widget.enabled ? color : color?.withOpacity(0.5)),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: WorldChefTextStyles.labelSmall.copyWith(
                      color: widget.enabled ? color : color?.withOpacity(0.5),
                      fontWeight: _fontWeightAnimation.value,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
