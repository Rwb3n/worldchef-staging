import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Color System Stories - RED Step (Will show placeholders/errors)
/// 
/// These stories demonstrate the WorldChef color system and will fail
/// until design system implementation is completed in task t002.
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
  const BrandColorPalette({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WorldChef Brand Colors',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefColors in t002
          _buildColorCard(
            'Brand Blue',
            'Primary navigation, major CTAs',
            const Color(0xFF0288D1), // Placeholder from design_tokens.md
            'WorldChefColors.brandBlue (NOT IMPLEMENTED)',
          ),
          
          _buildColorCard(
            'Secondary Green',
            'Success highlights, badges',
            const Color(0xFF89C247), // Placeholder from design_tokens.md
            'WorldChefColors.secondaryGreen (NOT IMPLEMENTED)',
          ),
          
          _buildColorCard(
            'Accent Coral',
            'Primary CTA buttons (Order Now)',
            const Color(0xFFFF7247), // Placeholder from design_tokens.md
            'WorldChefColors.accentCoral (NOT IMPLEMENTED)',
          ),
          
          _buildColorCard(
            'Accent Orange',
            'Secondary CTAs, warnings',
            const Color(0xFFFFA000), // Placeholder from design_tokens.md
            'WorldChefColors.accentOrange (NOT IMPLEMENTED)',
          ),
          
          const SizedBox(height: 24),
          const Card(
            color: Colors.orange,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'RED STEP: Design System Not Implemented',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'These are placeholder colors from design_tokens.md. '
                    'Actual WorldChefColors classes will be implemented in task t002.',
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

  Widget _buildColorCard(String name, String usage, Color color, String implementation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Color swatch
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(width: 16),
            
            // Color info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    usage,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hex: ${color.value.toRadixString(16).toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    implementation,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade700,
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
  const BrandColorStates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Brand Color States',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will show actual hover/active states in t002
          _buildStateRow(
            'Brand Blue',
            const Color(0xFF0288D1), // Default
            const Color(0xFF027ABC), // Hover placeholder
            const Color(0xFF026DA7), // Active placeholder  
            const Color(0x800288D1), // Disabled placeholder
          ),
          
          _buildStateRow(
            'Accent Coral',
            const Color(0xFFFF7247), // Default
            const Color(0xFFE6633F), // Hover placeholder
            const Color(0xFFCC5639), // Active placeholder
            const Color(0x80FF7247), // Disabled placeholder
          ),
          
          const SizedBox(height: 24),
          const Card(
            color: Colors.orange,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'RED STEP: Interactive states will be implemented with '
                'proper hover/focus/active behaviors in task t002.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateRow(String name, Color defaultColor, Color hoverColor, 
                       Color activeColor, Color disabledColor) {
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
                _buildStateColor('Default', defaultColor),
                _buildStateColor('Hover', hoverColor),
                _buildStateColor('Active', activeColor),
                _buildStateColor('Disabled', disabledColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateColor(String state, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Semantic Color Palette
class SemanticColorPalette extends StatelessWidget {
  const SemanticColorPalette({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Semantic Colors',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefSemanticColors in t002
          _buildSemanticCard(
            'Success',
            'Success messages, confirmation badges',
            const Color(0xFF89C247),
            Icons.check_circle,
          ),
          
          _buildSemanticCard(
            'Warning',
            'Warnings, promotional banners',
            const Color(0xFFFFA000),
            Icons.warning,
          ),
          
          _buildSemanticCard(
            'Error',
            'Error states, critical alerts',
            const Color(0xFFD32F2F),
            Icons.error,
          ),
          
          _buildSemanticCard(
            'Info',
            'Informational messages, tooltips',
            const Color(0xFF0288D1),
            Icons.info,
          ),
        ],
      ),
    );
  }

  Widget _buildSemanticCard(String name, String usage, Color color, IconData icon) {
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
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(usage),
                  const SizedBox(height: 8),
                  Text(
                    'WorldChefSemanticColors.$name (NOT IMPLEMENTED)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade700,
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

/// WCAG AA Contrast Validation Grid
class ContrastValidationGrid extends StatelessWidget {
  const ContrastValidationGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WCAG AA Contrast Validation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will use actual contrast calculation in t002
          _buildContrastTest(
            'Brand Blue on White',
            const Color(0xFF0288D1),
            Colors.white,
            4.52, // Placeholder calculation
          ),
          
          _buildContrastTest(
            'Secondary Green on White', 
            const Color(0xFF89C247),
            Colors.white,
            4.8, // Placeholder calculation
          ),
          
          _buildContrastTest(
            'Accent Coral on White',
            const Color(0xFFFF7247),
            Colors.white,
            3.9, // Placeholder - might fail WCAG AA
          ),
          
          _buildContrastTest(
            'Primary Text on Background',
            const Color(0xFF212121),
            const Color(0xFFFAFAFA),
            15.8, // Placeholder calculation
          ),
          
          const SizedBox(height: 24),
          const Card(
            color: Colors.orange,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'RED STEP: Contrast calculations are placeholders. '
                'Actual calculateContrast() function will be implemented in task t002.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContrastTest(String name, Color foreground, Color background, double ratio) {
    final bool passesWCAG = ratio >= 4.5;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Color combination preview
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: foreground,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Sample',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Contrast info
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Contrast: ${ratio.toStringAsFixed(2)}:1',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        passesWCAG ? Icons.check_circle : Icons.error,
                        color: passesWCAG ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        passesWCAG ? 'WCAG AA' : 'FAILS',
                        style: TextStyle(
                          fontSize: 12,
                          color: passesWCAG ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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