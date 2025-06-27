import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldchef_mobile/src/screens/recipe_detail_screen.dart';

void main() {
  group('Recipe Detail – Optimistic Like (RED)', () {
    testWidgets('taps like button toggles to filled heart immediately',
        (tester) async {
      await tester.pumpWidget(const ProviderScope(
        child: MaterialApp(home: RecipeDetailScreen()),
      ));

      // Initial state should be outline heart
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);

      // Tap like button
      await tester.tap(find.byKey(const Key('likeButton')));
      await tester.pump();

      // Expect filled heart – this will FAIL until implementation
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}
