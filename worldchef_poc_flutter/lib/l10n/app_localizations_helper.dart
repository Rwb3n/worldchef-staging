/* ANNOTATION_BLOCK_START
{
  "artifact_id": "flutter_i18n_setup_snippet",
  "version_tag": "1.0.0-manual-localization",
  "g_created": 14,
  "g_last_modified": 14,
  "description": "Manual localization helper for WorldChef PoC demonstrating Flutter i18n capabilities without requiring code generation for PoC evaluation.",
  "artifact_type": "CODE_MODULE",
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Provides internationalization functionality for Recipe Detail Screen to evaluate Flutter's i18n development experience including pluralization, interpolation, and RTL support.",
  "key_logic_points": [
    "Manual localization implementation for PoC simplicity",
    "Support for English, Spanish, and Arabic languages",
    "Demonstrates pluralization with ingredient and review counts",
    "String interpolation for dynamic content like recipe creator and timing",
    "RTL layout support for Arabic language testing",
    "Fallback to English for missing translations"
  ],
  "interfaces_provided": [
    {
      "name": "AppLocalizationsHelper",
      "interface_type": "LOCALIZATION_SERVICE",
      "details": "Static helper providing localized strings with pluralization and interpolation",
      "notes": "Demonstrates key Flutter i18n patterns for PoC evaluation"
    }
  ],
  "requisites": [
    { "description": "flutter/material for Locale support", "type": "FRAMEWORK_DEPENDENCY" },
    { "description": "intl package for pluralization formatting", "type": "EXTERNAL_DEPENDENCY" }
  ],
  "external_dependencies": [
    { "name": "intl", "version": "^0.19.0", "reason": "Pluralization and number formatting support" }
  ],
  "internal_dependencies": [],
  "dependents": ["flutter_recipe_detail_screen"],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "N/A - PoC implementation for i18n evaluation",
    "manual_review_comment": "Manual localization helper demonstrating Flutter i18n key features for Task F008 evaluation."
  }
}
ANNOTATION_BLOCK_END */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Manual localization helper for WorldChef PoC
/// 
/// Demonstrates Flutter internationalization features including:
/// - Multiple language support (English, Spanish, Arabic)
/// - String interpolation for dynamic content
/// - Pluralization for counts (ingredients, reviews)
/// - RTL layout support for Arabic
/// 
/// This is a PoC implementation that works without code generation
/// to evaluate Flutter's i18n development experience.
class AppLocalizationsHelper {
  static const String _fallbackLocale = 'en';
  
  /// Get current locale from context
  static Locale getCurrentLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }
  
  /// Check if current locale is RTL
  static bool isRTL(BuildContext context) {
    final locale = getCurrentLocale(context);
    return locale.languageCode == 'ar' || locale.languageCode == 'he';
  }
  
  /// Get localized string by key and locale
  static String _getString(String locale, String key) {
    final localeData = _localizationData[locale] ?? _localizationData[_fallbackLocale]!;
    return localeData[key] ?? _localizationData[_fallbackLocale]![key] ?? key;
  }
  
  /// Get localized string for current context
  static String get(BuildContext context, String key) {
    final locale = getCurrentLocale(context).languageCode;
    return _getString(locale, key);
  }
  
  /// String interpolation helper
  static String interpolate(BuildContext context, String key, Map<String, dynamic> params) {
    String text = get(context, key);
    
    for (final entry in params.entries) {
      text = text.replaceAll('{${entry.key}}', entry.value.toString());
    }
    
    return text;
  }
  
  /// Pluralization helper
  static String plural(BuildContext context, String key, int count) {
    final locale = getCurrentLocale(context).languageCode;
    final pluralKey = '${key}_plural';
    
    // Get plural rules for each language
    String pluralText;
    switch (locale) {
      case 'es':
        pluralText = _getString(locale, pluralKey);
        if (count == 0) {
          pluralText = pluralText.replaceFirst(RegExp(r'\{count, plural, =0\{([^}]+)\}.*'), r'$1');
        } else if (count == 1) {
          pluralText = pluralText.replaceFirst(RegExp(r'.*=1\{([^}]+)\}.*'), r'$1');
        } else {
          pluralText = pluralText.replaceFirst(RegExp(r'.*other\{([^}]+)\}.*'), r'$1');
        }
        break;
      case 'ar':
        pluralText = _getString(locale, pluralKey);
        if (count == 0) {
          pluralText = pluralText.replaceFirst(RegExp(r'\{count, plural, =0\{([^}]+)\}.*'), r'$1');
        } else if (count == 1) {
          pluralText = pluralText.replaceFirst(RegExp(r'.*=1\{([^}]+)\}.*'), r'$1');
        } else {
          pluralText = pluralText.replaceFirst(RegExp(r'.*other\{([^}]+)\}.*'), r'$1');
        }
        break;
      default: // English
        pluralText = _getString(_fallbackLocale, pluralKey);
        if (count == 0) {
          pluralText = pluralText.replaceFirst(RegExp(r'\{count, plural, =0\{([^}]+)\}.*'), r'$1');
        } else if (count == 1) {
          pluralText = pluralText.replaceFirst(RegExp(r'.*=1\{([^}]+)\}.*'), r'$1');
        } else {
          pluralText = pluralText.replaceFirst(RegExp(r'.*other\{([^}]+)\}.*'), r'$1');
        }
    }
    
    return pluralText.replaceAll('{count}', count.toString());
  }
  
  /// Combined interpolation and pluralization
  static String pluralWithParams(BuildContext context, String key, int count, Map<String, dynamic> params) {
    String text = plural(context, key, count);
    
    for (final entry in params.entries) {
      text = text.replaceAll('{${entry.key}}', entry.value.toString());
    }
    
    return text;
  }
  
  /// Localization data map
  static const Map<String, Map<String, String>> _localizationData = {
    'en': {
      'recipeDetailTitle': 'Recipe Details',
      'recipeBy': 'Recipe by {creatorName}',
      'cookingTime': 'Cooking Time',
      'preparationTime': 'Prep Time',
      'servings': 'Servings',
      'difficulty': 'Difficulty',
      'ingredients': 'Ingredients',
      'ingredientCount_plural': '{count, plural, =0{No ingredients} =1{1 ingredient} other{{count} ingredients}}',
      'cookingSteps': 'Cooking Steps',
      'stepNumber': 'Step {number}',
      'totalTime': 'Total: {minutes}m',
      'rating': 'Rating: {rating}/5',
      'reviewCount_plural': '{count, plural, =0{No reviews} =1{1 review} other{{count} reviews}}',
      'backToRecipes': 'Back to Recipes',
      'recipeImage': 'Recipe image for {recipeName}',
      'difficultyEasy': 'Easy',
      'difficultyMedium': 'Medium',
      'difficultyHard': 'Hard',
      'loadingRecipe': 'Loading recipe details...',
      'recipeNotFound': 'Recipe not found',
      'errorLoadingRecipe': 'Error loading recipe',
      'tryAgain': 'Try Again',
    },
    'es': {
      'recipeDetailTitle': 'Detalles de la Receta',
      'recipeBy': 'Receta de {creatorName}',
      'cookingTime': 'Tiempo de Cocción',
      'preparationTime': 'Tiempo de Preparación',
      'servings': 'Porciones',
      'difficulty': 'Dificultad',
      'ingredients': 'Ingredientes',
      'ingredientCount_plural': '{count, plural, =0{Sin ingredientes} =1{1 ingrediente} other{{count} ingredientes}}',
      'cookingSteps': 'Pasos de Cocción',
      'stepNumber': 'Paso {number}',
      'totalTime': 'Total: {minutes}m',
      'rating': 'Calificación: {rating}/5',
      'reviewCount_plural': '{count, plural, =0{Sin reseñas} =1{1 reseña} other{{count} reseñas}}',
      'backToRecipes': 'Volver a Recetas',
      'recipeImage': 'Imagen de receta para {recipeName}',
      'difficultyEasy': 'Fácil',
      'difficultyMedium': 'Medio',
      'difficultyHard': 'Difícil',
      'loadingRecipe': 'Cargando detalles de la receta...',
      'recipeNotFound': 'Receta no encontrada',
      'errorLoadingRecipe': 'Error al cargar la receta',
      'tryAgain': 'Intentar de Nuevo',
    },
    'ar': {
      'recipeDetailTitle': 'تفاصيل الوصفة',
      'recipeBy': 'وصفة من {creatorName}',
      'cookingTime': 'وقت الطبخ',
      'preparationTime': 'وقت التحضير',
      'servings': 'الحصص',
      'difficulty': 'الصعوبة',
      'ingredients': 'المكونات',
      'ingredientCount_plural': '{count, plural, =0{لا توجد مكونات} =1{مكون واحد} other{{count} مكونات}}',
      'cookingSteps': 'خطوات الطبخ',
      'stepNumber': 'الخطوة {number}',
      'totalTime': 'المجموع: {minutes} دقيقة',
      'rating': 'التقييم: {rating}/5',
      'reviewCount_plural': '{count, plural, =0{لا توجد مراجعات} =1{مراجعة واحدة} other{{count} مراجعات}}',
      'backToRecipes': 'العودة إلى الوصفات',
      'recipeImage': 'صورة الوصفة لـ {recipeName}',
      'difficultyEasy': 'سهل',
      'difficultyMedium': 'متوسط',
      'difficultyHard': 'صعب',
      'loadingRecipe': 'تحميل تفاصيل الوصفة...',
      'recipeNotFound': 'الوصفة غير موجودة',
      'errorLoadingRecipe': 'خطأ في تحميل الوصفة',
      'tryAgain': 'حاول مرة أخرى',
    },
  };
}

/// Extension to make localization easier to use
extension BuildContextLocalization on BuildContext {
  /// Get localized string
  String l10n(String key) => AppLocalizationsHelper.get(this, key);
  
  /// Get localized string with interpolation
  String l10nInterpolate(String key, Map<String, dynamic> params) => 
      AppLocalizationsHelper.interpolate(this, key, params);
  
  /// Get pluralized string
  String l10nPlural(String key, int count) => 
      AppLocalizationsHelper.plural(this, key, count);
  
  /// Check if current locale is RTL
  bool get isRTL => AppLocalizationsHelper.isRTL(this);
} 