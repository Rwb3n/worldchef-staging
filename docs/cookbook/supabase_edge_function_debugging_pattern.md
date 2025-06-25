# Supabase Edge Function Debugging Pattern

## Overview

This cookbook entry documents the systematic debugging methodology for Supabase Edge Functions, validated during WorldChef task t003 when diagnosing performance issues with the nutrition enrichment function.

**Validation**: Successfully identified root cause of zero nutrition values despite 200 HTTP responses and functional cache logic.

## Core Debugging Methodology

### Phase 1: Environment Validation

Before assuming code issues, validate the Edge Function runtime environment:

```bash
# 1. List all secrets available to Edge Functions
supabase secrets list --project-ref <project-ref>

# Expected output should include all required variables
#   NAME                      | DIGEST
#   --------------------------|------------------
#   SUPABASE_SERVICE_ROLE_KEY | b2b1c3001aec...
#   SUPABASE_URL              | 4d66d61e03e4...
#   EXTERNAL_API_KEY          | 8a75cd7b14d1...
```

**Common Issues**:
- Missing secrets (not set via `supabase secrets set`)
- Case-sensitive variable names (`SUPABASE_URL` vs `supabase_url`)
- Assuming local `.env` variables are available in Edge Function runtime

### Phase 2: Database Connectivity Validation

Verify database access and table existence:

```typescript
// Add to Edge Function for debugging
const admin = getSupabaseAdmin();
if (!admin) {
  console.error("Supabase admin client failed to initialize");
  console.error("SUPABASE_URL available:", !!Deno.env.get("SUPABASE_URL"));
  console.error("SERVICE_ROLE_KEY available:", !!Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"));
}
```

```sql
-- Verify table exists and is accessible
SELECT table_name FROM information_schema.tables WHERE table_name = 'your_table';
SELECT COUNT(*) as record_count FROM your_table;
```

### Phase 3: Enhanced Error Logging

Replace silent error handling with detailed logging:

```typescript
// ❌ ANTIPATTERN: Silent error masking
try {
  const result = await externalApiCall();
  return processResult(result);
} catch (error) {
  // Silent failure - returns zeros/nulls
  return getDefaultValues();
}

// ✅ CORRECT: Detailed error logging
try {
  const result = await externalApiCall();
  return processResult(result);
} catch (error) {
  console.error(`API call failed for ${identifier}:`, error.message);
  console.error(`Full error details:`, error);
  console.error(`API key available:`, !!Deno.env.get("API_KEY"));
  console.error(`API key length:`, Deno.env.get("API_KEY")?.length);
  
  // Still return defaults but with full visibility
  return getDefaultValues();
}
```

### Phase 4: External API Isolation Testing

Test external APIs outside the Edge Function to isolate issues:

```javascript
// Create standalone test script: test_external_api.js
async function testExternalApi() {
  const apiKey = process.env.API_KEY; // From .env.local
  
  try {
    const response = await fetch('https://api.example.com/endpoint', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Api-Key': apiKey
      },
      body: JSON.stringify({ query: 'test data' })
    });
    
    const data = await response.json();
    console.log('External API works:', data);
    
  } catch (error) {
    console.error('External API failed:', error);
  }
}

testExternalApi();
```

Run comparison test:
```bash
# Test external API directly
node test_external_api.js

# Test Edge Function
curl -X POST https://project.supabase.co/functions/v1/function_name \
  -H "Authorization: Bearer anon_key" \
  -d '{"test": "data"}'
```

## Log Retrieval and Analysis

### Accessing Edge Function Logs

```bash
# Method 1: CLI
supabase functions logs --project-ref <project-ref>

# Method 2: MCP (in development environment)
mcp_supabase_get_logs(project_id, service="edge-function")
```

### Interpreting Log Output

```bash
# Successful execution
POST | 200 | https://project.supabase.co/functions/v1/function_name
execution_time_ms: 1200

# With console.log output (may require additional log level)
[function_name] Cache MISS for: ingredient|100|g
[function_name] USDA API attempt 1/3 failed: 401 Unauthorized
```

**Note**: Console logs may not appear immediately in `get_logs`. Use strategic logging at key decision points.

## Common Edge Function Issues

### Issue 1: Environment Variable Confusion

**Symptom**: Function works locally but fails in production
**Cause**: Local `.env` vs Edge Function secrets mismatch

```typescript
// Debug environment differences
console.log('Runtime environment check:');
console.log('SUPABASE_URL:', Deno.env.get('SUPABASE_URL')?.substring(0, 20) + '...');
console.log('API_KEY length:', Deno.env.get('API_KEY')?.length);
console.log('All env vars:', Object.keys(Deno.env.toObject()));
```

### Issue 2: Silent Cache Failures

**Symptom**: Cache hit rate = 0%, no error messages
**Cause**: Database connection fails silently

```typescript
// Add cache operation validation
const { data, error } = await admin
  .from('cache_table')
  .select('*')
  .limit(1);

if (error) {
  console.error('Cache table access failed:', error);
}
```

### Issue 3: External API Authentication

**Symptom**: API returns 401/403 in Edge Function but works externally
**Cause**: API key not properly configured or different format expected

```typescript
// Debug API authentication
const apiKey = Deno.env.get('API_KEY');
console.log('API key configured:', !!apiKey);
console.log('API key format check:', apiKey?.startsWith('expected_prefix'));

// Test with minimal request
const testResponse = await fetch('https://api.example.com/test', {
  headers: { 'X-Api-Key': apiKey }
});
console.log('API test status:', testResponse.status);
```

## Performance vs Functionality Debugging

### Isolate Functional Issues First

Before performance testing, ensure basic functionality:

```bash
# 1. Single ingredient test
curl -X POST https://project.supabase.co/functions/v1/function_name \
  -H "Authorization: Bearer anon_key" \
  -d '{"ingredients":[{"name":"test","quantity":100,"unit":"g"}]}'

# 2. Check for non-zero values in response
# 3. Verify cache miss/hit logic
# 4. Only then run performance tests
```

### Performance Test Interpretation

```javascript
// k6 results analysis
if (errorRate > 1%) {
  console.log('Fix functional issues before performance optimization');
} else if (cacheHitRate < 60%) {
  console.log('Cache not functioning - debug cache logic');
} else if (p95Latency > target) {
  console.log('Performance optimization needed');
}
```

## Debugging Workflow Checklist

### Pre-Debugging Setup
- [ ] Verify all secrets configured via `supabase secrets list`
- [ ] Confirm database tables exist and are accessible
- [ ] Add enhanced error logging to Edge Function
- [ ] Create external API test script

### Systematic Debugging
- [ ] Test external API independently (should work)
- [ ] Deploy Edge Function with enhanced logging
- [ ] Make single test request to Edge Function
- [ ] Retrieve and analyze Edge Function logs
- [ ] Compare external vs Edge Function API behavior

### Issue Resolution
- [ ] Identify root cause (environment, database, or API)
- [ ] Implement fix with continued logging
- [ ] Verify fix with single request
- [ ] Remove debug logging (optional)
- [ ] Run performance tests

## Error Handling Best Practices

### Fail Fast vs Graceful Degradation

```typescript
// For critical operations: Fail fast
if (!apiKey) {
  throw new Error('API_KEY not configured');
}

// For optional features: Graceful degradation
try {
  const enhancement = await optionalApiCall();
  return { ...baseResult, enhancement };
} catch (error) {
  console.warn('Optional enhancement failed:', error.message);
  return baseResult;
}
```

### Structured Error Information

```typescript
interface DebugInfo {
  timestamp: string;
  function_name: string;
  operation: string;
  input_data: any;
  error_details: {
    message: string;
    stack?: string;
    api_response?: any;
  };
  environment_check: {
    secrets_available: string[];
    database_accessible: boolean;
  };
}

function logStructuredError(operation: string, error: Error, context: any): DebugInfo {
  const debugInfo: DebugInfo = {
    timestamp: new Date().toISOString(),
    function_name: 'nutrition_enrichment',
    operation,
    input_data: context,
    error_details: {
      message: error.message,
      stack: error.stack,
    },
    environment_check: {
      secrets_available: Object.keys(Deno.env.toObject()),
      database_accessible: !!getSupabaseAdmin(),
    }
  };
  
  console.error('Structured error log:', JSON.stringify(debugInfo, null, 2));
  return debugInfo;
}
```

## Integration with Performance Testing

### Pre-Performance Validation

```javascript
// Validate function works before performance testing
async function validateFunctionality() {
  const response = await fetch(functionUrl, {
    method: 'POST',
    headers: authHeaders,
    body: JSON.stringify({ ingredients: [testIngredient] })
  });
  
  const data = await response.json();
  
  const hasValidData = data.items?.[0]?.nutrition?.calories > 0;
  if (!hasValidData) {
    throw new Error('Function returns zero values - debug before performance testing');
  }
  
  return true;
}
```

### Performance Test with Debugging

```javascript
// Enhanced k6 test with functionality checks
export default function() {
  const response = http.post(url, payload, { headers });
  
  const functionalityCheck = check(response, {
    'status is 200': (r) => r.status === 200,
    'has non-zero nutrition': (r) => {
      const data = JSON.parse(r.body);
      return data.items?.[0]?.nutrition?.calories > 0;
    },
    'cache performance reported': (r) => {
      const data = JSON.parse(r.body);
      return data.cache_performance !== undefined;
    }
  });
  
  if (!functionalityCheck) {
    console.error('Functionality check failed - investigate before performance analysis');
  }
}
```

## Key Implementation Notes

### Critical Success Factors

1. **Environment Validation First**: Always verify secrets before debugging code
2. **External API Isolation**: Test APIs outside Edge Function to isolate issues
3. **Detailed Error Logging**: Never mask errors with silent defaults
4. **Systematic Approach**: Environment → Database → Code → Performance
5. **Structured Debugging**: Use consistent logging format for analysis

### AI Development Considerations

- **Add debugging logs temporarily**: Remove after issue resolution
- **Test external APIs independently**: Isolate Edge Function vs API issues
- **Validate assumptions**: Don't assume missing secrets without verification
- **Use MCP tools**: Leverage `get_logs` and `execute_sql` for validation
- **Document debugging steps**: Create evidence trail for complex issues

## Production Deployment Checklist

- [ ] All secrets configured in Supabase project
- [ ] Database tables exist with proper indexes
- [ ] External API access validated independently
- [ ] Error logging configured appropriately
- [ ] Functionality validated before performance testing
- [ ] Performance targets met with functional cache
- [ ] Debug logging removed or reduced for production

## References

- **Source Implementation**: `_legacy/supabase/functions/nutrition_enrichment/index.ts`
- **Debugging Evidence**: `status/plan_cycle4_week1_execution_t003_progress.md`
- **External API Testing**: `staging/tests/usda_api_test.js`
- **Performance Testing**: `staging/performance/k6_nutrition_edge_function_test.js`
- **MCP Integration**: Supabase MCP tools for secrets and logs management 