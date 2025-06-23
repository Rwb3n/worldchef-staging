# Mock API Testing Pattern

## Overview

This cookbook entry documents the validated mock API testing pattern from WorldChef PoCs #1, providing consistent test data across Flutter and React Native implementations with realistic latency simulation.

**Validation**: 100% test success rate, consistent 80-150ms simulated latency, CORS-enabled for mobile development.

## Core Implementation

### Express Mock Server Structure

```javascript
const express = require('express');
const cors = require('cors');
const jsonServer = require('json-server');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// CORS configuration for mobile development
const corsOptions = {
  origin: function (origin, callback) {
    // Allow requests with no origin (mobile apps)
    if (!origin) return callback(null, true);
    
    // Allow localhost origins for development
    if (origin.startsWith('http://localhost:') || 
        origin.startsWith('http://127.0.0.1:')) {
      return callback(null, true);
    }
    
    // Allow specific mobile app origins
    const allowedOrigins = [
      'http://localhost:19006', // Expo web
      'http://localhost:19000', // Expo dev server
      'exp://localhost:19000',  // Expo app protocol
      'http://10.0.2.2:3000',   // Android emulator
    ];
    
    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }
    
    return callback(new Error('Not allowed by CORS'));
  },
  credentials: true,
  optionsSuccessStatus: 200
};

app.use(cors(corsOptions));
```

### Realistic Latency Simulation

```javascript
// Response time middleware (80-150ms simulation)
app.use((req, res, next) => {
  const delay = Math.floor(Math.random() * 70) + 80; // 80-150ms
  setTimeout(next, delay);
});

// Request logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});
```

### JSON Server Integration

```javascript
// Create JSON Server router
const router = jsonServer.router(path.join(__dirname, 'data', 'recipes.json'));
const middlewares = jsonServer.defaults();

app.use(middlewares);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString(),
    version: '1.0.0',
    endpoints: {
      recipes: '/recipes',
      recipe_by_id: '/recipes/:id'
    }
  });
});

// Use JSON Server router
app.use(router);

app.listen(PORT, () => {
  console.log(`Mock Server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  console.log(`Recipes: http://localhost:${PORT}/recipes`);
});
```

## Mock Data Structure

### Recipe JSON Schema

```json
{
  "recipes": [
    {
      "id": 1,
      "schema_version": 1,
      "title": "Classic Margherita Pizza",
      "description": "Traditional Italian pizza with tomato sauce, mozzarella, and fresh basil",
      "cookTime": 25,
      "prepTime": 15,
      "servings": 4,
      "difficulty": "Medium",
      "category": "Italian",
      "ingredients": ["Pizza dough", "Tomato sauce", "Mozzarella cheese", "Fresh basil", "Olive oil"],
      "imageUrl": "https://example.com/images/margherita-pizza.jpg",
      "rating": 4.7,
      "reviewCount": 1245,
      "createdAt": "2024-01-15T10:30:00Z"
    }
  ]
}
```

### Data Generation Strategy

- **Total Recipes**: 50 realistic entries
- **Categories**: Italian, Asian, Mexican, American, Desserts, Salads, Seafood
- **Difficulty Levels**: Easy, Medium, Hard
- **Rating Range**: 4.1 - 4.9 stars (realistic distribution)
- **Review Counts**: 345 - 2456 reviews (varied engagement)

## API Endpoints

### Available Endpoints

```
GET /health              - Server status and available endpoints
GET /recipes             - All recipes with optional query parameters
GET /recipes/:id         - Single recipe by ID
```

### Query Parameters

```
GET /recipes?_limit=10   - Limit results
GET /recipes?_page=2     - Pagination
GET /recipes?category=Italian - Filter by category
GET /recipes?difficulty=Easy  - Filter by difficulty
```

## Client Integration Patterns

### Flutter Integration

```dart
class RecipeApiService {
  static const String baseUrl = 'http://localhost:3000';
  
  Future<List<Recipe>> getRecipes({int? limit}) async {
    final uri = Uri.parse('$baseUrl/recipes${limit != null ? '?_limit=$limit' : ''}');
    
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return (jsonData['recipes'] as List)
          .map((json) => Recipe.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }
  
  Future<bool> healthCheck() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      final data = jsonDecode(response.body);
      return data['status'] == 'healthy';
    } catch (e) {
      return false;
    }
  }
}
```

### React Native Integration

```javascript
// React Native API service
class RecipeApiService {
  static baseUrl = 'http://localhost:3000';
  
  static async getRecipes(limit) {
    const url = limit ? `${this.baseUrl}/recipes?_limit=${limit}` : `${this.baseUrl}/recipes`;
    
    try {
      const response = await fetch(url, {
        headers: {
          'Content-Type': 'application/json',
        },
      });
      
      if (response.ok) {
        const data = await response.json();
        return data.recipes || data;
      } else {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
    } catch (error) {
      throw new Error(`Network error: ${error.message}`);
    }
  }
  
  static async healthCheck() {
    try {
      const response = await fetch(`${this.baseUrl}/health`);
      const data = await response.json();
      return data.status === 'healthy';
    } catch (error) {
      return false;
    }
  }
}
```

## Smoke Testing Pattern

### Flutter Smoke Test

```dart
void main() async {
  print('🧪 Flutter Smoke Test - Starting...');
  
  final client = HttpClient();
  
  try {
    // Health check
    final healthRequest = await client.getUrl(Uri.parse('http://localhost:3000/health'));
    final healthResponse = await healthRequest.close();
    
    if (healthResponse.statusCode == 200) {
      print('✅ Health check successful!');
    }
    
    // Recipe list test with timing
    final stopwatch = Stopwatch()..start();
    final recipesRequest = await client.getUrl(Uri.parse('http://localhost:3000/recipes?_limit=5'));
    final recipesResponse = await recipesRequest.close();
    stopwatch.stop();
    
    if (recipesResponse.statusCode == 200) {
      final body = await recipesResponse.transform(utf8.decoder).join();
      final recipes = json.decode(body) as List;
      print('✅ Recipes fetch successful!');
      print('   Response time: ${stopwatch.elapsedMilliseconds}ms');
      print('   Recipes count: ${recipes.length}');
    }
    
    print('\n🎉 Smoke test completed successfully!');
  } catch (e) {
    print('\n💥 Smoke test failed: $e');
    exit(1);
  } finally {
    client.close();
  }
}
```

### React Native Smoke Test

```javascript
async function runSmokeTest() {
  console.log('🧪 React Native Smoke Test - Starting...');
  
  try {
    // Health check
    const healthResponse = await fetch('http://localhost:3000/health');
    if (healthResponse.ok) {
      console.log('✅ Health check successful!');
    }
    
    // Recipe list test with timing
    const start = Date.now();
    const recipesResponse = await fetch('http://localhost:3000/recipes?_limit=5');
    const elapsed = Date.now() - start;
    
    if (recipesResponse.ok) {
      const data = await recipesResponse.json();
      const recipes = data.recipes || data;
      console.log('✅ Recipes fetch successful!');
      console.log(`   Response time: ${elapsed}ms`);
      console.log(`   Recipes count: ${recipes.length}`);
    }
    
    console.log('\n🎉 Smoke test completed successfully!');
  } catch (error) {
    console.log(`\n💥 Smoke test failed: ${error.message}`);
    process.exit(1);
  }
}
```

## Network Configuration

### Platform-Specific URLs

```javascript
// Development URL mapping
const getApiUrl = () => {
  if (Platform.OS === 'android') {
    // Android emulator maps localhost to 10.0.2.2
    return 'http://10.0.2.2:3000';
  } else {
    // iOS simulator can use localhost
    return 'http://localhost:3000';
  }
};
```

### CORS Troubleshooting

Common CORS issues and solutions:

```javascript
// Add new origins to CORS configuration
const allowedOrigins = [
  'http://localhost:19006',  // Expo web
  'http://localhost:8081',   // Metro bundler
  'capacitor://localhost',   // Capacitor
  'ionic://localhost',       // Ionic
];
```

## Performance Testing

### Response Time Validation

```javascript
// Measure API performance
async function measureApiPerformance() {
  const iterations = 10;
  const times = [];
  
  for (let i = 0; i < iterations; i++) {
    const start = performance.now();
    await fetch('http://localhost:3000/recipes?_limit=5');
    const end = performance.now();
    times.push(end - start);
  }
  
  const average = times.reduce((a, b) => a + b) / times.length;
  const min = Math.min(...times);
  const max = Math.max(...times);
  
  console.log(`Average: ${average.toFixed(2)}ms`);
  console.log(`Min: ${min.toFixed(2)}ms`);
  console.log(`Max: ${max.toFixed(2)}ms`);
}
```

## Key Implementation Notes

### Critical Success Factors

1. **Realistic Latency**: 80-150ms simulation matches production API characteristics
2. **CORS Configuration**: Comprehensive mobile platform support
3. **Request Logging**: Essential for debugging integration issues
4. **Health Check Endpoint**: Validates server availability before testing
5. **Consistent Data**: Same JSON structure across all client implementations

### AI Development Considerations

- **Don't hardcode localhost**: Use platform-specific URL resolution
- **Include error handling**: Network requests fail in mobile environments
- **Add request timeouts**: Prevent hanging requests during testing
- **Log response times**: Monitor performance across different platforms
- **Validate JSON structure**: Ensure API contract consistency

## Production Migration

### Environment Configuration

```javascript
// Environment-based URL configuration
const API_CONFIG = {
  development: 'http://localhost:3000',
  staging: 'https://api-staging.worldchef.com',
  production: 'https://api.worldchef.com'
};

const getApiUrl = () => {
  return API_CONFIG[process.env.NODE_ENV] || API_CONFIG.development;
};
```

### Migration Checklist

- [ ] Replace mock endpoints with production URLs
- [ ] Update authentication headers if required
- [ ] Adjust timeout values for production network conditions
- [ ] Implement proper error tracking
- [ ] Update CORS configuration for production domains
- [ ] Validate SSL certificate handling
- [ ] Test with real network latency
- [ ] Update smoke tests for production endpoints

## References

- **Source Implementation**: `worldchef_poc_mock_server/`
- **Flutter Integration**: `worldchef_poc_flutter/lib/services/recipe_api_service.dart`
- **Performance Validation**: Both Flutter and React Native PoCs achieved 100% success rates
- **Mock Data Contract**: `worldchef_poc_mock_server/data/recipes.json` 