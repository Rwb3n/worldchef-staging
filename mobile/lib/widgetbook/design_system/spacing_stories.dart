import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Spacing System Stories - RED Step (Will show placeholders/errors)
/// 
/// These stories demonstrate the WorldChef spacing system and will fail
/// until design system implementation is completed in task t002.
List<WidgetbookComponent> buildSpacingStories() {
  return [
    WidgetbookComponent(
      name: 'Spacing Tokens',
      useCases: [
        WidgetbookUseCase(
          name: '8px Base Unit System',
          builder: (context) => const SpacingTokensDemo(),
        ),
        WidgetbookUseCase(
          name: 'Spacing Scale',
          builder: (context) => const SpacingScaleDemo(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Layout Patterns',
      useCases: [
        WidgetbookUseCase(
          name: 'Card Spacing',
          builder: (context) => const CardSpacingDemo(),
        ),
        WidgetbookUseCase(
          name: 'List Spacing',
          builder: (context) => const ListSpacingDemo(),
        ),
        WidgetbookUseCase(
          name: 'Form Spacing',
          builder: (context) => const FormSpacingDemo(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Touch Targets',
      useCases: [
        WidgetbookUseCase(
          name: '44dp Minimum Targets',
          builder: (context) => const TouchTargetDemo(),
        ),
      ],
    ),
  ];
}

/// Spacing Tokens Demonstration
class SpacingTokensDemo extends StatelessWidget {
  const SpacingTokensDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WorldChef Spacing Tokens (8px Base Unit)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefSpacing in t002
          _buildSpacingToken(
            'XS',
            '4px',
            'WorldChefSpacing.xs (NOT IMPLEMENTED)',
            4.0,
            'Tight spacing, small gaps',
          ),
          
          _buildSpacingToken(
            'SM',
            '8px',
            'WorldChefSpacing.sm (NOT IMPLEMENTED)',
            8.0,
            'Base unit, compact layouts',
          ),
          
          _buildSpacingToken(
            'MD',
            '16px',
            'WorldChefSpacing.md (NOT IMPLEMENTED)',
            16.0,
            'Standard spacing, most common',
          ),
          
          _buildSpacingToken(
            'LG',
            '24px',
            'WorldChefSpacing.lg (NOT IMPLEMENTED)',
            24.0,
            'Generous spacing, section breaks',
          ),
          
          _buildSpacingToken(
            'XL',
            '32px',
            'WorldChefSpacing.xl (NOT IMPLEMENTED)',
            32.0,
            'Large spacing, major sections',
          ),
          
          _buildSpacingToken(
            'XXL',
            '48px',
            'WorldChefSpacing.xxl (NOT IMPLEMENTED)',
            48.0,
            'Extra large spacing, page sections',
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
                    'RED STEP: Spacing System Not Implemented',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Using hardcoded values. WorldChefSpacing constants '
                    'will be implemented in task t002.',
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

  Widget _buildSpacingToken(String name, String size, String implementation, 
                           double value, String usage) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Visual representation
            Column(
              children: [
                Container(
                  width: 60,
                  height: value,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${value.toInt()}px',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Token info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        size,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
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

/// Spacing Scale Visual Demo
class SpacingScaleDemo extends StatelessWidget {
  const SpacingScaleDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spacing Scale Visual Comparison',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progressive Spacing Scale',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Visual spacing scale
                  _buildSpacingRow('XS', 4.0, Colors.red.shade200),
                  _buildSpacingRow('SM', 8.0, Colors.orange.shade200),
                  _buildSpacingRow('MD', 16.0, Colors.yellow.shade200),
                  _buildSpacingRow('LG', 24.0, Colors.green.shade200),
                  _buildSpacingRow('XL', 32.0, Colors.blue.shade200),
                  _buildSpacingRow('XXL', 48.0, Colors.purple.shade200),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Card(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.straighten, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    '8px Base Unit System Benefits',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Consistent visual rhythm\n'
                    '• Easy to remember and apply\n'
                    '• Scales well across different screen sizes\n'
                    '• Aligns with Material Design principles',
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

  Widget _buildSpacingRow(String name, double spacing, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: spacing * 3, // Scale up for visibility
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${spacing.toInt()}px',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Card Spacing Patterns
class CardSpacingDemo extends StatelessWidget {
  const CardSpacingDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Card Spacing Patterns',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Recipe card example
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // MD spacing
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 48, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16), // MD spacing
                  
                  // Title
                  const Text(
                    'Classic Margherita Pizza',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8), // SM spacing
                  
                  // Description
                  Text(
                    'Authentic Neapolitan-style pizza with fresh basil and mozzarella',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16), // MD spacing
                  
                  // Metadata row
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4), // XS spacing
                      Text(
                        '30 min',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16), // MD spacing
                      Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4), // XS spacing
                      Text(
                        '4 servings',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Card(
            color: Colors.green,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.credit_card, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Card Spacing Guidelines',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Card padding: MD (16px)\n'
                    '• Element spacing: SM (8px) for related items\n'
                    '• Section spacing: MD (16px) for different sections\n'
                    '• Micro spacing: XS (4px) for icons and labels',
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

/// List Spacing Patterns
class ListSpacingDemo extends StatelessWidget {
  const ListSpacingDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'List Spacing Patterns',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Ingredient list example
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16), // MD spacing
                  
                  // List items
                  _buildListItem('500g tipo 00 flour', '2 cups'),
                  const SizedBox(height: 12), // Between items
                  _buildListItem('325ml warm water', '1⅓ cups'),
                  const SizedBox(height: 12),
                  _buildListItem('10g fine sea salt', '2 tsp'),
                  const SizedBox(height: 12),
                  _buildListItem('7g active dry yeast', '1 packet'),
                  const SizedBox(height: 12),
                  _buildListItem('400g canned tomatoes', '1 can'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Recipe steps example
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16), // MD spacing
                  
                  _buildStepItem(1, 'Mix flour and salt in a large bowl'),
                  const SizedBox(height: 16), // MD spacing between steps
                  _buildStepItem(2, 'Dissolve yeast in warm water and let stand for 5 minutes'),
                  const SizedBox(height: 16),
                  _buildStepItem(3, 'Add yeast mixture to flour and mix until dough forms'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String ingredient, String amount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12), // SM + XS spacing
        Expanded(
          child: Text(
            ingredient,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(width: 8), // SM spacing
        Text(
          amount,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(int step, String instruction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '$step',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12), // SM + XS spacing
        Expanded(
          child: Text(
            instruction,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ),
      ],
    );
  }
}

/// Form Spacing Patterns
class FormSpacingDemo extends StatelessWidget {
  const FormSpacingDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Form Spacing Patterns',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Recipe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24), // LG spacing after title
                  
                  // Recipe name field
                  const Text(
                    'Recipe Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8), // SM spacing
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter recipe name...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 4), // XS spacing
                  Text(
                    'This field is required',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24), // LG spacing between fields
                  
                  // Description field
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8), // SM spacing
                  TextFormField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Describe your recipe...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24), // LG spacing
                  
                  // Cooking time field
                  const Text(
                    'Cooking Time',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8), // SM spacing
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: '30',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8), // SM spacing
                      const Text('minutes'),
                    ],
                  ),
                  const SizedBox(height: 32), // XL spacing before buttons
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16), // MD spacing between buttons
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Save Recipe'),
                        ),
                      ),
                    ],
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

/// Touch Target Demonstration
class TouchTargetDemo extends StatelessWidget {
  const TouchTargetDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Touch Target Guidelines (44dp Minimum)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Interactive Elements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Good touch targets
                  _buildTouchTargetExample(
                    'Primary Button',
                    true,
                    SizedBox(
                      width: double.infinity,
                      height: 48, // 48dp > 44dp minimum
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Add to Favorites'),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildTouchTargetExample(
                    'Icon Button',
                    true,
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                      iconSize: 24,
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildTouchTargetExample(
                    'List Item',
                    true,
                    ListTile(
                      leading: const Icon(Icons.restaurant),
                      title: const Text('Recipe Name'),
                      subtitle: const Text('Recipe description'),
                      onTap: () {},
                      minVerticalPadding: 12, // Ensures 44dp+ height
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bad touch targets (too small)
                  const Text(
                    'Avoid: Too Small Touch Targets',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTouchTargetExample(
                    'Small Icon (BAD)',
                    false,
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 24, // Too small!
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.close, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Card(
            color: Colors.green,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.touch_app, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Touch Target Requirements',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Minimum 44dp × 44dp for all interactive elements\n'
                    '• Adequate spacing between adjacent touch targets\n'
                    '• Clear visual feedback on touch/hover\n'
                    '• Consider thumb reach zones on mobile devices',
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

  Widget _buildTouchTargetExample(String title, bool isGood, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isGood ? Icons.check_circle : Icons.error,
              color: isGood ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isGood ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isGood ? Colors.green.shade300 : Colors.red.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      ],
    );
  }
} 