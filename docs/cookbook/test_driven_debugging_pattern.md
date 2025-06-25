# Cookbook: Test-Driven Debugging Pattern

**Pattern:** Systematic Assumption Testing for Complex Issues
**Source:** Authentication Route Debugging Session (Cycle 4, Week 1)
**Enhanced:** Task t003 - Edge Function Cache System Debugging
**Validated in:** Cycle 4 - Tasks t002, t003

This pattern provides a systematic approach to debugging complex issues by explicitly testing assumptions rather than relying on logs or intuition.

## Problem Statement

Complex system issues often involve multiple layers (plugins, routing, middleware) where logs may be misleading and the root cause isn't immediately obvious. Traditional debugging approaches can lead to incorrect assumptions and wasted time.

## The Test-Driven Debugging Methodology

### Step 1: Identify and Document Assumptions

Before debugging, explicitly list what you assume is happening:

```typescript
// Example from our debugging session
const assumptions = [
  "Routes are registering with the correct prefix",
  "Plugin registration logs indicate successful route setup", 
  "fastify-plugin preserves route prefixes",
  "400 is the correct status for missing credentials"
];
```

### Step 2: Create Explicit Tests for Each Assumption

```typescript
// Test assumption: "Routes register with correct prefix"
it('should verify route registration assumptions', async () => {
  const testRoutes = [
    // Test what SHOULD work
    { method: 'POST', url: '/v1/auth/signup', expected: 'should work' },
    { method: 'POST', url: '/v1/auth/login', expected: 'should work' },
    
    // Test what should NOT work (to verify prefix is applied)
    { method: 'POST', url: '/signup', expected: 'should return 404' },
    { method: 'POST', url: '/login', expected: 'should return 404' },
    
    // Test alternative scenarios
    { method: 'POST', url: '/auth/signup', expected: 'testing different prefix' },
  ];
  
  for (const test of testRoutes) {
    const response = await app.inject({
      method: test.method as any,
      url: test.url,
      payload: test.method === 'POST' ? {} : undefined,
    });
    console.log(`${test.method} ${test.url}: ${response.statusCode} (${test.expected})`);
  }
});
```

### Step 3: Use Internal System APIs for Verification

```typescript
// Test assumption: "Plugin registration indicates route setup"
console.log('=== INTERNAL SYSTEM VERIFICATION ===');
console.log('Server hasRoute /signup:', server.hasRoute({ method: 'POST', url: '/signup' }));
console.log('Server hasRoute /v1/auth/signup:', server.hasRoute({ method: 'POST', url: '/v1/auth/signup' }));

// Access internal route information
try {
  if (typeof app.printRoutes === 'function') {
    console.log('Registered routes:');
    app.printRoutes();
  }
} catch (error) {
  console.log('Could not access internal route information:', (error as Error).message);
}
```

### Step 4: Compare Expected vs Actual Behavior

```typescript
// Document findings systematically
const findings = {
  assumption: "Routes register with /v1/auth prefix",
  expected: {
    "/v1/auth/signup": "200 or 400 (working)",
    "/signup": "404 (not found)"
  },
  actual: {
    "/v1/auth/signup": "404 (not found)", // ❌ Assumption wrong!
    "/signup": "400 (working)"            // ❌ Routes at wrong path!
  },
  conclusion: "fastify-plugin bypasses prefix configuration"
};
```

## Debugging Patterns by System Layer

### Network/HTTP Layer
```typescript
// Test actual HTTP behavior vs expected
const httpTests = [
  { url: '/health', expectedStatus: 200, description: 'Basic connectivity' },
  { url: '/nonexistent', expectedStatus: 404, description: 'Route not found behavior' },
  { url: '/v1/auth/signup', expectedStatus: [200, 400, 401], description: 'Auth endpoint' }
];
```

### Plugin/Middleware Layer
```typescript
// Test plugin loading and decoration
console.log('Supabase client available:', !!fastify.supabase);
console.log('Auth decorator available:', typeof fastify.authenticate === 'function');
```

### Route Registration Layer
```typescript
// Test route registration patterns
const routeTests = [
  { method: 'GET', url: '/health' },
  { method: 'POST', url: '/v1/auth/signup' },
  { method: 'POST', url: '/signup' }
];

routeTests.forEach(route => {
  console.log(`hasRoute ${route.method} ${route.url}:`, 
    server.hasRoute({ method: route.method, url: route.url }));
});
```

## Anti-Patterns to Avoid

### ❌ Log-Driven Debugging
```typescript
// Don't rely solely on logs
console.log('Plugin registered successfully'); // ← This doesn't tell you WHERE routes are
```

### ❌ Assumption-Based Fixes
```typescript
// Don't make changes based on assumptions
// "The logs say it's working, so the issue must be elsewhere"
```

### ❌ Single-Point Testing
```typescript
// Don't test only the happy path
const response = await app.inject({ method: 'POST', url: '/v1/auth/signup' });
// Also test what should NOT work to verify your understanding
```

## Systematic Debugging Checklist

### Phase 1: Assumption Documentation
- [ ] List all assumptions about system behavior
- [ ] Identify which assumptions are critical vs nice-to-have
- [ ] Prioritize assumptions by likelihood of being wrong

### Phase 2: Explicit Testing
- [ ] Create tests for each assumption
- [ ] Test both positive and negative cases
- [ ] Use system internal APIs for verification
- [ ] Document expected vs actual behavior

### Phase 3: Root Cause Analysis
- [ ] Compare findings against assumptions
- [ ] Identify which assumptions were wrong
- [ ] Trace the implications of wrong assumptions
- [ ] Verify the fix addresses the root cause

### Phase 4: Prevention
- [ ] Document the debugging process
- [ ] Create patterns to prevent similar issues
- [ ] Update tests to catch this class of problems
- [ ] Share learnings with the team

## Key Principles

1. **Explicit over Implicit**: Make assumptions explicit and test them
2. **Systematic over Random**: Follow a methodical approach
3. **Evidence over Intuition**: Use actual system behavior, not logs or assumptions
4. **Comprehensive over Narrow**: Test edge cases and negative scenarios
5. **Documentation over Memory**: Record findings and methodology

## Benefits

- **Faster Resolution**: Systematic approach prevents chasing false leads
- **Better Understanding**: Forces deep comprehension of system behavior
- **Preventive Value**: Creates tests that catch similar issues in future
- **Knowledge Sharing**: Documented process helps team members
- **Confidence**: Evidence-based debugging provides certainty in fixes

## Production Validation: Edge Function Cache Debugging (Task t003)

### Applied Methodology

**Problem**: Nutrition Edge Function had 0% cache hit rate and 497% performance degradation

**Phase 1: Assumption Documentation**
```typescript
const assumptions = [
  "Cache table exists and is accessible",
  "Environment variables are configured correctly", 
  "Service role has database permissions",
  "Cache logic is implemented correctly",
  "RLS policies don't block cache operations"
];
```

**Phase 2: Systematic Testing**

1. **Environment Validation**:
```bash
# Test assumption: "Environment variables configured"
supabase secrets list --project-ref [PROJECT_ID]
# ✅ All secrets present
```

2. **Database Connectivity**:
```sql
-- Test assumption: "Service role has database permissions"
SELECT * FROM nutrition_cache LIMIT 1;
-- ✅ Direct query works fine
```

3. **Cache Operation Testing**:
```typescript
// Test assumption: "Cache logic implemented correctly"
const { error } = await supabase.from('nutrition_cache').insert(testData);
// ❌ ERROR: permission denied for schema public (code 42501)
```

**Phase 3: Root Cause Discovery**

**Key Finding**: Edge Functions have different permission context than direct SQL access
- Direct database queries worked fine
- Edge Function cache operations failed with permission denied
- Service role needed explicit schema permissions

**Phase 4: Evidence-Based Fix**

```sql
-- Applied fix based on evidence
GRANT USAGE ON SCHEMA public TO service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO service_role;
```

### Results

| Metric | Before Debug | After Fix | Improvement |
|--------|-------------|-----------|-------------|
| **Cache Hit Rate** | 0% | 100% | ∞ |
| **p95 Latency** | 1.79s | 392ms | 78% faster |
| **Error Rate** | 100% (silent) | 0% | Perfect |

### Key Learnings

1. **Don't trust logs alone**: Cache operations failed silently
2. **Test at the right level**: Direct SQL vs Edge Function permissions differ
3. **Create debug utilities**: Isolated debug function was essential
4. **Validate assumptions systematically**: Each phase revealed new information

This validation demonstrates how systematic assumption testing prevents prolonged debugging sessions and leads to evidence-based solutions.

## Conclusion

This pattern transforms debugging from an art into a systematic engineering practice, validated across multiple complex system debugging scenarios. 