import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/ui/atoms/wc_button.dart';

/// Button Component Stories - GREEN Step (Interactive, token-compliant)
/// 
/// These stories demonstrate all WorldChef button variants and states interactively.
List<WidgetbookComponent> buildButtonStories() {
  return [
    WidgetbookComponent(
      name: 'Primary Buttons',
      useCases: [
        WidgetbookUseCase(
          name: 'Primary CTA',
          builder: (context) => Center(
            child: WorldChefButton.primary(
              label: 'Order Now',
              onPressed: () {},
              icon: Icons.shopping_cart,
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'Primary Button States',
          builder: (context) => ButtonStateDemo(variant: ButtonVariant.filled),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Secondary Buttons',
      useCases: [
        WidgetbookUseCase(
          name: 'Secondary Actions',
          builder: (context) => Center(
            child: WorldChefButton.secondary(
              label: 'Cancel',
              onPressed: () {},
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'Secondary Button States',
          builder: (context) => ButtonStateDemo(variant: ButtonVariant.outlined),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Icon Buttons',
      useCases: [
        WidgetbookUseCase(
          name: 'Icon Only',
          builder: (context) => Center(
            child: WorldChefButton.icon(
              icon: Icons.favorite,
              onPressed: () {},
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'Icon Button States',
          builder: (context) => ButtonStateDemo(variant: ButtonVariant.icon),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Chip Buttons',
      useCases: [
        WidgetbookUseCase(
          name: 'Category Chip',
          builder: (context) => Center(
            child: WorldChefButton.chip(
              label: 'Vegan',
              onPressed: () {},
              icon: Icons.eco,
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'Chip Button States',
          builder: (context) => ButtonStateDemo(variant: ButtonVariant.chip),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Material3 Variants',
      useCases: [
        WidgetbookUseCase(
          name: 'Filled Tonal',
          builder: (context) => Center(
            child: WorldChefButton(
              label: 'Tonal',
              onPressed: () {},
              variant: ButtonVariant.filledTonal,
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'Outlined',
          builder: (context) => Center(
            child: WorldChefButton(
              label: 'Outlined',
              onPressed: () {},
              variant: ButtonVariant.outlined,
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'Text',
          builder: (context) => Center(
            child: WorldChefButton(
              label: 'Text',
                onPressed: () {},
              variant: ButtonVariant.text,
            ),
                      ),
                    ),
                  ],
                ),
  ];
}

/// Interactive demo for all 5 MaterialStates
class ButtonStateDemo extends StatefulWidget {
  final ButtonVariant variant;
  const ButtonStateDemo({Key? key, required this.variant}) : super(key: key);

  @override
  State<ButtonStateDemo> createState() => _ButtonStateDemoState();
}

class _ButtonStateDemoState extends State<ButtonStateDemo> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SwitchListTile(
          title: const Text('Disabled'),
          value: _disabled,
          onChanged: (v) => setState(() => _disabled = v),
        ),
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) => setState(() => _pressed = false),
              onTapCancel: () => setState(() => _pressed = false),
              child: WorldChefButton(
                label: 'Demo',
                onPressed: _disabled ? null : () {},
                variant: widget.variant,
                enabled: !_disabled,
              ),
            ),
          ),
          ),
          const SizedBox(height: 16),
        Text('States: ' +
            (_hovered ? 'Hovered ' : '') +
            (_pressed ? 'Pressed ' : '') +
            (_focused ? 'Focused ' : '') +
            (_disabled ? 'Disabled' : 'Enabled')),
      ],
    );
  }
} 