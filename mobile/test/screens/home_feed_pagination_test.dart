import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worldchef_mobile/src/screens/home_feed_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Home Feed – Pagination Integration Tests (RED→GREEN)', () {
    testWidgets(
      'loads next page when scrolled to bottom',
      (WidgetTester tester) async {
        await tester.pumpWidget(
            const ProviderScope(child: MaterialApp(home: HomeFeedScreen())));

        // Scroll to the bottom to trigger visibility of deeper items
        await tester.drag(
            find.byType(CustomScrollView), const Offset(0, -1500));
        await tester.pumpAndSettle();

        // Expect a widget from the second "page" (index 10)
        expect(find.text('Recipe 11'), findsOneWidget);
      },
    );
  });
}
