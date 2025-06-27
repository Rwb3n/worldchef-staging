import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/screens/recipe_detail_screen.dart';

/// Screen-level stories for the Recipe Detail page.
WidgetbookComponent buildRecipeDetailStories() {
  return WidgetbookComponent(
    name: 'RecipeDetailScreen',
    useCases: [
      WidgetbookUseCase(
        name: 'Interactive States',
        builder: (context) {
          return const RecipeDetailScreen();
        },
      ),
    ],
  );
}
