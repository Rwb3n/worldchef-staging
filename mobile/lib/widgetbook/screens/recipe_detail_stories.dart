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
          final state = context.knobs.list<ScreenState>(
            label: 'Screen State',
            options: ScreenState.values,
            labelBuilder: (value) => value.toString().split('.').last,
          );

          return RecipeDetailScreen(
            state: state,
          );
        },
      ),
    ],
  );
} 