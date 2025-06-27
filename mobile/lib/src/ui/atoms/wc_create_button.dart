import 'package:flutter/material.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';

/// Specialized create button variant
class WCCreateButton extends StatelessWidget {
  final VoidCallback onTapped;

  const WCCreateButton({super.key, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTapped,
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: WorldChefColors.brandBlue,
              width: 2.0,
              style: BorderStyle
                  .solid, // Note: Flutter doesn't support dotted borders natively
            ),
            color: Colors.transparent,
          ),
          child: Icon(
            Icons.add,
            color: WorldChefColors.brandBlue,
            size: 24.0,
          ),
        ),
      ),
    );
  }
}
