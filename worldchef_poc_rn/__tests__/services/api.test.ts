/* ANNOTATION_BLOCK_START
{
  "artifact_id": "rn_api_service_tests_v2",
  "version_tag": "1.0.0-testing",
  "g_created": 23,
  "g_last_modified": 23,
  "description": "Unit tests for the enhanced API service covering success scenarios, error handling, retry logic, and error classification with proper mocking of fetch API.",
  "artifact_type": "TEST_SUITE",
  "status_in_lifecycle": "DEVELOPMENT", 
  "purpose_statement": "Validates the enhanced API service functionality including custom error types, retry mechanisms, and proper error propagation to ensure robust API communication.",
  "key_logic_points": [
    "Tests successful API calls for both getRecipes and getRecipeById",
    "Validates custom error type classification (NetworkError, ApiError, NotFoundError)",
    "Tests retry logic with exponential backoff for transient failures",
    "Validates error logging and structured error information",
    "Tests response validation and format checking",
    "Includes integration tests for error classification workflow"
  ],
  "dependencies": [
    "Enhanced API service with error handling and retry logic",
    "Custom error types (NetworkError, ApiError, NotFoundError)",
    "Jest testing framework with fetch mocking capabilities"
  ]
}
ANNOTATION_BLOCK_END */

import { describe, it, expect, beforeEach, afterEach, jest } from '@jest/globals';
import { getRecipes, getRecipeById } from '../../src/services/api';
import { NetworkError, ApiError, NotFoundError } from '../../src/types/errors';
import { Recipe } from '../../src/types';

// Mock the global fetch function
const mockFetch = jest.fn() as jest.MockedFunction<typeof fetch>;
global.fetch = mockFetch;

describe('API Service Tests', () => {
  beforeEach(() => {
    // Reset mocks before each test
    mockFetch.mockClear();
    // Mock console methods to avoid noise in test output
    jest.spyOn(console, 'error').mockImplementation(() => {});
    jest.spyOn(console, 'log').mockImplementation(() => {});
  });

  afterEach(() => {
    // Restore console methods
    jest.restoreAllMocks();
  });

  describe('getRecipes', () => {
    const mockRecipes = [
      {
        id: '1',
        name: 'Test Recipe 1',
        description: 'A test recipe',
        author: 'Test Author',
        imageUrl: 'https://example.com/image1.jpg',
        ingredients: ['ingredient 1', 'ingredient 2'],
        steps: ['step 1', 'step 2']
      },
      {
        id: '2',
        name: 'Test Recipe 2',
        description: 'Another test recipe',
        author: 'Another Author',
        imageUrl: 'https://example.com/image2.jpg',
        ingredients: ['ingredient 3', 'ingredient 4'],
        steps: ['step 3', 'step 4']
      }
    ];

    it('should successfully fetch recipes', async () => {
      // Mock successful response
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        json: async () => mockRecipes
      });

      const result = await getRecipes();

      expect(fetch).toHaveBeenCalledWith('http://localhost:3000/recipes', {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });
      expect(result).toEqual(mockRecipes);
    });

    it('should handle network errors and classify them correctly', async () => {
      // Mock network error (TypeError is what fetch throws for network issues)
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

    it('should validate response format and throw ApiError for non-array', async () => {
      // Mock response with invalid data format
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        json: async () => ({ error: 'Invalid response' }),
      });

      await expect(getRecipes()).rejects.toThrow(ApiError);
      await expect(getRecipes()).rejects.toThrow('Invalid response format: expected array of recipes');
    });

    it('should retry transient errors with exponential backoff', async () => {
      // Mock first call fails, second succeeds
      (fetch as jest.Mock)
        .mockRejectedValueOnce(new Error('Network timeout'))
        .mockResolvedValueOnce({
          ok: true,
          json: async () => mockRecipes,
        });

      const result = await getRecipes();

      expect(fetch).toHaveBeenCalledTimes(2);
      expect(result).toEqual(mockRecipes);
      expect(console.warn).toHaveBeenCalledWith(
        expect.stringContaining('API request failed (attempt 1/3). Retrying in'),
        expect.objectContaining({
          error: 'Network timeout',
          url: 'http://localhost:3000/recipes',
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
      (fetch as jest.Mock).mockRejectedValueOnce(new Error('Connection refused'));

      await expect(getRecipes()).rejects.toThrow();
      
      expect(console.error).toHaveBeenCalledWith(
        'getRecipes failed:',
        expect.objectContaining({
          errorType: 'NetworkError',
          message: 'Connection refused',
          timestamp: expect.any(Date),
          isRetryable: true
        })
      );
    });
  });

  describe('getRecipeById', () => {
    const mockRecipe = {
      id: '1',
      name: 'Test Recipe',
      description: 'A test recipe',
      author: 'Test Author',
      imageUrl: 'https://example.com/image.jpg',
      ingredients: ['ingredient 1', 'ingredient 2'],
      steps: ['step 1', 'step 2']
    };

    it('should successfully fetch recipe by id', async () => {
      // Mock successful response
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        json: async () => mockRecipe,
      });

      const result = await getRecipeById('1');

      expect(fetch).toHaveBeenCalledWith('http://localhost:3000/recipes/1');
      expect(result).toEqual(mockRecipe);
    });

    it('should handle 404 Not Found errors with NotFoundError', async () => {
      // Mock 404 response
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: false,
        status: 404,
        statusText: 'Not Found',
      });

      await expect(getRecipeById('999')).rejects.toThrow(NotFoundError);
      await expect(getRecipeById('999')).rejects.toThrow('Recipe with ID 999 was not found');
    });

    it('should handle invalid response format', async () => {
      // Mock response with invalid data format (null)
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        json: async () => null,
      });

      await expect(getRecipeById('1')).rejects.toThrow(ApiError);
      await expect(getRecipeById('1')).rejects.toThrow('Invalid response format: expected recipe object');
    });

    it('should handle invalid response format (primitive)', async () => {
      // Mock response with invalid data format (string)
      (fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        json: async () => 'invalid response',
      });

      await expect(getRecipeById('1')).rejects.toThrow(ApiError);
      await expect(getRecipeById('1')).rejects.toThrow('Invalid response format: expected recipe object');
    });

    it('should retry network errors for getRecipeById', async () => {
      // Mock network error then success
      (fetch as jest.Mock)
        .mockRejectedValueOnce(new Error('ECONNRESET'))
        .mockResolvedValueOnce({
          ok: true,
          json: async () => mockRecipe,
        });

      const result = await getRecipeById('1');

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

      await expect(getRecipeById('123')).rejects.toThrow();
      
      expect(console.error).toHaveBeenCalledWith(
        'getRecipeById failed:',
        expect.objectContaining({
          errorType: 'NotFoundError',
          message: 'Recipe with ID 123 was not found',
          code: 404,
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

      await expect(getRecipeById('1')).rejects.toThrow(NetworkError);
      await expect(getRecipeById('1')).rejects.toThrow('Timeout');
      
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

      await expect(getRecipeById('123')).rejects.toThrow(NotFoundError);
      await expect(getRecipeById('123')).rejects.toThrow('Recipe with ID 123 was not found');
    });
  });
}); 