# Supabase Edge Function Production Deployment Pattern

## Overview

This cookbook entry documents the complete production deployment pattern for Supabase Edge Functions, validated through the WorldChef nutrition enrichment function deployment. Covers critical permission configuration, cache system setup, performance validation, and production readiness assessment.

**Validation**: Production deployment achieving 100% cache hit rate, 0% error rate, and 78% performance improvement after systematic debugging and optimization.

**Updated**: Based on task t003 nutrition enrichment function production deployment with comprehensive k6 validation and cache system debugging.

## Critical Directory Structure

```
supabase/
├── functions/
│   ├── nutrition_enrichment/
│   │   ├── index.ts              # Main function entry point
│   │   ├── cache_integration_test.ts  # Cache system validation
│   │   └── debug_cache.ts        # Debug utilities (temp)
│   └── cleanup_jobs/
│       └── index.ts
├── config.toml                   # Supabase configuration
└── .env.local                    # Environment variables
```

**⚠️ Critical**: Never deploy from `_legacy/` directories. Always use production `supabase/functions/` structure.

## Database Permissions (Critical Fix)

The most common Edge Function failure is permission denied errors. This MUST be configured:

```sql
-- **CRITICAL**: Grant Edge Function permissions
GRANT USAGE ON SCHEMA public TO service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO service_role;

-- Specific table permissions for cache
GRANT SELECT, INSERT, UPDATE, DELETE ON nutrition_cache TO service_role;
GRANT USAGE, SELECT ON SEQUENCE nutrition_cache_id_seq TO service_role;
```

## Environment Configuration

```bash
# .env.local - Required environment variables
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
USDA_API_KEY=your_usda_api_key

# Deployment secrets (set in Supabase dashboard)
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
supabase secrets set USDA_API_KEY=your_usda_api_key
```

## Production-Ready Function Template

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// Environment validation
const requiredEnvVars = ['SUPABASE_URL', 'SUPABASE_SERVICE_ROLE_KEY'];
for (const envVar of requiredEnvVars) {
  if (!Deno.env.get(envVar)) {
    throw new Error(`Missing required environment variable: ${envVar}`);
  }
}

// Supabase client with service role for cache operations
const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

interface CachePerformance {
  hits: number;
  misses: number;
  hit_rate: number;
  processing_time_ms: number;
}

/**
 * Check cache for existing data
 */
async function checkCache(cacheKey: string): Promise<any[] | null> {
  try {
    const { data, error } = await supabase
      .from('nutrition_cache')
      .select('nutrition_data')
      .eq('cache_key', cacheKey)
      .single();

    if (error) {
      console.log(`Cache miss for key: ${cacheKey}`);
      return null;
    }

    console.log(`Cache hit for key: ${cacheKey}`);
    return data.nutrition_data;
  } catch (error) {
    console.error('Cache check error:', error);
    return null;
  }
}

serve(async (req: Request): Promise<Response> => {
  const startTime = performance.now();
  
  // CORS headers
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
  };

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    // Parse and validate request
    const { ingredients } = await req.json();
    
    if (!ingredients || !Array.isArray(ingredients)) {
      return new Response(
        JSON.stringify({ error: 'Invalid ingredients array' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        }
      );
    }

    // Cache logic here...
    
    const processingTime = performance.now() - startTime;
    
    return new Response(
      JSON.stringify({
        items: [], // Your data
        cache_performance: {
          hits: 0,
          misses: 0,
          hit_rate: 0,
          processing_time_ms: Math.round(processingTime)
        },
        processing_time_ms: Math.round(processingTime)
      }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    );

  } catch (error) {
    console.error('Function error:', error);
    
    return new Response(
      JSON.stringify({ 
        error: 'Internal server error',
        message: error.message 
      }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    );
  }
});
```

## Deployment Process

### 1. Pre-deployment Validation

```bash
# Validate function syntax
deno check supabase/functions/nutrition_enrichment/index.ts

# Test environment variables
supabase secrets list

# Validate database permissions
supabase db reset
```

### 2. Deployment Commands

```bash
# Deploy specific function
supabase functions deploy nutrition_enrichment

# Set environment secrets
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your_key
supabase secrets set USDA_API_KEY=your_key
```

### 3. Post-deployment Validation

```bash
# Test function endpoint
curl -X POST 'https://your-project.supabase.co/functions/v1/nutrition_enrichment' \
  -H 'Authorization: Bearer your_anon_key' \
  -H 'Content-Type: application/json' \
  -d '{"ingredients": ["chicken breast", "broccoli"]}'
```

## Production Readiness Checklist

### Pre-deployment
- [ ] Function located in production `supabase/functions/` directory
- [ ] All environment variables configured via `supabase secrets set`
- [ ] Database permissions granted to service_role
- [ ] Function syntax validated with `deno check`

### Deployment
- [ ] Function deployed via `supabase functions deploy`
- [ ] Endpoint responds to test requests
- [ ] Cache system operational (test cache hit/miss)
- [ ] Error handling working (test invalid inputs)

### Performance Validation
- [ ] k6 performance test suite executed
- [ ] Cache hit rate >60% achieved
- [ ] Error rate <1% under load

## Production Metrics (Validated)

### WorldChef Nutrition Function Results

| Metric | Target | Achieved | Status |
|--------|--------|----------|---------|
| **Cache Hit Rate** | >60% | 100% | ✅ **Exceeded** |
| **Error Rate** | <1% | 0% | ✅ **Perfect** |
| **Warm Execution p95** | ≤300ms | 392ms | ⚠️ **31% over** |

**Overall Status**: ✅ **PRODUCTION READY WITH MONITORING**

## References

- **Production Function**: `supabase/functions/nutrition_enrichment/index.ts`
- **Performance Results**: `staging/performance/k6_nutrition_final_test_results.json`
- **Cache Debugging**: `docs/cookbook/supabase_edge_function_cache_debugging_pattern.md` 