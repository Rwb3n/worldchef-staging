# Supabase Edge Function Cache Debugging Pattern

> **Pattern**: Systematic debugging methodology for Edge Function cache system failures  
> **Source**: Task t003 - Nutrition Enrichment Edge Function optimization  
> **Validation**: Production debugging experience with 0% cache hit rate issue resolved via systematic permission fix, achieving 100% cache hit rate and 78% performance improvement

## Overview

This pattern provides a systematic approach to debugging cache system failures in Supabase Edge Functions, particularly when implementing read-through cache patterns with external APIs.

## Problem Statement

Edge Functions with read-through cache implementations may experience:
- 0% cache hit rates despite proper implementation
- Performance degradation (497% over target observed)
- Silent cache write failures
- Database permission issues

## Root Cause Categories

### 1. Database Schema Issues
- **Missing tables**: Cache table doesn't exist
- **Column mismatches**: Schema doesn't match code expectations
- **Index problems**: Poor query performance on cache lookups

### 2. Permission Issues
- **RLS policies**: Service role blocked by Row Level Security
- **Database permissions**: Insufficient privileges for cache operations
- **Connection issues**: Edge Function can't connect to database

### 3. Code Logic Issues
- **Cache key generation**: Inconsistent or incorrect hash generation
- **Error handling**: Silent failures masking cache write errors
- **Async operations**: Promises not properly awaited

### 4. Environment Issues
- **Missing secrets**: Database connection strings not configured
- **Network issues**: Connectivity problems between Edge Function and database
- **Runtime limitations**: Deno runtime restrictions

## Debugging Methodology

### Phase 1: Environment Validation

```bash
# Verify all secrets are configured
supabase secrets list --project-ref [PROJECT_ID]

# Expected output should include:
# - SUPABASE_URL
# - SUPABASE_SERVICE_ROLE_KEY
# - SUPABASE_ANON_KEY (if needed)
# - External API keys (e.g., USDA_API_KEY)
```

### Phase 2: Database Connectivity

```typescript
// Add to Edge Function for debugging
const admin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

// Test basic connectivity
try {
  const { data, error } = await admin.from("nutrition_cache").select("count").limit(1);
  console.log("Database connectivity test:", { data, error });
} catch (e) {
  console.error("Database connection failed:", e);
}
```

### Phase 3: Cache Operation Debugging

```typescript
// Enhanced cache debugging with detailed logging
async function debugCacheOperation(hash: string, canonical: string) {
  console.log(`🔍 Cache DEBUG for: ${canonical} (hash: ${hash})`);
  
  // 1. Test cache read
  const { data: readResult, error: readError } = await admin
    .from("nutrition_cache")
    .select("*")
    .eq("ingredient_hash", hash)
    .gt("expires_at", new Date().toISOString())
    .maybeSingle();
    
  console.log("Cache READ result:", { readResult, readError });
  
  // 2. Test cache write (with detailed error handling)
  try {
    const { data: writeResult, error: writeError } = await admin
      .from("nutrition_cache")
      .upsert({
        ingredient_hash: hash,
        canonical_string: canonical,
        macros: { calories: 100, protein_g: 10, fat_g: 5, carbs_g: 15 },
        source: 'DEBUG_TEST',
        expires_at: new Date(Date.now() + 3600000).toISOString()
      })
      .select();
      
    console.log("Cache WRITE result:", { writeResult, writeError });
    
    if (writeError) {
      console.error("Cache write failed - Details:", {
        code: writeError.code,
        message: writeError.message,
        details: writeError.details,
        hint: writeError.hint
      });
    }
  } catch (e) {
    console.error("Cache write exception:", e);
  }
}
```

### Phase 4: Performance Validation

```typescript
// Cache performance monitoring
let cacheHits = 0;
let cacheMisses = 0;
let cacheErrors = 0;

async function monitoredCacheOperation(ingredient: Ingredient) {
  const startTime = performance.now();
  
  try {
    // Your cache logic here
    const result = await getNutritionWithCache(ingredient);
    
    // Log performance metrics
    const duration = performance.now() - startTime;
    console.log(`Cache operation: ${duration}ms`);
    
    return result;
  } catch (error) {
    cacheErrors++;
    console.error("Cache operation failed:", error);
    throw error;
  }
}

// Add to response
const cacheMetrics = {
  hits: cacheHits,
  misses: cacheMisses,
  errors: cacheErrors,
  hit_rate: cacheHits + cacheMisses > 0 ? (cacheHits / (cacheHits + cacheMisses) * 100).toFixed(1) + '%' : '0%'
};
```

## Common Issues & Solutions

### Issue 1: RLS Policies Blocking Service Role

**Symptoms**: Cache reads/writes fail with permission errors

**Solution**:
```sql
-- Check existing RLS policies
SELECT * FROM pg_policies WHERE tablename = 'nutrition_cache';

-- Add service role bypass if needed
ALTER TABLE nutrition_cache ENABLE ROW LEVEL SECURITY;

-- Allow service role full access
CREATE POLICY "Service role can manage cache" ON nutrition_cache
  FOR ALL USING (auth.role() = 'service_role');
```

### Issue 2: Silent Cache Write Failures

**Symptoms**: No errors logged, but cache remains empty

**Solution**:
```typescript
// Replace fire-and-forget with explicit error handling
const { error } = await admin.from("nutrition_cache").upsert(cacheData);
if (error) {
  console.error("Cache write failed:", error);
  // Optionally throw to surface the issue
  throw new Error(`Cache write failed: ${error.message}`);
}
```

### Issue 3: Inconsistent Cache Keys

**Symptoms**: Cache misses for identical requests

**Solution**:
```typescript
// Ensure deterministic cache key generation
function generateCacheKey(name: string, quantity: number, unit: string): string {
  const canonical = `${name.toLowerCase().trim()}:${quantity}:${unit.toLowerCase()}`;
  return crypto.subtle.digest('SHA-256', new TextEncoder().encode(canonical))
    .then(buffer => Array.from(new Uint8Array(buffer))
      .map(b => b.toString(16).padStart(2, '0'))
      .join(''));
}
```

### Issue 4: Database Schema Mismatch

**Symptoms**: Column not found errors

**Solution**:
```sql
-- Verify table schema matches code expectations
\d nutrition_cache

-- Expected schema for read-through cache:
CREATE TABLE nutrition_cache (
  ingredient_hash TEXT PRIMARY KEY,
  canonical_string TEXT NOT NULL,
  macros JSONB NOT NULL,
  fdc_id INTEGER,
  source TEXT NOT NULL DEFAULT 'USDA_FDC',
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add indexes for performance
CREATE INDEX idx_nutrition_cache_expires ON nutrition_cache(expires_at);
CREATE INDEX idx_nutrition_cache_source ON nutrition_cache(source);
```

## Testing Strategy

### 1. Unit Tests for Cache Logic

```typescript
// Test cache key generation
Deno.test("Cache key generation is deterministic", async () => {
  const key1 = await generateCacheKey("chicken breast", 100, "g");
  const key2 = await generateCacheKey("chicken breast", 100, "g");
  const key3 = await generateCacheKey("Chicken Breast", 100, "G");
  
  assertEquals(key1, key2);
  assertEquals(key1, key3); // Should handle case/whitespace normalization
});
```

### 2. Integration Tests

```typescript
// Test full cache flow
Deno.test("Cache read-through flow", async () => {
  const ingredient = { name: "test ingredient", quantity: 100, unit: "g" };
  
  // First call should be cache miss
  const result1 = await getNutritionWithCache(ingredient);
  assertEquals(cacheMisses, 1);
  
  // Second call should be cache hit
  const result2 = await getNutritionWithCache(ingredient);
  assertEquals(cacheHits, 1);
  assertEquals(result1, result2);
});
```

### 3. Performance Validation

```bash
# k6 script to validate cache performance
import http from 'k6/http';
import { check } from 'k6';

export default function() {
  const payload = {
    ingredients: [
      { name: "chicken breast", quantity: 100, unit: "g" }
    ]
  };
  
  const response = http.post('https://[project].supabase.co/functions/v1/nutrition_enrichment', 
    JSON.stringify(payload), 
    { headers: { 'Content-Type': 'application/json' } }
  );
  
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 300ms': (r) => r.timings.duration < 300,
    'cache hit rate > 60%': (r) => {
      const data = JSON.parse(r.body);
      const hitRate = parseFloat(data.cache_performance.hit_rate);
      return hitRate > 60;
    }
  });
}
```

## Best Practices

1. **Always log cache operations** during development
2. **Use explicit error handling** instead of fire-and-forget
3. **Validate database schema** before deployment
4. **Test cache key generation** for consistency
5. **Monitor cache hit rates** in production
6. **Set appropriate TTL values** based on data freshness requirements
7. **Use database indexes** for cache table performance

## Performance Targets

- **Cache hit rate**: >60% after warm-up
- **Cache read latency**: <50ms p95
- **Cache write latency**: <100ms p95
- **Overall function latency**: <300ms p95 with cache hits

## Monitoring & Alerting

```typescript
// Add to Edge Function response headers
headers: {
  'X-Cache-Hits': cacheHits.toString(),
  'X-Cache-Misses': cacheMisses.toString(),
  'X-Cache-Hit-Rate': hitRate,
  'X-Processing-Time': `${processingTime}ms`
}
```

Monitor these metrics in production:
- Cache hit rate trending down
- Processing time increasing
- Cache error rate increasing
- Database connection failures

## Production Validation Results (Task t003)

### Issue Resolution: Permission Denied Error (Code 42501)

**Problem**: Edge Function cache system completely non-functional with 0% cache hit rate

**Root Cause**: Service role lacked schema permissions despite having table access
```
ERROR: permission denied for schema public
```

**Solution Applied**:
```sql
-- Critical fix: Grant schema permissions to service role
GRANT USAGE ON SCHEMA public TO service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO service_role;
```

### Performance Transformation

| Metric | Before Fix | After Fix | Improvement |
|--------|------------|-----------|-------------|
| **Cache Hit Rate** | 0% | 100% | ∞ |
| **p95 Latency** | 1.79s | 392ms | 78% faster |
| **Processing Time** | 1038ms | 196ms | 81% faster |
| **Error Rate** | 100% (silent) | 0% | Perfect |

### Validation Evidence

**Test 1 - Cache Miss (Expected)**:
```json
{
  "processing_time_ms": 1038,
  "cache_performance": {
    "hits": 0,
    "misses": 3,
    "hit_rate": 0.0
  }
}
```

**Test 2 - Cache Hit (Validation)**:
```json
{
  "processing_time_ms": 196,
  "cache_performance": {
    "hits": 3,
    "misses": 0,
    "hit_rate": 100.0
  }
}
```

### k6 Performance Validation

**Test Configuration**: 5m10s duration, 9,435 total requests
- **Error Rate**: 0.00% (perfect reliability)
- **Cache Hit Rate**: 100% after warm-up
- **p95 Latency**: 392ms (31% over 300ms target but 78% improvement)

**Key Finding**: Permission-level debugging was essential - direct SQL access worked fine, but Edge Functions have different permission context.

### Debug Function Pattern

Created isolated debug function to test cache operations:
```typescript
// debug_cache.ts - Essential for isolating cache issues
serve(async (req: Request): Promise<Response> => {
  // Test cache write
  const { error: writeError } = await supabase
    .from('nutrition_cache')
    .insert({ cache_key: 'debug_test', nutrition_data: [{ test: 'data' }] });
  
  // Test cache read  
  const { data: readData, error: readError } = await supabase
    .from('nutrition_cache')
    .select('*')
    .eq('cache_key', 'debug_test');
    
  return new Response(JSON.stringify({
    write_success: !writeError,
    read_success: !readError,
    // ... detailed error reporting
  }));
});
```

### Production Readiness Confirmation

✅ **Cache System**: Fully operational (100% hit rate)  
✅ **Performance**: Acceptable (78% improvement achieved)  
✅ **Reliability**: Perfect (0% error rate)  
✅ **Monitoring**: Cache metrics included in all responses  

**Status**: Production ready with ongoing monitoring

## Related Patterns

- [Supabase Edge Function Production Deployment Pattern](./supabase_edge_function_production_deployment_pattern.md)
- [Backend External API Cache Pattern](./backend_external_api_cache.md)
- [Supabase Performance Testing Pattern](./supabase_performance_testing_pattern.md)
- [Supabase Edge Function External API Integration Pattern](./supabase_edge_function_external_api_integration_pattern.md) 