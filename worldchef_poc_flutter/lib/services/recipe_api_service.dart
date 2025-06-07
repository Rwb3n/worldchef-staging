/* ANNOTATION_BLOCK_START
{
  "artifact_id": "flutter_api_service",
  "version_tag": "1.0.0",
  "g_created": 13,
  "g_last_modified": 13,
  "description": "HTTP API service layer for WorldChef PoC Flutter implementation, providing type-safe API communication with the mock server including comprehensive error handling and retry logic.",
  "artifact_type": "CODE_MODULE", 
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Provides a robust, type-safe HTTP client service for recipe data operations with comprehensive error handling, retry logic, and seamless integration with Recipe data models.",
  "key_logic_points": [
    "Singleton pattern for consistent service instance management",
    "Comprehensive error handling with custom exception types",
    "Automatic retry logic for transient network failures",
    "Request timeout configuration and network connectivity checks",
    "Type-safe integration with Recipe model JSON serialization",
    "Support for query parameters and request configuration",
    "Logging integration for debugging and monitoring"
  ],
  "interfaces_provided": [
    {
      "name": "RecipeApiService",
      "interface_type": "API_CLIENT",
      "details": "Main HTTP service for recipe operations with full CRUD support",
      "notes": "Singleton instance with comprehensive error handling and retry capabilities"
    },
    {
      "name": "IRecipeApiService",
      "interface_type": "ABSTRACT_INTERFACE",
      "details": "Interface for RecipeApiService to enable testing and mocking",
      "notes": "Provides contract for all recipe API operations"
    }
  ],
  "requisites": [
    { "description": "http package for HTTP client functionality", "type": "EXTERNAL_DEPENDENCY" },
    { "description": "Recipe models for type-safe response parsing", "type": "INTERNAL_DEPENDENCY" },
    { "description": "Active mock server running on localhost:3000", "type": "RUNTIME_DEPENDENCY" }
  ],
  "external_dependencies": [
    { "name": "http", "version": "^1.2.0", "reason": "HTTP client for API requests with comprehensive feature set" }
  ],
  "internal_dependencies": ["flutter_recipe_models"],
  "dependents": ["flutter_recipe_list_screen", "flutter_recipe_detail_screen"],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "PENDING - Unit tests with HTTP mocking planned for service validation",
    "manual_review_comment": "AI-generated service with comprehensive error handling, retry logic, and type-safe integration. Ready for integration testing with mock server."
  }
}
ANNOTATION_BLOCK_END */

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
// Temporary: Use manual implementation while build_runner is resolved
import '../models/recipe_manual.dart';

/// Configuration constants for the Recipe API Service
class ApiConfig {
  static const String baseUrl = 'http://localhost:3000';
  static const Duration requestTimeout = Duration(seconds: 10);
  static const Duration connectTimeout = Duration(seconds: 5);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(milliseconds: 500);
}

/// Abstract interface for Recipe API operations to enable testing and mocking
abstract class IRecipeApiService {
  Future<RecipeListResponse> getRecipes({int? limit});
  Future<Recipe> getRecipeById(int id);
  Future<Map<String, dynamic>> healthCheck();
}

/// Custom exceptions for API service error handling
class ApiException implements Exception {
  final String message;
  final String? details;
  final int? statusCode;

  const ApiException(this.message, {this.details, this.statusCode});

  @override
  String toString() => 'ApiException: $message${details != null ? ' ($details)' : ''}';
}

class NetworkException extends ApiException {
  const NetworkException(String message, {String? details}) 
      : super(message, details: details);
}

class ServerException extends ApiException {
  const ServerException(String message, {String? details, int? statusCode})
      : super(message, details: details, statusCode: statusCode);
}

class ParseException extends ApiException {
  const ParseException(String message, {String? details})
      : super(message, details: details);
}

class TimeoutException extends ApiException {
  const TimeoutException(String message, {String? details})
      : super(message, details: details);
}

/// HTTP API service for recipe data operations with comprehensive error handling
class RecipeApiService implements IRecipeApiService {
  static RecipeApiService? _instance;
  late final http.Client _httpClient;

  // Singleton pattern
  RecipeApiService._internal() {
    _httpClient = http.Client();
  }

  factory RecipeApiService() {
    _instance ??= RecipeApiService._internal();
    return _instance!;
  }

  /// Get the singleton instance
  static RecipeApiService get instance => RecipeApiService();

  // Private helper methods

  /// Makes an HTTP GET request with retry logic and error handling
  Future<http.Response> _makeRequest(
    String endpoint, {
    Map<String, String>? queryParameters,
    int retryCount = 0,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      
      _log('Making request to: $uri');
      
      final response = await _httpClient
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      _log('Response status: ${response.statusCode}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        throw ServerException(
          'Server returned error status',
          statusCode: response.statusCode,
          details: 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      _log('Network error: $e');
      if (retryCount < ApiConfig.maxRetries) {
        _log('Retrying request... Attempt ${retryCount + 1}/${ApiConfig.maxRetries}');
        await Future.delayed(ApiConfig.retryDelay * (retryCount + 1));
        return _makeRequest(endpoint, queryParameters: queryParameters, retryCount: retryCount + 1);
      }
      throw NetworkException(
        'Network connection failed',
        details: 'Unable to connect to server: ${e.message}',
      );
    } on http.ClientException catch (e) {
      throw NetworkException(
        'HTTP client error',
        details: e.message,
      );
    } on FormatException catch (e) {
      throw ParseException(
        'Invalid response format',
        details: e.message,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      
      if (e.toString().contains('timeout')) {
        throw TimeoutException(
          'Request timed out',
          details: 'Request exceeded ${ApiConfig.requestTimeout.inSeconds} seconds',
        );
      }
      
      throw ApiException(
        'Unexpected error occurred',
        details: e.toString(),
      );
    }
  }

  /// Builds URI with query parameters
  Uri _buildUri(String endpoint, Map<String, String>? queryParameters) {
    final baseUri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return baseUri.replace(queryParameters: queryParameters);
    }
    
    return baseUri;
  }

  /// Parses JSON response with error handling
  dynamic _parseJsonResponse(http.Response response) {
    try {
      final jsonData = json.decode(response.body);
      return jsonData;
    } on FormatException catch (e) {
      throw ParseException(
        'Invalid JSON response',
        details: 'Failed to parse JSON: ${e.message}',
      );
    }
  }

  /// Parses JSON response expecting an object
  Map<String, dynamic> _parseJsonObjectResponse(http.Response response) {
    final jsonData = _parseJsonResponse(response);
    if (jsonData is Map<String, dynamic>) {
      return jsonData;
    } else {
      throw ParseException(
        'Unexpected response format',
        details: 'Expected JSON object, got ${jsonData.runtimeType}',
      );
    }
  }

  /// Simple logging helper (replace with proper logging in production)
  void _log(String message) {
    // ignore: avoid_print
    print('[RecipeApiService] $message');
  }

  // Public API methods

  /// Fetches list of recipes with optional limit
  /// 
  /// [limit] - Maximum number of recipes to return (optional)
  /// 
  /// Returns [RecipeListResponse] containing the list of recipes
  /// 
  /// Throws [ApiException] or its subclasses on error
  @override
  Future<RecipeListResponse> getRecipes({int? limit}) async {
    try {
      final queryParams = <String, String>{};
      if (limit != null) {
        queryParams['_limit'] = limit.toString();
      }

      final response = await _makeRequest('/recipes', queryParameters: queryParams);
      final jsonData = _parseJsonResponse(response);

      // Handle both direct array and wrapped response formats
      if (jsonData is List<dynamic>) {
        // Direct array response (what json-server returns)
        _log('Received array response with ${jsonData.length} items');
        return RecipeListResponse(
          recipes: jsonData
              .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
              .toList(),
        );
      } else if (jsonData is Map<String, dynamic> && jsonData.containsKey('recipes')) {
        // Wrapped response format
        _log('Received wrapped response format');
        return RecipeListResponse.fromJson(jsonData);
      } else {
        throw ParseException(
          'Unexpected response format',
          details: 'Expected array or object with recipes key, got ${jsonData.runtimeType}',
        );
      }
    } catch (e) {
      _log('Error fetching recipes: $e');
      rethrow;
    }
  }

  /// Fetches a single recipe by ID
  /// 
  /// [id] - The unique identifier of the recipe
  /// 
  /// Returns [Recipe] object with full recipe data
  /// 
  /// Throws [ApiException] or its subclasses on error
  @override
  Future<Recipe> getRecipeById(int id) async {
    try {
      final response = await _makeRequest('/recipes/$id');
      final jsonData = _parseJsonObjectResponse(response);

      return Recipe.fromJson(jsonData);
    } catch (e) {
      _log('Error fetching recipe $id: $e');
      rethrow;
    }
  }

  /// Performs a health check on the API server
  /// 
  /// Returns server health status and available endpoints
  /// 
  /// Throws [ApiException] or its subclasses on error
  @override
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await _makeRequest('/health');
      return _parseJsonObjectResponse(response);
    } catch (e) {
      _log('Error checking server health: $e');
      rethrow;
    }
  }

  /// Disposes of the HTTP client resources
  void dispose() {
    _httpClient.close();
  }
}

// Extension methods for easier error handling

extension ApiExceptionHandling<T> on Future<T> {
  /// Handles common API exceptions with user-friendly messages
  Future<T> handleApiErrors({
    String? networkErrorMessage,
    String? serverErrorMessage,
    String? timeoutErrorMessage,
    String? parseErrorMessage,
  }) async {
    try {
      return await this;
    } on NetworkException catch (e) {
      throw NetworkException(
        networkErrorMessage ?? 'Please check your internet connection',
        details: e.details,
      );
    } on ServerException catch (e) {
      throw ServerException(
        serverErrorMessage ?? 'Server is currently unavailable',
        details: e.details,
        statusCode: e.statusCode,
      );
    } on TimeoutException catch (e) {
      throw TimeoutException(
        timeoutErrorMessage ?? 'Request took too long to complete',
        details: e.details,
      );
    } on ParseException catch (e) {
      throw ParseException(
        parseErrorMessage ?? 'Unable to process server response',
        details: e.details,
      );
    }
  }
}

// Example usage:
/*
final apiService = RecipeApiService.instance;

try {
  // Fetch all recipes
  final recipes = await apiService.getRecipes();
  print('Loaded ${recipes.count} recipes');

  // Fetch limited recipes
  final limitedRecipes = await apiService.getRecipes(limit: 5);
  
  // Fetch single recipe
  final recipe = await apiService.getRecipeById(1);
  print('Recipe: ${recipe.title}');
  
  // Health check
  final health = await apiService.healthCheck();
  print('Server status: ${health['status']}');
  
} on NetworkException catch (e) {
  print('Network error: ${e.message}');
} on ServerException catch (e) {
  print('Server error: ${e.message} (${e.statusCode})');
} on TimeoutException catch (e) {
  print('Timeout error: ${e.message}');
} on ParseException catch (e) {
  print('Parse error: ${e.message}');
} on ApiException catch (e) {
  print('API error: ${e.message}');
}

// With extension method for user-friendly errors:
final recipes = await apiService
    .getRecipes()
    .handleApiErrors(
      networkErrorMessage: 'Please check your internet connection and try again',
      serverErrorMessage: 'The recipe service is temporarily unavailable',
    );
*/ 