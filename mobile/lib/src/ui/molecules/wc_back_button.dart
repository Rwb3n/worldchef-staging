import 'package:flutter/material.dart';

/// WorldChefBackButton - standardized back navigation button for WorldChef.
///
/// Uses the platform-adaptive back icon and zero elevation to integrate with
/// custom AppBars. Color defaults to `Theme.of(context).colorScheme.onBackground`,
/// but can be overridden. Sized identically to an [IconButton].
class WorldChefBackButton extends StatelessWidget {
  const WorldChefBackButton({super.key, this.onPressed, this.color});

  /// Callback when the button is tapped.
  final VoidCallback? onPressed;

  /// Optional override for icon color.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      visualDensity: VisualDensity.compact,
      color: color ?? Theme.of(context).colorScheme.onBackground,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
    );
  }
}

// Temporary typedef for backward compatibility while migrating codebase.
@deprecated
typedef WCBackButton = WorldChefBackButton; 