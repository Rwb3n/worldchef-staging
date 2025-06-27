import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('featured_recipe_card_stories.dart has updated signature', () {
    final file =
        File('lib/widgetbook/components/featured_recipe_card_stories.dart');
    expect(file.existsSync(), isTrue,
        reason: 'featured_recipe_card_stories.dart does not exist');

    final content = file.readAsStringSync();

    final hasOldSignature =
        RegExp(r'Widget\s+featuredRecipeCardStories\s*\(\s*BuildContext')
            .hasMatch(content);
    final hasNewReturnType = RegExp(
            r'List<\s*WidgetbookComponent\s*>\s+buildFeaturedRecipeCardStories\s*\(')
        .hasMatch(content);

    // The test should fail until the old signature is removed and the new one introduced.
    expect(hasOldSignature, isFalse,
        reason:
            'Old signature using BuildContext parameter still present. Please refactor to `List<WidgetbookComponent> buildFeaturedRecipeCardStories()`');
    expect(hasNewReturnType, isTrue,
        reason:
            'Refactored function `buildFeaturedRecipeCardStories` returning List<WidgetbookComponent> is missing.');
  });
}
