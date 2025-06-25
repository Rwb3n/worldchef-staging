import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Input Component Stories - RED Step (Will show placeholders/errors)
/// 
/// These stories demonstrate WorldChef input components and will fail
/// until design system implementation is completed in task t002.
List<WidgetbookComponent> buildInputStories() {
  return [
    WidgetbookComponent(
      name: 'Text Fields',
      useCases: [
        WidgetbookUseCase(
          name: 'Basic Text Fields',
          builder: (context) => const BasicTextFields(),
        ),
        WidgetbookUseCase(
          name: 'Text Field States',
          builder: (context) => const TextFieldStates(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Search Inputs',
      useCases: [
        WidgetbookUseCase(
          name: 'Search Bars',
          builder: (context) => const SearchInputs(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Selection Inputs',
      useCases: [
        WidgetbookUseCase(
          name: 'Dropdowns & Pickers',
          builder: (context) => const SelectionInputs(),
        ),
        WidgetbookUseCase(
          name: 'Checkboxes & Switches',
          builder: (context) => const CheckboxSwitchInputs(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Specialized Inputs',
      useCases: [
        WidgetbookUseCase(
          name: 'Recipe Form Fields',
          builder: (context) => const RecipeFormFields(),
        ),
      ],
    ),
  ];
}

/// Basic Text Fields
class BasicTextFields extends StatelessWidget {
  const BasicTextFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Text Input Fields',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefTextField in t002
          _buildTextFieldExample(
            'Recipe Name',
            'WorldChefTextField.standard (NOT IMPLEMENTED)',
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Recipe Name',
                hintText: 'Enter recipe name...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant),
              ),
            ),
          ),
          
          _buildTextFieldExample(
            'Description',
            'WorldChefTextField.multiline (NOT IMPLEMENTED)',
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your recipe...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ),
          
          _buildTextFieldExample(
            'Cooking Time',
            'WorldChefTextField.numeric (NOT IMPLEMENTED)',
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cooking Time',
                      hintText: '30',
                      border: OutlineInputBorder(),
                      suffixText: 'minutes',
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          _buildTextFieldExample(
            'Servings',
            'WorldChefTextField.numeric (NOT IMPLEMENTED)',
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Servings',
                      hintText: '4',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.people),
                    ),
                  ),
                ),
              ],
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
                    'RED STEP: Input Components Not Implemented',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Using default TextFormField widgets. '
                    'WorldChefTextField components will be implemented in task t002.',
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

  Widget _buildTextFieldExample(String label, String implementation, Widget field) {
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
            field,
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

/// Text Field States
class TextFieldStates extends StatelessWidget {
  const TextFieldStates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Text Field States',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Default state
          _buildStateExample(
            'Default',
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Recipe Name',
                hintText: 'Enter recipe name...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          
          // Focused state (simulated)
          _buildStateExample(
            'Focused',
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Recipe Name',
                hintText: 'Enter recipe name...',
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          
          // Error state
          _buildStateExample(
            'Error',
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Recipe Name',
                hintText: 'Enter recipe name...',
                border: OutlineInputBorder(),
                errorText: 'This field is required',
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
            ),
          ),
          
          // Disabled state
          _buildStateExample(
            'Disabled',
            TextFormField(
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Recipe Name',
                hintText: 'Enter recipe name...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          
          // Success state
          _buildStateExample(
            'Success',
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Recipe Name',
                hintText: 'Enter recipe name...',
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
                suffixIcon: const Icon(Icons.check_circle, color: Colors.green),
                helperText: 'Great name!',
                helperStyle: TextStyle(color: Colors.green.shade700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateExample(String state, Widget field) {
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
            field,
          ],
        ),
      ),
    );
  }
}

/// Search Inputs
class SearchInputs extends StatelessWidget {
  const SearchInputs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Input Components',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefSearchBar in t002
          _buildSearchExample(
            'Recipe Search Bar',
            'WorldChefSearchBar.primary (NOT IMPLEMENTED)',
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          
          _buildSearchExample(
            'Ingredient Search',
            'WorldChefSearchBar.ingredient (NOT IMPLEMENTED)',
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search ingredients...',
                prefixIcon: const Icon(Icons.local_grocery_store),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {},
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          
          _buildSearchExample(
            'Filter Search',
            'WorldChefSearchBar.filter (NOT IMPLEMENTED)',
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Filter recipes...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF0288D1),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Search with suggestions
          _buildSearchExample(
            'Search with Suggestions',
            'WorldChefSearchBar.withSuggestions (NOT IMPLEMENTED)',
            Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search recipes...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Searches:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildSuggestionChip('Pasta'),
                          _buildSuggestionChip('Pizza'),
                          _buildSuggestionChip('Vegetarian'),
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

  Widget _buildSearchExample(String label, String implementation, Widget search) {
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
            search,
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

  Widget _buildSuggestionChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.grey.shade200,
      onDeleted: () {},
      deleteIconColor: Colors.grey.shade600,
    );
  }
}

/// Selection Inputs
class SelectionInputs extends StatelessWidget {
  const SelectionInputs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selection Input Components',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefDropdown in t002
          _buildSelectionExample(
            'Cuisine Type Dropdown',
            'WorldChefDropdown.cuisine (NOT IMPLEMENTED)',
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Cuisine Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.public),
              ),
              items: const [
                DropdownMenuItem(value: 'italian', child: Text('Italian')),
                DropdownMenuItem(value: 'mexican', child: Text('Mexican')),
                DropdownMenuItem(value: 'asian', child: Text('Asian')),
                DropdownMenuItem(value: 'american', child: Text('American')),
              ],
              onChanged: (value) {},
            ),
          ),
          
          _buildSelectionExample(
            'Difficulty Level',
            'WorldChefDropdown.difficulty (NOT IMPLEMENTED)',
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Difficulty Level',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.signal_cellular_alt),
                helperText: 'Select cooking difficulty',
              ),
              items: const [
                DropdownMenuItem(value: 'easy', child: Text('Easy')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'hard', child: Text('Hard')),
              ],
              onChanged: (value) {},
            ),
          ),
          
          _buildSelectionExample(
            'Meal Type',
            'WorldChefDropdown.mealType (NOT IMPLEMENTED)',
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Meal Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              items: const [
                DropdownMenuItem(value: 'breakfast', child: Text('Breakfast')),
                DropdownMenuItem(value: 'lunch', child: Text('Lunch')),
                DropdownMenuItem(value: 'dinner', child: Text('Dinner')),
                DropdownMenuItem(value: 'snack', child: Text('Snack')),
                DropdownMenuItem(value: 'dessert', child: Text('Dessert')),
              ],
              onChanged: (value) {},
            ),
          ),
          
          // Time picker
          _buildSelectionExample(
            'Cooking Time Picker',
            'WorldChefTimePicker (NOT IMPLEMENTED)',
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Prep Time',
                      hintText: 'Select time',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    onTap: () {
                      // Time picker would open here
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Cook Time',
                      hintText: 'Select time',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    onTap: () {
                      // Time picker would open here
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionExample(String label, String implementation, Widget selection) {
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
            selection,
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

/// Checkbox and Switch Inputs
class CheckboxSwitchInputs extends StatefulWidget {
  const CheckboxSwitchInputs({Key? key}) : super(key: key);

  @override
  State<CheckboxSwitchInputs> createState() => _CheckboxSwitchInputsState();
}

class _CheckboxSwitchInputsState extends State<CheckboxSwitchInputs> {
  bool _isVegetarian = false;
  bool _isGlutenFree = false;
  bool _isDairyFree = false;
  bool _notificationsEnabled = true;
  bool _autoSave = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Checkbox & Switch Components',
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
                    'Dietary Restrictions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // PLACEHOLDER: Will be replaced with WorldChefCheckbox in t002
                  CheckboxListTile(
                    title: const Text('Vegetarian'),
                    subtitle: const Text('Contains no meat or fish'),
                    value: _isVegetarian,
                    onChanged: (value) {
                      setState(() {
                        _isVegetarian = value ?? false;
                      });
                    },
                    secondary: const Icon(Icons.eco),
                  ),
                  
                  CheckboxListTile(
                    title: const Text('Gluten-Free'),
                    subtitle: const Text('Contains no gluten ingredients'),
                    value: _isGlutenFree,
                    onChanged: (value) {
                      setState(() {
                        _isGlutenFree = value ?? false;
                      });
                    },
                    secondary: const Icon(Icons.no_food),
                  ),
                  
                  CheckboxListTile(
                    title: const Text('Dairy-Free'),
                    subtitle: const Text('Contains no dairy products'),
                    value: _isDairyFree,
                    onChanged: (value) {
                      setState(() {
                        _isDairyFree = value ?? false;
                      });
                    },
                    secondary: const Icon(Icons.block),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'App Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // PLACEHOLDER: Will be replaced with WorldChefSwitch in t002
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Receive recipe updates and tips'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    secondary: const Icon(Icons.notifications),
                  ),
                  
                  SwitchListTile(
                    title: const Text('Auto-Save Recipes'),
                    subtitle: const Text('Automatically save recipes as you browse'),
                    value: _autoSave,
                    onChanged: (value) {
                      setState(() {
                        _autoSave = value;
                      });
                    },
                    secondary: const Icon(Icons.save),
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
                'RED STEP: Using default CheckboxListTile and SwitchListTile widgets. '
                'WorldChefCheckbox and WorldChefSwitch components will be implemented in task t002.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Specialized Recipe Form Fields
class RecipeFormFields extends StatelessWidget {
  const RecipeFormFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Specialized Recipe Form Fields',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // PLACEHOLDER: Will be replaced with WorldChefIngredientInput in t002
          _buildSpecializedExample(
            'Ingredient Input',
            'WorldChefIngredientInput (NOT IMPLEMENTED)',
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Ingredient',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Ingredient',
                              hintText: 'e.g., Flour',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              hintText: '2',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Unit',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'cups', child: Text('cups')),
                              DropdownMenuItem(value: 'tsp', child: Text('tsp')),
                              DropdownMenuItem(value: 'tbsp', child: Text('tbsp')),
                              DropdownMenuItem(value: 'g', child: Text('g')),
                              DropdownMenuItem(value: 'ml', child: Text('ml')),
                            ],
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          _buildSpecializedExample(
            'Recipe Step Input',
            'WorldChefStepInput (NOT IMPLEMENTED)',
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0288D1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Step 1',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Describe this cooking step...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Add Photo'),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.timer),
                          label: const Text('Add Timer'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          _buildSpecializedExample(
            'Nutrition Input',
            'WorldChefNutritionInput (NOT IMPLEMENTED)',
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nutrition Information (per serving)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Calories',
                              border: OutlineInputBorder(),
                              suffixText: 'kcal',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Protein',
                              border: OutlineInputBorder(),
                              suffixText: 'g',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Carbs',
                              border: OutlineInputBorder(),
                              suffixText: 'g',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Fat',
                              border: OutlineInputBorder(),
                              suffixText: 'g',
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildSpecializedExample(String label, String implementation, Widget field) {
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
            field,
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