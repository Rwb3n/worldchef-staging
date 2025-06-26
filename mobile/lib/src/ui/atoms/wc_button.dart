import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart' as ds show WorldChefLayout;

/// WorldChefButton – token-compliant button atom
///
/// Variants: primary, secondary, icon, chip, filled, filledTonal, outlined, text
class WorldChefButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final bool enabled;
  final bool isSelected;

  const WorldChefButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = ButtonVariant.filled,
    this.enabled = true,
    this.isSelected = false,
  }) : super(key: key);

  /// Factory constructors for convenience
  factory WorldChefButton.primary({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    bool enabled = true,
    Key? key,
  }) => WorldChefButton(
    label: label,
    onPressed: onPressed,
    icon: icon,
    variant: ButtonVariant.filled,
    enabled: enabled,
    isSelected: false,
    key: key,
  );

  factory WorldChefButton.secondary({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    bool enabled = true,
    Key? key,
  }) => WorldChefButton(
    label: label,
    onPressed: onPressed,
    icon: icon,
    variant: ButtonVariant.outlined,
    enabled: enabled,
    isSelected: false,
    key: key,
  );

  factory WorldChefButton.icon({
    required IconData icon,
    required VoidCallback? onPressed,
    bool enabled = true,
    Key? key,
  }) => WorldChefButton(
    label: '',
    onPressed: onPressed,
    icon: icon,
    variant: ButtonVariant.icon,
    enabled: enabled,
    isSelected: false,
    key: key,
  );

  factory WorldChefButton.chip({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    bool enabled = true,
    bool isSelected = false,
    Key? key,
  }) => WorldChefButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
    variant: ButtonVariant.chip,
    enabled: enabled,
    isSelected: isSelected,
      key: key,
    );

  @override
  State<WorldChefButton> createState() => _WorldChefButtonState();
}

enum ButtonVariant { filled, filledTonal, outlined, text, icon, chip }

class _WorldChefButtonState extends State<WorldChefButton> with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      value: 0.0,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variant == ButtonVariant.chip) {
      return _buildChip(context);
    }

    final style = _getButtonStyle(widget.variant);
    final child = widget.icon == null
        ? Text(widget.label, style: WorldChefTextStyles.labelLarge)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
              Icon(widget.icon, size: WorldChefDimensions.iconMedium),
              if (widget.label.isNotEmpty) ...[
                  const SizedBox(width: 8),
                Text(widget.label, style: WorldChefTextStyles.labelLarge),
                ],
            ],
          );
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, childWidget) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ElevatedButton(
              onPressed: widget.enabled ? widget.onPressed : null,
              style: style,
              child: Padding(
                padding: ds.WorldChefLayout.primaryButtonPadding,
                child: child,
              ),
            ),
          );
        },
        child: child,
      ),
    );
  }

  Widget _buildChip(BuildContext context) {
    final chipTheme = Theme.of(context).chipTheme;
    final isSelected = widget.isSelected;
    
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
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(WorldChefDimensions.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: WorldChefDimensions.iconSmall,
                  color: isSelected ? selectedForegroundColor : unselectedForegroundColor,
                ),
                const SizedBox(width: WorldChefSpacing.xs),
              ],
              Text(
                widget.label,
                style: WorldChefTextStyles.labelSmall.copyWith(
                  color: isSelected ? selectedForegroundColor : unselectedForegroundColor,
                ),
              ),
            ],
          ),
              ),
      ),
    );
  }

  ButtonStyle _getButtonStyle(ButtonVariant variant) {
    switch (variant) {
      case ButtonVariant.filled:
        return ElevatedButton.styleFrom(
          backgroundColor: WorldChefColors.secondaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(WorldChefDimensions.buttonLarge),
          padding: ds.WorldChefLayout.primaryButtonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WorldChefDimensions.radiusMedium),
          ),
          textStyle: WorldChefTextStyles.labelLarge,
        );
      case ButtonVariant.outlined:
        return OutlinedButton.styleFrom(
          foregroundColor: WorldChefColors.brandBlue,
          side: BorderSide(color: WorldChefColors.brandBlue, width: 2),
          minimumSize: const Size.fromHeight(WorldChefDimensions.buttonMedium),
          padding: ds.WorldChefLayout.secondaryButtonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WorldChefDimensions.radiusMedium),
          ),
          textStyle: WorldChefTextStyles.labelLarge,
        );
      case ButtonVariant.icon:
        return IconButton.styleFrom(
          foregroundColor: WorldChefColors.brandBlue,
          backgroundColor: Colors.transparent,
          minimumSize: const Size.square(44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WorldChefDimensions.radiusMedium),
          ),
        );
      case ButtonVariant.chip:
        return OutlinedButton.styleFrom();
      case ButtonVariant.filledTonal:
        return ElevatedButton.styleFrom(
          backgroundColor: WorldChefColors.secondaryGreen.withOpacity(0.7),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(WorldChefDimensions.buttonLarge),
          padding: ds.WorldChefLayout.primaryButtonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WorldChefDimensions.radiusMedium),
          ),
          textStyle: WorldChefTextStyles.labelLarge,
        );
      case ButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: WorldChefColors.brandBlue,
          minimumSize: const Size.fromHeight(WorldChefDimensions.buttonMedium),
          padding: ds.WorldChefLayout.secondaryButtonPadding,
          textStyle: WorldChefTextStyles.labelLarge,
        );
    }
  }
} 