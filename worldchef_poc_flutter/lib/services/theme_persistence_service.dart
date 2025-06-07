/* ANNOTATION_BLOCK_START
{
  "artifact_id": "flutter_theme_persistence_service",
  "version_tag": "1.0.0-theme-persistence",
  "g_created": 14,
  "g_last_modified": 14,
  "description": "Flutter shared_preferences wrapper service for theme preference persistence with error handling and type safety.",
  "artifact_type": "CODE_MODULE",
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Provides persistent storage for theme preferences using shared_preferences to evaluate Flutter's local storage development experience and integration patterns.",
  "key_logic_points": [
    "Uses shared_preferences for cross-platform local storage",
    "Provides type-safe ThemeMode enum serialization/deserialization",
    "Implements comprehensive error handling with meaningful error messages",
    "Uses singleton pattern for efficient shared_preferences instance management",
    "Includes data validation to handle corrupted preference values gracefully"
  ],
  "interfaces_provided": [
    { 
      "name": "ThemePersistenceService",
      "interface_type": "PERSISTENCE_SERVICE",
      "details": "Theme preference storage and retrieval operations",
      "notes": "Exposes saveThemeMode() and loadThemeMode() methods with ThemeMode enum support"
    }
  ],
  "requisites": [
    { "description": "shared_preferences package for local storage", "type": "EXTERNAL_DEPENDENCY" },
    { "description": "flutter/material.dart for ThemeMode enum", "type": "FRAMEWORK_DEPENDENCY" }
  ],
  "external_dependencies": [
    { "name": "shared_preferences", "version": "^2.2.2", "reason": "Cross-platform local key-value storage for theme preferences" },
    { "name": "flutter/material.dart", "version": "built-in", "reason": "ThemeMode enum definition" }
  ],
  "internal_dependencies": [],
  "dependents": [
    { "name": "ThemeProvider", "reason": "Uses this service for theme state persistence" }
  ],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "N/A - PoC implementation focused on development experience evaluation",
    "manual_review_comment": "Robust persistence service with comprehensive error handling and type safety. Ready for integration with theme provider."
  }
}
ANNOTATION_BLOCK_END */

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting theme preferences using shared_preferences.
/// 
/// Provides type-safe storage and retrieval of ThemeMode preferences
/// with comprehensive error handling and data validation.
/// 
/// Usage:
/// ```dart
/// final service = ThemePersistenceService();
/// 
/// // Save theme preference
/// await service.saveThemeMode(ThemeMode.dark);
/// 
/// // Load theme preference
/// final themeMode = await service.loadThemeMode();
/// ```
class ThemePersistenceService {
  static const String _themeKey = 'app_theme_mode';
  
  /// Save theme mode preference to local storage
  /// 
  /// Converts ThemeMode enum to string representation for storage.
  /// Throws [Exception] if storage operation fails.
  /// 
  /// [themeMode] The theme mode to persist
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = _themeModeToString(themeMode);
      
      final success = await prefs.setString(_themeKey, themeString);
      if (!success) {
        throw Exception('Failed to save theme preference to shared_preferences');
      }
      
      debugPrint('ThemePersistenceService: Saved theme mode: $themeString');
    } catch (e) {
      throw Exception('Error saving theme preference: $e');
    }
  }
  
  /// Load theme mode preference from local storage
  /// 
  /// Returns the saved ThemeMode or defaults to [ThemeMode.system] if:
  /// - No preference is saved
  /// - Saved value is invalid/corrupted
  /// - Storage operation fails
  /// 
  /// Returns [ThemeMode] The loaded theme mode or system default
  Future<ThemeMode> loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themeKey);
      
      if (themeString == null) {
        debugPrint('ThemePersistenceService: No saved theme preference, using system default');
        return ThemeMode.system;
      }
      
      final themeMode = _stringToThemeMode(themeString);
      debugPrint('ThemePersistenceService: Loaded theme mode: $themeString');
      return themeMode;
    } catch (e) {
      debugPrint('ThemePersistenceService: Error loading theme preference: $e');
      // Return system default on any error
      return ThemeMode.system;
    }
  }
  
  /// Clear saved theme preference
  /// 
  /// Useful for reset functionality or testing.
  /// Returns true if successfully cleared or no preference existed.
  Future<bool> clearThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.remove(_themeKey);
      debugPrint('ThemePersistenceService: Cleared theme preference');
      return result;
    } catch (e) {
      debugPrint('ThemePersistenceService: Error clearing theme preference: $e');
      return false;
    }
  }
  
  /// Check if theme preference exists
  /// 
  /// Returns true if a theme preference is currently saved.
  Future<bool> hasThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_themeKey);
    } catch (e) {
      debugPrint('ThemePersistenceService: Error checking theme preference existence: $e');
      return false;
    }
  }
  
  /// Convert ThemeMode enum to string for storage
  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
  
  /// Convert string back to ThemeMode enum
  /// 
  /// Returns [ThemeMode.system] for invalid/unknown strings
  /// to provide graceful degradation.
  ThemeMode _stringToThemeMode(String themeString) {
    switch (themeString.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        debugPrint('ThemePersistenceService: Unknown theme mode string: $themeString, defaulting to system');
        return ThemeMode.system;
    }
  }
} 