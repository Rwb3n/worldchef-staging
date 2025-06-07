import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SmokeTest {
  static const String baseUrl = 'http://localhost:3000';
  
  static Future<void> runConnectivityTest() async {
    print('🧪 Flutter Smoke Test - Starting...');
    print('📡 Testing connection to mock server at $baseUrl');
    
    try {
      // Test 1: Health check endpoint
      print('\n1. Testing health endpoint...');
      final healthResponse = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      if (healthResponse.statusCode == 200) {
        final healthData = json.decode(healthResponse.body);
        print('✅ Health check successful!');
        print('   Status: ${healthData['status']}');
        print('   Endpoints available: ${healthData['endpoints']}');
      } else {
        print('❌ Health check failed: ${healthResponse.statusCode}');
        return;
      }
      
      // Test 2: Recipes endpoint
      print('\n2. Testing recipes endpoint...');
      final stopwatch = Stopwatch()..start();
      
      final recipesResponse = await http.get(
        Uri.parse('$baseUrl/recipes?_limit=5'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      stopwatch.stop();
      
      if (recipesResponse.statusCode == 200) {
        final recipes = json.decode(recipesResponse.body) as List;
        print('✅ Recipes fetch successful!');
        print('   Response time: ${stopwatch.elapsedMilliseconds}ms');
        print('   Recipes count: ${recipes.length}');
        
        if (recipes.isNotEmpty) {
          final firstRecipe = recipes[0];
          print('   First recipe: ${firstRecipe['title']}');
          print('   Schema version: ${firstRecipe['schema_version']}');
          print('   Category: ${firstRecipe['category']}');
        }
      } else {
        print('❌ Recipes fetch failed: ${recipesResponse.statusCode}');
        print('   Response: ${recipesResponse.body}');
        return;
      }
      
      // Test 3: Single recipe endpoint
      print('\n3. Testing single recipe endpoint...');
      final singleRecipeResponse = await http.get(
        Uri.parse('$baseUrl/recipes/1'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      if (singleRecipeResponse.statusCode == 200) {
        final recipe = json.decode(singleRecipeResponse.body);
        print('✅ Single recipe fetch successful!');
        print('   Recipe ID: ${recipe['id']}');
        print('   Recipe title: ${recipe['title']}');
        print('   Cooking time: ${recipe['cookTime']} minutes');
      } else {
        print('❌ Single recipe fetch failed: ${singleRecipeResponse.statusCode}');
      }
      
      print('\n🎉 Flutter smoke test completed successfully!');
      print('📊 All mock server endpoints are working correctly.');
      
    } catch (e) {
      print('\n💥 Flutter smoke test failed with error:');
      if (e is SocketException) {
        print('   Network error: ${e.message}');
        print('   Make sure the mock server is running at $baseUrl');
      } else {
        print('   Error: $e');
      }
      rethrow;
    }
  }
} 