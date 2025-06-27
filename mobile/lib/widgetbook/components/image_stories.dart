import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/ui/atoms/wc_circular_image.dart';
import 'package:worldchef_mobile/src/ui/atoms/wc_thumbnail_image.dart';
import 'package:worldchef_mobile/src/core/design_system/app_theme.dart';

/// Image Component Stories
///
/// Demonstrates all image-related atomic components.
List<WidgetbookComponent> buildImageStories() {
  return [
    WidgetbookComponent(
      name: 'WCCircularImage',
      useCases: [
        WidgetbookUseCase(
          name: 'Category Image',
          builder: (context) => Center(
            child: WCCircularImage(
              imageUrl:
                  'https://placehold.co/60x60/E91E63/FFFFFF/png', // Placeholder
              size: 60,
              onTap: () {},
              semanticLabel: 'Browse category',
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'Creator Avatar',
          builder: (context) => Center(
            child: WCCircularImage(
              imageUrl:
                  'https://placehold.co/48x48/3F51B5/FFFFFF/png', // Placeholder
              size: 48,
              onTap: () {},
              semanticLabel: 'View creator profile',
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'With Placeholder',
          builder: (context) => Center(
            child: WCCircularImage(
              imageUrl: 'invalid-url', // Will trigger placeholder
              size: 60,
              onTap: () {},
              placeholder: const Icon(Icons.person, color: Colors.white),
              semanticLabel: 'Image with placeholder',
            ),
          ),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'WCThumbnailImage',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) => Center(
            child: WCThumbnailImage(
              imageUrl: 'https://placehold.co/80x80/2196F3/FFFFFF/png',
              size: 80,
              onTap: () {},
              semanticLabel: 'Thumbnail image',
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'With Overlay',
          builder: (context) => Center(
            child: WCThumbnailImage(
              imageUrl: 'https://placehold.co/120x120/4CAF50/FFFFFF/png',
              size: 120,
              onTap: () {},
              semanticLabel: 'Country thumbnail',
              overlay: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '🇫🇷 France',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  ];
}
