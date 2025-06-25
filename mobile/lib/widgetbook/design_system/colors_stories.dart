import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/core/design_system/colors.dart';

/// Color System Stories - GREEN Step (Implementation Complete)
///
/// These stories demonstrate the WorldChef color system using the
/// implemented design tokens from task t002.
List<WidgetbookComponent> buildColorStories() {
  return [
    WidgetbookComponent(
      name: 'Brand Colors',
      useCases: [
        WidgetbookUseCase(
          name: 'Primary Brand Palette',
          builder: (context) => const BrandColorPalette(),
        ),
        WidgetbookUseCase(
          name: 'Brand Color States',
          builder: (context) => const BrandColorStates(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Semantic Colors',
      useCases: [
        WidgetbookUseCase(
          name: 'Success, Warning, Error',
          builder: (context) => const SemanticColorPalette(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Contrast Validation',
      useCases: [
        WidgetbookUseCase(
          name: 'WCAG AA Compliance',
          builder: (context) => const ContrastValidationGrid(),
        ),
      ],
    ),
  ];
}

/// Brand Color Palette Showcase
class BrandColorPalette extends StatelessWidget {
  const BrandColorPalette({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Material Design 3 Roles',
            style: textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),

          // GREEN STEP: Using actual ColorScheme roles
          _buildColorCard(
            'Primary',
            'The primary color for major UI elements.',
            colorScheme.primary,
            'colorScheme.primary',
          ),
          _buildColorCard(
            'Secondary',
            'An accent color for less prominent components.',
            colorScheme.secondary,
            'colorScheme.secondary',
          ),
          _buildColorCard(
            'Tertiary',
            'A contrasting accent color.',
            colorScheme.tertiary,
            'colorScheme.tertiary',
          ),
          _buildColorCard(
            'Surface',
            'The background color for components like Cards.',
            colorScheme.surface,
            'colorScheme.surface',
          ),
          _buildColorCard(
            'Background',
            'The background color for screens.',
            colorScheme.background,
            'colorScheme.background',
          ),

          const SizedBox(height: 24),
          Card(
            color: colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: colorScheme.onSecondaryContainer),
                  const SizedBox(height: 8),
                  Text(
                    'GREEN STEP: Design System Implemented',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'These colors are now dynamically sourced from the active '
                    'ThemeData via Theme.of(context).colorScheme. '
                    'Toggle between Light and Dark themes to see them update.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCard(String name, String usage, Color color, String implementation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: color == Colors.white || color.value == 0xFFFFFFFF
                  ? const Center(child: Text('BG', style: TextStyle(color: Colors.black)))
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    usage,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hex: ${color.value.toRadixString(16).toUpperCase()}',
                    style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    implementation,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700, // Changed to green for success
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Brand Color States (Hover, Active, Disabled)
class BrandColorStates extends StatelessWidget {
  const BrandColorStates({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Color States (via Containers)',
            style: textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),

          // GREEN STEP: Using ColorScheme roles
          _buildStateRow(
            'Primary -> Primary Container',
            colorScheme.primary,
            colorScheme.primaryContainer,
            colorScheme.onPrimary,
            colorScheme.onPrimaryContainer,
          ),
           _buildStateRow(
            'Secondary -> Secondary Container',
            colorScheme.secondary,
            colorScheme.secondaryContainer,
            colorScheme.onSecondary,
            colorScheme.onSecondaryContainer,
          ),

          const SizedBox(height: 24),
           Card(
            color: colorScheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'GREEN STEP: These rows demonstrate the relationship between a color role (e.g., primary) and its container counterpart (primaryContainer), along with their corresponding "on" colors for text.',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onTertiaryContainer),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateRow(String name, Color defaultColor, Color containerColor, Color onColor, Color onContainerColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStateSwatch('Default', defaultColor, onColor),
                const SizedBox(width: 8),
                _buildStateSwatch('Container', containerColor, onContainerColor),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStateSwatch(String name, Color color, Color onColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(color: onColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Text on this color', style: TextStyle(color: onColor)),
          ],
        ),
      ),
    );
  }
}

/// Semantic Color Palette
class SemanticColorPalette extends StatelessWidget {
  const SemanticColorPalette({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Semantic Colors',
            style: textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          _buildColorCard(
            'Error',
            'For indicating errors in forms, etc.',
            colorScheme.error,
            'colorScheme.error',
          ),
          _buildColorCard(
            'On Error',
            'Color for text/icons on top of Error color.',
            colorScheme.onError,
            'colorScheme.onError',
          ),
          _buildColorCard(
            'Error Container',
            'A lighter tint for error backgrounds.',
            colorScheme.errorContainer,
            'colorScheme.errorContainer',
          ),
        ],
      ),
    );
  }

  // Re-using the same helper from BrandColorPalette
  Widget _buildColorCard(String name, String usage, Color color, String implementation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: color == Colors.white || color.value == 0xFFFFFFFF
                  ? const Center(child: Text('BG', style: TextStyle(color: Colors.black)))
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    usage,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hex: ${color.value.toRadixString(16).toUpperCase()}',
                    style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    implementation,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700, // Changed to green for success
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// WCAG Contrast Validation Grid
class ContrastValidationGrid extends StatelessWidget {
  const ContrastValidationGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contrast Validation',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          const Text('Demonstrating WCAG AA compliance for common text/background pairings.'),
          const SizedBox(height: 16),

          _buildContrastChecker(
            'On Primary',
            colorScheme.onPrimary,
            colorScheme.primary,
          ),
           _buildContrastChecker(
            'On Secondary',
            colorScheme.onSecondary,
            colorScheme.secondary,
          ),
           _buildContrastChecker(
            'On Surface',
            colorScheme.onSurface,
            colorScheme.surface,
          ),
           _buildContrastChecker(
            'On Background',
            colorScheme.onBackground,
            colorScheme.background,
          ),
           _buildContrastChecker(
            'On Error',
            colorScheme.onError,
            colorScheme.error,
          ),
        ],
      ),
    );
  }

  Widget _buildContrastChecker(String name, Color textColor, Color backgroundColor) {
    // Basic luminance calculation to determine if contrast is good.
    // This is a simplified version. A real app might use a package.
    final double luminance = backgroundColor.computeLuminance();
    final double contrast = (textColor.computeLuminance() + 0.05) / (luminance + 0.05);
    final bool passes = contrast > 4.5; // WCAG AA for normal text

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: passes ? Colors.green.withOpacity(0.8) : Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                passes ? 'PASS' : 'FAIL',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
} 