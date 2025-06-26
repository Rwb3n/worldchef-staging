import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/ui/atoms/wc_button.dart';

/// WCMenuButton - A pre-configured icon button for opening menus.
///
/// Wraps the `WorldChefButton.icon` factory for consistency.
class WCMenuButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const WCMenuButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return WorldChefButton.icon(
      icon: Icons.more_vert,
      onPressed: onPressed,
    );
  }
} 