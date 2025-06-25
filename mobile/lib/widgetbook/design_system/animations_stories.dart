import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Animation System Stories - RED Step (Will show placeholders/errors)
/// 
/// These stories demonstrate the WorldChef animation system and will fail
/// until design system implementation is completed in task t002.
List<WidgetbookComponent> buildAnimationStories() {
  return [
    WidgetbookComponent(
      name: 'Animation Timing',
      useCases: [
        WidgetbookUseCase(
          name: 'Duration Standards',
          builder: (context) => const AnimationTimingDemo(),
        ),
        WidgetbookUseCase(
          name: 'Easing Curves',
          builder: (context) => const EasingCurvesDemo(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'UI Animations',
      useCases: [
        WidgetbookUseCase(
          name: 'Micro Interactions',
          builder: (context) => const MicroInteractionsDemo(),
        ),
        WidgetbookUseCase(
          name: 'Loading States',
          builder: (context) => const LoadingAnimationsDemo(),
        ),
        WidgetbookUseCase(
          name: 'Page Transitions',
          builder: (context) => const PageTransitionsDemo(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Recipe Animations',
      useCases: [
        WidgetbookUseCase(
          name: 'Card Interactions',
          builder: (context) => const RecipeCardAnimationsDemo(),
        ),
        WidgetbookUseCase(
          name: 'List Animations',
          builder: (context) => const ListAnimationsDemo(),
        ),
      ],
    ),
  ];
}

/// Animation Timing Standards
class AnimationTimingDemo extends StatelessWidget {
  const AnimationTimingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WorldChef Animation Timing Standards',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefAnimations in t002
          _buildTimingCard(
            'Fast (100ms)',
            'Micro interactions, hover states',
            'WorldChefAnimations.fast (NOT IMPLEMENTED)',
            100,
            Colors.green.shade200,
          ),
          
          _buildTimingCard(
            'Standard (200ms)',
            'Button presses, small UI changes',
            'WorldChefAnimations.standard (NOT IMPLEMENTED)',
            200,
            Colors.blue.shade200,
          ),
          
          _buildTimingCard(
            'Slow (300ms)',
            'Page transitions, modal appearances',
            'WorldChefAnimations.slow (NOT IMPLEMENTED)',
            300,
            Colors.orange.shade200,
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
                    'RED STEP: Animation System Not Implemented',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Using hardcoded durations. WorldChefAnimations constants '
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

  Widget _buildTimingCard(String name, String usage, String implementation, 
                         int durationMs, Color color) {
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
                    ],
                  ),
                ),
                Text(
                  '${durationMs}ms',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Visual timing representation
            AnimatedTimingBar(
              duration: Duration(milliseconds: durationMs),
              color: color,
            ),
            
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

/// Animated timing bar widget
class AnimatedTimingBar extends StatefulWidget {
  final Duration duration;
  final Color color;

  const AnimatedTimingBar({
    super.key,
    required this.duration,
    required this.color,
  });

  @override
  State<AnimatedTimingBar> createState() => _AnimatedTimingBarState();
}

class _AnimatedTimingBarState extends State<AnimatedTimingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _startAnimation,
          child: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: _controller.value,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Tap to animate',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Easing Curves Demonstration
class EasingCurvesDemo extends StatelessWidget {
  const EasingCurvesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Animation Easing Curves',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will use WorldChefAnimations.curves in t002
          _buildEasingCard(
            'Ease Out',
            'UI element entrances, expansions',
            'WorldChefAnimations.easeOut (NOT IMPLEMENTED)',
            Curves.easeOut,
          ),
          
          _buildEasingCard(
            'Ease In Out',
            'Smooth transitions, page changes',
            'WorldChefAnimations.easeInOut (NOT IMPLEMENTED)',
            Curves.easeInOut,
          ),
          
          _buildEasingCard(
            'Bounce',
            'Playful interactions, success states',
            'WorldChefAnimations.bounce (NOT IMPLEMENTED)',
            Curves.bounceOut,
          ),
          
          _buildEasingCard(
            'Elastic',
            'Attention-grabbing animations',
            'WorldChefAnimations.elastic (NOT IMPLEMENTED)',
            Curves.elasticOut,
          ),
        ],
      ),
    );
  }

  Widget _buildEasingCard(String name, String usage, String implementation, Curve curve) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),
            
            // Easing curve visualization
            EasingCurveDemo(curve: curve),
            
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

/// Easing curve demonstration widget
class EasingCurveDemo extends StatefulWidget {
  final Curve curve;

  const EasingCurveDemo({super.key, required this.curve});

  @override
  State<EasingCurveDemo> createState() => _EasingCurveDemoState();
}

class _EasingCurveDemoState extends State<EasingCurveDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startAnimation,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final curvedValue = widget.curve.transform(_controller.value);
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Positioned(
                  left: 8 + (MediaQuery.of(context).size.width - 80) * curvedValue,
                  top: 8,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                if (_controller.value == 0)
                  const Center(
                    child: Text(
                      'Tap to see easing curve',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Micro Interactions Demo
class MicroInteractionsDemo extends StatelessWidget {
  const MicroInteractionsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Micro Interactions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interactive Elements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  
                  // Animated favorite button
                  AnimatedFavoriteButton(),
                  SizedBox(height: 16),
                  
                  // Animated rating stars
                  AnimatedRatingStars(),
                  SizedBox(height: 16),
                  
                  // Animated toggle switch
                  AnimatedToggleSwitch(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated favorite button
class AnimatedFavoriteButton extends StatefulWidget {
  const AnimatedFavoriteButton({super.key});

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Favorite Button: '),
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  _isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorited ? Colors.red : Colors.grey,
                ),
              ),
            );
          },
        ),
        Text(_isFavorited ? 'Favorited!' : 'Not favorited'),
      ],
    );
  }
}

/// Animated rating stars
class AnimatedRatingStars extends StatefulWidget {
  const AnimatedRatingStars({super.key});

  @override
  State<AnimatedRatingStars> createState() => _AnimatedRatingStarsState();
}

class _AnimatedRatingStarsState extends State<AnimatedRatingStars> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Rating: '),
        ...List.generate(5, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _rating = index + 1;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              child: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: index < _rating ? 28 : 24,
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        Text('$_rating/5'),
      ],
    );
  }
}

/// Animated toggle switch
class AnimatedToggleSwitch extends StatefulWidget {
  const AnimatedToggleSwitch({super.key});

  @override
  State<AnimatedToggleSwitch> createState() => _AnimatedToggleSwitchState();
}

class _AnimatedToggleSwitchState extends State<AnimatedToggleSwitch> {
  bool _isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Notifications: '),
        Switch(
          value: _isEnabled,
          onChanged: (value) {
            setState(() {
              _isEnabled = value;
            });
          },
        ),
        Text(_isEnabled ? 'Enabled' : 'Disabled'),
      ],
    );
  }
}

/// Loading Animations Demo
class LoadingAnimationsDemo extends StatelessWidget {
  const LoadingAnimationsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Loading State Animations',
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
                    'Loading Indicators',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Circular progress
                  const Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 16),
                      Text('Loading recipes...'),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Linear progress
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Uploading image...'),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 0.7,
                        backgroundColor: Colors.grey.shade200,
                      ),
                      const SizedBox(height: 4),
                      const Text('70% complete', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Skeleton loading
                  const Text('Skeleton Loading:'),
                  const SizedBox(height: 8),
                  const SkeletonLoader(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton loader widget
class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({super.key});

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image skeleton
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment(-1.0 + 2 * _controller.value, 0.0),
                    end: Alignment(1.0 + 2 * _controller.value, 0.0),
                    colors: [
                      Colors.grey.shade300,
                      Colors.grey.shade200,
                      Colors.grey.shade300,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Title skeleton
              Container(
                width: double.infinity * 0.7,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    begin: Alignment(-1.0 + 2 * _controller.value, 0.0),
                    end: Alignment(1.0 + 2 * _controller.value, 0.0),
                    colors: [
                      Colors.grey.shade300,
                      Colors.grey.shade200,
                      Colors.grey.shade300,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              // Description skeleton
              Container(
                width: double.infinity * 0.9,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    begin: Alignment(-1.0 + 2 * _controller.value, 0.0),
                    end: Alignment(1.0 + 2 * _controller.value, 0.0),
                    colors: [
                      Colors.grey.shade300,
                      Colors.grey.shade200,
                      Colors.grey.shade300,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Page Transitions Demo
class PageTransitionsDemo extends StatelessWidget {
  const PageTransitionsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Page Transition Animations',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          
          Card(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.navigation, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Page Transition Guidelines',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Use 300ms duration for page transitions\n'
                    '• Slide transitions for hierarchical navigation\n'
                    '• Fade transitions for modal overlays\n'
                    '• Scale transitions for expanding content',
                    style: TextStyle(color: Colors.white),
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
                'RED STEP: Page transitions will be implemented with '
                'proper route animations in task t002.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Recipe Card Animations Demo
class RecipeCardAnimationsDemo extends StatelessWidget {
  const RecipeCardAnimationsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recipe Card Animations',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          
          // Animated recipe card
          AnimatedRecipeCard(),
        ],
      ),
    );
  }
}

/// Animated recipe card
class AnimatedRecipeCard extends StatefulWidget {
  const AnimatedRecipeCard({super.key});

  @override
  State<AnimatedRecipeCard> createState() => _AnimatedRecipeCardState();
}

class _AnimatedRecipeCardState extends State<AnimatedRecipeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          // Recipe card tap animation would go here
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..scale(_isHovered ? 1.02 : 1.0),
          child: Card(
            elevation: _isHovered ? 8 : 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 16),
                  const Text(
                    'Classic Margherita Pizza',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Authentic Neapolitan-style pizza with fresh basil',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '30 min',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
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
        ),
      ),
    );
  }
}

/// List Animations Demo
class ListAnimationsDemo extends StatelessWidget {
  const ListAnimationsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'List Entry Animations',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          
          Card(
            color: Colors.green,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.list, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'List Animation Guidelines',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Stagger list item animations by 50ms\n'
                    '• Use slide-up + fade-in for new items\n'
                    '• Use slide-out + fade-out for removed items\n'
                    '• Keep animations under 300ms total',
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