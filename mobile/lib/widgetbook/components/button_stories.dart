import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Button Component Stories - RED Step (Will show placeholders/errors)
/// 
/// These stories demonstrate WorldChef button components and will fail
/// until design system implementation is completed in task t002.
List<WidgetbookComponent> buildButtonStories() {
  return [
    WidgetbookComponent(
      name: 'Primary Buttons',
      useCases: [
        WidgetbookUseCase(
          name: 'Primary CTA',
          builder: (context) => const PrimaryCTAButtons(),
        ),
        WidgetbookUseCase(
          name: 'Primary Button States',
          builder: (context) => const PrimaryButtonStates(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Secondary Buttons',
      useCases: [
        WidgetbookUseCase(
          name: 'Secondary Actions',
          builder: (context) => const SecondaryButtons(),
        ),
        WidgetbookUseCase(
          name: 'Outline Buttons',
          builder: (context) => const OutlineButtons(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Icon Buttons',
      useCases: [
        WidgetbookUseCase(
          name: 'Action Icons',
          builder: (context) => const IconButtons(),
        ),
        WidgetbookUseCase(
          name: 'Social Buttons',
          builder: (context) => const SocialButtons(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Floating Action Buttons',
      useCases: [
        WidgetbookUseCase(
          name: 'FAB Variants',
          builder: (context) => const FloatingActionButtons(),
        ),
      ],
    ),
  ];
}

/// Primary CTA Buttons
class PrimaryCTAButtons extends StatelessWidget {
  const PrimaryCTAButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Primary CTA Buttons',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefButton.primary in t002
          _buildButtonExample(
            'Order Now',
            'WorldChefButton.primary (NOT IMPLEMENTED)',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7247), // Accent Coral
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Order Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          
          _buildButtonExample(
            'Add to Cart',
            'WorldChefButton.primary (NOT IMPLEMENTED)',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7247), // Accent Coral
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          
          _buildButtonExample(
            'Start Cooking',
            'WorldChefButton.primary (NOT IMPLEMENTED)',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7247), // Accent Coral
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Start Cooking',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                    'RED STEP: Button Components Not Implemented',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Using placeholder ElevatedButton widgets. '
                    'WorldChefButton components will be implemented in task t002.',
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

  Widget _buildButtonExample(String label, String implementation, Widget button) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            button,
            const SizedBox(height: 12),
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
    );
  }
}

/// Primary Button States
class PrimaryButtonStates extends StatelessWidget {
  const PrimaryButtonStates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Primary Button States',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Default state
          _buildStateExample(
            'Default',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7247),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Order Now'),
              ),
            ),
          ),
          
          // Hover state (simulated)
          _buildStateExample(
            'Hover',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6633F), // Darker coral
                  foregroundColor: Colors.white,
                  elevation: 4,
                ),
                child: const Text('Order Now'),
              ),
            ),
          ),
          
          // Pressed state (simulated)
          _buildStateExample(
            'Pressed',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCC5639), // Even darker coral
                  foregroundColor: Colors.white,
                  elevation: 1,
                ),
                child: const Text('Order Now'),
              ),
            ),
          ),
          
          // Disabled state
          _buildStateExample(
            'Disabled',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: null, // Disabled
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.grey.shade600,
                ),
                child: const Text('Order Now'),
              ),
            ),
          ),
          
          // Loading state
          _buildStateExample(
            'Loading',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7247),
                  foregroundColor: Colors.white,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('Processing...'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateExample(String state, Widget button) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            button,
          ],
        ),
      ),
    );
  }
}

/// Secondary Buttons
class SecondaryButtons extends StatelessWidget {
  const SecondaryButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Secondary Action Buttons',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefButton.secondary in t002
          _buildButtonExample(
            'Save Recipe',
            'WorldChefButton.secondary (NOT IMPLEMENTED)',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA000), // Accent Orange
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Recipe',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          
          _buildButtonExample(
            'Share Recipe',
            'WorldChefButton.secondary (NOT IMPLEMENTED)',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA000), // Accent Orange
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Share Recipe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          _buildButtonExample(
            'View Nutrition',
            'WorldChefButton.secondary (NOT IMPLEMENTED)',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA000), // Accent Orange
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'View Nutrition',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonExample(String label, String implementation, Widget button) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            button,
            const SizedBox(height: 12),
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
    );
  }
}

/// Outline Buttons
class OutlineButtons extends StatelessWidget {
  const OutlineButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Outline Buttons',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefButton.outline in t002
          _buildButtonExample(
            'Cancel',
            'WorldChefButton.outline (NOT IMPLEMENTED)',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0288D1), // Brand Blue
                  side: const BorderSide(
                    color: Color(0xFF0288D1),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          
          _buildButtonExample(
            'Learn More',
            'WorldChefButton.outline (NOT IMPLEMENTED)',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0288D1), // Brand Blue
                  side: const BorderSide(
                    color: Color(0xFF0288D1),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Learn More',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
          ),
          
          _buildButtonExample(
            'Edit Recipe',
            'WorldChefButton.outline (NOT IMPLEMENTED)',
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0288D1), // Brand Blue
                  side: const BorderSide(
                    color: Color(0xFF0288D1),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Edit Recipe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonExample(String label, String implementation, Widget button) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            button,
            const SizedBox(height: 12),
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
    );
  }
}

/// Icon Buttons
class IconButtons extends StatelessWidget {
  const IconButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Icon Action Buttons',
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
                    'Recipe Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Action icons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIconButton(
                        Icons.favorite_border,
                        'Favorite',
                        const Color(0xFFFF7247), // Accent Coral
                      ),
                      _buildIconButton(
                        Icons.share,
                        'Share',
                        const Color(0xFF0288D1), // Brand Blue
                      ),
                      _buildIconButton(
                        Icons.bookmark_border,
                        'Save',
                        const Color(0xFF89C247), // Secondary Green
                      ),
                      _buildIconButton(
                        Icons.more_vert,
                        'More',
                        Colors.grey.shade600,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Navigation Icons',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIconButton(
                        Icons.arrow_back,
                        'Back',
                        const Color(0xFF0288D1), // Brand Blue
                      ),
                      _buildIconButton(
                        Icons.close,
                        'Close',
                        Colors.grey.shade600,
                      ),
                      _buildIconButton(
                        Icons.search,
                        'Search',
                        const Color(0xFF0288D1), // Brand Blue
                      ),
                      _buildIconButton(
                        Icons.filter_list,
                        'Filter',
                        const Color(0xFF0288D1), // Brand Blue
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Card(
            color: Colors.orange,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'RED STEP: Icon buttons using default IconButton widget. '
                'WorldChefIconButton component will be implemented in task t002.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon, color: color),
          iconSize: 24,
          constraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

/// Social Buttons
class SocialButtons extends StatelessWidget {
  const SocialButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Social Action Buttons',
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
                    'Social Sharing',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Social sharing buttons
                  _buildSocialButton(
                    'Share on Facebook',
                    Icons.facebook,
                    const Color(0xFF1877F2), // Facebook Blue
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildSocialButton(
                    'Share on Twitter',
                    Icons.share, // Using generic share icon as Twitter icon not available
                    const Color(0xFF1DA1F2), // Twitter Blue
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildSocialButton(
                    'Share on Instagram',
                    Icons.camera_alt, // Using camera icon as Instagram icon not available
                    const Color(0xFFE4405F), // Instagram Pink
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildSocialButton(
                    'Share via WhatsApp',
                    Icons.message, // Using message icon as WhatsApp icon not available
                    const Color(0xFF25D366), // WhatsApp Green
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

/// Floating Action Buttons
class FloatingActionButtons extends StatelessWidget {
  const FloatingActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Action Buttons',
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
                    'FAB Variants',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Standard FAB
                  Row(
                    children: [
                      FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: const Color(0xFFFF7247), // Accent Coral
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      const Text('Add Recipe'),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Extended FAB
                  FloatingActionButton.extended(
                    onPressed: () {},
                    backgroundColor: const Color(0xFFFF7247), // Accent Coral
                    foregroundColor: Colors.white,
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Recipe'),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Small FAB
                  Row(
                    children: [
                      FloatingActionButton.small(
                        onPressed: () {},
                        backgroundColor: const Color(0xFF89C247), // Secondary Green
                        child: const Icon(Icons.edit, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      const Text('Quick Edit'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Card(
            color: Colors.orange,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'RED STEP: Using default FloatingActionButton widgets. '
                'WorldChefFAB component will be implemented in task t002.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 