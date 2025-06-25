# Supabase Edge Function External API Integration Pattern

## Overview

This cookbook entry documents best practices for integrating external APIs within Supabase Edge Functions, validated during WorldChef's USDA FoodData Central API integration for nutrition enrichment.

**Validation**: Identified and resolved silent authentication failures in Edge Function runtime while maintaining successful external API access.

## Core Integration Architecture

### API Key Management

```typescript
// Environment validation at function start
function validateApiConfiguration(): void {
  const apiKey = Deno.env.get('EXTERNAL_API_KEY');
  
  if (!apiKey) {
    throw new Error('EXTERNAL_API_KEY not configured in Supabase secrets');
  }
  
  if (apiKey.length < 10) {
    throw new Error('EXTERNAL_API_KEY appears invalid (too short)');
  }
  
  console.log(`API key configured: ${apiKey.substring(0, 8)}...`);
}
```

### Retry Logic with Exponential Backoff

```typescript
interface RetryConfig {
  maxRetries: number;
  baseDelayMs: number;
  maxDelayMs: number;
  backoffMultiplier: number;
}

async function fetchWithRetry<T>(
  url: string,
  options: RequestInit,
  config: RetryConfig = {
    maxRetries: 3,
    baseDelayMs: 1000,
    maxDelayMs: 10000,
    backoffMultiplier: 2
  }
): Promise<T> {
  let lastError: Error;
  
  for (let attempt = 1; attempt <= config.maxRetries; attempt++) {
    try {
      console.log(`API attempt ${attempt}/${config.maxRetries}: ${url}`);
      
      const response = await fetch(url, {
        ...options,
        signal: AbortSignal.timeout(15000) // 15s timeout
      });
      
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      
      const data = await response.json();
      console.log(`API success on attempt ${attempt}`);
      return data;
      
    } catch (error) {
      lastError = error as Error;
      console.error(`API attempt ${attempt} failed:`, error.message);
      
      if (attempt === config.maxRetries) {
        break;
      }
      
      // Calculate delay with exponential backoff
      const delay = Math.min(
        config.baseDelayMs * Math.pow(config.backoffMultiplier, attempt - 1),
        config.maxDelayMs
      );
      
      console.log(`Retrying in ${delay}ms...`);
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
  
  throw new Error(`API failed after ${config.maxRetries} attempts: ${lastError.message}`);
}
```

## USDA FoodData Central Integration

### API Configuration

```typescript
interface USDAConfig {
  baseUrl: string;
  apiKey: string;
  searchEndpoint: string;
  foodDetailsEndpoint: string;
  defaultPageSize: number;
}

function getUSDAConfig(): USDAConfig {
  const apiKey = Deno.env.get('USDA_API_KEY');
  if (!apiKey) {
    throw new Error('USDA_API_KEY not configured');
  }
  
  return {
    baseUrl: 'https://api.nal.usda.gov/fdc/v1',
    apiKey,
    searchEndpoint: '/foods/search',
    foodDetailsEndpoint: '/food',
    defaultPageSize: 5
  };
}
```

### Search Implementation

```typescript
interface USDASearchParams {
  query: string;
  dataType?: string[];
  pageSize?: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

async function searchUSDAFood(params: USDASearchParams): Promise<any> {
  const config = getUSDAConfig();
  
  const searchParams = new URLSearchParams({
    api_key: config.apiKey,
    query: params.query,
    dataType: params.dataType?.join(',') || 'Foundation,SR Legacy',
    pageSize: (params.pageSize || config.defaultPageSize).toString(),
    sortBy: params.sortBy || 'dataType.keyword',
    sortOrder: params.sortOrder || 'asc'
  });
  
  const url = `${config.baseUrl}${config.searchEndpoint}?${searchParams}`;
  
  try {
    const response = await fetchWithRetry(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'WorldChef-NutritionEnrichment/1.0'
      }
    });
    
    console.log(`USDA search found ${response.foods?.length || 0} results for "${params.query}"`);
    return response;
    
  } catch (error) {
    console.error(`USDA search failed for "${params.query}":`, error.message);
    throw error;
  }
}
```

### Food Details Retrieval

```typescript
interface NutrientData {
  nutrientId: number;
  nutrientName: string;
  value: number;
  unitName: string;
}

interface USDAFoodDetails {
  fdcId: number;
  description: string;
  foodNutrients: NutrientData[];
}

async function getUSDAFoodDetails(fdcId: number): Promise<USDAFoodDetails> {
  const config = getUSDAConfig();
  const url = `${config.baseUrl}${config.foodDetailsEndpoint}/${fdcId}?api_key=${config.apiKey}`;
  
  try {
    const response = await fetchWithRetry<USDAFoodDetails>(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'WorldChef-NutritionEnrichment/1.0'
      }
    });
    
    console.log(`Retrieved details for FDC ID ${fdcId}: ${response.description}`);
    return response;
    
  } catch (error) {
    console.error(`Failed to get details for FDC ID ${fdcId}:`, error.message);
    throw error;
  }
}
```

## Nutrition Data Extraction

### Nutrient ID Mapping

```typescript
// USDA Nutrient IDs for macronutrients
const USDA_NUTRIENTS = {
  ENERGY_KCAL: 208,    // Energy (calories)
  PROTEIN: 203,        // Protein
  FAT_TOTAL: 204,      // Total lipid (fat)
  CARBS_TOTAL: 205,    // Carbohydrate, by difference
  FIBER: 291,          // Fiber, total dietary
  SUGARS: 269,         // Sugars, total including NLEA
  SODIUM: 307,         // Sodium, Na
  CHOLESTEROL: 601     // Cholesterol
} as const;

interface MacroNutrients {
  calories: number;
  protein_g: number;
  fat_g: number;
  carbs_g: number;
  fiber_g?: number;
  sugars_g?: number;
  sodium_mg?: number;
  cholesterol_mg?: number;
}

function extractMacroNutrients(foodDetails: USDAFoodDetails): MacroNutrients {
  const nutrients = foodDetails.foodNutrients;
  
  const getValue = (nutrientId: number): number => {
    const nutrient = nutrients.find(n => n.nutrientId === nutrientId);
    return nutrient?.value || 0;
  };
  
  return {
    calories: getValue(USDA_NUTRIENTS.ENERGY_KCAL),
    protein_g: getValue(USDA_NUTRIENTS.PROTEIN),
    fat_g: getValue(USDA_NUTRIENTS.FAT_TOTAL),
    carbs_g: getValue(USDA_NUTRIENTS.CARBS_TOTAL),
    fiber_g: getValue(USDA_NUTRIENTS.FIBER),
    sugars_g: getValue(USDA_NUTRIENTS.SUGARS),
    sodium_mg: getValue(USDA_NUTRIENTS.SODIUM),
    cholesterol_mg: getValue(USDA_NUTRIENTS.CHOLESTEROL)
  };
}
```

### Ingredient Matching Logic

```typescript
interface IngredientMatch {
  fdcId: number;
  description: string;
  dataType: string;
  confidence: number;
}

function findBestIngredientMatch(searchResults: any, query: string): IngredientMatch | null {
  if (!searchResults.foods || searchResults.foods.length === 0) {
    return null;
  }
  
  const foods = searchResults.foods;
  const queryLower = query.toLowerCase();
  
  // Scoring algorithm
  const scoredFoods = foods.map((food: any) => {
    const descLower = food.description.toLowerCase();
    let score = 0;
    
    // Exact match bonus
    if (descLower === queryLower) {
      score += 100;
    }
    
    // Starts with query bonus
    if (descLower.startsWith(queryLower)) {
      score += 50;
    }
    
    // Contains all query words
    const queryWords = queryLower.split(' ');
    const matchedWords = queryWords.filter(word => descLower.includes(word));
    score += (matchedWords.length / queryWords.length) * 30;
    
    // Data type preference (Foundation > SR Legacy > others)
    if (food.dataType === 'Foundation') {
      score += 20;
    } else if (food.dataType === 'SR Legacy') {
      score += 10;
    }
    
    // Shorter descriptions are often more generic/accurate
    if (food.description.length < 50) {
      score += 5;
    }
    
    return {
      fdcId: food.fdcId,
      description: food.description,
      dataType: food.dataType,
      confidence: score
    };
  });
  
  // Return highest scoring match
  scoredFoods.sort((a, b) => b.confidence - a.confidence);
  const bestMatch = scoredFoods[0];
  
  console.log(`Best match for "${query}": ${bestMatch.description} (confidence: ${bestMatch.confidence})`);
  return bestMatch;
}
```

## Complete Integration Function

```typescript
async function enrichIngredientNutrition(
  ingredientName: string,
  quantity: number,
  unit: string
): Promise<MacroNutrients> {
  
  try {
    // 1. Search for ingredient
    const searchResults = await searchUSDAFood({
      query: ingredientName,
      pageSize: 10
    });
    
    // 2. Find best match
    const match = findBestIngredientMatch(searchResults, ingredientName);
    if (!match) {
      throw new Error(`No USDA match found for "${ingredientName}"`);
    }
    
    // 3. Get detailed nutrition data
    const foodDetails = await getUSDAFoodDetails(match.fdcId);
    
    // 4. Extract macronutrients (per 100g)
    const macros = extractMacroNutrients(foodDetails);
    
    // 5. Scale to actual quantity
    const scalingFactor = calculateScalingFactor(quantity, unit);
    const scaledMacros: MacroNutrients = {
      calories: Math.round(macros.calories * scalingFactor),
      protein_g: Math.round(macros.protein_g * scalingFactor * 10) / 10,
      fat_g: Math.round(macros.fat_g * scalingFactor * 10) / 10,
      carbs_g: Math.round(macros.carbs_g * scalingFactor * 10) / 10
    };
    
    console.log(`Enriched "${ingredientName}" (${quantity}${unit}):`, scaledMacros);
    return scaledMacros;
    
  } catch (error) {
    console.error(`Failed to enrich "${ingredientName}":`, error.message);
    
    // Return zero macros but log the failure for debugging
    return {
      calories: 0,
      protein_g: 0,
      fat_g: 0,
      carbs_g: 0
    };
  }
}
```

## Unit Conversion and Scaling

```typescript
interface UnitConversion {
  [key: string]: number; // Conversion factor to grams
}

const UNIT_CONVERSIONS: UnitConversion = {
  // Weight units
  'g': 1,
  'gram': 1,
  'grams': 1,
  'kg': 1000,
  'kilogram': 1000,
  'kilograms': 1000,
  'oz': 28.35,
  'ounce': 28.35,
  'ounces': 28.35,
  'lb': 453.59,
  'pound': 453.59,
  'pounds': 453.59,
  
  // Volume units (approximate for common ingredients)
  'ml': 1,        // Assume 1ml ≈ 1g for liquids
  'milliliter': 1,
  'milliliters': 1,
  'l': 1000,
  'liter': 1000,
  'liters': 1000,
  'cup': 240,     // 1 cup ≈ 240ml
  'cups': 240,
  'tbsp': 15,     // 1 tablespoon ≈ 15ml
  'tablespoon': 15,
  'tablespoons': 15,
  'tsp': 5,       // 1 teaspoon ≈ 5ml
  'teaspoon': 5,
  'teaspoons': 5,
  
  // Count units (need ingredient-specific handling)
  'piece': 100,   // Default assumption
  'pieces': 100,
  'item': 100,
  'items': 100
};

function calculateScalingFactor(quantity: number, unit: string): number {
  const unitLower = unit.toLowerCase().trim();
  const conversionFactor = UNIT_CONVERSIONS[unitLower];
  
  if (!conversionFactor) {
    console.warn(`Unknown unit "${unit}", assuming grams`);
    return quantity / 100; // USDA data is per 100g
  }
  
  const totalGrams = quantity * conversionFactor;
  return totalGrams / 100; // Convert to per-100g basis
}
```

## Error Handling and Fallbacks

### Graceful Degradation

```typescript
interface EnrichmentResult {
  success: boolean;
  nutrition: MacroNutrients;
  source: 'usda' | 'fallback';
  error?: string;
}

async function enrichWithFallback(
  ingredientName: string,
  quantity: number,
  unit: string
): Promise<EnrichmentResult> {
  
  try {
    const nutrition = await enrichIngredientNutrition(ingredientName, quantity, unit);
    
    // Check if we got meaningful data
    if (nutrition.calories > 0 || nutrition.protein_g > 0) {
      return {
        success: true,
        nutrition,
        source: 'usda'
      };
    } else {
      throw new Error('USDA returned zero nutrition values');
    }
    
  } catch (error) {
    console.warn(`USDA enrichment failed for "${ingredientName}": ${error.message}`);
    
    // Fallback to basic estimates
    const fallbackNutrition = getFallbackNutrition(ingredientName, quantity, unit);
    
    return {
      success: false,
      nutrition: fallbackNutrition,
      source: 'fallback',
      error: error.message
    };
  }
}

function getFallbackNutrition(ingredientName: string, quantity: number, unit: string): MacroNutrients {
  // Basic fallback estimates for common ingredient categories
  const name = ingredientName.toLowerCase();
  
  let caloriesPerGram = 2; // Default estimate
  
  if (name.includes('oil') || name.includes('butter')) {
    caloriesPerGram = 9; // Fats
  } else if (name.includes('sugar') || name.includes('honey')) {
    caloriesPerGram = 4; // Simple carbs
  } else if (name.includes('meat') || name.includes('chicken') || name.includes('fish')) {
    caloriesPerGram = 2; // Proteins
  }
  
  const scalingFactor = calculateScalingFactor(quantity, unit);
  const totalCalories = Math.round(caloriesPerGram * scalingFactor * 100);
  
  return {
    calories: totalCalories,
    protein_g: Math.round(totalCalories * 0.15 / 4), // Rough estimate
    fat_g: Math.round(totalCalories * 0.25 / 9),     // Rough estimate
    carbs_g: Math.round(totalCalories * 0.60 / 4)    // Rough estimate
  };
}
```

## Testing and Validation

### External API Testing Script

```javascript
// test_usda_api.js - Run outside Edge Function
import 'dotenv/config';

async function testUSDAAPI() {
  const apiKey = process.env.USDA_API_KEY;
  
  if (!apiKey) {
    console.error('USDA_API_KEY not found in environment');
    return;
  }
  
  const testIngredients = [
    'chicken breast',
    'olive oil',
    'brown rice',
    'broccoli'
  ];
  
  for (const ingredient of testIngredients) {
    try {
      console.log(`\nTesting: ${ingredient}`);
      
      // Search
      const searchUrl = `https://api.nal.usda.gov/fdc/v1/foods/search?api_key=${apiKey}&query=${encodeURIComponent(ingredient)}`;
      const searchResponse = await fetch(searchUrl);
      const searchData = await searchResponse.json();
      
      if (searchData.foods && searchData.foods.length > 0) {
        const food = searchData.foods[0];
        console.log(`✓ Found: ${food.description} (FDC ID: ${food.fdcId})`);
        
        // Get details
        const detailsUrl = `https://api.nal.usda.gov/fdc/v1/food/${food.fdcId}?api_key=${apiKey}`;
        const detailsResponse = await fetch(detailsUrl);
        const detailsData = await detailsResponse.json();
        
        // Extract calories
        const calories = detailsData.foodNutrients?.find(n => n.nutrientId === 208)?.value || 0;
        console.log(`✓ Calories: ${calories} per 100g`);
        
      } else {
        console.log(`✗ No results found`);
      }
      
    } catch (error) {
      console.error(`✗ Error testing ${ingredient}:`, error.message);
    }
  }
}

testUSDAAPI();
```

### Edge Function Testing

```typescript
// Add to Edge Function for testing
async function runSelfTest(): Promise<boolean> {
  const testIngredients = [
    { name: 'chicken breast', quantity: 100, unit: 'g' },
    { name: 'olive oil', quantity: 1, unit: 'tbsp' }
  ];
  
  console.log('Running self-test...');
  
  for (const ingredient of testIngredients) {
    try {
      const result = await enrichIngredientNutrition(
        ingredient.name,
        ingredient.quantity,
        ingredient.unit
      );
      
      if (result.calories === 0) {
        console.error(`Self-test failed: ${ingredient.name} returned zero calories`);
        return false;
      }
      
      console.log(`✓ Self-test passed: ${ingredient.name} = ${result.calories} calories`);
      
    } catch (error) {
      console.error(`Self-test failed for ${ingredient.name}:`, error.message);
      return false;
    }
  }
  
  console.log('✓ All self-tests passed');
  return true;
}
```

## Performance Considerations

### Request Optimization

```typescript
// Batch processing for multiple ingredients
async function enrichMultipleIngredients(
  ingredients: Array<{name: string, quantity: number, unit: string}>
): Promise<MacroNutrients[]> {
  
  // Process in parallel with concurrency limit
  const CONCURRENCY_LIMIT = 3;
  const results: MacroNutrients[] = [];
  
  for (let i = 0; i < ingredients.length; i += CONCURRENCY_LIMIT) {
    const batch = ingredients.slice(i, i + CONCURRENCY_LIMIT);
    
    const batchPromises = batch.map(ingredient =>
      enrichIngredientNutrition(ingredient.name, ingredient.quantity, ingredient.unit)
    );
    
    const batchResults = await Promise.all(batchPromises);
    results.push(...batchResults);
  }
  
  return results;
}
```

### Caching Strategy

```typescript
// Cache USDA search results to reduce API calls
interface CacheEntry {
  searchResults: any;
  timestamp: number;
  ttl: number;
}

const searchCache = new Map<string, CacheEntry>();
const CACHE_TTL_MS = 24 * 60 * 60 * 1000; // 24 hours

async function getCachedSearchResults(query: string): Promise<any> {
  const cacheKey = query.toLowerCase();
  const cached = searchCache.get(cacheKey);
  
  if (cached && Date.now() - cached.timestamp < cached.ttl) {
    console.log(`Using cached search results for "${query}"`);
    return cached.searchResults;
  }
  
  // Cache miss - fetch from API
  const results = await searchUSDAFood({ query });
  
  searchCache.set(cacheKey, {
    searchResults: results,
    timestamp: Date.now(),
    ttl: CACHE_TTL_MS
  });
  
  return results;
}
```

## Production Deployment Checklist

### Environment Configuration
- [ ] USDA_API_KEY configured via `supabase secrets set`
- [ ] API key validated with test request
- [ ] Error logging level appropriate for production
- [ ] Timeout values configured for production load

### Performance Validation
- [ ] Single ingredient test returns non-zero values
- [ ] Batch processing tested with realistic payloads
- [ ] Cache hit/miss rates measured
- [ ] API rate limits understood and respected

### Error Handling
- [ ] Fallback nutrition estimates implemented
- [ ] Retry logic configured appropriately
- [ ] Error logging provides actionable information
- [ ] Silent failures eliminated

### Monitoring
- [ ] Success/failure rates tracked
- [ ] API response times monitored
- [ ] Cache performance measured
- [ ] USDA API usage tracked

## Common Issues and Solutions

### Issue: Zero Nutrition Values
**Symptom**: Function returns 200 but all nutrition values are zero
**Solution**: Check USDA API authentication and ingredient matching logic

### Issue: High Latency
**Symptom**: Function takes >5 seconds to respond
**Solution**: Implement caching, optimize ingredient matching, add timeouts

### Issue: API Rate Limiting
**Symptom**: 429 responses from USDA API
**Solution**: Implement exponential backoff, reduce concurrent requests

### Issue: Inaccurate Matches
**Symptom**: Wrong foods selected for ingredients
**Solution**: Improve matching algorithm, add manual overrides for common ingredients

## References

- **USDA FoodData Central API**: https://fdc.nal.usda.gov/api-guide.html
- **Source Implementation**: `_legacy/supabase/functions/nutrition_enrichment/index.ts`
- **External Testing**: `staging/tests/usda_api_test.js`
- **Edge Function Testing**: `staging/tests/test_deployed_function.js`
- **Performance Testing**: `staging/performance/k6_nutrition_edge_function_test.js` 