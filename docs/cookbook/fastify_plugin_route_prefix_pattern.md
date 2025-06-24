# Cookbook: Fastify Plugin Registration & Route Prefixing

**Pattern:** Proper Plugin Registration with Route Prefixes
**Source:** Authentication Route Debugging Session (Cycle 4, Week 1)
**Validated in:** Cycle 4 - Task t002

This pattern addresses the critical issue where `fastify-plugin` wrappers bypass route prefixes, causing routes to register in the parent context instead of respecting the intended prefix.

## Problem Statement

When using `fastify-plugin` (`fp()`) wrapper with route registration and prefixes, routes may not register with the expected prefix, leading to 404 errors despite successful plugin registration logs.

## Root Cause

The `fastify-plugin` wrapper is designed to expose plugin functionality to the parent scope, which includes route registration. This effectively bypasses any prefix configuration applied during plugin registration.

## Solution Pattern

### ❌ Incorrect: Using fastify-plugin with Route Registration

```typescript
// src/routes/v1/auth/index.ts
import { FastifyInstance, FastifyPluginOptions } from 'fastify';
import fp from 'fastify-plugin';

async function authRoutes(fastify: FastifyInstance, options: FastifyPluginOptions) {
  // Routes defined here will register in parent context, bypassing prefix
  fastify.post('/signup', async (request, reply) => {
    // Implementation
  });
  
  fastify.post('/login', async (request, reply) => {
    // Implementation
  });
}

// ❌ This causes routes to bypass the prefix
export default fp(authRoutes, {
  dependencies: ['supabase']
});

// Server registration
await server.register(authRoutes, { prefix: '/v1/auth' });
// Result: Routes available at /signup and /login (NO PREFIX!)
```

### ✅ Correct: Direct Export for Route Registration

```typescript
// src/routes/v1/auth/index.ts
import { FastifyInstance, FastifyPluginOptions } from 'fastify';

async function authRoutes(fastify: FastifyInstance, options: FastifyPluginOptions) {
  // Routes will respect the prefix when registered
  fastify.post('/signup', async (request, reply) => {
    // Implementation
  });
  
  fastify.post('/login', async (request, reply) => {
    // Implementation
  });
}

// ✅ Direct export respects prefix configuration
export default authRoutes;

// Server registration
await server.register(authRoutes, { prefix: '/v1/auth' });
// Result: Routes available at /v1/auth/signup and /v1/auth/login
```

## When to Use fastify-plugin

Use `fastify-plugin` (`fp()`) wrapper **only** for:

### ✅ Correct Usage: Decorators and Utilities

```typescript
// src/plugins/supabase_plugin.ts
import fp from 'fastify-plugin';
import { createClient } from '@supabase/supabase-js';

async function supabasePlugin(fastify: FastifyInstance) {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!
  );
  
  // Decorating the fastify instance - should be available globally
  fastify.decorate('supabase', supabase);
}

// ✅ Correct: Use fp() for decorators that need global scope
export default fp(supabasePlugin, {
  name: 'supabase'
});
```

### ✅ Correct Usage: Authentication Middleware

```typescript
// src/plugins/auth_plugin.ts
import fp from 'fastify-plugin';

async function authPlugin(fastify: FastifyInstance) {
  // Authentication decorator - should be available globally
  fastify.decorate('authenticate', async (request, reply) => {
    // JWT validation logic
  });
}

// ✅ Correct: Use fp() for middleware that needs global scope
export default fp(authPlugin, {
  dependencies: ['supabase']
});
```

## Debugging Route Registration

### Method 1: Use hasRoute() for Verification

```typescript
// After plugin registration, verify routes are where expected
console.log('Server hasRoute /signup:', server.hasRoute({ method: 'POST', url: '/signup' }));
console.log('Server hasRoute /v1/auth/signup:', server.hasRoute({ method: 'POST', url: '/v1/auth/signup' }));
```

### Method 2: Explicit Route Testing

```typescript
// In tests, verify actual route behavior
const testRoutes = [
  { method: 'POST', url: '/v1/auth/signup', expected: 'should work' },
  { method: 'POST', url: '/signup', expected: 'should return 404' },
];

for (const test of testRoutes) {
  const response = await app.inject({
    method: test.method,
    url: test.url,
    payload: {}
  });
  console.log(`${test.method} ${test.url}: ${response.statusCode} (${test.expected})`);
}
```

## Key Principles

1. **Route Registration**: Never use `fp()` wrapper for route-defining plugins
2. **Global Decorators**: Always use `fp()` wrapper for decorators and middleware
3. **Dependency Management**: Use `dependencies` array in `fp()` options for proper loading order
4. **Testing**: Always verify route registration with explicit testing, not just logs
5. **HTTP Standards**: Return 401 for authentication failures, 400 for malformed requests

## Validation Checklist

- [ ] Routes register with intended prefix
- [ ] Plugin dependencies load in correct order
- [ ] Authentication middleware available globally
- [ ] Integration tests verify actual route behavior
- [ ] Proper HTTP status codes returned

## Common Pitfalls

1. **Assuming logs indicate correct registration** - Logs show plugin loading, not route paths
2. **Using fp() for everything** - Only use for decorators/middleware that need global scope
3. **Not testing route paths explicitly** - Always verify with `hasRoute()` or integration tests
4. **Wrong HTTP status codes** - Use 401 for auth failures, not 400

This pattern prevents the most common Fastify routing issues and ensures predictable plugin behavior. 