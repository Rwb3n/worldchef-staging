// =============================================================================
// WORLDCHEF POC - ENHANCED TYPESCRIPT INTERFACES
// =============================================================================
// AI_ANNOTATION: Enhanced type safety implementation - comprehensive interfaces
// matching complete mock server data structure for better type checking and
// developer experience. Part of Task RN-ENH-003.
// ENHANCEMENT: Moved from basic Recipe interface to complete data model with
// all fields from mock server including cookTime, prepTime, servings, difficulty,
// category, rating, reviewCount, schema_version, and proper ISO date strings.
// =============================================================================

/**
 * Difficulty levels for recipes
 */
export type RecipeDifficulty = 'Easy' | 'Medium' | 'Hard';

/**
 * Recipe categories
 */
export type RecipeCategory = 
  | 'Italian' 
  | 'Asian' 
  | 'Salads' 
  | 'Mexican' 
  | 'Desserts' 
  | 'Seafood' 
  | 'Vegetarian' 
  | 'Breakfast' 
  | 'Soup' 
  | 'British' 
  | 'Comfort Food';

/**
 * Complete Recipe interface matching mock server data structure
 * Includes all fields with proper TypeScript types
 */
export interface Recipe {
  id: number;
  schema_version: number;
  title: string;
  description: string;
  cookTime: number; // minutes
  prepTime: number; // minutes
  servings: number;
  difficulty: RecipeDifficulty;
  category: RecipeCategory;
  ingredients: string[];
  imageUrl: string;
  rating: number; // decimal, e.g., 4.7
  reviewCount: number;
  createdAt: string; // ISO date string, e.g., "2024-01-15T10:30:00Z"
}

/**
 * Recipe card interface for list display
 * Contains essential fields for recipe card UI component
 */
export interface RecipeCard {
  id: number;
  title: string;
  description: string;
  imageUrl: string;
  rating: number;
  reviewCount: number;
  difficulty: RecipeDifficulty;
  category: RecipeCategory;
  cookTime: number;
  prepTime: number;
  servings: number;
}

/**
 * Recipe list response from API
 */
export interface RecipeListResponse {
  recipes: Recipe[];
}

/**
 * Recipe search/filter parameters
 */
export interface RecipeFilters {
  category?: RecipeCategory;
  difficulty?: RecipeDifficulty;
  maxCookTime?: number;
  minRating?: number;
}

/**
 * Utility type for creating new recipes (without server-generated fields)
 */
export type RecipeInput = Omit<Recipe, 'id' | 'schema_version' | 'rating' | 'reviewCount' | 'createdAt'>;

/**
 * Utility type for partial recipe updates
 */
export type RecipeUpdate = Partial<RecipeInput> & { id: number };

// =============================================================================
// AI_ANNOTATION: These enhanced interfaces provide:
// 1. Complete field coverage matching mock server data
// 2. Proper TypeScript union types for enums (difficulty, category)
// 3. Utility types for common operations (creating, updating recipes)
// 4. Clear documentation of field types and purposes
// 5. Type safety for all recipe operations in components and services
// This addresses the gap between basic Recipe interface and comprehensive
// data model needed for robust type checking throughout the application.
// ============================================================================= 