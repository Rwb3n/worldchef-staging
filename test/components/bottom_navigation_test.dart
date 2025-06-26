import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// RED step: WCBottomNavigation not yet implemented; this test will fail to compile
import 'package:worldchef_mobile/src/ui/organisms/wc_bottom_navigation.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart';

void main() {
  group('WCBottomNavigation visual contract', () {
    testWidgets('renders five nav items with correct height and background', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: WCBottomNavigation(
              currentIndex: 0,
              onTap: (_) {},
            ),
          ),
        ),
      );

      final navFinder = find.byType(WCBottomNavigation);
      expect(navFinder, findsOneWidget);

      // verify height
      final size = tester.getSize(navFinder);
      expect(size.height, WorldChefDimensions.bottomNavHeight);

      // verify background color
      final material = tester.widget<Material>(find.descendant(of: navFinder, matching: find.byType(Material)).first);
      expect(material.color, WorldChefColors.brandBlue);

      // verify 5 items
      final iconFinders = find.descendant(of: navFinder, matching: find.byType(Icon));
      expect(iconFinders, findsNWidgets(5));
    });
  });
} 