import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/ui/organisms/wc_bottom_navigation.dart';
import 'package:worldchef_mobile/src/ui/organisms/wc_category_circle_row.dart';
import 'package:worldchef_mobile/src/ui/organisms/wc_featured_recipe_card.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_section_header.dart';
import 'package:worldchef_mobile/src/ui/molecules/wc_creator_info_row.dart';
import 'package:worldchef_mobile/src/models/creator_data.dart';

/// Home Feed Screen Stories - GREEN Step (Specification Compliant)
/// 
/// These stories demonstrate WorldChef home feed screens using all created
/// components to match the UI specification exactly. This implementation
/// should make the golden tests pass with pixel-perfect alignment.
List<WidgetbookComponent> buildHomeFeedStories() {
  return [
    WidgetbookComponent(
      name: 'Home Feed Layouts',
      useCases: [
        WidgetbookUseCase(
          name: 'Main Home Feed',
          builder: (context) => const MainHomeFeed(),
        ),
        WidgetbookUseCase(
          name: 'Interactive Home Feed',
          builder: (context) => InteractiveHomeFeed(),
        ),
        WidgetbookUseCase(
          name: 'Home Feed Sections',
          builder: (context) => const HomeFeedSections(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Feed States',
      useCases: [
        WidgetbookUseCase(
          name: 'Loading States',
          builder: (context) => const HomeFeedLoadingStates(),
        ),
        WidgetbookUseCase(
          name: 'Empty States',
          builder: (context) => const HomeFeedEmptyStates(),
        ),
        WidgetbookUseCase(
          name: 'Content Variations',
          builder: (context) => ContentVariationsHomeFeed(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Feed Interactions',
      useCases: [
        WidgetbookUseCase(
          name: 'Category Filtering',
          builder: (context) => CategoryFilteringHomeFeed(),
        ),
        WidgetbookUseCase(
          name: 'Navigation States',
          builder: (context) => NavigationStatesHomeFeed(),
        ),
      ],
    ),
  ];
}

/// Main Home Feed - Specification Compliant Implementation
/// 
/// This implementation matches the UI specification exactly and uses all
/// created WorldChef components to achieve pixel-perfect alignment with
/// the golden test target layout.
/// 
/// Key Features:
/// - Blue background matching WorldChef brand colors
/// - WCCategoryCircleRow for category navigation
/// - WCSectionHeader for "Taste by Country" and "Taste by Diet" sections
/// - WCFeaturedRecipeCard for the featured recipe display
/// - WCBottomNavigation for consistent navigation
/// - Proper spacing using WorldChef design tokens
class MainHomeFeed extends StatelessWidget {
  const MainHomeFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0288D1), // WorldChef brand blue background
      body: CustomScrollView(
        slivers: [
          // Status bar area with blue background
          SliverToBoxAdapter(
            child: Container(
              height: 44, // Status bar height
              color: const Color(0xFF0288D1),
            ),
          ),
          
          // Category navigation section
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF0288D1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: WCCategoryCircleRow(
                categories: _getMockCategoryData(),
                onCategoryTapped: (category) {
                  if (category.isCreateButton) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Create new recipe tapped!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tapped category: ${category.name}')),
                    );
                  }
                },
              ),
            ),
          ),
          
          // Country section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Section header with proper spacing
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16), // headlineToGrid spacing
                    child: WCSectionHeader(
                      title: 'Taste by Country',
                      onViewAllPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('View all countries tapped!')),
                        );
                      },
                    ),
                  ),
                  
                  // Country grid (4 columns)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildCountryGrid(context),
                  ),
                  
                  const SizedBox(height: 32), // gridToGrid spacing
                ],
              ),
            ),
          ),
          
          // Diet section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Section header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: WCSectionHeader(
                      title: 'Taste by Diet',
                      onViewAllPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('View all diets tapped!')),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Featured recipe card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: WCFeaturedRecipeCard(
                      recipe: _getMockFeaturedRecipe(),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Featured recipe tapped!')),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: WCBottomNavigation(
        currentIndex: 0, // Home/Feed tab active
        onTap: (index) {
          final tabs = ['Home', 'Explore', 'Create', 'Plans', 'Profile'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped ${tabs[index]} tab')),
          );
        },
      ),
    );
  }

  /// Builds the country thumbnail grid (4 columns) matching specification
  Widget _buildCountryGrid(BuildContext context) {
    final countries = [
      {'name': 'Mexico', 'flag': '🇲🇽', 'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=200'},
      {'name': 'Jamaica', 'flag': '🇯🇲', 'image': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=200'},
      {'name': 'France', 'flag': '🇫🇷', 'image': 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=200'},
      {'name': 'Nigeria', 'flag': '🇳🇬', 'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0, // Square aspect ratio
      ),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return _buildCountryThumbnail(
          context,
          country['name']!,
          country['flag']!,
          country['image']!,
        );
      },
    );
  }

  /// Builds individual country thumbnail matching specification
  Widget _buildCountryThumbnail(BuildContext context, String name, String flag, String imageUrl) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped $name cuisine')),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8), // radiusMedium
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Background image (75% of thumbnail)
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
              ),
              // Gradient overlay for text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Country name at the bottom
              Positioned(
                bottom: 4,
                left: 4,
                right: 4,
                child: Text(
                  '$flag $name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<CategoryData> _getMockCategoryData() {
    return [
      CategoryData(name: 'Italian', imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200'),
      CategoryData(name: 'Mexican', imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=200'),
      CategoryData(name: 'Vegan', imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=200'),
      CategoryData(name: 'Japanese', imageUrl: 'https://images.unsplash.com/photo-1569058242253-92a9c5552db3?w=200'),
      CategoryData(name: 'Quick', imageUrl: 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=200'),
      CategoryData(name: 'Create', isCreateButton: true),
    ];
  }

  RecipeCardData _getMockFeaturedRecipe() {
    return RecipeCardData(
      id: '1',
      title: 'Classic Italian Spaghetti Bolognese with a secret ingredient',
      imageUrl: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=400',
      creator: CreatorData(
        name: 'Jamie Oliver',
        avatarUrl: 'https://i.pravatar.cc/48?u=jamieoliver',
      ),
      rating: 4.8,
      reviewCount: 231,
      cookTime: '45 min',
      servings: 4,
    );
  }
}

/// Interactive Home Feed with Widgetbook Knobs
class InteractiveHomeFeed extends StatefulWidget {
  @override
  _InteractiveHomeFeedState createState() => _InteractiveHomeFeedState();
}

class _InteractiveHomeFeedState extends State<InteractiveHomeFeed> {
  int _selectedTabIndex = 0;
  String _selectedCategory = 'All';
  
  @override
  Widget build(BuildContext context) {
    // Widgetbook knobs for interactive testing
    final backgroundColor = context.knobs.colorOrNull(
      label: 'Background Color',
      initialValue: const Color(0xFF0288D1),
    ) ?? const Color(0xFF0288D1);
    
    final showCategories = context.knobs.boolean(
      label: 'Show Categories',
      initialValue: true,
    );
    
    final showCountrySection = context.knobs.boolean(
      label: 'Show Country Section', 
      initialValue: true,
    );
    
    final showDietSection = context.knobs.boolean(
      label: 'Show Diet Section',
      initialValue: true,
    );
    
    final categoryCount = context.knobs.double.slider(
      label: 'Category Count',
      initialValue: 5,
      min: 1,
      max: 10,
    ).toInt();
    
    final selectedTab = context.knobs.list(
      label: 'Active Tab',
      options: ['Home', 'Explore', 'Create', 'Plans', 'Profile'],
      initialOption: 'Home',
    );
    
    _selectedTabIndex = ['Home', 'Explore', 'Create', 'Plans', 'Profile'].indexOf(selectedTab);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Status bar area
          SliverToBoxAdapter(
            child: Container(
              height: 44,
              color: backgroundColor,
            ),
          ),
          
          // Category section (conditional)
          if (showCategories)
            SliverToBoxAdapter(
              child: Container(
                color: backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: WCCategoryCircleRow(
                  categories: _getMockCategoryData().take(categoryCount).toList(),
                  onCategoryTapped: (category) {
                    setState(() {
                      _selectedCategory = category.name;
                    });
                    if (category.isCreateButton) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Create new recipe tapped!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped category: ${category.name}')),
                      );
                    }
                  },
                ),
              ),
            ),
          
          // Country section (conditional)
          if (showCountrySection)
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: WCSectionHeader(
                        title: 'Taste by Country',
                        onViewAllPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('View all countries!')),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildCountryGrid(context),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          
          // Diet section (conditional)
          if (showDietSection)
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: WCSectionHeader(
                        title: 'Taste by Diet',
                        onViewAllPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('View all diets!')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: WCFeaturedRecipeCard(
                        recipe: _getMockFeaturedRecipe(),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Featured recipe tapped!')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          
          // Selected category display
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Interactive State',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Selected Category: $_selectedCategory'),
                      Text('Active Tab: $selectedTab'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: WCBottomNavigation(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
          final tabs = ['Home', 'Explore', 'Create', 'Plans', 'Profile'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Switched to ${tabs[index]} tab')),
          );
        },
      ),
    );
  }
  
  Widget _buildCountryGrid(BuildContext context) {
    final countries = [
      {'name': 'Mexico', 'flag': '🇲🇽', 'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=200'},
      {'name': 'Jamaica', 'flag': '🇯🇲', 'image': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=200'},
      {'name': 'France', 'flag': '🇫🇷', 'image': 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=200'},
      {'name': 'Nigeria', 'flag': '🇳🇬', 'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return _buildCountryThumbnail(
          context,
          country['name']!,
          country['flag']!,
          country['image']!,
        );
      },
    );
  }
  
  Widget _buildCountryThumbnail(BuildContext context, String name, String flag, String imageUrl) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped $name $flag')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Text(
                        flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
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
              Positioned(
                bottom: 4,
                left: 4,
                right: 4,
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mock data for category circles
  List<CategoryData> _getMockCategoryData() {
    return [
      CategoryData(
        id: '1',
        name: 'Breakfast',
        imageUrl: 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=100',
      ),
      CategoryData(
        id: '2',
        name: 'Dinner',
        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=100',
      ),
      CategoryData(
        id: '3',
        name: 'Desserts',
        imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=100',
      ),
    ];
  }

  /// Mock data for featured recipe
  RecipeCardData _getMockFeaturedRecipe() {
    return RecipeCardData(
      id: 'featured1',
      title: 'Protein muffins',
      imageUrl: 'https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7?w=400',
      creator: CreatorData(
        name: 'Chef Muscle',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      ),
      rating: 4.5,
      reviewCount: 128,
      cookTime: '25 min',
      servings: 12,
    );
  }

  Widget _buildQuickCategories() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Quick Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildCategoryCard('🍝', 'Pasta', Colors.orange),
                _buildCategoryCard('🍕', 'Pizza', Colors.red),
                _buildCategoryCard('🥗', 'Salads', Colors.green),
                _buildCategoryCard('🍰', 'Desserts', Colors.pink),
                _buildCategoryCard('🌮', 'Mexican', Colors.yellow),
                _buildCategoryCard('🍜', 'Asian', Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String emoji, String label, Color color) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Featured Recipes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildFeaturedCard(
                  'Chef\'s Special Carbonara',
                  'by Gordon Ramsay',
                  '25 min',
                  '4.9',
                ),
                _buildFeaturedCard(
                  'Perfect Margherita Pizza',
                  'by Maria Rossi',
                  '30 min',
                  '4.8',
                ),
                _buildFeaturedCard(
                  'Chocolate Lava Cake',
                  'by Julia Child',
                  '20 min',
                  '4.7',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(String title, String chef, String time, String rating) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: double.infinity,
              height: 140,
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
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7247),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'FEATURED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border,
                          size: 20,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chef,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  color: Color(0xFFFF7247),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Trending Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Trending recipe cards
          _buildTrendingCard(
            'Korean BBQ Tacos',
            'Fusion cuisine trending this week',
            '35 min',
            '4.6',
            '🔥 Hot',
          ),
          _buildTrendingCard(
            'Sourdough Bread',
            'Perfect for weekend baking',
            '4 hours',
            '4.8',
            '📈 Rising',
          ),
          _buildTrendingCard(
            'Bubble Tea at Home',
            'Make your favorite drink',
            '15 min',
            '4.5',
            '⭐ Popular',
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCard(
    String title,
    String description,
    String time,
    String rating,
    String trendLabel,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Card(
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
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7247).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trendLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFFF7247),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    time,
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
            ],
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border),
          ),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildRecentSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Recent Recipes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Recent recipe grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
              children: [
                _buildRecentCard('Chicken Tikka', '30 min', '4.5'),
                _buildRecentCard('Caesar Salad', '15 min', '4.3'),
                _buildRecentCard('Beef Stir Fry', '25 min', '4.7'),
                _buildRecentCard('Fruit Smoothie', '5 min', '4.4'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCard(String title, String time, String rating) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 32,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.star,
                      size: 12,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 10,
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

/// Home Feed Sections
class HomeFeedSections extends StatelessWidget {
  const HomeFeedSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Home Feed Sections'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section demos
            _buildSectionDemo(
              'Hero Banner Section',
              'WorldChefHomeBanner (NOT IMPLEMENTED)',
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0288D1),
                      const Color(0xFF0288D1).withOpacity(0.8),
                    ],
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Discover Amazing Recipes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Cook like a chef with our curated collection',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            _buildSectionDemo(
              'Quick Actions Section',
              'WorldChefQuickActions (NOT IMPLEMENTED)',
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickAction(Icons.add, 'Add Recipe', Colors.orange),
                    _buildQuickAction(Icons.camera_alt, 'Scan Food', Colors.green),
                    _buildQuickAction(Icons.list, 'Meal Plan', Colors.blue),
                    _buildQuickAction(Icons.shopping_cart, 'Grocery', Colors.purple),
                  ],
                ),
              ),
            ),
            
            _buildSectionDemo(
              'Recipe Feed Section',
              'WorldChefRecipeFeed (NOT IMPLEMENTED)',
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildFeedItem('Pasta Carbonara', 'Italian classic'),
                    _buildFeedItem('Chicken Tikka', 'Spicy Indian curry'),
                    _buildFeedItem('Chocolate Cake', 'Rich dessert'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDemo(String title, String implementation, Widget content) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
          content,
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedItem(String title, String description) {
    return ListTile(
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
      title: Text(title),
      subtitle: Text(description),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert),
      ),
    );
  }
}

/// Home Feed Loading States
class HomeFeedLoadingStates extends StatelessWidget {
  const HomeFeedLoadingStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Loading States'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // Loading skeleton for home feed
                          HomeFeedSkeleton(),
          ],
        ),
      ),
    );
  }
}

/// Content Variations Home Feed with Different Data Sets
class ContentVariationsHomeFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contentType = context.knobs.list(
      label: 'Content Type',
      options: ['Standard', 'Minimal', 'Rich', 'International'],
      initialOption: 'Standard',
    );
    
    final recipeCount = context.knobs.double.slider(
      label: 'Recipe Count',
      initialValue: 1,
      min: 0,
      max: 5,
    ).toInt();
    
    return Scaffold(
      backgroundColor: const Color(0xFF0288D1),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 44,
              color: const Color(0xFF0288D1),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF0288D1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: WCCategoryCircleRow(
                categories: _getContentVariationCategories(contentType),
                onCategoryTapped: (category) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tapped: ${category.name}')),
                  );
                },
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: WCSectionHeader(
                      title: _getSectionTitle(contentType),
                      onViewAllPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('View all tapped!')),
                        );
                      },
                    ),
                  ),
                  
                  if (recipeCount > 0)
                    ...List.generate(recipeCount, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: WCFeaturedRecipeCard(
                          recipe: _getVariationRecipe(contentType, index),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Recipe ${index + 1} tapped!')),
                            );
                          },
                        ),
                      );
                    })
                  else
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No recipes to display',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: WCBottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          final tabs = ['Home', 'Explore', 'Create', 'Plans', 'Profile'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${tabs[index]} tab')),
          );
        },
      ),
    );
  }
}

/// Category Filtering Home Feed
class CategoryFilteringHomeFeed extends StatefulWidget {
  @override
  _CategoryFilteringHomeFeedState createState() => _CategoryFilteringHomeFeedState();
}

class _CategoryFilteringHomeFeedState extends State<CategoryFilteringHomeFeed> {
  String _activeFilter = 'All';
  
  @override
  Widget build(BuildContext context) {
    final categories = _getMockCategoryData();
    final filteredRecipes = _getFilteredRecipes(_activeFilter);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0288D1),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 44,
              color: const Color(0xFF0288D1),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF0288D1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: WCCategoryCircleRow(
                categories: categories,
                onCategoryTapped: (category) {
                  setState(() {
                    _activeFilter = category.name;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Filtering by: ${category.name}')),
                  );
                },
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Active Filter: $_activeFilter',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Showing ${filteredRecipes.length} recipes'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: WCSectionHeader(
                      title: 'Filtered Results',
                      onViewAllPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('View all filtered!')),
                        );
                      },
                    ),
                  ),
                  
                  if (filteredRecipes.isNotEmpty)
                    ...filteredRecipes.map((recipe) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: WCFeaturedRecipeCard(
                          recipe: recipe,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${recipe.title} tapped!')),
                            );
                          },
                        ),
                      );
                    }).toList()
                  else
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No recipes found for "$_activeFilter"',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: WCBottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          final tabs = ['Home', 'Explore', 'Create', 'Plans', 'Profile'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${tabs[index]} tab')),
          );
        },
      ),
    );
  }

  List<CategoryData> _getMockCategoryData() {
    return [
      CategoryData(name: 'Italian', imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200'),
      CategoryData(name: 'Mexican', imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=200'),
      CategoryData(name: 'Vegan', imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=200'),
      CategoryData(name: 'Japanese', imageUrl: 'https://images.unsplash.com/photo-1569058242253-92a9c5552db3?w=200'),
      CategoryData(name: 'Quick', imageUrl: 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=200'),
      CategoryData(name: 'Create', isCreateButton: true),
    ];
  }
}

/// Navigation States Home Feed
class NavigationStatesHomeFeed extends StatefulWidget {
  @override
  _NavigationStatesHomeFeedState createState() => _NavigationStatesHomeFeedState();
}

class _NavigationStatesHomeFeedState extends State<NavigationStatesHomeFeed> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final tabContent = _getTabContent(_currentIndex);
    
    return Scaffold(
      backgroundColor: tabContent['backgroundColor'] as Color,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 44,
              color: tabContent['backgroundColor'] as Color,
            ),
          ),
          
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        tabContent['icon'] as IconData,
                        size: 48,
                        color: tabContent['backgroundColor'] as Color,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tabContent['title'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tabContent['description'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${tabContent['title']} action!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tabContent['backgroundColor'] as Color,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(tabContent['action'] as String),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: WCBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          final tabs = ['Home', 'Explore', 'Create', 'Plans', 'Profile'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Switched to ${tabs[index]}')),
          );
        },
      ),
    );
  }
}

// Helper functions for new story classes
List<CategoryData> _getContentVariationCategories(String contentType) {
  switch (contentType) {
    case 'Minimal':
      return [
        CategoryData(
          id: '1',
          name: 'Quick',
          imageUrl: 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=100',
        ),
      ];
    case 'Rich':
      return [
        CategoryData(id: '1', name: 'Breakfast', imageUrl: 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=100'),
        CategoryData(id: '2', name: 'Lunch', imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=100'),
        CategoryData(id: '3', name: 'Dinner', imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=100'),
        CategoryData(id: '4', name: 'Desserts', imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100'),
        CategoryData(id: '5', name: 'Snacks', imageUrl: 'https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7?w=100'),
        CategoryData(id: '6', name: 'Drinks', imageUrl: 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=100'),
        CategoryData(id: '7', name: 'Healthy', imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=100'),
      ];
    case 'International':
      return [
        CategoryData(id: '1', name: 'Italian', imageUrl: 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=100'),
        CategoryData(id: '2', name: 'Mexican', imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=100'),
        CategoryData(id: '3', name: 'Asian', imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=100'),
        CategoryData(id: '4', name: 'French', imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100'),
      ];
    default: // Standard
      return [
        CategoryData(id: '1', name: 'Breakfast', imageUrl: 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=100'),
        CategoryData(id: '2', name: 'Dinner', imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=100'),
        CategoryData(id: '3', name: 'Desserts', imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=100'),
      ];
  }
}

String _getSectionTitle(String contentType) {
  switch (contentType) {
    case 'Minimal': return 'Quick Bites';
    case 'Rich': return 'Gourmet Collection';
    case 'International': return 'World Cuisines';
    default: return 'Featured Recipes';
  }
}

RecipeCardData _getVariationRecipe(String contentType, int index) {
  final recipes = {
    'Minimal': [
      RecipeCardData(
        id: 'min1',
        title: '5-Minute Smoothie',
        imageUrl: 'https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7?w=400',
        creator: CreatorData(name: 'Quick Chef', avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
        rating: 4.2,
        reviewCount: 45,
        cookTime: '5 min',
        servings: 1,
      ),
    ],
    'Rich': [
      RecipeCardData(
        id: 'rich1',
        title: 'Truffle Risotto',
        imageUrl: 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=400',
        creator: CreatorData(name: 'Chef Laurent', avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
        rating: 4.9,
        reviewCount: 234,
        cookTime: '45 min',
        servings: 4,
      ),
      RecipeCardData(
        id: 'rich2',
        title: 'Wagyu Beef Wellington',
        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
        creator: CreatorData(name: 'Chef Gordon', avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
        rating: 4.8,
        reviewCount: 156,
        cookTime: '90 min',
        servings: 6,
      ),
    ],
    'International': [
      RecipeCardData(
        id: 'int1',
        title: 'Authentic Pad Thai',
        imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400',
        creator: CreatorData(name: 'Chef Siriporn', avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
        rating: 4.7,
        reviewCount: 189,
        cookTime: '30 min',
        servings: 2,
      ),
    ],
  };
  
  final recipeList = recipes[contentType] ?? [
    RecipeCardData(
      id: 'std1',
      title: 'Classic Pancakes',
      imageUrl: 'https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7?w=400',
      creator: CreatorData(name: 'Chef Maria', avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
      rating: 4.5,
      reviewCount: 128,
      cookTime: '20 min',
      servings: 4,
    ),
  ];
  
  return recipeList[index % recipeList.length];
}

List<RecipeCardData> _getFilteredRecipes(String filter) {
  final allRecipes = [
    RecipeCardData(
      id: 'breakfast1',
      title: 'Fluffy Pancakes',
      imageUrl: 'https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7?w=400',
      creator: CreatorData(name: 'Chef Maria', avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
      rating: 4.5,
      reviewCount: 128,
      cookTime: '20 min',
      servings: 4,
    ),
    RecipeCardData(
      id: 'dinner1',
      title: 'Grilled Salmon',
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
      creator: CreatorData(name: 'Chef John', avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
      rating: 4.7,
      reviewCount: 203,
      cookTime: '25 min',
      servings: 2,
    ),
    RecipeCardData(
      id: 'dessert1',
      title: 'Chocolate Cake',
      imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400',
      creator: CreatorData(name: 'Chef Sophie', avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
      rating: 4.8,
      reviewCount: 156,
      cookTime: '60 min',
      servings: 8,
    ),
  ];
  
  if (filter == 'All') return allRecipes;
  
  return allRecipes.where((recipe) {
    return recipe.title.toLowerCase().contains(filter.toLowerCase()) ||
           recipe.id.toLowerCase().contains(filter.toLowerCase());
  }).toList();
}

Map<String, dynamic> _getTabContent(int index) {
  final contents = [
    {
      'title': 'Home Feed',
      'description': 'Discover recipes from around the world',
      'icon': Icons.home,
      'backgroundColor': const Color(0xFF0288D1),
      'action': 'Browse Recipes',
    },
    {
      'title': 'Explore',
      'description': 'Search and filter through thousands of recipes',
      'icon': Icons.explore,
      'backgroundColor': const Color(0xFF4CAF50),
      'action': 'Start Exploring',
    },
    {
      'title': 'Create Recipe',
      'description': 'Share your culinary creations with the world',
      'icon': Icons.add_circle,
      'backgroundColor': const Color(0xFFFF9800),
      'action': 'Create Now',
    },
    {
      'title': 'Meal Plans',
      'description': 'Plan your weekly meals and shopping lists',
      'icon': Icons.calendar_today,
      'backgroundColor': const Color(0xFF9C27B0),
      'action': 'View Plans',
    },
    {
      'title': 'Profile',
      'description': 'Manage your account and preferences',
      'icon': Icons.person,
      'backgroundColor': const Color(0xFF607D8B),
      'action': 'Edit Profile',
    },
  ];
  
  return contents[index];
} 

/// Home feed skeleton loader
class HomeFeedSkeleton extends StatefulWidget {
  const HomeFeedSkeleton({super.key});

  @override
  State<HomeFeedSkeleton> createState() => _HomeFeedSkeletonState();
}

class _HomeFeedSkeletonState extends State<HomeFeedSkeleton>
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
        return Column(
          children: [
            // Header skeleton
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSkeletonBox(double.infinity, 24),
                  const SizedBox(height: 12),
                  _buildSkeletonBox(double.infinity * 0.7, 16),
                  const SizedBox(height: 16),
                  _buildSkeletonBox(double.infinity, 48),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Categories skeleton
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildSkeletonBox(120, 20),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 60,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              _buildSkeletonBox(60, 60, borderRadius: 16),
                              const SizedBox(height: 8),
                              _buildSkeletonBox(40, 12),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Featured recipes skeleton
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _buildSkeletonBox(140, 20),
                        const Spacer(),
                        _buildSkeletonBox(60, 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 200,
                          margin: const EdgeInsets.only(right: 16),
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSkeletonBox(double.infinity, 120, borderRadius: 8),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildSkeletonBox(double.infinity, 16),
                                      const SizedBox(height: 8),
                                      _buildSkeletonBox(100, 12),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          _buildSkeletonBox(60, 12),
                                          const Spacer(),
                                          _buildSkeletonBox(40, 12),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Recipe list skeleton
            Container(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        _buildSkeletonBox(60, 60, borderRadius: 8),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSkeletonBox(double.infinity * 0.8, 16),
                              const SizedBox(height: 8),
                              _buildSkeletonBox(double.infinity * 0.6, 12),
                              const SizedBox(height: 8),
                              _buildSkeletonBox(100, 12),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildSkeletonBox(24, 24, borderRadius: 12),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkeletonBox(double width, double height, {double borderRadius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
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
    );
  }
}

/// Home Feed Empty States
class HomeFeedEmptyStates extends StatelessWidget {
  const HomeFeedEmptyStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Empty States'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildEmptyState(
              Icons.restaurant_menu,
              'No Recipes Yet',
              'Start building your recipe collection by adding your first recipe!',
              'Add Recipe',
              Colors.orange,
            ),
            
            const SizedBox(height: 24),
            
            _buildEmptyState(
              Icons.wifi_off,
              'No Internet Connection',
              'Please check your connection and try again.',
              'Retry',
              Colors.red,
            ),
            
            const SizedBox(height: 24),
            
            _buildEmptyState(
              Icons.favorite_border,
              'No Favorites Yet',
              'Heart recipes you love to see them here.',
              'Browse Recipes',
              Colors.pink,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    IconData icon,
    String title,
    String description,
    String buttonText,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
} 