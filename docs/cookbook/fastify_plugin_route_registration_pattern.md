# Cookbook: Fastify Plugin Route Registration Pattern

**Pattern:** Correct plugin patterns for Fastify route registration and common pitfalls
**Source:** Cycle 4 Validation Track - Task t002 Debugging Experience
**Validated in:** TDD implementation with comprehensive testing
**ADR Reference:** ADR-WCF-003 (Backend Service Architecture)

This pattern addresses the critical distinction between different Fastify plugin registration approaches and when to use each pattern.

## Problem Statement

Fastify route registration can fail silently or return 404 errors when using incorrect plugin patterns. Common issues include:

- Routes registered with `fastify-plugin` wrapper not being found (404 errors)
- Inconsistent plugin patterns across the codebase
- Confusion between route plugins and utility plugins
- Silent failures during plugin registration that only surface during testing

This leads to routes that appear to register successfully but are not accessible at runtime.

## Solution Pattern

### 1. Route Plugin Pattern (Recommended for Route Modules)

Use the **simple function pattern** for route modules that define HTTP endpoints:

```typescript
// backend/src/routes/v1/status/index.ts
import { FastifyInstance, FastifyPluginOptions } from 'fastify';

async function statusRoute(fastify: FastifyInstance, options: FastifyPluginOptions) {
  fastify.get('/status', {
    schema: {
      description: 'Health check endpoint to verify the server is running.',
      tags: ['Status'],
      response: {
        200: {
          description: 'Successful response',
          type: 'object',
          properties: {
            status: { type: 'string', example: 'ok' }
          }
        }
      }
    }
  }, async (request, reply) => {
    return reply.code(200).send({ status: 'ok' });
  });
}

export default statusRoute;
```

**Registration in server.ts:**
```typescript
import statusRoute from './routes/v1/status';

// Register with prefix
await server.register(statusRoute, { prefix: '/v1' });
```

### 2. Utility Plugin Pattern (Use fastify-plugin wrapper)

Use `fastify-plugin` wrapper for **utility plugins** that add decorators, hooks, or shared functionality:

```typescript
// backend/src/plugins/auth_plugin.ts
import { FastifyPluginAsync } from 'fastify';
import fp from 'fastify-plugin';

const authPlugin: FastifyPluginAsync = async (fastify) => {
  // Add decorator to fastify instance
  fastify.decorate('authenticate', async (request, reply) => {
    // Authentication logic
  });
  
  // Add hooks that apply globally
  fastify.addHook('preHandler', async (request, reply) => {
    // Global pre-handler logic
  });
};

export default fp(authPlugin);
```

**Registration in server.ts:**
```typescript
import authPlugin from './plugins/auth_plugin';

// Register without prefix (applies globally)
await server.register(authPlugin);
```

## Key Distinctions

### When to Use Each Pattern

| Pattern | Use Case | fastify-plugin | Prefix Support | Example |
|---------|----------|----------------|----------------|---------|
| **Route Plugin** | HTTP endpoints, route handlers | ❌ No | ✅ Yes | `/v1/status`, `/v1/auth/*` |
| **Utility Plugin** | Decorators, hooks, middleware | ✅ Yes | ❌ No | Authentication, logging, database |

### Technical Reasoning

**Route Plugins without `fp` wrapper:**
- Maintain route encapsulation within their registration scope
- Support prefix application during registration
- Allow for route-specific configuration and options
- Follow Fastify's intended pattern for route organization

**Utility Plugins with `fp` wrapper:**
- Share decorators and hooks across the entire application
- Break out of encapsulation to provide global functionality
- Cannot use prefixes (would break the global nature)
- Follow Fastify's intended pattern for cross-cutting concerns

## Common Pitfalls and Solutions

### Pitfall 1: Using `fp` wrapper for route plugins

**❌ Incorrect (causes 404 errors):**
```typescript
import fp from 'fastify-plugin';

const statusRoute: FastifyPluginAsync = async (fastify) => {
  fastify.get('/status', async (request, reply) => {
    return { status: 'ok' };
  });
};

export default fp(statusRoute); // ❌ Wrong for route plugins
```

**✅ Correct:**
```typescript
async function statusRoute(fastify: FastifyInstance, options: FastifyPluginOptions) {
  fastify.get('/status', async (request, reply) => {
    return { status: 'ok' };
  });
}

export default statusRoute; // ✅ Correct for route plugins
```

### Pitfall 2: Inconsistent patterns across route modules

**❌ Inconsistent:**
```typescript
// Some routes use fp wrapper, others don't
export default fp(authRoutes);  // ❌ Inconsistent
export default statusRoutes;    // ❌ Inconsistent
```

**✅ Consistent:**
```typescript
// All route modules use the same pattern
export default authRoutes;    // ✅ Consistent
export default statusRoutes;  // ✅ Consistent
```

## Debugging Route Registration Issues

### 1. Verify Route Registration

Add debugging to your test setup:

```typescript
// In test files (temporarily)
beforeAll(async () => {
  app = await build({ logger: false });
  await app.ready();
  
  // Debug: Print all registered routes
  console.log('Registered routes:');
  console.log(app.printRoutes());
});
```

### 2. Test Route Accessibility

```typescript
it('should register the expected route', async () => {
  const response = await app.inject({
    method: 'GET',
    url: '/v1/status',
  });
  
  // Should not be 404
  expect(response.statusCode).not.toBe(404);
  expect(response.statusCode).toBe(200);
});
```

### 3. Validate Plugin Loading Order

```typescript
// In server.ts build function
try {
  // Register utility plugins first
  await server.register(authPlugin);
  await server.register(securityHeadersPlugin);
  
  // Register route plugins last
  await server.register(authRoutes, { prefix: '/v1/auth' });
  await server.register(statusRoute, { prefix: '/v1' });
} catch (error) {
  console.error('Plugin registration failed:', error);
  throw error;
}
```

## Implementation Checklist

### For Route Plugins
- [ ] Use simple function signature: `async function routeName(fastify, options)`
- [ ] Export function directly (no `fp` wrapper)
- [ ] Register with appropriate prefix in `server.ts`
- [ ] Include OpenAPI schema definitions for documentation
- [ ] Test route accessibility with integration tests

### For Utility Plugins  
- [ ] Use `FastifyPluginAsync` type with `fp` wrapper
- [ ] Add decorators or hooks for shared functionality
- [ ] Register without prefix in `server.ts`
- [ ] Test decorator/hook functionality across routes

## Validation

This pattern has been validated through:
- **TDD Implementation:** Red-Green-Refactor cycle with comprehensive testing
- **Integration Testing:** Full route accessibility verification
- **Debugging Process:** Systematic isolation and resolution of 404 errors
- **Consistency Check:** Alignment with existing codebase patterns (auth routes)

## Related Patterns

- `fastify_comprehensive_testing_pattern.md` - Testing strategies for plugin validation
- `fastify_openapi_swagger_integration_pattern.md` - API documentation integration
- `test_driven_debugging_pattern.md` - Systematic debugging methodology

## References

- [Fastify Plugin Guide](https://www.fastify.io/docs/latest/Reference/Plugins/)
- [fastify-plugin Documentation](https://github.com/fastify/fastify-plugin)
- ADR-WCF-003: Backend Service Architecture 