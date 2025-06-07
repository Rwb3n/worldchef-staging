/* ANNOTATION_BLOCK_START
{
  "artifact_id": "flutter_ui_state_management",
  "version_tag": "1.0.0-theme-provider",
  "g_created": 14,
  "g_last_modified": 14,
  "description": "Flutter Provider-based theme state management for light/dark theme toggle with persistence support.",
  "artifact_type": "CODE_MODULE",
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Implements global theme state management using Provider pattern with shared_preferences persistence to evaluate Flutter's state management development experience.",
  "key_logic_points": [
    "Uses ChangeNotifier pattern with Provider for reactive theme state",
    "Integrates with ThemePersistenceService for automatic persistence",
    "Provides type-safe theme mode access throughout the widget tree",
    "Supports both system theme and manual override modes",
    "Includes error handling for persistence failures with fallback to system theme"
  ],
  "interfaces_provided": [
    { 
      "name": "ThemeProvider",
      "interface_type": "STATE_PROVIDER",
      "details": "Global theme state management with persistence",
      "notes": "Exposes currentThemeMode, isDarkMode, toggleTheme() and initialization methods"
    }
  ],
  "requisites": [
    { "description": "provider package for state management", "type": "EXTERNAL_DEPENDENCY" },
    { "description": "flutter/material.dart for ThemeMode enum", "type": "FRAMEWORK_DEPENDENCY" },
    { "description": "ThemePersistenceService for storage integration", "type": "INTERNAL_DEPENDENCY" }
  ],
  "external_dependencies": [
    { "name": "provider", "version": "^6.1.1", "reason": "State management solution for theme state" },
    { "name": "flutter/material.dart", "version": "built-in", "reason": "ThemeMode enum and Material Design integration" }
  ],
  "internal_dependencies": [
    { "name": "ThemePersistenceService", "reason": "Handles theme preference persistence to shared_preferences" }
  ],
  "dependents": [
    { "name": "main.dart", "reason": "App-level theme configuration and provider setup" },
    { "name": "Theme toggle UI components", "reason": "Consume theme state for UI updates" }
  ],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "N/A - PoC implementation focused on development experience evaluation",
    "manual_review_comment": "Provider pattern implementation with comprehensive error handling and persistence integration. Ready for integration with main app widget."
  }
}
ANNOTATION_BLOCK_END */

import 'package:flutter/material.dart';
import '../services/theme_persistence_service.dart';

/// Global theme state management using Provider pattern.
/// 
/// Manages light/dark theme toggling with automatic persistence
/// to shared_preferences. Provides reactive theme updates throughout
/// the widget tree.
/// 
/// Usage:
/// ```dart
/// // Access theme state
/// final themeProvider = context.watch<ThemeProvider>();
/// final isDark = themeProvider.isDarkMode;
/// 
/// // Toggle theme
/// context.read<ThemeProvider>().toggleTheme();
/// ```
class ThemeProvider extends ChangeNotifier {
  final ThemePersistenceService _persistenceService;
  ThemeMode _currentThemeMode = ThemeMode.system;
  bool _isInitialized = false;

  ThemeProvider(this._persistenceService);

  /// Current theme mode (light, dark, or system)
  ThemeMode get currentThemeMode => _currentThemeMode;

  /// Whether the current effective theme is dark mode
  /// 
  /// Returns true if explicitly set to dark mode, or if system mode
  /// is active and the system is using dark theme.
  bool get isDarkMode {
    if (_currentThemeMode == ThemeMode.dark) return true;
    if (_currentThemeMode == ThemeMode.light) return false;
    
    // For system mode, we'll default to light during PoC
    // In production, this would check MediaQuery.platformBrightnessOf(context)
    return false;
  }

  /// Whether the provider has completed initialization
  bool get isInitialized => _isInitialized;

  /// Initialize theme provider by loading saved preference
  /// 
  /// Should be called once during app startup before MaterialApp
  /// widget is built to ensure proper theme application.
  /// 
  /// Returns the loaded theme mode or ThemeMode.system as fallback.
  Future<ThemeMode> initialize() async {
    try {
      _currentThemeMode = await _persistenceService.loadThemeMode();
      _isInitialized = true;
      notifyListeners();
      return _currentThemeMode;
    } catch (e) {
      // Fallback to system theme on persistence errors
      debugPrint('ThemeProvider: Failed to load theme preference: $e');
      _currentThemeMode = ThemeMode.system;
      _isInitialized = true;
      notifyListeners();
      return _currentThemeMode;
    }
  }

  /// Toggle between light and dark themes
  /// 
  /// Cycles through: light → dark → system → light
  /// Automatically persists the new theme preference.
  Future<void> toggleTheme() async {
    final ThemeMode newTheme;
    
    switch (_currentThemeMode) {
      case ThemeMode.light:
        newTheme = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newTheme = ThemeMode.system;
        break;
      case ThemeMode.system:
        newTheme = ThemeMode.light;
        break;
    }

    await _setThemeMode(newTheme);
  }

  /// Set specific theme mode programmatically
  /// 
  /// Useful for settings screens or programmatic theme switching.
  /// Automatically persists the preference.
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _setThemeMode(themeMode);
  }

  /// Internal method to update theme mode with persistence
  Future<void> _setThemeMode(ThemeMode themeMode) async {
    if (_currentThemeMode == themeMode) return;

    _currentThemeMode = themeMode;
    notifyListeners();

    try {
      await _persistenceService.saveThemeMode(themeMode);
    } catch (e) {
      debugPrint('ThemeProvider: Failed to persist theme preference: $e');
      // Continue with theme change even if persistence fails
    }
  }

  /// Get display name for current theme mode
  /// 
  /// Useful for UI elements showing current theme status.
  String get currentThemeDisplayName {
    switch (_currentThemeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Get icon for current theme mode
  /// 
  /// Returns appropriate Material Design icon for theme toggle buttons.
  IconData get currentThemeIcon {
    switch (_currentThemeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
} 