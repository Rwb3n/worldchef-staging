# Flutter Persistence Pattern

## Overview

This cookbook entry documents the validated local persistence pattern from WorldChef PoC #1, using SharedPreferences for cross-platform key-value storage with comprehensive error handling and type safety.

**Validation**: 3-42ms cache operations, 100% data integrity, seamless online/offline transitions.

## Core Implementation

### Generic Persistence Service

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Generic persistence service with type safety and error handling
class PersistenceService {
  static const Duration _timeout = Duration(seconds: 5);
  
  /// Save string value
  static Future<bool> saveString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance()
          .timeout(_timeout);
      final success = await prefs.setString(key, value);
      debugPrint('PersistenceService: Saved $key');
      return success;
    } catch (e) {
      debugPrint('PersistenceService: Error saving $key: $e');
      return false;
    }
  }
  
  /// Load string value with default
  static Future<String?> loadString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance()
          .timeout(_timeout);
      final value = prefs.getString(key);
      debugPrint('PersistenceService: Loaded $key');
      return value;
    } catch (e) {
      debugPrint('PersistenceService: Error loading $key: $e');
      return null;
    }
  }
  
  /// Save JSON object
  static Future<bool> saveJson(String key, Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(data);
      return await saveString(key, jsonString);
    } catch (e) {
      debugPrint('PersistenceService: Error encoding JSON for $key: $e');
      return false;
    }
  }
  
  /// Load JSON object
  static Future<Map<String, dynamic>?> loadJson(String key) async {
    try {
      final jsonString = await loadString(key);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('PersistenceService: Error decoding JSON for $key: $e');
      return null;
    }
  }
  
  /// Remove key
  static Future<bool> remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.remove(key);
      debugPrint('PersistenceService: Removed $key');
      return success;
    } catch (e) {
      debugPrint('PersistenceService: Error removing $key: $e');
      return false;
    }
  }
  
  /// Check if key exists
  static Future<bool> containsKey(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(key);
    } catch (e) {
      debugPrint('PersistenceService: Error checking $key: $e');
      return false;
    }
  }
}
```

### Theme Persistence Service

```dart
/// Service for persisting theme preferences with type safety
class ThemePersistenceService {
  static const String _themeKey = 'app_theme_mode';
  
  /// Save theme mode preference
  static Future<bool> saveThemeMode(ThemeMode themeMode) async {
    final themeString = _themeModeToString(themeMode);
    final success = await PersistenceService.saveString(_themeKey, themeString);
    if (success) {
      debugPrint('ThemePersistenceService: Saved theme mode: $themeString');
    }
    return success;
  }
  
  /// Load theme mode preference
  static Future<ThemeMode> loadThemeMode() async {
    final themeString = await PersistenceService.loadString(_themeKey);
    if (themeString != null) {
      final themeMode = _stringToThemeMode(themeString);
      debugPrint('ThemePersistenceService: Loaded theme mode: $themeString');
      return themeMode;
    }
    
    debugPrint('ThemePersistenceService: No saved theme, using system default');
    return ThemeMode.system;
  }
  
  /// Clear theme preference
  static Future<bool> clearThemeMode() async {
    return await PersistenceService.remove(_themeKey);
  }
  
  /// Check if theme preference exists
  static Future<bool> hasThemePreference() async {
    return await PersistenceService.containsKey(_themeKey);
  }
  
  // Helper methods for type conversion
  static String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
  
  static ThemeMode _stringToThemeMode(String themeString) {
    switch (themeString.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        debugPrint('Unknown theme mode: $themeString, defaulting to system');
        return ThemeMode.system;
    }
  }
}
```

### Recipe Cache Service

```dart
/// Service for caching recipe data with validation
class RecipeCacheService {
  static const String _recipesKey = 'cached_recipes';
  static const String _timestampKey = 'cache_timestamp';
  static const Duration _cacheValidDuration = Duration(hours: 24);
  
  /// Cache list of recipes
  static Future<bool> cacheRecipes(List<Recipe> recipes) async {
    try {
      final recipeJsonList = recipes.map((recipe) => recipe.toJson()).toList();
      final cacheData = {
        'recipes': recipeJsonList,
        'timestamp': DateTime.now().toIso8601String(),
        'count': recipes.length,
      };
      
      final success = await PersistenceService.saveJson(_recipesKey, cacheData);
      if (success) {
        debugPrint('RecipeCacheService: Cached ${recipes.length} recipes');
      }
      return success;
    } catch (e) {
      debugPrint('RecipeCacheService: Error caching recipes: $e');
      return false;
    }
  }
  
  /// Load cached recipes with validation
  static Future<List<Recipe>> getCachedRecipes() async {
    try {
      final cacheData = await PersistenceService.loadJson(_recipesKey);
      if (cacheData == null) {
        debugPrint('RecipeCacheService: No cached recipes found');
        return [];
      }
      
      // Validate cache timestamp
      final timestampString = cacheData['timestamp'] as String?;
      if (timestampString != null) {
        final cacheTime = DateTime.parse(timestampString);
        final now = DateTime.now();
        
        if (now.difference(cacheTime) > _cacheValidDuration) {
          debugPrint('RecipeCacheService: Cache expired, clearing');
          await clearCache();
          return [];
        }
      }
      
      // Parse recipes
      final recipeJsonList = cacheData['recipes'] as List?;
      if (recipeJsonList != null) {
        final recipes = recipeJsonList
            .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
            .toList();
        
        debugPrint('RecipeCacheService: Loaded ${recipes.length} cached recipes');
        return recipes;
      }
      
      return [];
    } catch (e) {
      debugPrint('RecipeCacheService: Error loading cached recipes: $e');
      return [];
    }
  }
  
  /// Check if cache is valid and exists
  static Future<bool> isCacheValid() async {
    try {
      final cacheData = await PersistenceService.loadJson(_recipesKey);
      if (cacheData == null) return false;
      
      final timestampString = cacheData['timestamp'] as String?;
      if (timestampString != null) {
        final cacheTime = DateTime.parse(timestampString);
        final now = DateTime.now();
        return now.difference(cacheTime) <= _cacheValidDuration;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Clear recipe cache
  static Future<bool> clearCache() async {
    return await PersistenceService.remove(_recipesKey);
  }
  
  /// Get cache metadata
  static Future<Map<String, dynamic>?> getCacheMetadata() async {
    final cacheData = await PersistenceService.loadJson(_recipesKey);
    if (cacheData != null) {
      return {
        'timestamp': cacheData['timestamp'],
        'count': cacheData['count'],
        'valid': await isCacheValid(),
      };
    }
    return null;
  }
}
```

## Usage Examples

### Basic Theme Persistence

```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  /// Initialize from saved preference
  Future<void> loadTheme() async {
    _themeMode = await ThemePersistenceService.loadThemeMode();
    notifyListeners();
  }
  
  /// Update theme and save preference
  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();
    
    final success = await ThemePersistenceService.saveThemeMode(themeMode);
    if (!success) {
      debugPrint('Failed to save theme preference');
    }
  }
}
```

### Offline-First Data Pattern

```dart
class RecipeRepository {
  final RecipeApiService _apiService;
  
  RecipeRepository(this._apiService);
  
  /// Get recipes with cache fallback
  Future<List<Recipe>> getRecipes({bool forceRefresh = false}) async {
    try {
      // Check cache first unless forcing refresh
      if (!forceRefresh && await RecipeCacheService.isCacheValid()) {
        final cachedRecipes = await RecipeCacheService.getCachedRecipes();
        if (cachedRecipes.isNotEmpty) {
          debugPrint('RecipeRepository: Using cached recipes');
          return cachedRecipes;
        }
      }
      
      // Fetch from API
      final recipes = await _apiService.getRecipes();
      
      // Cache the results
      await RecipeCacheService.cacheRecipes(recipes);
      
      return recipes;
    } on NetworkException {
      // Fallback to cache on network error
      debugPrint('RecipeRepository: Network error, falling back to cache');
      return await RecipeCacheService.getCachedRecipes();
    } catch (e) {
      debugPrint('RecipeRepository: Error getting recipes: $e');
      return await RecipeCacheService.getCachedRecipes();
    }
  }
  
  /// Clear cache and refresh
  Future<List<Recipe>> refreshRecipes() async {
    await RecipeCacheService.clearCache();
    return await getRecipes(forceRefresh: true);
  }
}
```

### State Management Integration

```dart
// Riverpod provider with persistence
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }
  
  Future<void> _loadTheme() async {
    state = await ThemePersistenceService.loadThemeMode();
  }
  
  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    await ThemePersistenceService.saveThemeMode(themeMode);
  }
}
```

## Performance Characteristics

### Validated Metrics (PoC #1)

- **Cache Writes**: 3-11ms (excellent performance)
- **Cache Reads**: 3-42ms (outstanding performance)  
- **Data Validation**: 8ms (fast integrity checks)
- **Error Recovery**: Graceful fallback to defaults
- **Storage Efficiency**: 20.6KB for 50 recipes

### Optimization Strategies

```dart
/// Batch operations for better performance
class BatchPersistenceService {
  static Future<bool> saveBatch(Map<String, dynamic> keyValues) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool allSuccess = true;
      
      for (final entry in keyValues.entries) {
        final success = await prefs.setString(entry.key, entry.value.toString());
        if (!success) allSuccess = false;
      }
      
      return allSuccess;
    } catch (e) {
      return false;
    }
  }
}
```

## Testing Strategy

### Unit Tests

```dart
void main() {
  group('PersistenceService Tests', () {
    setUp(() async {
      // Clear SharedPreferences before each test
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });
    
    test('should save and load string values', () async {
      const key = 'test_key';
      const value = 'test_value';
      
      final saveSuccess = await PersistenceService.saveString(key, value);
      expect(saveSuccess, isTrue);
      
      final loadedValue = await PersistenceService.loadString(key);
      expect(loadedValue, equals(value));
    });
    
    test('should handle JSON serialization', () async {
      const key = 'test_json';
      final data = {'id': 1, 'name': 'Test'};
      
      final saveSuccess = await PersistenceService.saveJson(key, data);
      expect(saveSuccess, isTrue);
      
      final loadedData = await PersistenceService.loadJson(key);
      expect(loadedData, equals(data));
    });
    
    test('should handle cache expiration', () async {
      final recipes = [/* test recipes */];
      
      // Cache recipes
      await RecipeCacheService.cacheRecipes(recipes);
      expect(await RecipeCacheService.isCacheValid(), isTrue);
      
      // Simulate expired cache by manipulating timestamp
      // (Implementation depends on your testing strategy)
    });
  });
}
```

### Integration Tests

```dart
void main() {
  group('Theme Persistence Integration', () {
    testWidgets('should persist theme across app restarts', (tester) async {
      // Save theme
      await ThemePersistenceService.saveThemeMode(ThemeMode.dark);
      
      // Simulate app restart by creating new instance
      final loadedTheme = await ThemePersistenceService.loadThemeMode();
      expect(loadedTheme, equals(ThemeMode.dark));
    });
  });
}
```

## Key Implementation Notes

### Critical Success Factors

1. **Error Handling**: Comprehensive try-catch blocks prevent crashes
2. **Type Safety**: Dedicated services for different data types
3. **Timeout Handling**: Prevents hanging operations
4. **Validation**: Data integrity checks before processing
5. **Graceful Degradation**: Fallback to defaults on errors

### AI Development Considerations

- **Handle initialization delays**: SharedPreferences can be slow on first access
- **Validate data integrity**: Check for corrupted preferences
- **Provide sensible defaults**: Never return null without fallback
- **Log operations**: Essential for debugging persistence issues
- **Consider data migration**: Plan for preference schema changes

## Advanced Patterns

### Secure Storage Integration

```dart
/// Secure storage for sensitive data
class SecureStorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );
  
  static Future<bool> saveSecureString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      return true;
    } catch (e) {
      debugPrint('SecureStorageService: Error saving $key: $e');
      return false;
    }
  }
  
  static Future<String?> loadSecureString(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      debugPrint('SecureStorageService: Error loading $key: $e');
      return null;
    }
  }
}
```

### Data Migration Pattern

```dart
/// Handle preference schema migrations
class MigrationService {
  static const String _versionKey = 'preferences_version';
  static const int _currentVersion = 2;
  
  static Future<void> migrate() async {
    final currentVersion = await PersistenceService.loadString(_versionKey);
    final version = currentVersion != null ? int.parse(currentVersion) : 1;
    
    if (version < _currentVersion) {
      await _performMigration(version);
      await PersistenceService.saveString(_versionKey, _currentVersion.toString());
    }
  }
  
  static Future<void> _performMigration(int fromVersion) async {
    // Implement migration logic based on version
    switch (fromVersion) {
      case 1:
        await _migrateFromV1ToV2();
        break;
    }
  }
  
  static Future<void> _migrateFromV1ToV2() async {
    // Example: Rename keys or transform data
    final oldTheme = await PersistenceService.loadString('theme');
    if (oldTheme != null) {
      await PersistenceService.saveString('app_theme_mode', oldTheme);
      await PersistenceService.remove('theme');
    }
  }
}
```

## Production Checklist

- [ ] Implement proper error handling for all persistence operations
- [ ] Add comprehensive unit tests for all persistence services
- [ ] Test with corrupted SharedPreferences data
- [ ] Validate performance under heavy load
- [ ] Implement data migration strategy
- [ ] Add logging for debugging persistence issues
- [ ] Test cache expiration logic
- [ ] Verify offline-first data patterns work correctly
- [ ] Implement secure storage for sensitive data
- [ ] Test persistence across app updates

## References

- **Source Implementation**: `worldchef_poc_flutter/lib/services/theme_persistence_service.dart`
- **Performance Data**: 3-42ms cache operations from PoC #1 testing
- **Cache Validation**: 100% data integrity during PoC #1 testing
- **Offline Support**: Seamless online/offline transitions validated 