import 'dart:convert';
import 'dart:io';

void main() async {
  print('🧪 Flutter Smoke Test - Starting...');
  print('📡 Testing connection to mock server at http://localhost:3000');
  
  final client = HttpClient();
  
  try {
    // Test 1: Health check endpoint
    print('\n1. Testing health endpoint...');
    final healthRequest = await client.getUrl(Uri.parse('http://localhost:3000/health'));
    healthRequest.headers.set('Content-Type', 'application/json');
    final healthResponse = await healthRequest.close();
    
    if (healthResponse.statusCode == 200) {
      final healthBody = await healthResponse.transform(utf8.decoder).join();
      final healthData = json.decode(healthBody);
      print('✅ Health check successful!');
      print('   Status: ${healthData['status']}');
      print('   Endpoints available: ${healthData['endpoints']}');
    } else {
      print('❌ Health check failed: ${healthResponse.statusCode}');
      exit(1);
    }
    
    // Test 2: Recipes endpoint
    print('\n2. Testing recipes endpoint...');
    final stopwatch = Stopwatch()..start();
    
    final recipesRequest = await client.getUrl(Uri.parse('http://localhost:3000/recipes?_limit=5'));
    recipesRequest.headers.set('Content-Type', 'application/json');
    final recipesResponse = await recipesRequest.close();
    
    stopwatch.stop();
    
    if (recipesResponse.statusCode == 200) {
      final recipesBody = await recipesResponse.transform(utf8.decoder).join();
      final recipes = json.decode(recipesBody) as List;
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
      exit(1);
    }
    
    // Test 3: Single recipe endpoint
    print('\n3. Testing single recipe endpoint...');
    final singleRecipeRequest = await client.getUrl(Uri.parse('http://localhost:3000/recipes/1'));
    singleRecipeRequest.headers.set('Content-Type', 'application/json');
    final singleRecipeResponse = await singleRecipeRequest.close();
    
    if (singleRecipeResponse.statusCode == 200) {
      final recipeBody = await singleRecipeResponse.transform(utf8.decoder).join();
      final recipe = json.decode(recipeBody);
      print('✅ Single recipe fetch successful!');
      print('   Recipe ID: ${recipe['id']}');
      print('   Recipe title: ${recipe['title']}');
      print('   Cooking time: ${recipe['cookTime']} minutes');
    } else {
      print('❌ Single recipe fetch failed: ${singleRecipeResponse.statusCode}');
      exit(1);
    }
    
    print('\n🎉 Flutter smoke test completed successfully!');
    print('📊 All mock server endpoints are working correctly.');
    print('\nSMOKE TEST PASSED');
    
  } catch (e) {
    print('\n💥 Flutter smoke test failed with error:');
    if (e is SocketException) {
      print('   Network error: ${e.message}');
      print('   Make sure the mock server is running at http://localhost:3000');
    } else {
      print('   Error: $e');
    }
    print('\nSMOKE TEST FAILED');
    exit(1);
  } finally {
    client.close();
  }
} 