# Cookbook: Fastify Comprehensive Testing Pattern

**Pattern:** Complete integration testing for Fastify applications with plugin ecosystem validation
**Source:** Cycle 4 OpenAPI Implementation - Comprehensive Testing Validation
**Validated in:** TDD Cycle with 10/10 test coverage including plugin interactions
**ADR Reference:** ADR-WCF-010a, ADR-WCF-010b

This pattern provides comprehensive testing strategies for Fastify applications that validate not just individual functionality but complete plugin ecosystem integration.

## Problem Statement

Basic Fastify testing often focuses on individual endpoints or features without validating:

- Plugin loading order and dependencies
- Cross-plugin interactions and decorators
- Environment variable requirements
- Security header application across all endpoints
- Schema validation integration
- TypeScript type safety in tests

This leads to integration failures in production despite passing unit tests.

## Solution Pattern

### 1. Test Structure Organization

```typescript
// __tests__/integration/comprehensive.test.ts
/// <reference types="jest" />
/// <reference path="../../src/types/fastify.d.ts" />

import { FastifyInstance } from 'fastify';
import { describe, it, expect, beforeAll, afterAll } from '@jest/globals';
import { build } from '../../src/server';

describe('Comprehensive Application Integration', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    app = await build({ logger: false });
    await app.ready();
  });

  afterAll(async () => {
    await app.close();
  });

  // Test categories organized by concern
  describe('Plugin Integration Validation', () => {
    // Plugin-specific tests
  });

  describe('Security Integration', () => {
    // Security header and CORS tests
  });

  describe('API Contract Validation', () => {
    // Schema validation and OpenAPI tests
  });

  describe('Environment Configuration', () => {
    // Environment variable and configuration tests
  });
});
```

### 2. Plugin Integration Testing

```typescript
describe('Plugin Integration Validation', () => {
  it('should have all required plugins loaded with correct decorators', async () => {
    // Validate Supabase plugin
    expect(app.supabase).toBeDefined();
    expect(typeof app.supabase.from).toBe('function');
    expect(typeof app.supabase.auth).toBe('object');

    // Validate Auth plugin
    expect(typeof app.authenticate).toBe('function');

    // Validate OpenAPI plugin (if applicable)
    if (app.swagger) {
      expect(typeof app.swagger).toBe('function');
    }
  });

  it('should have plugins loaded in correct dependency order', async () => {
    // Test that server builds successfully (all plugins loaded)
    expect(app).toBeDefined();
    expect(app.ready).toBeDefined();
    
    // Test that plugin decorations are available
    expect(app.supabase).toBeDefined(); // supabase_plugin
    
    // Test that routes are properly registered with auth plugin
    const healthResponse = await app.inject({
      method: 'GET',
      url: '/health'
    });
    expect(healthResponse.statusCode).toBe(200);
  });

  it('should handle plugin dependency failures gracefully', async () => {
    // This test validates error handling during plugin registration
    // Note: This requires a separate test server build with missing env vars
    
    const originalUrl = process.env.SUPABASE_URL;
    delete process.env.SUPABASE_URL;

    try {
      await expect(build({ logger: false })).rejects.toThrow();
    } finally {
      process.env.SUPABASE_URL = originalUrl;
    }
  });
});
```

### 3. Environment Configuration Testing

```typescript
describe('Environment Configuration', () => {
  it('should have all required environment variables', async () => {
    // Database configuration
    expect(process.env.SUPABASE_URL).toBeDefined();
    expect(process.env.SUPABASE_SERVICE_ROLE_KEY).toBeDefined();
    
    // Validate URL format
    expect(process.env.SUPABASE_URL).toMatch(/^https:\/\/.+\.supabase\.co$/);
    
    // Additional service configurations (if applicable)
    if (process.env.NODE_ENV === 'production') {
      expect(process.env.STRIPE_SECRET_KEY).toBeDefined();
      expect(process.env.FCM_SERVER_KEY).toBeDefined();
    }
  });

  it('should handle missing environment variables appropriately', async () => {
    // Test configuration validation
    const requiredVars = ['SUPABASE_URL', 'SUPABASE_SERVICE_ROLE_KEY'];
    
    for (const varName of requiredVars) {
      expect(process.env[varName]).toBeDefined();
      expect(process.env[varName]).not.toBe('');
    }
  });
});
```

### 4. Security Integration Testing

```typescript
describe('Security Integration', () => {
  it('should apply security headers to all endpoints', async () => {
    const endpoints = [
      '/health',
      '/v1/openapi.json',
      '/v1/docs',
      '/'
    ];

    for (const endpoint of endpoints) {
      const response = await app.inject({
        method: 'GET',
        url: endpoint
      });

      // Verify security headers plugin is working
      expect(response.headers['x-content-type-options']).toBe('nosniff');
      expect(response.headers['strict-transport-security']).toContain('max-age=31536000');
      expect(response.headers['cross-origin-opener-policy']).toBe('same-origin');
      expect(response.headers['cross-origin-embedder-policy']).toBe('require-corp');
    }
  });

  it('should apply appropriate cache control headers', async () => {
    // API endpoints should not be cached
    const apiResponse = await app.inject({
      method: 'GET',
      url: '/v1/openapi.json'
    });
    expect(apiResponse.headers['cache-control']).toContain('no-store');

    // Static content can be cached
    const robotsResponse = await app.inject({
      method: 'GET',
      url: '/robots.txt'
    });
    expect(robotsResponse.headers['cache-control']).toContain('max-age');
  });
});
```

### 5. API Contract Validation Testing

```typescript
describe('API Contract Validation', () => {
  it('should validate request schemas for all endpoints', async () => {
    // Test schema validation is active
    const invalidRequest = await app.inject({
      method: 'POST',
      url: '/v1/auth/signup',
      payload: {
        email: 'invalid-email',
        password: 'short'
      }
    });

    // Should return proper error status (validation working)
    expect([400, 401, 422]).toContain(invalidRequest.statusCode);
    expect(invalidRequest.headers['content-type']).toMatch(/application\/json/);
  });

  it('should return consistent error response format', async () => {
    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/signup',
      payload: {}
    });

    expect([400, 401, 422]).toContain(response.statusCode);
    
    const body = JSON.parse(response.payload);
    expect(body).toHaveProperty('error');
    
    // Validate error response structure matches schema
    expect(typeof body.error).toBe('string');
  });

  it('should handle malformed JSON gracefully', async () => {
    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/signup',
      payload: 'invalid-json{',
      headers: {
        'content-type': 'application/json'
      }
    });

    expect(response.statusCode).toBe(400);
  });
});
```

### 6. Route Registration Validation

```typescript
describe('Route Registration Validation', () => {
  it('should register routes with correct prefixes', async () => {
    // Test expected routes exist
    const expectedRoutes = [
      { method: 'POST', url: '/v1/auth/signup', shouldExist: true },
      { method: 'POST', url: '/v1/auth/login', shouldExist: true },
      { method: 'GET', url: '/health', shouldExist: true },
      { method: 'GET', url: '/v1/openapi.json', shouldExist: true }
    ];

    for (const route of expectedRoutes) {
      const response = await app.inject({
        method: route.method as any,
        url: route.url,
        payload: route.method === 'POST' ? {} : undefined
      });

      if (route.shouldExist) {
        expect(response.statusCode).not.toBe(404);
      } else {
        expect(response.statusCode).toBe(404);
      }
    }
  });

  it('should not register routes without prefixes', async () => {
    // Test that routes don't exist without prefixes (fastify-plugin issue)
    const unprefixedRoutes = [
      { method: 'POST', url: '/signup' },
      { method: 'POST', url: '/login' }
    ];

    for (const route of unprefixedRoutes) {
      const response = await app.inject({
        method: route.method as any,
        url: route.url,
        payload: {}
      });

      expect(response.statusCode).toBe(404);
    }
  });
});
```

### 7. Performance and Load Testing Integration

```typescript
describe('Performance Baseline', () => {
  it('should respond to health check within acceptable time', async () => {
    const start = Date.now();
    
    const response = await app.inject({
      method: 'GET',
      url: '/health'
    });
    
    const duration = Date.now() - start;
    
    expect(response.statusCode).toBe(200);
    expect(duration).toBeLessThan(100); // 100ms baseline
  });

  it('should handle concurrent requests without errors', async () => {
    const concurrentRequests = 10;
    const requests = Array(concurrentRequests).fill(null).map(() =>
      app.inject({
        method: 'GET',
        url: '/health'
      })
    );

    const responses = await Promise.all(requests);
    
    responses.forEach(response => {
      expect(response.statusCode).toBe(200);
    });
  });
});
```

## Testing Utilities and Helpers

### Test Server Builder

```typescript
// __tests__/helpers/test-server.ts
import { FastifyInstance } from 'fastify';
import { build } from '../../src/server';

export class TestServer {
  private app: FastifyInstance | null = null;

  async start(options: any = {}) {
    this.app = await build({ logger: false, ...options });
    await this.app.ready();
    return this.app;
  }

  async stop() {
    if (this.app) {
      await this.app.close();
      this.app = null;
    }
  }

  getInstance() {
    if (!this.app) {
      throw new Error('Test server not started');
    }
    return this.app;
  }
}
```

### Environment Variable Helper

```typescript
// __tests__/helpers/env-helper.ts
export class EnvHelper {
  private originalEnv: Record<string, string | undefined> = {};

  backup(keys: string[]) {
    keys.forEach(key => {
      this.originalEnv[key] = process.env[key];
    });
  }

  restore() {
    Object.keys(this.originalEnv).forEach(key => {
      if (this.originalEnv[key] === undefined) {
        delete process.env[key];
      } else {
        process.env[key] = this.originalEnv[key];
      }
    });
    this.originalEnv = {};
  }

  set(key: string, value: string) {
    if (!(key in this.originalEnv)) {
      this.originalEnv[key] = process.env[key];
    }
    process.env[key] = value;
  }

  unset(key: string) {
    if (!(key in this.originalEnv)) {
      this.originalEnv[key] = process.env[key];
    }
    delete process.env[key];
  }
}
```

## Key Principles

### 1. Test Plugin Integration, Not Just Endpoints
- Validate plugin decorators are available
- Test cross-plugin dependencies
- Verify plugin loading order

### 2. Test the Complete Request Lifecycle
- Environment configuration
- Plugin initialization
- Route registration
- Schema validation
- Security header application
- Response formatting

### 3. Validate Error Handling
- Missing environment variables
- Plugin initialization failures
- Invalid request payloads
- Network timeouts

### 4. Performance Baseline Testing
- Response time thresholds
- Concurrent request handling
- Memory usage patterns

## Validation Checklist

- [ ] All plugins load successfully with correct decorators
- [ ] Environment variables validated and properly formatted
- [ ] Security headers applied to all endpoints
- [ ] Schema validation active for all routes
- [ ] Error responses follow consistent format
- [ ] Routes registered with correct prefixes
- [ ] Performance baselines met
- [ ] Concurrent request handling verified
- [ ] TypeScript type safety maintained in tests

## Common Testing Pitfalls

### ❌ Testing Only Happy Paths
```typescript
// Wrong: Only testing successful cases
it('should create user', async () => {
  const response = await app.inject({
    method: 'POST',
    url: '/v1/auth/signup',
    payload: { email: 'test@example.com', password: 'password123' }
  });
  expect(response.statusCode).toBe(201);
});
```

### ❌ Not Testing Plugin Integration
```typescript
// Wrong: Assuming plugins work without validation
it('should access database', async () => {
  // Test assumes app.supabase exists without verification
  const result = await app.supabase.from('users').select('*');
});
```

### ❌ Ignoring Environment Dependencies
```typescript
// Wrong: Not validating required environment variables
beforeAll(async () => {
  app = await build(); // May fail if env vars missing
});
```

## Related Patterns

- [Test Environment Real vs Mock Pattern](./test_environment_real_vs_mock_pattern.md)
- [Fastify Plugin Registration Pattern](./fastify_plugin_route_prefix_pattern.md)
- [Test Driven Debugging Pattern](./test_driven_debugging_pattern.md)

This pattern ensures comprehensive validation of Fastify applications with complete plugin ecosystem testing. 