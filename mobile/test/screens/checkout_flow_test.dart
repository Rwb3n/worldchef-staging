import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldchef_mobile/src/screens/checkout_screen.dart';

void main() {
  group('Checkout Flow – Stripe integration (RED)', () {
    testWidgets('tapping Pay launches Stripe sheet', (tester) async {
      await tester.pumpWidget(const ProviderScope(
        child: MaterialApp(home: CheckoutScreen()),
      ));

      // Tap Pay button
      await tester.tap(find.text('Pay'));
      await tester.pump();

      // Expect the Stripe sheet placeholder to appear – will FAIL until implemented
      expect(find.byKey(const Key('stripeSheet')), findsOneWidget);
    });
  });
}
