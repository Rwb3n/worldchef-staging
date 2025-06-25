import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Recipe Card Component Stories - RED Step (Will show placeholders/errors)
/// 
/// These stories demonstrate WorldChef recipe card components and will fail
/// until design system implementation is completed in task t002.
List<WidgetbookComponent> buildRecipeCardStories() {
  return [
    WidgetbookComponent(
      name: 'Recipe Cards',
      useCases: [
        WidgetbookUseCase(
          name: 'Standard Recipe Cards',
          builder: (context) => const StandardRecipeCards(),
        ),
        WidgetbookUseCase(
          name: 'Compact Recipe Cards',
          builder: (context) => const CompactRecipeCards(),
        ),
        WidgetbookUseCase(
          name: 'Featured Recipe Cards',
          builder: (context) => const FeaturedRecipeCards(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Recipe Card States',
      useCases: [
        WidgetbookUseCase(
          name: 'Loading States',
          builder: (context) => const RecipeCardLoadingStates(),
        ),
        WidgetbookUseCase(
          name: 'Interactive States',
          builder: (context) => const RecipeCardInteractiveStates(),
        ),
      ],
    ),
  ];
}

/// Standard Recipe Cards
class StandardRecipeCards extends StatelessWidget {
  const StandardRecipeCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Standard Recipe Cards',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefRecipeCard in t002
          _buildRecipeCard(
            'Classic Margherita Pizza',
            'Authentic Neapolitan-style pizza with fresh basil and mozzarella',
            '30 min',
            '4 servings',
            '4.8',
            'Italian',
            true,
          ),
          
          const SizedBox(height: 16),
          
          _buildRecipeCard(
            'Chicken Tikka Masala',
            'Creamy tomato-based curry with tender chicken pieces',
            '45 min',
            '6 servings',
            '4.6',
            'Indian',
            false,
          ),
          
          const SizedBox(height: 16),
          
          _buildRecipeCard(
            'Chocolate Chip Cookies',
            'Soft and chewy cookies with premium chocolate chips',
            '25 min',
            '24 cookies',
            '4.9',
            'Dessert',
            true,
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
                    'RED STEP: Recipe Card Components Not Implemented',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Using placeholder Card widgets. '
                    'WorldChefRecipeCard components will be implemented in task t002.',
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

  Widget _buildRecipeCard(
    String title,
    String description,
    String cookTime,
    String servings,
    String rating,
    String cuisine,
    bool isFavorited,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe image placeholder
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.image,
                    size: 64,
                    color: Colors.grey,
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
                // Cuisine badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0288D1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cuisine,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Recipe details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                
                // Metadata row
                Row(
                  children: [
                    // Cook time
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      cookTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Servings
                    Icon(
                      Icons.people,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      servings,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    
                    // Rating
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact Recipe Cards
class CompactRecipeCards extends StatelessWidget {
  const CompactRecipeCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Compact Recipe Cards',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefRecipeCard.compact in t002
          _buildCompactCard(
            'Quick Pasta Salad',
            '15 min',
            '4.5',
            false,
          ),
          
          const SizedBox(height: 12),
          
          _buildCompactCard(
            'Grilled Chicken Sandwich',
            '20 min',
            '4.7',
            true,
          ),
          
          const SizedBox(height: 12),
          
          _buildCompactCard(
            'Vegetable Stir Fry',
            '12 min',
            '4.3',
            false,
          ),
          
          const SizedBox(height: 12),
          
          _buildCompactCard(
            'Banana Smoothie Bowl',
            '5 min',
            '4.8',
            true,
          ),
          
          const SizedBox(height: 24),
          const Card(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Compact Card Usage',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Compact cards are ideal for lists, search results, '
                    'and when screen space is limited.',
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

  Widget _buildCompactCard(
    String title,
    String cookTime,
    String rating,
    bool isFavorited,
  ) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.image,
            color: Colors.grey,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.access_time,
              size: 14,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              cookTime,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.star,
              size: 14,
              color: Colors.amber,
            ),
            const SizedBox(width: 4),
            Text(
              rating,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: isFavorited ? Colors.red : Colors.grey,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

/// Featured Recipe Cards
class FeaturedRecipeCards extends StatelessWidget {
  const FeaturedRecipeCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Featured Recipe Cards',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefRecipeCard.featured in t002
          _buildFeaturedCard(
            'Chef\'s Special: Beef Wellington',
            'A masterclass in fine dining - tender beef wrapped in puff pastry',
            '2 hours',
            '6 servings',
            '4.9',
            'Gordon Ramsay',
            'British',
            true,
          ),
          
          const SizedBox(height: 16),
          
          _buildFeaturedCard(
            'Trending: Korean BBQ Tacos',
            'Fusion cuisine at its finest - Korean flavors meet Mexican tradition',
            '40 min',
            '8 servings',
            '4.7',
            'Chef Kim',
            'Fusion',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(
    String title,
    String description,
    String cookTime,
    String servings,
    String rating,
    String chef,
    String cuisine,
    bool isFeatured,
  ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured image with gradient overlay
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.image,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
                
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                
                // Featured badge
                if (isFeatured)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7247),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'FEATURED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Favorite button
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                
                // Title overlay
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by $chef',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Recipe details
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                
                // Metadata row
                Row(
                  children: [
                    // Cook time
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            cookTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Servings
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            servings,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    
                    // Rating
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7247),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Recipe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Recipe Card Loading States
class RecipeCardLoadingStates extends StatelessWidget {
  const RecipeCardLoadingStates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recipe Card Loading States',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefRecipeCard.loading in t002
          const RecipeCardSkeleton(),
          
          const SizedBox(height: 16),
          const RecipeCardSkeleton(),
        ],
      ),
    );
  }
}

/// Recipe card skeleton loader
class RecipeCardSkeleton extends StatefulWidget {
  const RecipeCardSkeleton({Key? key}) : super(key: key);

  @override
  State<RecipeCardSkeleton> createState() => _RecipeCardSkeletonState();
}

class _RecipeCardSkeletonState extends State<RecipeCardSkeleton>
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image skeleton
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
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
              
              // Content skeleton
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title skeleton
                    Container(
                      width: double.infinity * 0.8,
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
                      width: double.infinity,
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
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity * 0.6,
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
                    const SizedBox(height: 16),
                    
                    // Metadata skeleton
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 14,
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
                        const SizedBox(width: 16),
                        Container(
                          width: 80,
                          height: 14,
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
                        const Spacer(),
                        Container(
                          width: 40,
                          height: 14,
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
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Recipe Card Interactive States
class RecipeCardInteractiveStates extends StatefulWidget {
  const RecipeCardInteractiveStates({Key? key}) : super(key: key);

  @override
  State<RecipeCardInteractiveStates> createState() => _RecipeCardInteractiveStatesState();
}

class _RecipeCardInteractiveStatesState extends State<RecipeCardInteractiveStates> {
  bool _isFavorited = false;
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interactive Recipe Card',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Interactive recipe card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe image with interactive elements
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.image,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
                      
                      // Interactive buttons
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Column(
                          children: [
                            // Favorite button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isFavorited = !_isFavorited;
                                  });
                                },
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                                    key: ValueKey(_isFavorited),
                                    color: _isFavorited ? Colors.red : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // Bookmark button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isBookmarked = !_isBookmarked;
                                  });
                                },
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                    key: ValueKey(_isBookmarked),
                                    color: _isBookmarked ? const Color(0xFF0288D1) : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Recipe details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Interactive Recipe Card',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try tapping the favorite and bookmark buttons above!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Status indicators
                      Row(
                        children: [
                          if (_isFavorited)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size: 12,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Favorited',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (_isFavorited && _isBookmarked)
                            const SizedBox(width: 8),
                          if (_isBookmarked)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.bookmark,
                                    size: 12,
                                    color: Color(0xFF0288D1),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Saved',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF0288D1),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
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
        ],
      ),
    );
  }
} 