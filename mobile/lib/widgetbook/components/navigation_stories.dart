import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_bottom_nav_item.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_back_button.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_menu_button.dart';
import 'package:worldchef_mobile/src/ui/organisms/wc_bottom_navigation.dart';

/// Navigation Component Stories
///
/// Demonstrates all navigation-related molecular components.
List<WidgetbookComponent> buildNavigationStories() {
  return [
    WidgetbookComponent(
      name: 'WCBottomNavItem',
      useCases: [
        WidgetbookUseCase(
          name: 'Interactive',
          builder: (context) {
            final isSelected = context.knobs.boolean(label: 'Selected');
            final isEnabled =
                context.knobs.boolean(label: 'Enabled', initialValue: true);

            return Theme(
              data: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
              child: Scaffold(
                backgroundColor: Colors.grey.shade200,
                body: Center(
                  child: WCBottomNavItem(
                    icon: Icons.home,
                    label: 'Home',
                    isSelected: isSelected,
                    enabled: isEnabled,
                    onTap: () {},
                  ),
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Selection Animation',
          builder: (context) => const BottomNavItemAnimationDemo(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'WorldChefBackButton',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) => Center(
            child: WorldChefBackButton(
              onPressed: () {},
            ),
          ),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'WCMenuButton',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) => Center(
            child: WCMenuButton(
              onPressed: () {},
            ),
          ),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Icon Button Animations',
      useCases: [
        WidgetbookUseCase(
            name: 'Hover and Press',
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          'Hover and press the buttons to see animations.'),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WorldChefBackButton(onPressed: () {}),
                          const SizedBox(width: 16),
                          WCMenuButton(onPressed: () {}),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Card(
                        color: Colors.amberAccent,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            '🔴 FAILING TEST:\\nButtons do not have the specified animated feedback.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
      ],
    ),
    WidgetbookComponent(
      name: 'WCBottomNavigation',
      useCases: [
        WidgetbookUseCase(
          name: 'Interactive',
          builder: (context) => const BottomNavigationDemo(),
        ),
      ],
    )
  ];
}

class BottomNavItemAnimationDemo extends StatefulWidget {
  const BottomNavItemAnimationDemo({super.key});

  @override
  State<BottomNavItemAnimationDemo> createState() =>
      _BottomNavItemAnimationDemoState();
}

class _BottomNavItemAnimationDemoState
    extends State<BottomNavItemAnimationDemo> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tap the item to see the selection animation.'),
            const SizedBox(height: 24),
            WCBottomNavItem(
              icon: Icons.home,
              label: 'Home',
              isSelected: _isSelected,
              onTap: () {
                setState(() {
                  _isSelected = !_isSelected;
                });
              },
            ),
            const SizedBox(height: 24),
            const Card(
              color: Colors.amberAccent,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '🔴 FAILING TEST:\\nThis item does not yet animate color and scale over 200ms.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigationDemo extends StatefulWidget {
  const BottomNavigationDemo({super.key});

  @override
  State<BottomNavigationDemo> createState() => _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Screen Content for Index $_currentIndex'),
      ),
      bottomNavigationBar: WCBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
