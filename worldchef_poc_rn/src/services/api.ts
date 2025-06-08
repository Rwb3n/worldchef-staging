/**
 * Enhanced API Service for WorldChef React Native PoC
 * 
 * AI_ENHANCEMENT_NOTE: Enhanced as part of Task RN-ENH-001 to address sophistication
 * gap with Flutter implementation. Features:
 * - Custom error types with user-friendly messages
 * - Basic retry logic with exponential backoff
 * - Structured error propagation to UI components
 * - Proper error classification for different failure scenarios
 * 
 * AI_ENHANCEMENT_NOTE: Updated as part of Task RN-ENH-003 for enhanced type safety:
 * - Uses comprehensive Recipe and RecipeListResponse interfaces
 * - Handles proper data structure from mock server ({recipes: Recipe[]})
 * - Updated parameter types (number IDs instead of strings)
 */

import { Recipe, RecipeListResponse } from '../types';
import { 
  NetworkError, 
  ApiError, 
  NotFoundError, 
  ApiErrorType,
  classifyError,
  shouldRetryError,
  calculateRetryDelay,
  DEFAULT_RETRY_CONFIG,
  RetryConfig
} from '../types/errors';

// Dynamic API URL that works for both localhost testing and Expo Go
const getApiUrl = (): string => {
  // In test environment, use localhost
  if (process.env.NODE_ENV === 'test') {
    return 'http://localhost:3000';
  }
  
  // Use environment variable if available, otherwise fall back to current network IP
  return process.env.EXPO_PUBLIC_MOCK_SERVER_BASE_URL || 'http://10.181.47.230:3000';
};

const API_URL = getApiUrl();

// Utility function to create a delay promise
function delay(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// Enhanced fetch with retry logic
async function fetchWithRetry(
  url: string, 
  options?: RequestInit, 
  retryConfig: RetryConfig = DEFAULT_RETRY_CONFIG
): Promise<Response> {
  let lastError: ApiErrorType;
  
  for (let attempt = 1; attempt <= retryConfig.maxRetries + 1; attempt++) {
    try {
      const response = await fetch(url, options);
      
      // Handle HTTP error status codes
      if (!response.ok) {
        if (response.status === 404) {
          // Extract resource info from URL for better error context
          const pathParts = url.split('/');
          const resourceId = pathParts[pathParts.length - 1];
          const resourceType = pathParts[pathParts.length - 2] || 'resource';
          throw new NotFoundError(resourceType.slice(0, -1), resourceId); // Remove 's' from 'recipes'
        } else {
          throw new ApiError(`HTTP ${response.status}: ${response.statusText}`, response.status);
        }
      }
      
      return response;
    } catch (error) {
      // Classify the error using our custom error types
      const classifiedError = classifyError(error);
      lastError = classifiedError;
      
      // Check if we should retry this error
      if (shouldRetryError(classifiedError, attempt, retryConfig)) {
        const delayMs = calculateRetryDelay(attempt, retryConfig);
        console.warn(`API request failed (attempt ${attempt}/${retryConfig.maxRetries + 1}). Retrying in ${delayMs}ms...`, {
          error: classifiedError.message,
          url,
          attempt
        });
        await delay(delayMs);
        continue;
      }
      
      // Max retries exceeded or non-retryable error
      throw classifiedError;
    }
  }
  
  // This should never be reached, but TypeScript requires it
  throw lastError!;
}

// Enhanced getRecipes with error handling and retry logic
export const getRecipes = async (): Promise<Recipe[]> => {
  try {
    const response = await fetchWithRetry(`${API_URL}/recipes`);
    
    // Parse JSON with error handling
    try {
      const data = await response.json();
      
      // Handle both formats: direct array or wrapped in {recipes: []}
      if (Array.isArray(data)) {
        // Direct array format (json-server default)
        return data as Recipe[];
      } else if (data && typeof data === 'object' && Array.isArray(data.recipes)) {
        // Wrapped format {recipes: Recipe[]}
        return data.recipes;
      } else {
        throw new ApiError('Invalid response format: expected Recipe[] array or {recipes: Recipe[]} structure', 500);
      }
      
    } catch (jsonError) {
      if (jsonError instanceof ApiError) {
        throw jsonError;
      }
      throw new ApiError('Failed to parse server response', 500, jsonError as Error);
    }
  } catch (error) {
    // Ensure error is properly classified before propagating to UI
    const apiError = error instanceof NetworkError || error instanceof ApiError || error instanceof NotFoundError 
      ? error 
      : classifyError(error);
    
    // Log for debugging while preserving structured error for UI
    console.error('getRecipes failed:', {
      errorType: apiError.constructor.name,
      message: apiError.message,
      code: apiError.code,
      timestamp: apiError.timestamp,
      isRetryable: apiError.isRetryable
    });
    
    throw apiError;
  }
};

// Enhanced getRecipeById with error handling and retry logic
export const getRecipeById = async (id: number): Promise<Recipe> => {
  try {
    const response = await fetchWithRetry(`${API_URL}/recipes/${id}`);
    
    // Parse JSON with error handling
    try {
      const data = await response.json();
      
      // Basic data validation
      if (!data || typeof data !== 'object') {
        throw new ApiError('Invalid response format: expected recipe object', 500);
      }
      
      return data;
    } catch (jsonError) {
      if (jsonError instanceof ApiError) {
        throw jsonError;
      }
      throw new ApiError('Failed to parse server response', 500, jsonError as Error);
    }
  } catch (error) {
    // Ensure error is properly classified before propagating to UI
    const apiError = error instanceof NetworkError || error instanceof ApiError || error instanceof NotFoundError 
      ? error 
      : classifyError(error);
    
    // Log for debugging while preserving structured error for UI
    console.error('getRecipeById failed:', {
      errorType: apiError.constructor.name,
      message: apiError.message,
      code: apiError.code,
      timestamp: apiError.timestamp,
      isRetryable: apiError.isRetryable,
      resourceId: id
    });
    
    throw apiError;
  }
}; 