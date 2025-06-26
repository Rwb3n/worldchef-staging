import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/models/creator_data.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_star_rating_display.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_category_chip.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_flag_country_label.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_metadata_item.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_creator_info_row.dart';

/// Content Component Stories
///
/// Demonstrates all content-related molecular components.
List<WidgetbookComponent> buildContentStories() {
  return [
    WidgetbookComponent(
      name: 'WCStarRatingDisplay',
      useCases: [
        WidgetbookUseCase(
          name: 'High Rating',
          builder: (context) => Center(
            child: WCStarRatingDisplay(
              rating: 4.5,
              reviewCount: context.knobs.double.input(label: 'Review Count', initialValue: 128).toInt(),
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'Medium Rating',
          builder: (context) => Center(
            child: WCStarRatingDisplay(
              rating: 3,
              reviewCount: context.knobs.double.input(label: 'Review Count', initialValue: 42).toInt(),
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'Low Rating',
          builder: (context) => Center(
            child: WCStarRatingDisplay(
              rating: 1.5,
              reviewCount: context.knobs.double.input(label: 'Review Count', initialValue: 5).toInt(),
            ),
          ),
        ),
         WidgetbookUseCase(
          name: 'Zero Rating',
          builder: (context) => Center(
            child: WCStarRatingDisplay(
              rating: 0,
              reviewCount: context.knobs.double.input(label: 'Review Count', initialValue: 0).toInt(),
            ),
          ),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'WCCategoryChip',
      useCases: [
        WidgetbookUseCase(
          name: 'Interactive',
          builder: (context) {
            final isSelected = context.knobs.boolean(label: 'Selected', initialValue: false);
            return Center(
              child: WCCategoryChip(
                label: 'Vegetarian',
                icon: Icons.eco,
                isSelected: isSelected,
                onSelected: (_) {},
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Without Icon',
          builder: (context) {
            final isSelected = context.knobs.boolean(label: 'Selected', initialValue: true);
             return Center(
              child: WCCategoryChip(
                label: 'Quick & Easy',
                isSelected: isSelected,
                onSelected: (_) {},
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Selection Animation',
          builder: (context) => const ChipAnimationDemo(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'WCFlagCountryLabel',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) => Center(
            child: WCFlagCountryLabel(
              flagEmoji: context.knobs.string(label: 'Flag Emoji', initialValue: '🇺🇸'),
              countryName: context.knobs.string(label: 'Country Name', initialValue: 'United States'),
            ),
          ),
        ),
         WidgetbookUseCase(
          name: 'Long Name',
          builder: (context) => Center(
            child: SizedBox(
              width: 150,
              child: WCFlagCountryLabel(
                flagEmoji: '🇩🇪',
                countryName: 'Federal Republic of Germany',
              ),
            ),
          ),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'WCMetadataItem',
      useCases: [
        WidgetbookUseCase(
          name: 'Cook Time',
          builder: (context) => Center(
            child: WCMetadataItem(
              icon: Icons.access_time,
              label: context.knobs.string(label: 'Time', initialValue: '45 min'),
            ),
          ),
        ),
         WidgetbookUseCase(
          name: 'Servings',
          builder: (context) => Center(
            child: WCMetadataItem(
              icon: Icons.people_outline,
              label: context.knobs.string(label: 'Servings', initialValue: '4 servings'),
            ),
          ),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'WCCreatorInfoRow',
      useCases: [
        WidgetbookUseCase(
          name: 'Interactive',
          builder: (context) => Center(
            child: WCCreatorInfoRow(
              creator: CreatorData(
                name: context.knobs.string(
                  label: 'Creator Name',
                  initialValue: 'Gordon Ramsay',
                ),
                avatarUrl: context.knobs.string(
                  label: 'Avatar URL',
                  initialValue: 'https://i.pravatar.cc/48?u=gordon',
                ),
              ),
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'Without Avatar',
          builder: (context) => Center(
            child: WCCreatorInfoRow(
              creator: CreatorData(
                name: context.knobs.string(
                  label: 'Creator Name',
                  initialValue: 'Jamie Oliver',
                ),
              ),
            ),
          ),
        ),
      ],
    )
  ];
}

class ChipAnimationDemo extends StatefulWidget {
  const ChipAnimationDemo({super.key});

  @override
  State<ChipAnimationDemo> createState() => _ChipAnimationDemoState();
}

class _ChipAnimationDemoState extends State<ChipAnimationDemo> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tap the chip to see the selection animation.'),
            const SizedBox(height: 24),
            WCCategoryChip(
              label: 'Italian',
              icon: Icons.local_pizza_outlined,
              isSelected: _isSelected,
              onSelected: (bool selected) {
                setState(() {
                  _isSelected = selected;
                });
              },
            ),
            const SizedBox(height: 24),
            const Card(
              color: Colors.amberAccent,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '🔴 FAILING TEST:\\nChip does not animate background color on selection.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 