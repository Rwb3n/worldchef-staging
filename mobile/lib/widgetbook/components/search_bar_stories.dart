import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Search Bar Component Stories - RED Step (Will show placeholders/errors)
/// 
/// These stories demonstrate WorldChef search bar components and will fail
/// until design system implementation is completed in task t002.
List<WidgetbookComponent> buildSearchBarStories() {
  return [
    WidgetbookComponent(
      name: 'Search Bars',
      useCases: [
        WidgetbookUseCase(
          name: 'Primary Search Bar',
          builder: (context) => const PrimarySearchBar(),
        ),
        WidgetbookUseCase(
          name: 'Search Bar Variants',
          builder: (context) => const SearchBarVariants(),
        ),
        WidgetbookUseCase(
          name: 'Search with Filters',
          builder: (context) => const SearchWithFilters(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Search States',
      useCases: [
        WidgetbookUseCase(
          name: 'Search States & Results',
          builder: (context) => const SearchStatesAndResults(),
        ),
      ],
    ),
  ];
}

/// Primary Search Bar
class PrimarySearchBar extends StatefulWidget {
  const PrimarySearchBar({Key? key}) : super(key: key);

  @override
  State<PrimarySearchBar> createState() => _PrimarySearchBarState();
}

class _PrimarySearchBarState extends State<PrimarySearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Primary Search Bar',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefSearchBar.primary in t002
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recipe Search',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for recipes, ingredients, or cuisines...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                          size: 24,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _isSearching = false;
                                  });
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey.shade600,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                      onChanged: (value) {
                        setState(() {
                          _isSearching = value.isNotEmpty;
                        });
                      },
                      onSubmitted: (value) {
                        // Handle search submission
                      },
                    ),
                  ),
                  
                  if (_isSearching) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Searching for "${_searchController.text}"...',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
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
                    'RED STEP: Search Bar Components Not Implemented',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Using placeholder TextField widgets. '
                    'WorldChefSearchBar components will be implemented in task t002.',
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

/// Search Bar Variants
class SearchBarVariants extends StatelessWidget {
  const SearchBarVariants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Bar Variants',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Compact search bar
          _buildSearchVariant(
            'Compact Search',
            'WorldChefSearchBar.compact (NOT IMPLEMENTED)',
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Quick search...',
                  prefixIcon: Icon(Icons.search, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          
          // Ingredient search
          _buildSearchVariant(
            'Ingredient Search',
            'WorldChefSearchBar.ingredient (NOT IMPLEMENTED)',
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search ingredients...',
                  prefixIcon: const Icon(Icons.local_grocery_store),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt),
                        tooltip: 'Scan ingredient',
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.mic),
                        tooltip: 'Voice search',
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          
          // Voice search bar
          _buildSearchVariant(
            'Voice Search',
            'WorldChefSearchBar.voice (NOT IMPLEMENTED)',
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade50,
                    Colors.blue.shade100,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Try "Show me pasta recipes"',
                  hintStyle: TextStyle(
                    color: Colors.blue.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                  prefixIcon: Icon(
                    Icons.mic,
                    color: Colors.blue.shade600,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          
          // Search with suggestions
          _buildSearchVariant(
            'Search with Quick Suggestions',
            'WorldChefSearchBar.withSuggestions (NOT IMPLEMENTED)',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'What would you like to cook?',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSuggestionChip('🍝 Pasta', Colors.orange),
                    _buildSuggestionChip('🍕 Pizza', Colors.red),
                    _buildSuggestionChip('🥗 Salad', Colors.green),
                    _buildSuggestionChip('🍰 Dessert', Colors.pink),
                    _buildSuggestionChip('🌮 Mexican', Colors.yellow),
                    _buildSuggestionChip('🍜 Asian', Colors.purple),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchVariant(String title, String implementation, Widget searchBar) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            searchBar,
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

  Widget _buildSuggestionChip(String label, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Search with Filters
class SearchWithFilters extends StatefulWidget {
  const SearchWithFilters({Key? key}) : super(key: key);

  @override
  State<SearchWithFilters> createState() => _SearchWithFiltersState();
}

class _SearchWithFiltersState extends State<SearchWithFilters> {
  bool _showFilters = false;
  String _selectedCuisine = 'All';
  String _selectedTime = 'Any';
  String _selectedDifficulty = 'Any';
  bool _vegetarianOnly = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search with Filters',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar with filter button
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Search recipes...',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: _showFilters 
                              ? const Color(0xFF0288D1) 
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _showFilters = !_showFilters;
                            });
                          },
                          icon: Icon(
                            Icons.tune,
                            color: _showFilters ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Animated filter panel
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _showFilters ? null : 0,
                    child: _showFilters
                        ? Column(
                            children: [
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                              
                              // Filter options
                              Row(
                                children: [
                                  const Icon(Icons.tune, size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Filters',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedCuisine = 'All';
                                        _selectedTime = 'Any';
                                        _selectedDifficulty = 'Any';
                                        _vegetarianOnly = false;
                                      });
                                    },
                                    child: const Text('Clear All'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Cuisine filter
                              _buildFilterRow(
                                'Cuisine',
                                DropdownButton<String>(
                                  value: _selectedCuisine,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'All', child: Text('All Cuisines')),
                                    DropdownMenuItem(value: 'Italian', child: Text('Italian')),
                                    DropdownMenuItem(value: 'Mexican', child: Text('Mexican')),
                                    DropdownMenuItem(value: 'Asian', child: Text('Asian')),
                                    DropdownMenuItem(value: 'American', child: Text('American')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCuisine = value!;
                                    });
                                  },
                                ),
                              ),
                              
                              // Cooking time filter
                              _buildFilterRow(
                                'Cooking Time',
                                DropdownButton<String>(
                                  value: _selectedTime,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'Any', child: Text('Any Time')),
                                    DropdownMenuItem(value: '15', child: Text('Under 15 min')),
                                    DropdownMenuItem(value: '30', child: Text('Under 30 min')),
                                    DropdownMenuItem(value: '60', child: Text('Under 1 hour')),
                                    DropdownMenuItem(value: '60+', child: Text('Over 1 hour')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTime = value!;
                                    });
                                  },
                                ),
                              ),
                              
                              // Difficulty filter
                              _buildFilterRow(
                                'Difficulty',
                                DropdownButton<String>(
                                  value: _selectedDifficulty,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'Any', child: Text('Any Level')),
                                    DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                                    DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                                    DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedDifficulty = value!;
                                    });
                                  },
                                ),
                              ),
                              
                              // Dietary restriction
                              CheckboxListTile(
                                title: const Text('Vegetarian Only'),
                                value: _vegetarianOnly,
                                onChanged: (value) {
                                  setState(() {
                                    _vegetarianOnly = value!;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Apply filters button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Apply filters
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0288D1),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Apply Filters'),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          
          // Active filters display
          if (_selectedCuisine != 'All' || 
              _selectedTime != 'Any' || 
              _selectedDifficulty != 'Any' || 
              _vegetarianOnly) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Active Filters:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (_selectedCuisine != 'All')
                          _buildActiveFilterChip('Cuisine: $_selectedCuisine'),
                        if (_selectedTime != 'Any')
                          _buildActiveFilterChip('Time: $_selectedTime'),
                        if (_selectedDifficulty != 'Any')
                          _buildActiveFilterChip('Difficulty: $_selectedDifficulty'),
                        if (_vegetarianOnly)
                          _buildActiveFilterChip('Vegetarian'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterRow(String label, Widget filter) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: filter),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.blue.shade100,
      deleteIconColor: Colors.blue.shade700,
      onDeleted: () {
        // Remove specific filter
      },
    );
  }
}

/// Search States and Results
class SearchStatesAndResults extends StatefulWidget {
  const SearchStatesAndResults({Key? key}) : super(key: key);

  @override
  State<SearchStatesAndResults> createState() => _SearchStatesAndResultsState();
}

class _SearchStatesAndResultsState extends State<SearchStatesAndResults> {
  String _currentState = 'empty'; // empty, searching, results, no_results

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search States & Results',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // State selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select State to Preview:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildStateButton('Empty State', 'empty'),
                      _buildStateButton('Searching', 'searching'),
                      _buildStateButton('With Results', 'results'),
                      _buildStateButton('No Results', 'no_results'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Search bar
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Dynamic content based on state
          _buildStateContent(),
        ],
      ),
    );
  }

  Widget _buildStateButton(String label, String state) {
    final isSelected = _currentState == state;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentState = state;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0288D1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStateContent() {
    switch (_currentState) {
      case 'empty':
        return _buildEmptyState();
      case 'searching':
        return _buildSearchingState();
      case 'results':
        return _buildResultsState();
      case 'no_results':
        return _buildNoResultsState();
      default:
        return _buildEmptyState();
    }
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Search for Recipes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find your next favorite dish from thousands of recipes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchingState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text(
              'Searching...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Looking for the best recipes for you',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Found 127 recipes for "pasta"',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Sample search results
        _buildSearchResultItem(
          'Creamy Carbonara',
          'Classic Italian pasta with eggs and pancetta',
          '25 min',
          '4.8',
        ),
        _buildSearchResultItem(
          'Spaghetti Bolognese',
          'Traditional meat sauce with rich tomato base',
          '45 min',
          '4.6',
        ),
        _buildSearchResultItem(
          'Pesto Penne',
          'Fresh basil pesto with pine nuts and parmesan',
          '20 min',
          '4.7',
        ),
      ],
    );
  }

  Widget _buildNoResultsState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Results Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords or check your spelling',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Browse All Recipes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(
    String title,
    String description,
    String time,
    String rating,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
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
          style: const TextStyle(fontWeight: FontWeight.w600),
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
          icon: const Icon(Icons.favorite_border),
        ),
        onTap: () {},
      ),
    );
  }
} 