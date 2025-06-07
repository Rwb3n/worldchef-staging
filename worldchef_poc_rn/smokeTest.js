import axios from 'axios';

class SmokeTest {
  static baseUrl = 'http://localhost:3000';
  
  static async runConnectivityTest() {
    console.log('🧪 React Native Smoke Test - Starting...');
    console.log('📡 Testing connection to mock server at', this.baseUrl);
    
    try {
      // Test 1: Health check endpoint
      console.log('\n1. Testing health endpoint...');
      const healthResponse = await axios.get(`${this.baseUrl}/health`, {
        timeout: 10000,
        headers: { 'Content-Type': 'application/json' }
      });
      
      if (healthResponse.status === 200) {
        const healthData = healthResponse.data;
        console.log('✅ Health check successful!');
        console.log('   Status:', healthData.status);
        console.log('   Endpoints available:', healthData.endpoints);
      } else {
        console.log('❌ Health check failed:', healthResponse.status);
        return;
      }
      
      // Test 2: Recipes endpoint
      console.log('\n2. Testing recipes endpoint...');
      const startTime = Date.now();
      
      const recipesResponse = await axios.get(`${this.baseUrl}/recipes`, {
        params: { _limit: 5 },
        timeout: 10000,
        headers: { 'Content-Type': 'application/json' }
      });
      
      const responseTime = Date.now() - startTime;
      
      if (recipesResponse.status === 200) {
        const recipes = recipesResponse.data;
        console.log('✅ Recipes fetch successful!');
        console.log('   Response time:', responseTime + 'ms');
        console.log('   Recipes count:', recipes.length);
        
        if (recipes.length > 0) {
          const firstRecipe = recipes[0];
          console.log('   First recipe:', firstRecipe.title);
          console.log('   Schema version:', firstRecipe.schema_version);
          console.log('   Category:', firstRecipe.category);
        }
      } else {
        console.log('❌ Recipes fetch failed:', recipesResponse.status);
        console.log('   Response:', recipesResponse.data);
        return;
      }
      
      // Test 3: Single recipe endpoint
      console.log('\n3. Testing single recipe endpoint...');
      const singleRecipeResponse = await axios.get(`${this.baseUrl}/recipes/1`, {
        timeout: 10000,
        headers: { 'Content-Type': 'application/json' }
      });
      
      if (singleRecipeResponse.status === 200) {
        const recipe = singleRecipeResponse.data;
        console.log('✅ Single recipe fetch successful!');
        console.log('   Recipe ID:', recipe.id);
        console.log('   Recipe title:', recipe.title);
        console.log('   Cooking time:', recipe.cookTime, 'minutes');
      } else {
        console.log('❌ Single recipe fetch failed:', singleRecipeResponse.status);
      }
      
      console.log('\n🎉 React Native smoke test completed successfully!');
      console.log('📊 All mock server endpoints are working correctly.');
      
    } catch (error) {
      console.log('\n💥 React Native smoke test failed with error:');
      if (error.code === 'ECONNREFUSED' || error.code === 'NETWORK_ERROR') {
        console.log('   Network error:', error.message);
        console.log('   Make sure the mock server is running at', this.baseUrl);
      } else if (error.response) {
        console.log('   HTTP Error:', error.response.status, error.response.statusText);
        console.log('   Response:', error.response.data);
      } else {
        console.log('   Error:', error.message);
      }
      throw error;
    }
  }
}

export default SmokeTest; 