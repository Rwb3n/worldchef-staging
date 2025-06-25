import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/core/design_system/app_theme.dart';

// Design System Stories
import 'design_system/colors_stories.dart';
import 'design_system/typography_stories.dart';
import 'design_system/spacing_stories.dart';
import 'design_system/animations_stories.dart';

// Component Stories
import 'components/button_stories.dart';
import 'components/input_stories.dart';
import 'components/recipe_card_stories.dart';
import 'components/search_bar_stories.dart';

// Screen Stories
import 'screens/home_feed_stories.dart';
// import 'screens/recipe_detail_stories.dart'; // TODO: Create this file

/// WorldChef Widgetbook - Visual Design System & Component Catalogue
/// 
/// This is the RED step of TDD - stories will show placeholders/errors
/// until design system implementation is completed in task t002.
void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook(
      directories: [
        // Design System Category
        WidgetbookFolder(
          name: 'Design System',
          children: [
            WidgetbookFolder(
              name: 'Colors',
              children: buildColorStories(),
            ),
            WidgetbookFolder(
              name: 'Typography',
              children: buildTypographyStories(),
            ),
            WidgetbookFolder(
              name: 'Spacing',
              children: buildSpacingStories(),
            ),
            WidgetbookFolder(
              name: 'Animations',
              children: buildAnimationStories(),
            ),
          ],
        ),
        // Components Category
        WidgetbookFolder(
          name: 'Components',
          children: [
            WidgetbookFolder(
              name: 'Buttons',
              children: buildButtonStories(),
            ),
            WidgetbookFolder(
              name: 'Inputs',
              children: buildInputStories(),
            ),
            WidgetbookFolder(
              name: 'Recipe Cards',
              children: buildRecipeCardStories(),
            ),
            WidgetbookFolder(
              name: 'Search Bars',
              children: buildSearchBarStories(),
            ),
          ],
        ),
        // Screens Category
        WidgetbookFolder(
          name: 'Screens',
          children: [
            WidgetbookFolder(
              name: 'Home Feed',
              children: buildHomeFeedStories(),
            ),
            // TODO: Add Recipe Detail when file is created
          ],
        ),
      ],
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: AppTheme.lightTheme,
            ),
            WidgetbookTheme(
              name: 'Dark', 
              data: AppTheme.darkTheme,
            ),
          ],
        ),
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13,
            Devices.android.samsungGalaxyS20,
          ],
        ),
      ],
    );
  }
}


