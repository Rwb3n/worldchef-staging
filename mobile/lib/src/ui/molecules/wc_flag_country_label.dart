import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/app_theme.dart';
import 'package:worldchef_mobile/src/core/design_system/spacing.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';

/// WCFlagCountryLabel - A molecule for displaying a country flag emoji and name.
///
/// Design Specifications:
/// - Format: "[Flag Emoji] [Country Name]"
/// - Typography: WCLabelSmall
/// - Spacing: WorldChefSpacing.xs between flag and text.
class WCFlagCountryLabel extends StatelessWidget {
  /// The flag emoji string.
  final String flagEmoji;

  /// The name of the country.
  final String countryName;

  final TextStyle? style;

  const WCFlagCountryLabel({
    super.key,
    required this.flagEmoji,
    required this.countryName,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          flagEmoji,
          style: const TextStyle(
              fontSize: 14), // Emojis have their own rendered size
        ),
        const SizedBox(width: WorldChefSpacing.xs),
        Flexible(
          child: Text(
            countryName,
            style: style ?? WorldChefTextStyles.labelSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
