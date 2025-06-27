import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';

void main() {
  group('Design-token alias coverage', () {
    test('WorldChefColors exposes required alias tokens', () {
      // The mere act of referencing these constants forces compilation to fail
      // if they are missing. The expectations ensure the test suite reports
      // a RED step until the aliases are implemented (Task t002).
      expect(WorldChefColors.neutralGray, isNotNull);
      expect(WorldChefColors.textSecondary, isNotNull);
      expect(WorldChefColors.surfaceVariant, isNotNull);
      expect(WorldChefColors.outline, isNotNull);
    });
  });
}
