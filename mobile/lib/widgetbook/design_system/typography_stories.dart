import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/core/design_system/typography.dart';

/// Typography System Stories - GREEN Step (Implementation Complete)
///
/// These stories demonstrate the WorldChef typography system using the
/// implemented design tokens from task t002.
List<WidgetbookComponent> buildTypographyStories() {
  return [
    WidgetbookComponent(
      name: 'Typography Scale',
      useCases: [
        WidgetbookUseCase(
          name: 'Nunito UI Typography',
          builder: (context) => const NunitoTypographyScale(),
        ),
        WidgetbookUseCase(
          name: 'Lora Headlines',
          builder: (context) => const LoraHeadlineScale(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Text Styles',
      useCases: [
        WidgetbookUseCase(
          name: 'UI Text Styles',
          builder: (context) => const UITextStyles(),
        ),
        WidgetbookUseCase(
          name: 'Content Text Styles',
          builder: (context) => const ContentTextStyles(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Typography Accessibility',
      useCases: [
        WidgetbookUseCase(
          name: 'Text Scale Testing',
          builder: (context) => const TextScaleDemo(),
        ),
        WidgetbookUseCase(
          name: 'Reading Flow',
          builder: (context) => const ReadingFlowDemo(),
        ),
      ],
    ),
  ];
}

/// Nunito UI Typography Scale
class NunitoTypographyScale extends StatelessWidget {
  const NunitoTypographyScale({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Material Design 3 Type Scale',
            style: textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),

          // GREEN STEP: Using actual TextTheme roles
          _buildTypographyCard(
            'Display Large',
            'Used for short, important text or numerals.',
            'textTheme.displayLarge',
            textTheme.displayLarge ?? const TextStyle(),
            'Display Large',
          ),
          _buildTypographyCard(
            'Headline Large',
            'Best for short, high-emphasis text.',
            'textTheme.headlineLarge',
            textTheme.headlineLarge ?? const TextStyle(),
            'Headline Large',
          ),
          _buildTypographyCard(
            'Body Large',
            'The default style for long-form text.',
            'textTheme.bodyLarge',
            textTheme.bodyLarge ?? const TextStyle(),
            'The quick brown fox jumps over the lazy dog. This is the primary body text used for descriptions, instructions, and general content throughout the app.',
          ),
          _buildTypographyCard(
            'Label Large',
            'Used for buttons and other interactive elements.',
            'textTheme.labelLarge',
            textTheme.labelLarge ?? const TextStyle(),
            'BUTTON TEXT',
          ),

          const SizedBox(height: 24),
           Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onPrimaryContainer),
                  const SizedBox(height: 8),
                  Text(
                    'GREEN STEP: Typography System Implemented',
                    style: textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'These styles are now dynamically sourced from the active '
                    'ThemeData via Theme.of(context).textTheme. The google_fonts '
                    'package provides Lora and Nunito fonts.',
                     style: textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
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

  Widget _buildTypographyCard(String name, String usage, String implementation,
                             TextStyle style, String sampleText) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        usage,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${style.fontSize?.toInt()}px',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Weight: ${_getWeightName(style.fontWeight)}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Sample text
            Text(sampleText, style: style),
            
            const SizedBox(height: 12),
            Text(
              implementation,
              style: TextStyle(
                fontSize: 11,
                color: Colors.red.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeightName(FontWeight? weight) {
    switch (weight) {
      case FontWeight.w400:
        return 'Regular';
      case FontWeight.w500:
        return 'Medium';
      case FontWeight.w600:
        return 'SemiBold';
      case FontWeight.w700:
        return 'Bold';
      default:
        return 'Regular';
    }
  }
}

/// Lora Headlines Scale (Placeholder)
/// This widget is now DEPRECATED as the main scale showcases both fonts.
/// Kept for structural reference but can be removed.
class LoraHeadlineScale extends StatelessWidget {
  const LoraHeadlineScale({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('DEPRECATED: Lora headlines are part of the main Material 3 Type Scale story.'),
        ),
      ),
    );
  }
}

/// UI Text Styles Showcase
class UITextStyles extends StatelessWidget {
  const UITextStyles({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'UI Text Styles in Context',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Button text examples
          _buildContextCard(
            'Button Text',
            'Primary and secondary buttons',
            [
              _buildButtonExample('Primary CTA', Colors.blue, Colors.white),
              _buildButtonExample('Secondary', Colors.grey.shade200, Colors.black87),
            ],
          ),
          
          // Form text examples
          _buildContextCard(
            'Form Elements',
            'Input labels, helper text, validation',
            [
              _buildFormExample(),
            ],
          ),
          
          // Navigation text examples
          _buildContextCard(
            'Navigation',
            'Tab labels, menu items',
            [
              _buildNavigationExample(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContextCard(String title, String description, List<Widget> examples) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ...examples,
          ],
        ),
      ),
    );
  }

  Widget _buildButtonExample(String text, Color backgroundColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildFormExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recipe Name',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Enter recipe name...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'This field is required',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildNavigationExample() {
    return Row(
      children: [
        _buildTabItem('Home', true),
        _buildTabItem('Search', false),
        _buildTabItem('Favorites', false),
        _buildTabItem('Profile', false),
      ],
    );
  }

  Widget _buildTabItem(String label, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? Colors.blue : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

/// Content Text Styles Examples
class ContentTextStyles extends StatelessWidget {
  const ContentTextStyles({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Content Text Styles',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          
          // Recipe content example
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe title (Lora)
                  Text(
                    'Classic Margherita Pizza',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Recipe subtitle (Lora)
                  Text(
                    'Authentic Neapolitan-style pizza with fresh basil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Body text (Nunito)
                  Text(
                    'This classic Margherita pizza recipe brings the authentic taste of Naples to your kitchen. With a perfectly crispy crust, tangy tomato sauce, and fresh mozzarella, it\'s a timeless favorite that never goes out of style.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Section header (Lora)
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Ingredient list (Nunito)
                  Text(
                    '• 500g tipo 00 flour\n'
                    '• 325ml warm water\n'
                    '• 10g fine sea salt\n'
                    '• 7g active dry yeast\n'
                    '• 400g canned San Marzano tomatoes',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          Card(
            color: Colors.orange,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'RED STEP: Content is using default system fonts. '
                'Lora and Nunito fonts will be loaded in task t002.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Text Scale Accessibility Demo
class TextScaleDemo extends StatelessWidget {
  const TextScaleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Text Scale Accessibility Testing',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          const Text(
            'Use the Text Scale addon in Widgetbook to test different accessibility scales:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          
          _buildScaleExample('0.8x - Small', 0.8),
          _buildScaleExample('1.0x - Default', 1.0),
          _buildScaleExample('1.2x - Large', 1.2),
          _buildScaleExample('1.5x - Extra Large', 1.5),
          _buildScaleExample('2.0x - Accessibility', 2.0),
          
          const SizedBox(height: 16),
          const Card(
            color: Colors.green,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.accessibility, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Accessibility Requirement',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'All UI elements must remain functional and readable '
                    'at text scales up to 2.0x for accessibility compliance.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScaleExample(String label, double scale) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Transform.scale(
              scale: scale,
              alignment: Alignment.centerLeft,
              child: const Text(
                'Sample recipe title and description text',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reading Flow Demo
class ReadingFlowDemo extends StatelessWidget {
  const ReadingFlowDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reading Flow & Hierarchy',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Visual hierarchy demonstration
                  Text(
                    '1. Main Recipe Title',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  
                  Text(
                    '2. Recipe Subtitle/Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 16),
                  
                  Text(
                    '3. Section Headers',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  
                  Text(
                    '4. Body text for instructions and descriptions with proper line height for optimal readability. This text should flow naturally and be easy to scan.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 12),
                  
                  Text(
                    '5. Secondary information and captions',
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                  SizedBox(height: 8),
                  
                  Text(
                    '6. LABELS AND SMALL TEXT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          Card(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.visibility, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Typography Hierarchy Guidelines',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Clear size differentiation between levels\n'
                    '• Consistent spacing and rhythm\n'
                    '• Proper line height for readability\n'
                    '• Scannable content structure',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 