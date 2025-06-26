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
import 'components/section_header_stories.dart';
import 'components/category_circle_row_stories.dart';
import 'components/featured_recipe_card_stories.dart';
import 'components/image_stories.dart';
import 'components/content_stories.dart';
import 'components/navigation_stories.dart';

// Screen Stories
import 'screens/home_feed_stories.dart';
import 'screens/recipe_detail_stories.dart';

/// WorldChef Widgetbook - Visual Design System & Component Catalogue
/// 
/// This is the GREEN step of TDD - design system implementation completed
/// and all stories now show functional components and design tokens.
void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      appBuilder: (context, child) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
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
              name: 'Navigation',
              children: buildNavigationStories(),
            ),
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
            WidgetbookFolder(
              name: 'Section Headers',
              children: buildSectionHeaderStories(),
            ),
            WidgetbookFolder(
              name: 'Content',
              children: buildContentStories(),
            ),
            WidgetbookFolder(
              name: 'Images',
              children: buildImageStories(),
            ),
            WidgetbookFolder(
              name: 'Category Circle Row',
              children: categoryCircleRowStories().useCases,
            ),
            WidgetbookFolder(
              name: 'Featured Recipe Card',
              children: buildFeaturedRecipeCardStories()
                  .map((e) => WidgetbookFolder(name: e.name, children: e.useCases))
                  .toList(),
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
            WidgetbookFolder(
              name: 'Recipe Detail',
              children: buildRecipeDetailStories().useCases,
            ),
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


