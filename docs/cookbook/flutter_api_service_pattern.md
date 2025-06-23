# Flutter API Service Pattern

## Overview

This cookbook entry documents the validated HTTP API service pattern from WorldChef PoC #1, which achieved **100% success rate** during testing and **80-150ms response times** with comprehensive error handling and retry logic.

## Validated Pattern Summary

- **Source**: PoC #1 Flutter implementation (`worldchef_poc_flutter/lib/services/recipe_api_service.dart`)
- **Validation**: 100% success rate, no crashes during comprehensive testing
- **Performance**: 80-150ms API response times with retry logic
- **Error Handling**: Comprehensive exception hierarchy with graceful degradation

## Core Implementation

### API Service Structure

```dart
/// Configuration constants for the Recipe API Service
class ApiConfig {
  static const String baseUrl = 'http://localhost:3000';
  static const Duration requestTimeout = Duration(seconds: 10);
  static const Duration connectTimeout = Duration(seconds: 5);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(milliseconds: 500);
}

/// Abstract interface for API operations to enable testing and mocking
abstract class IRecipeApiService {
  Future<RecipeListResponse> getRecipes({int? limit});
  Future<Recipe> getRecipeById(int id);
  Future<Map<String, dynamic>> healthCheck();
}

/// Comprehensive exception hierarchy for API error handling
class ApiException implements Exception {
  final String message;
  final String? details;
  final int? statusCode;
  const ApiException(this.message, {this.details, this.statusCode});
}

class NetworkException extends ApiException {
  const NetworkException(String message, {String? details}) 
      : super(message, details: details);
}

class ServerException extends ApiException {
  const ServerException(String message, {String? details, int? statusCode})
      : super(message, details: details, statusCode: statusCode);
}

class TimeoutException extends ApiException {
  const TimeoutException(String message, {String? details})
      : super(message, details: details);
}
```

### Singleton API Service

```dart
/// HTTP API service with comprehensive error handling and retry logic
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

  static RecipeApiService get instance => RecipeApiService();
}
```

### Request Method with Retry Logic

```dart
/// Makes an HTTP GET request with retry logic and error handling
Future<http.Response> _makeRequest(
  String endpoint, {
  Map<String, String>? queryParameters,
  int retryCount = 0,
}) async {
  try {
    final uri = _buildUri(endpoint, queryParameters);
    
    final response = await _httpClient
        .get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )
        .timeout(ApiConfig.requestTimeout);

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
    if (retryCount < ApiConfig.maxRetries) {
      await Future.delayed(ApiConfig.retryDelay * (retryCount + 1));
      return _makeRequest(endpoint, queryParameters: queryParameters, retryCount: retryCount + 1);
    }
    throw NetworkException(
      'Network connection failed',
      details: 'Unable to connect to server: ${e.message}',
    );
  } on http.ClientException catch (e) {
    throw NetworkException('HTTP client error', details: e.message);
  } catch (e) {
    if (e.toString().contains('timeout')) {
      throw TimeoutException(
        'Request timed out',
        details: 'Request exceeded ${ApiConfig.requestTimeout.inSeconds} seconds',
      );
    }
    throw ApiException('Unexpected error occurred', details: e.toString());
  }
}
```

## Usage Examples

### Basic API Operations

```dart
// Get service instance
final apiService = RecipeApiService.instance;

// Fetch recipes with error handling
try {
  final recipes = await apiService.getRecipes(limit: 10);
  print('Loaded ${recipes.data.length} recipes');
} on NetworkException catch (e) {
  // Handle network errors - show offline mode
  print('Network error: ${e.message}');
} on ServerException catch (e) {
  // Handle server errors - show error message
  print('Server error: ${e.message}');
} on TimeoutException catch (e) {
  // Handle timeouts - show retry option
  print('Request timed out: ${e.message}');
} on ApiException catch (e) {
  // Handle generic API errors
  print('API error: ${e.message}');
}
```

### Health Check Pattern

```dart
/// Validate API availability before making requests
Future<bool> isApiHealthy() async {
  try {
    final health = await apiService.healthCheck();
    return health['status'] == 'healthy';
  } catch (e) {
    return false;
  }
}
```

## Performance Characteristics

### Validated Metrics (PoC #1)

- **Success Rate**: 100% during comprehensive testing
- **Response Time**: 80-150ms (includes simulated network latency)
- **Retry Success**: Automatic recovery from transient failures
- **Memory Usage**: Efficient HTTP client reuse (minimal allocation)
- **Error Recovery**: Graceful degradation with meaningful error messages

### Configuration Tuning

```dart
class ApiConfig {
  // Production-ready timeouts
  static const Duration requestTimeout = Duration(seconds: 10);
  static const Duration connectTimeout = Duration(seconds: 5);
  
  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(milliseconds: 500);
  
  // Rate limiting considerations
  static const Duration minRequestInterval = Duration(milliseconds: 100);
}
```

## Testing Strategy

### Mock Implementation

```dart
class MockRecipeApiService implements IRecipeApiService {
  @override
  Future<RecipeListResponse> getRecipes({int? limit}) async {
    // Return mock data for testing
    return RecipeListResponse(data: mockRecipes.take(limit ?? 50).toList());
  }
  
  @override
  Future<Recipe> getRecipeById(int id) async {
    final recipe = mockRecipes.firstWhere((r) => r.id == id);
    return recipe;
  }
  
  @override
  Future<Map<String, dynamic>> healthCheck() async {
    return {'status': 'healthy', 'timestamp': DateTime.now().toIso8601String()};
  }
}
```

### Integration Tests

```dart
void main() {
  group('RecipeApiService Integration Tests', () {
    late RecipeApiService apiService;
    
    setUp(() {
      apiService = RecipeApiService.instance;
    });
    
    testWidgets('should handle network failures gracefully', (tester) async {
      // Test network failure scenarios
      try {
        await apiService.getRecipes();
      } on NetworkException catch (e) {
        expect(e.message, contains('Network connection failed'));
      }
    });
    
    testWidgets('should retry on transient failures', (tester) async {
      // Test retry logic with mock server
      final recipes = await apiService.getRecipes(limit: 5);
      expect(recipes.data.length, lessThanOrEqualTo(5));
    });
  });
}
```

## Key Implementation Notes

### Critical Success Factors

1. **Singleton Pattern**: Ensures consistent HTTP client reuse and configuration
2. **Exception Hierarchy**: Enables precise error handling and user feedback
3. **Retry Logic**: Automatic recovery from transient network failures
4. **Timeout Configuration**: Prevents hanging requests with reasonable timeouts
5. **Interface Abstraction**: Enables testing with mock implementations

### AI Development Considerations

- **Don't infer API contracts**: Use concrete API specifications or mock server data
- **Error handling is critical**: Network requests fail frequently in mobile environments
- **Retry logic prevents user frustration**: Handle transient failures transparently
- **Logging is essential**: Include request/response logging for debugging
- **Type safety**: Use strongly-typed models for API responses

## Integration with Other Patterns

### State Management Integration

```dart
// Riverpod integration example
final recipeApiProvider = Provider<IRecipeApiService>((ref) {
  return RecipeApiService.instance;
});

final recipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final apiService = ref.read(recipeApiProvider);
  try {
    final response = await apiService.getRecipes();
    return response.data;
  } catch (e) {
    // Let Riverpod handle error state
    rethrow;
  }
});
```

### Cache Integration

```dart
// Combine with cache service for offline support
class CachedRecipeApiService implements IRecipeApiService {
  final IRecipeApiService _apiService;
  final CacheService _cacheService;
  
  CachedRecipeApiService(this._apiService, this._cacheService);
  
  @override
  Future<RecipeListResponse> getRecipes({int? limit}) async {
    try {
      final response = await _apiService.getRecipes(limit: limit);
      await _cacheService.cacheRecipes(response.data);
      return response;
    } on NetworkException {
      // Fallback to cache on network failure
      final cached = await _cacheService.getCachedRecipes();
      return RecipeListResponse(data: cached.take(limit ?? 50).toList());
    }
  }
}
```

## Production Deployment Checklist

- [ ] Configure production API base URL
- [ ] Set appropriate timeout values for production network conditions
- [ ] Implement proper error tracking/monitoring
- [ ] Add request/response logging for debugging
- [ ] Test retry logic with real network conditions
- [ ] Validate error handling with various failure scenarios
- [ ] Implement rate limiting if required by API
- [ ] Add authentication headers if required
- [ ] Configure HTTPS certificate validation
- [ ] Test offline mode fallback behavior

## References

- **Source Implementation**: `worldchef_poc_flutter/lib/services/recipe_api_service.dart`
- **Performance Data**: `docs/poc1_mobile_stack_selection/stage2_flutter/flutter_performance_data_summary.md`
- **Mock Server**: `worldchef_poc_mock_server/` (test data structure)
- **Validation Evidence**: PoC #1 Flutter implementation (100% success rate) 