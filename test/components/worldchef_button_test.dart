import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// RED STEP: This import will fail until WorldChefButton is implemented
import 'package:worldchef_mobile/src/ui/atoms/wc_button.dart';

void main() {
  group('WorldChefButton.primary visual contract', () {
    testWidgets('conforms to token specifications', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: WorldChefButton.primary(
                label: 'Start Cooking',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Act
      final buttonFinder = find.byType(WorldChefButton);

      // Assert – height
      final size = tester.getSize(buttonFinder);
      expect(size.height, 48.0, reason: 'Height must be WorldChefDimensions.buttonLarge (48)');

      // Assert – padding
      final paddingWidget = tester.widget<Padding>(find.descendant(of: buttonFinder, matching: find.byType(Padding)).first);
      expect(paddingWidget.padding, const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0));

      // Assert – background color
      final material = tester.widget<Material>(find.descendant(of: buttonFinder, matching: find.byType(Material)).first);
      expect((material.color as Color).value, 0xFFFF7247, reason: 'Background should be WorldChefColors.accentCoral');
    });
  });
} 