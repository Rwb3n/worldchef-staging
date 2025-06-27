import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef_mobile/src/core/design_system/dimensions.dart'
    show WorldChefDimensions;
import 'package:worldchef_mobile/src/core/design_system/spacing.dart'
    show WorldChefSpacing;

void main() {
  group('Design system token exposure', () {
    test('WorldChefDimensions exposes primary size constants', () {
      expect(WorldChefDimensions.buttonLarge, 48.0);
      expect(WorldChefDimensions.bottomNavHeight, 56.0);
      expect(WorldChefDimensions.iconMedium, 24.0);
    });

    test('WorldChefSpacing exposes spacing scale constants', () {
      expect(WorldChefSpacing.md, 16.0);
      expect(WorldChefSpacing.sm, 8.0);
      expect(WorldChefSpacing.xl, 32.0);
    });
  });
}
