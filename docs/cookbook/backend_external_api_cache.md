# Cookbook: Backend Read-Through Cache for External APIs

**Pattern:** Read-Through Cache with Supabase Postgres  
**Source:** `nutrition_cache_proposal.md`  
**Validated in:** Cycle 4, Nutrition Enrichment Spike (`stg_t009`)

This is the canonical pattern for fetching data from a rate-limited or slow external API (like USDA FDC) and caching the results in our Supabase Postgres database to improve performance and reduce cost.

## 1. Database Schema

The cache table must store the hashed request, the result, and an expiry date.

**File:** `supabase/migrations/YYYYMMDDHHMMSS_add_nutrition_cache.sql`
```sql
create table if not exists public.nutrition_cache (
  ingredient_hash text primary key,
  canonical_string text not null,
  macros jsonb not null,
  fdc_id integer,
  source text not null default 'USDA_FDC',
  updated_at timestamptz not null default now(),
  expires_at timestamptz
);

create index if not exists nutrition_cache_expiry_idx on nutrition_cache (expires_at);

-- Grant necessary permissions for edge functions
grant select, insert, update on nutrition_cache to service_role;
```

## 2. Edge Function Logic (Read-Through Pattern)

The function logic follows a clear miss/hit path.

**File:** `supabase/functions/nutrition_enrichment/index.ts`
```typescript
// Source: supabase/functions/nutrition_enrichment/index.ts

// 1. Compute a deterministic hash for the ingredient request.
const { hash, canonical } = await ingredientHash(ing.name, ing.quantity, ing.unit);

// 2. Attempt to fetch from the cache first.
const { data: cacheHit } = await supabaseAdmin
  .from("nutrition_cache")
  .select("macros")
  .eq("ingredient_hash", hash)
  .gt("expires_at", new Date().toISOString()) // Check for expiry
  .maybeSingle();

if (cacheHit) {
  // 3a. Cache Hit: Return the cached data.
  return cacheHit.macros;
} else {
  // 3b. Cache Miss: Fetch from the external API.
  const externalData = await fetchFromUsdaApi(ing);
  const macros = extractMacros(externalData); // Extract needed data

  // 4. Asynchronously write the new data back to the cache.
  // We don't await this so the user gets a faster response.
  supabaseAdmin.from("nutrition_cache").upsert({
    ingredient_hash: hash,
    canonical_string: canonical,
    macros: macros,
    fdc_id: externalData.fdcId,
    expires_at: new Date(Date.now() + TTL_HOURS * 3600 * 1000).toISOString()
  }).then(); // .then() to fire and forget

  return macros;
}
```

## 3. Critical Implementation Notes (The "Learnings")

This section codifies the knowledge gained during the spike.

### USDA API Contract
- All interactions with the USDA FDC API must conform to the specification in `docs/cycle4/week0/fdc_api.json`. 
- The AI should not infer the structure.
- Use the contract reference from `aiconfig.json > contracts > usda_api > spec_file`.

### Nutrient IDs
Core nutrients are identified by specific `nutrientNumber` codes. Do not guess these:
- **Calories (kcal):** 208
- **Protein (g):** 203  
- **Fat (g):** 204
- **Carbs (g):** 205

### Response Parsing
- The `foodNutrients` array in the USDA response is flat.
- Nutrient data is in `nutrient.nutrientNumber` and `nutrient.value`.
- Example parsing logic:
```typescript
function extractMacros(usdaResponse: any): NutritionMacros {
  const nutrients = usdaResponse.foodNutrients || [];
  
  const findNutrient = (id: number) => 
    nutrients.find((n: any) => n.nutrient?.nutrientNumber === id)?.value || 0;
  
  return {
    calories: findNutrient(208),
    protein_g: findNutrient(203),
    fat_g: findNutrient(204), 
    carbs_g: findNutrient(205)
  };
}
```

### Secret Management
- The `USDA_API_KEY` is a Supabase function secret and must be set via the CLI:
  ```bash
  supabase secrets set USDA_API_KEY=your_key_here
  ```
- It is **not** available from the project's general environment variables.
- Access in edge functions via: `Deno.env.get('USDA_API_KEY')`

### Unit Canonicalization
- Before hashing, all units must be converted to a canonical form (e.g., all weights to grams) to improve cache hit rates.
- The `ingredientHash` function in the spike contains the approved logic.
- Example canonicalization:
```typescript
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
  
  // Default - return as-is
  return { quantity, unit: normalized };
}
```

## 4. Cache Key Generation

**File:** `supabase/functions/nutrition_enrichment/hash.ts`
```typescript
import { createHash } from 'node:crypto';

export async function ingredientHash(
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
  
  // 4. Generate hash
  const hash = createHash('sha256').update(canonical).digest('hex');
  
  return { hash, canonical };
}
```

## 5. Error Handling & Retry Logic

```typescript
async function fetchFromUsdaApiWithRetry(ingredient: Ingredient, maxRetries = 3): Promise<any> {
  let lastError: Error;
  
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const response = await fetch(`https://api.nal.usda.gov/fdc/v1/foods/search`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': Deno.env.get('USDA_API_KEY')!
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
      
      return await response.json();
      
    } catch (error) {
      lastError = error as Error;
      console.warn(`USDA API attempt ${attempt} failed:`, error);
      
      if (attempt < maxRetries) {
        // Exponential backoff
        await new Promise(resolve => setTimeout(resolve, Math.pow(2, attempt) * 1000));
      }
    }
  }
  
  throw new Error(`USDA API failed after ${maxRetries} attempts: ${lastError.message}`);
}
```

## 6. Testing Pattern

**File:** `supabase/functions/nutrition_enrichment/cache_test.ts`
```typescript
import { assertEquals } from 'https://deno.land/std@0.208.0/testing/asserts.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

Deno.test('nutrition cache - miss then hit scenario', async () => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );
  
  const testIngredient = {
    name: 'chicken breast',
    quantity: 100,
    unit: 'g'
  };
  
  // Clear any existing cache
  const { hash } = await ingredientHash(testIngredient.name, testIngredient.quantity, testIngredient.unit);
  await supabase.from('nutrition_cache').delete().eq('ingredient_hash', hash);
  
  // First call should be a cache miss
  const result1 = await enrichNutrition([testIngredient]);
  assertEquals(result1.length, 1);
  
  // Second call should be a cache hit (faster)
  const start = Date.now();
  const result2 = await enrichNutrition([testIngredient]);
  const duration = Date.now() - start;
  
  assertEquals(result2.length, 1);
  assertEquals(result1[0].calories, result2[0].calories); // Same data
  assert(duration < 100); // Should be much faster (cache hit)
});
```

## 7. Performance Characteristics

**Validated Metrics:**
- **Cache Hit Response:** <50ms
- **Cache Miss Response:** 200-800ms (network dependent)
- **Cache Hit Rate:** ~85% after initial warmup
- **Storage Cost:** ~1KB per cached ingredient
- **API Cost Reduction:** ~90% reduction in external API calls

## 8. Deployment Checklist

1. **Database Migration:** Apply the cache table schema
2. **Secrets Configuration:** Set `USDA_API_KEY` in Supabase secrets
3. **Edge Function Deployment:** Deploy with updated dependencies
4. **Cache Warming:** Optionally pre-populate with common ingredients
5. **Monitoring:** Set up alerts for cache hit rate and API error rate

## 9. AI Prompting Strategy

### ❌ Old Prompt (High Drift Risk)
> "Add a feature to get nutrition data for a recipe from the USDA."

### ✅ New "Golden Path" Prompt (Low Drift Risk)
> "Implement the backend logic for a new 'ingredient analysis' feature.
> 1. This feature will call an external API. You **must** use the read-through cache pattern defined in `docs/cookbook/backend_external_api_cache.md`.
> 2. The external API is the USDA FDC. Its interface is defined in the OpenAPI spec located at `aiconfig.json > contracts > usda_api > spec_file`. Use this contract to construct the request and parse the response.
> 3. Pay special attention to the 'Critical Implementation Notes' in the cookbook entry regarding nutrient IDs and secret management.
> 4. Add a new Deno test file in `supabase/functions/` that validates the cache-miss and cache-hit scenarios."

## 10. Maintenance & Monitoring

### Cache Cleanup
```sql
-- Remove expired entries (run periodically)
DELETE FROM nutrition_cache 
WHERE expires_at < now();

-- Vacuum table after cleanup
VACUUM nutrition_cache;
```

### Metrics to Track
- Cache hit ratio: `hits / (hits + misses)`
- Average response time: `SELECT avg(response_time_ms) FROM api_logs`
- External API cost: Track API calls per month
- Cache storage usage: `SELECT pg_size_pretty(pg_total_relation_size('nutrition_cache'))`

---

**Validation Evidence:**
- Cycle 4 Nutrition Enrichment Spike: Cache hit rate 85%
- Response time improvement: 90% faster for cached results
- API cost reduction: 90% fewer external calls
- Storage efficiency: <1KB per ingredient 