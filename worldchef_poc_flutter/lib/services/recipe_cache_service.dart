/* ANNOTATION_BLOCK_START
{
  "artifact_id": "flutter_offline_recipe_list_cache_stub",
  "version_tag": "1.0.0-cache-service",
  "g_created": 14,
  "g_last_modified": 14,
  "description": "Flutter offline caching service for recipe list data using shared_preferences with performance timing and comprehensive error handling for PoC evaluation.",
  "artifact_type": "CODE_MODULE",
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Provides offline caching capabilities for recipe list data to evaluate Flutter's local storage development experience and performance characteristics for the WorldChef PoC.",
  "key_logic_points": [
    "Uses shared_preferences for cross-platform local JSON storage",
    "Implements performance timing for cache read/write operations as per PoC Plan #1",
    "Provides comprehensive error handling with graceful degradation",
    "Supports cache validation with timestamp and data integrity checks",
    "Includes cache management operations (clear, check existence)",
    "Integrates seamlessly with existing Recipe model JSON serialization"
  ],
  "interfaces_provided": [
    { 
      "name": "RecipeCacheService",
      "interface_type": "CACHE_SERVICE",
      "details": "Recipe data caching with performance measurement and error handling",
      "notes": "Exposes save/load operations with timing data for PoC performance analysis"
    }
  ],
  "requisites": [
    { "description": "shared_preferences package for local storage", "type": "EXTERNAL_DEPENDENCY" },
    { "description": "Recipe models for JSON serialization", "type": "INTERNAL_DEPENDENCY" },
    { "description": "dart:convert for JSON encoding/decoding", "type": "FRAMEWORK_DEPENDENCY" }
  ],
  "external_dependencies": [
    { "name": "shared_preferences", "version": "^2.2.2", "reason": "Cross-platform local key-value storage for recipe cache data" },
    { "name": "dart:convert", "version": "built-in", "reason": "JSON encoding/decoding for recipe list serialization" }
  ],
  "internal_dependencies": [
    { "name": "Recipe models", "reason": "RecipeListResponse and Recipe objects for type-safe caching" }
  ],
  "dependents": [
    { "name": "RecipeListScreen", "reason": "Uses cache service for offline recipe list fallback" },
    { "name": "Performance analysis", "reason": "Cache timing data contributes to PoC performance metrics" }
  ],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "N/A - PoC implementation focused on development experience evaluation",
    "manual_review_comment": "Comprehensive cache service with performance timing and error handling. Ready for integration with recipe list screen and offline mode simulation."
  }
}
ANNOTATION_BLOCK_END */

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_manual.dart';

/// Performance metrics for cache operations
class CacheOperationTiming {
  final Duration duration;
  final int dataSize;
  final DateTime timestamp;
  final String operation;

  const CacheOperationTiming({
    required this.duration,
    required this.dataSize,
    required this.timestamp,
    required this.operation,
  });

  /// Format timing for display/logging
  String get formattedDuration => '${duration.inMilliseconds}ms';
  
  /// Data size in KB
  double get dataSizeKB => dataSize / 1024.0;

  @override
  String toString() => '$operation: ${formattedDuration} (${dataSizeKB.toStringAsFixed(1)}KB)';
}

/// Offline caching service for recipe list data using shared_preferences
/// 
/// Provides offline storage capabilities with performance measurement
/// and comprehensive error handling for the WorldChef PoC evaluation.
/// 
/// Usage:
/// ```dart
/// final cacheService = RecipeCacheService();
/// 
/// // Save recipe list with timing
/// final saveTiming = await cacheService.saveRecipeList(recipeListResponse);
/// 
/// // Load cached recipe list with timing
/// final (cachedData, loadTiming) = await cacheService.loadRecipeList();
/// ```
class RecipeCacheService {
  static const String _cacheKey = 'cached_recipe_list';
  static const String _timestampKey = 'cached_recipe_list_timestamp';
  static const String _versionKey = 'cached_recipe_list_version';
  static const int _currentCacheVersion = 1;
  
  /// Maximum cache age in hours (24 hours for PoC)
  static const int maxCacheAgeHours = 24;

  /// Save recipe list to cache with performance timing measurement
  /// 
  /// Returns timing information for PoC performance analysis.
  /// Throws [CacheException] if storage operation fails.
  /// 
  /// [recipeListResponse] The recipe list data to cache
  Future<CacheOperationTiming> saveRecipeList(RecipeListResponse recipeListResponse) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Serialize recipe list to JSON
      final jsonData = recipeListResponse.toJson();
      final jsonString = jsonEncode(jsonData);
      final dataSize = utf8.encode(jsonString).length;
      
      // Save data, timestamp, and version
      final saveResults = await Future.wait([
        prefs.setString(_cacheKey, jsonString),
        prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch),
        prefs.setInt(_versionKey, _currentCacheVersion),
      ]);
      
      // Verify all operations succeeded
      if (!saveResults.every((result) => result == true)) {
        throw CacheException('Failed to save some cache data to shared_preferences');
      }
      
      stopwatch.stop();
      
      final timing = CacheOperationTiming(
        duration: stopwatch.elapsed,
        dataSize: dataSize,
        timestamp: DateTime.now(),
        operation: 'saveRecipeList',
      );
      
      debugPrint('RecipeCacheService: Saved ${recipeListResponse.count} recipes - $timing');
      
      return timing;
    } catch (e) {
      stopwatch.stop();
      debugPrint('RecipeCacheService: Save failed after ${stopwatch.elapsedMilliseconds}ms: $e');
      throw CacheException('Error saving recipe list to cache: $e');
    }
  }

  /// Load recipe list from cache with performance timing measurement
  /// 
  /// Returns a tuple of (RecipeListResponse?, CacheOperationTiming)
  /// Returns null if no cache exists, cache is invalid, or loading fails.
  /// 
  /// The timing is always returned for PoC performance analysis even on failure.
  Future<(RecipeListResponse?, CacheOperationTiming)> loadRecipeList() async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if cache exists and is valid
      if (!await _isCacheValid(prefs)) {
        stopwatch.stop();
        final timing = CacheOperationTiming(
          duration: stopwatch.elapsed,
          dataSize: 0,
          timestamp: DateTime.now(),
          operation: 'loadRecipeList_invalid',
        );
        debugPrint('RecipeCacheService: Cache invalid or missing - $timing');
        return (null, timing);
      }
      
      // Load cached data
      final jsonString = prefs.getString(_cacheKey);
      if (jsonString == null) {
        stopwatch.stop();
        final timing = CacheOperationTiming(
          duration: stopwatch.elapsed,
          dataSize: 0,
          timestamp: DateTime.now(),
          operation: 'loadRecipeList_missing',
        );
        debugPrint('RecipeCacheService: Cache data missing - $timing');
        return (null, timing);
      }
      
      // Parse JSON data
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final recipeListResponse = RecipeListResponse.fromJson(jsonData);
      final dataSize = utf8.encode(jsonString).length;
      
      stopwatch.stop();
      
      final timing = CacheOperationTiming(
        duration: stopwatch.elapsed,
        dataSize: dataSize,
        timestamp: DateTime.now(),
        operation: 'loadRecipeList',
      );
      
      debugPrint('RecipeCacheService: Loaded ${recipeListResponse.count} recipes - $timing');
      
      return (recipeListResponse, timing);
    } catch (e) {
      stopwatch.stop();
      debugPrint('RecipeCacheService: Load failed after ${stopwatch.elapsedMilliseconds}ms: $e');
      
      final timing = CacheOperationTiming(
        duration: stopwatch.elapsed,
        dataSize: 0,
        timestamp: DateTime.now(),
        operation: 'loadRecipeList_error',
      );
      
      return (null, timing);
    }
  }

  /// Check if cached data exists
  /// 
  /// Returns true if cache exists and is potentially valid.
  /// This is a quick check without full validation.
  Future<bool> hasCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_cacheKey) && 
             prefs.containsKey(_timestampKey);
    } catch (e) {
      debugPrint('RecipeCacheService: Error checking cache existence: $e');
      return false;
    }
  }

  /// Clear all cached recipe data
  /// 
  /// Returns timing information for the clear operation.
  /// Useful for testing and cache management.
  Future<CacheOperationTiming> clearCache() async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final removeResults = await Future.wait([
        prefs.remove(_cacheKey),
        prefs.remove(_timestampKey),
        prefs.remove(_versionKey),
      ]);
      
      stopwatch.stop();
      
      final timing = CacheOperationTiming(
        duration: stopwatch.elapsed,
        dataSize: 0,
        timestamp: DateTime.now(),
        operation: 'clearCache',
      );
      
      debugPrint('RecipeCacheService: Cache cleared - $timing');
      
      return timing;
    } catch (e) {
      stopwatch.stop();
      debugPrint('RecipeCacheService: Clear failed after ${stopwatch.elapsedMilliseconds}ms: $e');
      
      final timing = CacheOperationTiming(
        duration: stopwatch.elapsed,
        dataSize: 0,
        timestamp: DateTime.now(),
        operation: 'clearCache_error',
      );
      
      return timing;
    }
  }

  /// Get cache metadata (age, size estimate)
  /// 
  /// Returns information about the current cache state for diagnostics.
  Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (!prefs.containsKey(_timestampKey)) {
        return {'exists': false};
      }
      
      final timestamp = prefs.getInt(_timestampKey);
      final version = prefs.getInt(_versionKey) ?? 0;
      final jsonString = prefs.getString(_cacheKey);
      
      if (timestamp == null || jsonString == null) {
        return {'exists': false, 'corrupted': true};
      }
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final age = DateTime.now().difference(cacheTime);
      final dataSize = utf8.encode(jsonString).length;
      
      // Try to parse recipe count
      int? recipeCount;
      try {
        final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
        final recipes = jsonData['recipes'] as List<dynamic>?;
        recipeCount = recipes?.length;
      } catch (e) {
        // Ignore parsing errors for metadata
      }
      
      return {
        'exists': true,
        'timestamp': cacheTime.toIso8601String(),
        'age_hours': age.inHours,
        'age_minutes': age.inMinutes,
        'data_size_bytes': dataSize,
        'data_size_kb': (dataSize / 1024.0).toStringAsFixed(1),
        'version': version,
        'recipe_count': recipeCount,
        'is_valid': age.inHours < maxCacheAgeHours && version == _currentCacheVersion,
      };
    } catch (e) {
      return {'exists': false, 'error': e.toString()};
    }
  }

  /// Internal method to validate cache integrity and age
  Future<bool> _isCacheValid(SharedPreferences prefs) async {
    try {
      // Check if all required keys exist
      if (!prefs.containsKey(_cacheKey) || 
          !prefs.containsKey(_timestampKey) ||
          !prefs.containsKey(_versionKey)) {
        return false;
      }
      
      // Check cache version
      final version = prefs.getInt(_versionKey);
      if (version != _currentCacheVersion) {
        debugPrint('RecipeCacheService: Cache version mismatch - expected $_currentCacheVersion, got $version');
        return false;
      }
      
      // Check cache age
      final timestamp = prefs.getInt(_timestampKey);
      if (timestamp == null) return false;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final age = DateTime.now().difference(cacheTime);
      
      if (age.inHours > maxCacheAgeHours) {
        debugPrint('RecipeCacheService: Cache expired - age: ${age.inHours}h (max: ${maxCacheAgeHours}h)');
        return false;
      }
      
      return true;
    } catch (e) {
      debugPrint('RecipeCacheService: Cache validation error: $e');
      return false;
    }
  }
}

/// Exception thrown when cache operations fail
class CacheException implements Exception {
  final String message;
  final String? details;

  const CacheException(this.message, {this.details});

  @override
  String toString() => 'CacheException: $message${details != null ? ' ($details)' : ''}';
} 