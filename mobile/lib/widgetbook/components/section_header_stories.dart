import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_section_header.dart';

/// Section Header Component Stories - REFACTOR Step (Visual Validation)
///
/// These stories demonstrate the WCSectionHeader molecule component
/// with various configurations and states for visual validation.
List<WidgetbookComponent> buildSectionHeaderStories() {
  return [
    WidgetbookComponent(
      name: 'WCSectionHeader',
      useCases: [
        WidgetbookUseCase(
          name: 'Default Section Header',
          builder: (context) => const DefaultSectionHeader(),
        ),
        WidgetbookUseCase(
          name: 'Section Header Variants',
          builder: (context) => const SectionHeaderVariants(),
        ),
        WidgetbookUseCase(
          name: 'Interactive Section Header',
          builder: (context) => const InteractiveSectionHeader(),
        ),
      ],
    ),
  ];
}

/// Default Section Header showcase
class DefaultSectionHeader extends StatelessWidget {
  const DefaultSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WCSectionHeader - Default Usage',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            
            // Home Feed examples from specification
            WCSectionHeader(
              title: 'Taste by Country',
              onViewAllPressed: () {
                // Callback placeholder for Widgetbook
                print('View all pressed: Taste by Country');
              },
            ),
            
            const SizedBox(height: 32),
            
            WCSectionHeader(
              title: 'Taste by Diet',
              onViewAllPressed: () {
                print('View all pressed: Taste by Diet');
              },
            ),
            
            const SizedBox(height: 32),
            
            // Recipe Detail example
            WCSectionHeader(
              title: 'Nutrition Information',
              onViewAllPressed: () {
                print('View all pressed: Nutrition Information');
              },
            ),
            
            const SizedBox(height: 32),
            
            WCSectionHeader(
              title: 'Ingredients',
              onViewAllPressed: () {
                print('View all pressed: Ingredients');
              },
            ),
            
            const SizedBox(height: 24),
            
            // Design token validation card
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Design Token Compliance',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '✅ Title: WorldChefTextStyles.headlineSmall\n'
                      '✅ Link: WorldChefColors.brandBlue\n'
                      '✅ Padding: WorldChefSpacing.md (16dp)\n'
                      '✅ Layout: Row with MainAxisAlignment.spaceBetween',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section Header Variants showcase
class SectionHeaderVariants extends StatelessWidget {
  const SectionHeaderVariants({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WCSectionHeader - Variants',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            
            // With View All (default)
            const Text('With View All (default):'),
            const SizedBox(height: 8),
            WCSectionHeader(
              title: 'Featured Recipes',
              onViewAllPressed: () {},
            ),
            
            const SizedBox(height: 32),
            
            // Without View All
            const Text('Without View All:'),
            const SizedBox(height: 8),
            WCSectionHeader(
              title: 'Your Preferences',
              onViewAllPressed: () {},
              showViewAll: false,
            ),
            
            const SizedBox(height: 32),
            
            // Long title example
            const Text('Long Title Example:'),
            const SizedBox(height: 8),
            WCSectionHeader(
              title: 'Healthy Mediterranean Diet Recipes',
              onViewAllPressed: () {},
            ),
            
            const SizedBox(height: 32),
            
            // Short title example
            const Text('Short Title Example:'),
            const SizedBox(height: 8),
            WCSectionHeader(
              title: 'New',
              onViewAllPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// Interactive Section Header for testing callbacks
class InteractiveSectionHeader extends StatefulWidget {
  const InteractiveSectionHeader({super.key});

  @override
  State<InteractiveSectionHeader> createState() => _InteractiveSectionHeaderState();
}

class _InteractiveSectionHeaderState extends State<InteractiveSectionHeader> {
  int tapCount = 0;
  String lastTappedSection = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interactive WCSectionHeader',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            
            Text(
              'Tap counter: $tapCount\n'
              'Last tapped: $lastTappedSection',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            
            const SizedBox(height: 24),
            
            WCSectionHeader(
              title: 'Popular This Week',
              onViewAllPressed: () {
                setState(() {
                  tapCount++;
                  lastTappedSection = 'Popular This Week';
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            WCSectionHeader(
              title: 'Recently Added',
              onViewAllPressed: () {
                setState(() {
                  tapCount++;
                  lastTappedSection = 'Recently Added';
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            WCSectionHeader(
              title: 'Top Rated',
              onViewAllPressed: () {
                setState(() {
                  tapCount++;
                  lastTappedSection = 'Top Rated';
                });
              },
            ),
            
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tapCount = 0;
                  lastTappedSection = '';
                });
              },
              child: const Text('Reset Counter'),
            ),
          ],
        ),
      ),
    );
  }
} 