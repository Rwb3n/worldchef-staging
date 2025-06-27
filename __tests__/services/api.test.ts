/* ANNOTATION_BLOCK_START
{
  "artifact_id": "rn_api_service_tests_v2",
  "version_tag": "2.0.0-enhanced-types",
  "g_created": 23,
  "g_last_modified": 25,
  "description": "Unit tests for the enhanced API service covering success scenarios, error handling, retry logic, and error classification with proper mocking of fetch API. Updated for enhanced TypeScript interfaces.",
  "artifact_type": "TEST_SUITE",
  "status_in_lifecycle": "DEVELOPMENT", 
  "purpose_statement": "Validates the enhanced API service functionality including custom error types, retry mechanisms, proper error propagation, and new enhanced TypeScript interfaces to ensure robust API communication.",
  "key_logic_points": [
    "Tests successful API calls for both getRecipes and getRecipeById with enhanced Recipe interface",
    "Validates custom error type classification (NetworkError, ApiError, NotFoundError)",
    "Verifies retry logic with exponential backoff for transient failures",
    "Tests error handling for various HTTP status codes and network failures",
    "Validates JSON parsing error handling and data validation for {recipes: Recipe[]} structure",
    "Ensures proper error logging and structured error propagation",
    "Tests with number IDs instead of string IDs to match enhanced interface"
  ],
  "interfaces_provided": [
    {
      "name": "API Service Test Suite",
      "interface_type": "JEST_TEST_SUITE",
      "details": "Comprehensive unit tests for API service functionality with enhanced types",
      "notes": "Uses Jest mocking for fetch API and validates all error scenarios with new Recipe interface"
    }
  ],
  "requisites": [
    { "description": "Jest testing framework configured", "type": "TESTING_FRAMEWORK" },
    { "description": "Enhanced API service implementation", "type": "CODE_MODULE_DEPENDENCY" },
    { "description": "Enhanced TypeScript interfaces", "type": "CODE_MODULE_DEPENDENCY" },
    { "description": "Custom error types available", "type": "CODE_MODULE_DEPENDENCY" }
  ],
  "external_dependencies": [
    { "name": "jest", "version": "^29.0.0", "reason": "Testing framework for unit tests" }
  ],
  "internal_dependencies": [
    "worldchef_poc_rn/src/services/api.ts",
    "worldchef_poc_rn/src/types/errors.ts",
    "worldchef_poc_rn/src/types/index.ts"
  ],
  "dependents": [],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "Self-testing - this IS the unit test suite",
    "manual_review_comment": "Comprehensive API service test suite updated for enhanced TypeScript interfaces with full coverage of success paths, error scenarios, retry logic, and error classification patterns."
  }
}
ANNOTATION_BLOCK_END */

import { getRecipes, getRecipeById } from '../../src/services/api';
import { NetworkError, ApiError, NotFoundError } from '../../src/types/errors';
import { Recipe } from '../../src/types';
import { API_BASE_URL } from '../../backend/src/utils/constants';

// Mock the global fetch function
global.fetch = jest.fn();

describe('API Service Tests', () => {
  beforeEach(() => {
    // Clear all mocks before each test
    jest.clearAllMocks();
    // Clear console.error and console.warn mocks
    jest.spyOn(console, 'error').mockImplementation(() => {});
    jest.spyOn(console, 'warn').mockImplementation(() => {});
  });

  afterEach(() => {
    // Restore console methods
    jest.restoreAllMocks();
  });

  describe('getRecipes', () => {
    const mockRecipes: Recipe[] = [
      {
        id: 1,
        schema_version: 1,
        title: 'Test Recipe 1',
        description: 'A test recipe',
        cookTime: 25,
        prepTime: 15,
        servings: 4,
        difficulty: 'Medium',
        category: 'Italian',
        ingredients: ['ingredient 1', 'ingredient 2'],
        imageUrl: 'https://example.com/image1.jpg',
        rating: 4.5,
        reviewCount: 100,
        createdAt: '2024-01-15T10:30:00Z'
      },
      {
        id: 2,
        schema_version: 1,
        title: 'Test Recipe 2',
        description: 'Another test recipe',
        cookTime: 30,
        prepTime: 20,
        servings: 2,
        difficulty: 'Easy',
        category: 'Asian',
        ingredients: ['ingredient 3', 'ingredient 4'],
        imageUrl: 'https://example.com/image2.jpg',
        rating: 4.8,
        reviewCount: 200,
        createdAt: '2024-01-16T14:20:00Z'
      }
    ];

    const mockApiResponse = { recipes: mockRecipes };

    it('should successfully fetch recipes', async () => {
      // Mock successful response with {recipes: Recipe[]} structure
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        json: async () => mockApiResponse,
      });

      const result = await getRecipes();

      expect(fetch).toHaveBeenCalledWith(`${API_BASE_URL}/recipes`, undefined);
      expect(result).toEqual(mockRecipes);
    });

    it('should handle network errors and classify them correctly', async () => {
      // Mock network failure
      (fetch as jest.Mock).mockRejectedValueOnce(new TypeError('Failed to fetch'));

      await expect(getRecipes()).rejects.toThrow(NetworkError);
      await expect(getRecipes()).rejects.toThrow('Failed to fetch');
    });

    it('should handle 500 server errors', async () => {
      // Mock server error response
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: false,
        status: 500,
        statusText: 'Internal Server Error',
      });

      await expect(getRecipes()).rejects.toThrow(ApiError);
      await expect(getRecipes()).rejects.toThrow('HTTP 500: Internal Server Error');
    });

    it('should handle JSON parsing errors', async () => {
      // Mock response with invalid JSON
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        json: async () => {
          throw new SyntaxError('Unexpected token');
        },
      });

      await expect(getRecipes()).rejects.toThrow(ApiError);
      await expect(getRecipes()).rejects.toThrow('Failed to parse server response');
    });

    it('should validate response format and throw ApiError for non-recipes structure', async () => {
      // Mock response with invalid data format (no recipes property)
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        json: async () => ({ error: 'Invalid response' }),
      });

      await expect(getRecipes()).rejects.toThrow(ApiError);
      await expect(getRecipes()).rejects.toThrow('Invalid response format: expected {recipes: Recipe[]} structure');
    });

    it('should retry transient errors with exponential backoff', async () => {
      // Mock first call fails, second succeeds
      (fetch as jest.Mock)
        .mockRejectedValueOnce(new Error('Network timeout'))
        .mockResolvedValueOnce({
          ok: true,
          json: async () => mockApiResponse,
        });

      const result = await getRecipes();

      expect(fetch).toHaveBeenCalledTimes(2);
      expect(result).toEqual(mockRecipes);
      expect(console.warn).toHaveBeenCalledWith(
        expect.stringContaining('API request failed (attempt 1/3). Retrying in'),
        expect.objectContaining({
          error: 'Network timeout',
          url: `${API_BASE_URL}/recipes`,
          attempt: 1
        })
      );
    });

    it('should not retry non-retryable errors like 400 Bad Request', async () => {
      // Mock client error response (non-retryable)
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: false,
        status: 400,
        statusText: 'Bad Request',
      });

      await expect(getRecipes()).rejects.toThrow(ApiError);
      await expect(getRecipes()).rejects.toThrow('HTTP 400: Bad Request');
      
      // Should only be called once (no retries for 4xx errors)
      expect(fetch).toHaveBeenCalledTimes(1);
    });

    it('should log errors with structured format', async () => {
      // Mock network error
      (fetch as jest.Mock).mockRejectedValueOnce(new TypeError('Failed to fetch'));

      await expect(getRecipes()).rejects.toThrow();
      
      expect(console.error).toHaveBeenCalledWith(
        'getRecipes failed:',
        expect.objectContaining({
          errorType: 'NetworkError',
          message: 'Failed to fetch',
          timestamp: expect.any(Date),
          isRetryable: true
        })
      );
    });
  });

  describe('getRecipeById', () => {
    const mockRecipe: Recipe = {
      id: 1,
      schema_version: 1,
      title: 'Test Recipe',
      description: 'A test recipe',
      cookTime: 25,
      prepTime: 15,
      servings: 4,
      difficulty: 'Medium',
      category: 'Italian',
      ingredients: ['ingredient 1', 'ingredient 2'],
      imageUrl: 'https://example.com/image.jpg',
      rating: 4.5,
      reviewCount: 100,
      createdAt: '2024-01-15T10:30:00Z'
    };

    it('should successfully fetch recipe by id', async () => {
      // Mock successful response
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        json: async () => mockRecipe,
      });

      const result = await getRecipeById(1);

      expect(fetch).toHaveBeenCalledWith(`${API_BASE_URL}/recipes/1`, undefined);
      expect(result).toEqual(mockRecipe);
    });

    it('should handle 404 Not Found errors with NotFoundError', async () => {
      // Mock 404 response
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: false,
        status: 404,
        statusText: 'Not Found',
      });

      await expect(getRecipeById(999)).rejects.toThrow(NotFoundError);
      await expect(getRecipeById(999)).rejects.toThrow('recipe with ID 999 not found');
    });

    it('should handle invalid response format', async () => {
      // Mock response with invalid data format (null)
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        json: async () => null,
      });

      await expect(getRecipeById(1)).rejects.toThrow(ApiError);
      await expect(getRecipeById(1)).rejects.toThrow('Invalid response format: expected recipe object');
    });

    it('should handle invalid response format (primitive)', async () => {
      // Mock response with invalid data format (string)
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        json: async () => 'invalid response',
      });

      await expect(getRecipeById(1)).rejects.toThrow(ApiError);
      await expect(getRecipeById(1)).rejects.toThrow('Invalid response format: expected recipe object');
    });

    it('should retry network errors for getRecipeById', async () => {
      // Mock network error then success
      (fetch as jest.Mock)
        .mockRejectedValueOnce(new Error('ECONNRESET'))
        .mockResolvedValueOnce({
          ok: true,
          json: async () => mockRecipe,
        });

      const result = await getRecipeById(1);

      expect(fetch).toHaveBeenCalledTimes(2);
      expect(result).toEqual(mockRecipe);
    });

    it('should log errors with resource context for getRecipeById', async () => {
      // Mock 404 error
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: false,
        status: 404,
        statusText: 'Not Found',
      });

      await expect(getRecipeById(123)).rejects.toThrow();
      
      expect(console.error).toHaveBeenCalledWith(
        'getRecipeById failed:',
        expect.objectContaining({
          errorType: 'NotFoundError',
          message: 'recipe with ID 123 not found',
          timestamp: expect.any(Date),
          isRetryable: false,
          resourceId: '123'
        })
      );
    });

    it('should exhaust retries and throw the last error', async () => {
      // Mock repeated failures
      (fetch as jest.Mock)
        .mockRejectedValueOnce(new Error('Timeout'))
        .mockRejectedValueOnce(new Error('Timeout'))
        .mockRejectedValueOnce(new Error('Timeout'));

      await expect(getRecipeById(1)).rejects.toThrow(NetworkError);
      await expect(getRecipeById(1)).rejects.toThrow('Timeout');
      
      // Should try 3 times (initial + 2 retries)
      expect(fetch).toHaveBeenCalledTimes(3);
    });
  });

  describe('Error Classification Integration', () => {
    it('should properly classify TypeError as NetworkError', async () => {
      (fetch as jest.Mock).mockRejectedValueOnce(new TypeError('Failed to fetch'));

      await expect(getRecipes()).rejects.toThrow(NetworkError);
      await expect(getRecipes()).rejects.toThrow('Failed to fetch');
    });

    it('should preserve custom errors when they are already classified', async () => {
      const customError = new NotFoundError('recipe', '123');
      (fetch as jest.Mock).mockRejectedValueOnce(customError);

      await expect(getRecipeById(123)).rejects.toThrow(NotFoundError);
      await expect(getRecipeById(123)).rejects.toThrow('recipe with ID 123 not found');
    });
  });
}); 