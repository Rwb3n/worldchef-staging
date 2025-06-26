import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/ui/atoms/wc_button.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';

/// WCCategoryChip - A molecule for displaying a selectable category chip.
///
/// This component uses the `WorldChefButton.chip` factory for its base styling
/// and adds selection state logic and animation.
///
/// Design Specifications:
/// - States: Selected, Unselected
/// - Interaction: Tap to toggle selection
class WCCategoryChip extends StatefulWidget {
  /// The text label for the chip.
  final String label;

  /// The icon to display before the label.
  final IconData? icon;

  /// Whether the chip is currently selected.
  final bool isSelected;

  /// Callback when the selection state changes.
  final ValueChanged<bool> onSelected;

  const WCCategoryChip({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  State<WCCategoryChip> createState() => _WCCategoryChipState();
}

class _WCCategoryChipState extends State<WCCategoryChip> {
  @override
  Widget build(BuildContext context) {
    return WorldChefButton.chip(
      label: widget.label,
      icon: widget.icon,
      isSelected: widget.isSelected, // Pass selection state to the button
      onPressed: () {
        widget.onSelected(!widget.isSelected);
      },
    );
  }
} 