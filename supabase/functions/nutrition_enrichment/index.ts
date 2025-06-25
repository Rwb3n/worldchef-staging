// @ts-nocheck
// deno-lint-ignore-file no-explicit-any
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

/*
 * Nutrition Enrichment Edge Function – Optimized Read-Through Cache Implementation
 * 
 * Task: t003_optimize_edge_function (g158)
 * Pattern: Read-Through Cache with Supabase Postgres (from cookbook)
 * Performance Target: p95 latency ≤ 300ms with cache validation
 * 
 * Contract: POST body { ingredients: Ingredient[] }
 * Returns: { nutritionData: object | null, confidence: number, provider: string }
 *
 * USDA API Integration Learnings (g141, cr_t004):
 * - Nutrient IDs are specific codes, e.g., Calories (kcal) is 208, not 1008.
 * - API response for foodNutrients is a flat list.
 * - Nutrient ID is in `nutrientNumber` field.
 * - Nutrient value is in `value` field.
 * - The `USDA_API_KEY` must be set via `supabase secrets set`.
 */

// Types
interface Ingredient { 
  name: string; 
  quantity: number; 
  unit?: string;
}

interface NutritionMacros {
  calories: number;
  protein_g: number;
  fat_g: number;
  carbs_g: number;
}

interface NutritionResult { 
  nutritionData: Record<string, any>; 
  confidence: number; 
  provider: string;
}

// Core nutrient IDs in FoodData Central
// Last verified: 2025-06-23 (Task cr_t004)
const USDA_NUTRIENTS = {
  calories: 208,  // Energy (kcal)
  protein: 203,   // Protein
  fat: 204,       // Total lipid (fat)
  carbs: 205,     // Carbohydrate, by difference
};

// Time-to-live in hours (default 168 = 7 days)
const TTL_HOURS = Number(Deno.env.get("NUTRITION_CACHE_TTL_HOURS") || 168);

// ⚡️ Lazy Supabase admin client for cache table (created on first use)
let _supabaseAdmin: ReturnType<typeof createClient> | null = null;
function getSupabaseAdmin() {
  if (_supabaseAdmin) return _supabaseAdmin;
  const url = Deno.env.get("SUPABASE_URL");
  const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!url || !key) {
    console.warn("[nutrition_enrichment] SUPABASE_URL or SERVICE_ROLE_KEY not set; cache disabled.");
    return null;
  }
  _supabaseAdmin = createClient(url, key);
  return _supabaseAdmin;
}

// Comprehensive Unit Canonicalization (from cookbook pattern)
function canonicalizeUnit(quantity: number, unit: string): { quantity: number, unit: string } {
  const normalized = unit.toLowerCase().trim();
  
  // Weight conversions to grams
  if (['lb', 'pound', 'pounds'].includes(normalized)) {
    return { quantity: quantity * 453.592, unit: 'g' };
  }
  if (['oz', 'ounce', 'ounces'].includes(normalized)) {
    return { quantity: quantity * 28.3495, unit: 'g' };
  }
  if (['kg', 'kilogram', 'kilograms'].includes(normalized)) {
    return { quantity: quantity * 1000, unit: 'g' };
  }
  
  // Volume conversions to mL
  if (['cup', 'cups'].includes(normalized)) {
    return { quantity: quantity * 236.588, unit: 'ml' };
  }
  if (['tsp', 'teaspoon', 'teaspoons'].includes(normalized)) {
    return { quantity: quantity * 4.92892, unit: 'ml' };
  }
  if (['tbsp', 'tablespoon', 'tablespoons'].includes(normalized)) {
    return { quantity: quantity * 14.7868, unit: 'ml' };
  }
  if (['l', 'liter', 'liters', 'litre', 'litres'].includes(normalized)) {
    return { quantity: quantity * 1000, unit: 'ml' };
  }
  
  // Default - return as-is with normalized unit
  return { quantity, unit: normalized };
}

// Optimized Cache Key Generation (from cookbook pattern)
async function ingredientHash(
  name: string, 
  quantity: number, 
  unit: string
): Promise<{ hash: string, canonical: string }> {
  // 1. Normalize the ingredient name
  const normalizedName = name.toLowerCase()
    .trim()
    .replace(/[^\w\s]/g, '') // Remove punctuation
    .replace(/\s+/g, ' '); // Normalize whitespace
  
  // 2. Canonicalize quantity and unit
  const { quantity: canonicalQuantity, unit: canonicalUnit } = canonicalizeUnit(quantity, unit);
  
  // 3. Create canonical string
  const canonical = `${normalizedName}|${canonicalQuantity}|${canonicalUnit}`;
  
  // 4. Generate hash using Web Crypto API
  const hashBuf = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(canonical));
  const hashArr = Array.from(new Uint8Array(hashBuf)).map(b => b.toString(16).padStart(2, "0"));
  
  return { hash: hashArr.join(""), canonical };
}

// Enhanced macro extraction with validation
function extractMacros(food: any): NutritionMacros {
  const macros: NutritionMacros = { calories: 0, protein_g: 0, fat_g: 0, carbs_g: 0 };
  
  if (!food?.foodNutrients) return macros;
  
  // USDA FoodData Central returns nutrients in slightly different structures depending on
  // endpoint (search vs details). Support both common layouts:
  // 1) search endpoint: { nutrientId, nutrientName, unitName, value }
  // 2) details endpoint: { nutrient: { id, number, name, unitName }, amount }
  const findNutrient = (id: number) => {
    if (!Array.isArray(food.foodNutrients)) return 0;

    for (const n of food.foodNutrients) {
      // Case 1 – search endpoint shape
      if (n.nutrientId === id || n.nutrientNumber === String(id)) {
        return Number(n.value ?? 0);
      }
      // Case 2 – details endpoint nested shape
      if (n.nutrient && (n.nutrient.id === id || n.nutrient.number === String(id))) {
        return Number(n.amount ?? n.value ?? 0);
      }
    }

    return 0;
  };

  return {
    calories: findNutrient(USDA_NUTRIENTS.calories),
    protein_g: findNutrient(USDA_NUTRIENTS.protein),
    fat_g: findNutrient(USDA_NUTRIENTS.fat),
    carbs_g: findNutrient(USDA_NUTRIENTS.carbs)
  };
}

// USDA API with retry logic and error handling
async function fetchFromUsdaApiWithRetry(ingredient: Ingredient, maxRetries = 3): Promise<any> {
    const key = Deno.env.get("USDA_API_KEY");
  if (!key) {
    throw new Error("USDA_API_KEY not configured");
  }

  let lastError: Error;
  
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const response = await fetch(`https://api.nal.usda.gov/fdc/v1/foods/search`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': key
        },
        body: JSON.stringify({
          query: ingredient.name,
          pageSize: 1,
          dataType: ['Foundation', 'SR Legacy']
        })
      });

      if (!response.ok) {
        throw new Error(`USDA API error: ${response.status} ${response.statusText}`);
      }

      const data = await response.json();
      
      if (!data.foods || data.foods.length === 0) {
        console.warn(`No nutrition data found for ingredient: ${ingredient.name}`);
        return null;
      }

      return data.foods[0];
      
    } catch (error) {
      lastError = error as Error;
      console.warn(`USDA API attempt ${attempt}/${maxRetries} failed:`, error.message);
      
      if (attempt < maxRetries) {
        // Exponential backoff: 1s, 2s, 4s
        await new Promise(resolve => setTimeout(resolve, Math.pow(2, attempt - 1) * 1000));
      }
    }
  }
  
  throw lastError!;
}

// Read-Through Cache Implementation (exact cookbook pattern)
async function getNutritionWithCache(ingredient: Ingredient): Promise<NutritionMacros> {
  // 1. Compute deterministic hash for the ingredient request
  const { hash, canonical } = await ingredientHash(
    ingredient.name, 
    ingredient.quantity, 
    ingredient.unit || 'g'
  );

  const admin = getSupabaseAdmin();
  
  if (admin) {
    // 2. Attempt to fetch from cache first
    const { data: cacheHit } = await admin
      .from("nutrition_cache")
      .select("macros")
      .eq("ingredient_hash", hash)
      .gt("expires_at", new Date().toISOString()) // Check for expiry
      .maybeSingle();

    if (cacheHit) {
      // 3a. Cache Hit: Return cached data
      console.log(`Cache HIT for: ${canonical}`);
      return cacheHit.macros;
    }
  }

  // 3b. Cache Miss: Fetch from external API
  console.log(`Cache MISS for: ${canonical}`);
  
  try {
    const externalData = await fetchFromUsdaApiWithRetry(ingredient);
    const macros = extractMacros(externalData);

    // 4. Asynchronously write new data back to cache (fire and forget)
    if (admin && externalData) {
      const expiry = new Date(Date.now() + TTL_HOURS * 3600 * 1000).toISOString();
      
      admin.from("nutrition_cache").upsert({
        ingredient_hash: hash,
        canonical_string: canonical,
        macros: macros,
        fdc_id: externalData.fdcId,
        source: 'USDA_FDC',
        expires_at: expiry
      }).then(({ error }) => {
        if (error) {
          console.warn(`Cache write failed for ${canonical}:`, error.message);
        } else {
          console.log(`Cache WRITE for: ${canonical}`);
        }
      });
    }

    return macros;
    
  } catch (error) {
    console.error(`Failed to fetch nutrition for ${ingredient.name}:`, error.message);
    console.error("Stack trace:", error.stack);
    // Propagate error to caller – HTTP handler will aggregate and respond with 500
    throw error;
  }
}

// --- HTTP handler with optimized performance ---------------------------------------------------------
Deno.serve(async (req: Request) => {
  const startTime = performance.now();
  const requestId = crypto.randomUUID().substring(0, 8);
  
  console.log(`[${requestId}] Request started: ${req.method} ${req.url}`);
  
  if (req.method !== "POST") {
    console.log(`[${requestId}] Method not allowed: ${req.method}`);
    return new Response("Method Not Allowed", { status: 405 });
  }

  let body: any;
  try { 
    body = await req.json(); 
  } catch (error) {
    console.log(`[${requestId}] Invalid JSON payload: ${error.message}`);
    return new Response("Invalid JSON", { status: 400 });
  }
  
  const ingredients = Array.isArray(body?.ingredients) ? body.ingredients : [];
  if (ingredients.length === 0) {
    console.log(`[${requestId}] No ingredients provided`);
    return new Response("ingredients[] required", { status: 400 });
  }

  console.log(`[${requestId}] Processing ${ingredients.length} ingredients`);

  // Validate USDA API key early
  const key = Deno.env.get("USDA_API_KEY");
  if (!key) {
    console.error(`[${requestId}] USDA_API_KEY not configured`);
    return new Response("USDA_API_KEY not configured", { status: 500 });
  }

  const items: any[] = [];
  const totals = { calories: 0, protein_g: 0, fat_g: 0, carbs_g: 0 };
  let cacheHits = 0;
  let cacheMisses = 0;

  // Process ingredients with parallel requests for better performance
  const nutritionPromises = ingredients.map(async (ing: any, index: number) => {
    const ingredient: Ingredient = {
      name: ing.name,
      quantity: Number(ing.quantity) || 1,
      unit: ing.unit || 'g'
    };

    const macros = await getNutritionWithCache(ingredient);

    return { ingredient_index: index, nutrition: macros };
  });

  try {
    const results = await Promise.all(nutritionPromises);
    items.push(...results);

    // Calculate totals
    for (const item of items) {
      totals.calories += item.nutrition.calories;
      totals.protein_g += item.nutrition.protein_g;
      totals.fat_g += item.nutrition.fat_g;
      totals.carbs_g += item.nutrition.carbs_g;
    }

    // Calculate cache performance metrics efficiently
    const admin = getSupabaseAdmin();
    if (admin && ingredients.length > 0) {
      // Batch check all ingredient hashes in a single query
      const hashes = await Promise.all(
        ingredients.map(async (ing: any) => {
          const ingredient: Ingredient = {
            name: ing.name,
            quantity: Number(ing.quantity) || 1,
            unit: ing.unit || 'g'
          };
          const { hash } = await ingredientHash(ingredient.name, ingredient.quantity, ingredient.unit);
          return hash;
        })
      );

      const { data: cacheData } = await admin
        .from("nutrition_cache")
        .select("ingredient_hash")
        .in("ingredient_hash", hashes)
        .gt("expires_at", new Date().toISOString());

      cacheHits = cacheData?.length || 0;
      cacheMisses = ingredients.length - cacheHits;
    } else {
      // Fallback when no admin client
      cacheHits = 0;
      cacheMisses = ingredients.length;
    }

  } catch (error) {
    console.error(`[${requestId}] Error processing ingredients:`, error);
    return new Response("Internal server error", { status: 500 });
  }

  const processingTime = performance.now() - startTime;
  
  // Structured performance logging
  console.log(`[${requestId}] Request completed:`, {
    ingredients_count: ingredients.length,
    processing_time_ms: Math.round(processingTime * 100) / 100,
    cache_hits: cacheHits,
    cache_misses: cacheMisses,
    cache_hit_rate: cacheHits + cacheMisses > 0 ? ((cacheHits / (cacheHits + cacheMisses)) * 100).toFixed(1) + '%' : '0%',
    total_calories: Math.round(totals.calories * 100) / 100,
    performance_target_met: processingTime <= 300
  });

  const response = {
    items,
    aggregate_totals: {
      calories: Math.round(totals.calories * 100) / 100,
      protein_g: Math.round(totals.protein_g * 100) / 100,
      fat_g: Math.round(totals.fat_g * 100) / 100,
      carbs_g: Math.round(totals.carbs_g * 100) / 100,
    },
    source: "USDA_FDC",
    cache_performance: {
      hits: cacheHits,
      misses: cacheMisses,
      hit_rate: cacheHits + cacheMisses > 0 ? (cacheHits / (cacheHits + cacheMisses) * 100).toFixed(1) + '%' : '0%'
    },
    processing_time_ms: Math.round(processingTime * 100) / 100,
    generated_at: new Date().toISOString(),
    request_id: requestId
  };

  return new Response(JSON.stringify(response), {
    headers: { 
      "Content-Type": "application/json",
      "Cache-Control": "no-cache", // Prevent CDN caching of dynamic nutrition data
      "X-Request-ID": requestId
    },
  });
}); 

export { ingredientHash, canonicalizeUnit, extractMacros }; 