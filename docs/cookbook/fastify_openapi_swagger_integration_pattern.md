# Cookbook: Fastify OpenAPI/Swagger Integration Pattern

**Pattern:** Complete OpenAPI 3.x integration with Fastify using @fastify/swagger
**Source:** Cycle 4 Documentation Gap Fill - OpenAPI Implementation
**Validated in:** TDD Cycle (RED→GREEN→REFACTOR) with comprehensive plugin integration testing
**ADR Reference:** ADR-WCF-015 §XIV

This pattern provides a complete, production-ready OpenAPI/Swagger integration for Fastify applications with plugin ecosystem validation.

## Problem Statement

Modern APIs require standardized documentation and interactive testing interfaces. The OpenAPI specification provides this, but integrating it properly with Fastify's plugin ecosystem requires careful consideration of:

- Plugin loading order and dependencies
- Schema validation integration
- Security headers application
- Export automation for CI/CD
- Type safety with TypeScript
- Comprehensive testing including plugin interactions

## Solution Pattern

### 1. Dependencies Installation

```bash
npm install @fastify/swagger@^8.14.0 @fastify/swagger-ui@^4.0.0
```

**Version Compatibility**: These versions are compatible with Fastify 4.x. Always check compatibility matrix.

### 2. Swagger Plugin Implementation

```typescript
// src/plugins/swagger_plugin.ts
import { FastifyInstance } from 'fastify';
import fp from 'fastify-plugin';

// Extend FastifyInstance to include swagger method
declare module 'fastify' {
  interface FastifyInstance {
    swagger(): any;
  }
}

async function swaggerPlugin(fastify: FastifyInstance) {
  // Register swagger plugin for OpenAPI generation
  await fastify.register(require('@fastify/swagger'), {
    openapi: {
      openapi: '3.0.3',
      info: {
        title: 'WorldChef API',
        description: 'AI-powered recipe discovery and creator platform API',
        version: '1.0.0',
      },
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Development server'
        },
        {
          url: 'https://worldchef-staging.onrender.com',
          description: 'Staging server'
        }
      ],
      tags: [
        { name: 'auth', description: 'Authentication endpoints' },
        { name: 'recipes', description: 'Recipe management endpoints' },
        { name: 'users', description: 'User management endpoints' }
      ],
    },
    transform: ({ schema, url }: { schema: any; url: string }) => {
      // Transform the schema to include the /v1 prefix
      const transformedUrl = url.startsWith('/v1') ? url : `/v1${url}`;
      return { schema, url: transformedUrl };
    },
  });

  // Register swagger UI plugin
  await fastify.register(require('@fastify/swagger-ui'), {
    routePrefix: '/v1/docs',
    uiConfig: {
      docExpansion: 'list',
      deepLinking: false,
    },
    staticCSP: true,
    transformStaticCSP: (header: string) => header,
  });

  // Add route for raw OpenAPI JSON
  fastify.get('/v1/openapi.json', async (request, reply) => {
    return fastify.swagger();
  });
}

export default fp(swaggerPlugin);
```

### 3. JSON Schema Definitions

```typescript
// src/schemas/auth_schemas.ts
export const signupSchema = {
  summary: 'Create new user account',
  tags: ['auth'],
  description: 'Register a new user with email and password',
  body: {
    type: 'object',
    required: ['email', 'password'],
    properties: {
      email: {
        type: 'string',
        format: 'email',
        description: 'User email address'
      },
      password: {
        type: 'string',
        minLength: 8,
        description: 'User password (minimum 8 characters)'
      },
      firstName: {
        type: 'string',
        maxLength: 50,
        description: 'User first name (optional)'
      },
      lastName: {
        type: 'string',
        maxLength: 50,
        description: 'User last name (optional)'
      }
    },
    additionalProperties: false
  },
  response: {
    200: {
      type: 'object',
      properties: {
        user: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            email: { type: 'string', format: 'email' },
            created_at: { type: 'string', format: 'date-time' }
          }
        },
        access_token: { type: 'string' },
        refresh_token: { type: 'string' }
      }
    },
    400: {
      type: 'object',
      properties: {
        error: { type: 'string' },
        message: { type: 'string' }
      }
    },
    422: {
      type: 'object',
      properties: {
        error: { type: 'string' },
        message: { type: 'string' }
      }
    }
  }
};

export const loginSchema = {
  summary: 'Authenticate user',
  tags: ['auth'],
  description: 'Login with email and password to receive access tokens',
  body: {
    type: 'object',
    required: ['email', 'password'],
    properties: {
      email: {
        type: 'string',
        format: 'email',
        description: 'User email address'
      },
      password: {
        type: 'string',
        description: 'User password'
      }
    },
    additionalProperties: false
  },
  response: {
    200: {
      type: 'object',
      properties: {
        user: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            email: { type: 'string', format: 'email' },
            last_sign_in_at: { type: 'string', format: 'date-time' }
          }
        },
        access_token: { type: 'string' },
        refresh_token: { type: 'string' }
      }
    },
    400: {
      type: 'object',
      properties: {
        error: { type: 'string' },
        message: { type: 'string' }
      }
    },
    401: {
      type: 'object',
      properties: {
        error: { type: 'string' },
        message: { type: 'string' }
      }
    }
  }
};
```

### 4. Route Integration with Schemas

```typescript
// src/routes/v1/auth/index.ts
import { FastifyInstance, FastifyPluginOptions } from 'fastify';
import { signupSchema, loginSchema } from '../../schemas/auth_schemas';

async function authRoutes(fastify: FastifyInstance, options: FastifyPluginOptions) {
  // Apply schemas to routes for OpenAPI generation
  fastify.post('/signup', { schema: signupSchema }, async (request, reply) => {
    const { email, password, firstName, lastName } = request.body as any;
    // Implementation...
  });

  fastify.post('/login', { schema: loginSchema }, async (request, reply) => {
    const { email, password } = request.body as any;
    // Implementation...
  });
}

// ✅ Direct export for route registration (preserves prefix)
export default authRoutes;
```

### 5. Server Registration with Plugin Loading Order

```typescript
// src/server.ts
import swaggerPlugin from './plugins/swagger_plugin';
import authRoutes from './routes/v1/auth';

export async function build(opts: FastifyServerOptions = {}): Promise<FastifyInstance> {
  const server = Fastify({ logger: true, ...opts });

  try {
    // ⚠️ CRITICAL: Plugin loading order matters
    await server.register(supabasePlugin);      // 1. Database connection
    await server.register(authPlugin);          // 2. Authentication (depends on Supabase)
    await server.register(securityHeadersPlugin); // 3. Security headers
    await server.register(swaggerPlugin);       // 4. OpenAPI (after all dependencies)

    // Register routes AFTER all plugins
    await server.register(authRoutes, { prefix: '/v1/auth' });
  } catch (error) {
    console.error('Error registering plugins or routes:', error);
    throw error;
  }

  return server;
}
```

### 6. OpenAPI Export Script for CI/CD

```typescript
// scripts/export-openapi.ts
import * as fs from 'fs';
import * as path from 'path';
import Fastify from 'fastify';
import swaggerPlugin from '../src/plugins/swagger_plugin';
import { signupSchema, loginSchema } from '../src/schemas/auth_schemas';

async function exportOpenAPI() {
  try {
    console.log('Building minimal Fastify server for OpenAPI export...');
    
    // Create minimal server without Supabase dependencies
    const app = Fastify({ logger: false });
    
    // Register only swagger plugin
    await app.register(swaggerPlugin);
    
    // Register minimal auth routes with schemas for OpenAPI generation
    await app.register(async function (fastify) {
      fastify.post('/v1/auth/signup', { schema: signupSchema }, async (request, reply) => {
        return { message: 'OpenAPI export - endpoint not implemented' };
      });
      
      fastify.post('/v1/auth/login', { schema: loginSchema }, async (request, reply) => {
        return { message: 'OpenAPI export - endpoint not implemented' };
      });
    });
    
    await app.ready();
    
    console.log('Generating OpenAPI specification...');
    const spec = app.swagger();
    
    // Create docs/api directory
    const apiDir = path.join(__dirname, '../docs/api');
    fs.mkdirSync(apiDir, { recursive: true });
    
    // Write OpenAPI spec to file
    const specPath = path.join(apiDir, 'openapi_v1.json');
    fs.writeFileSync(specPath, JSON.stringify(spec, null, 2));
    
    console.log(`OpenAPI spec exported to: ${specPath}`);
    console.log('Export completed successfully!');
    
    await app.close();
    process.exit(0);
  } catch (error) {
    console.error('Error exporting OpenAPI spec:', error);
    process.exit(1);
  }
}

if (require.main === module) {
  exportOpenAPI();
}
```

### 7. NPM Script Integration

```json
{
  "scripts": {
    "openapi:export": "ts-node scripts/export-openapi.ts"
  }
}
```

## Comprehensive Testing Pattern

### Plugin Integration Testing

```typescript
// __tests__/integration/openapi.test.ts
/// <reference types="jest" />
/// <reference path="../../src/types/fastify.d.ts" />

import { FastifyInstance } from 'fastify';
import { describe, it, expect, beforeAll, afterAll } from '@jest/globals';
import { build } from '../../src/server';

describe('OpenAPI Integration', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    app = await build({ logger: false });
    await app.ready();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('Plugin Integration Validation', () => {
    it('should have Supabase plugin properly loaded', async () => {
      expect(app.supabase).toBeDefined();
      expect(typeof app.supabase.from).toBe('function');
      expect(typeof app.supabase.auth).toBe('object');
    });

    it('should have required environment variables', async () => {
      expect(process.env.SUPABASE_URL).toBeDefined();
      expect(process.env.SUPABASE_SERVICE_ROLE_KEY).toBeDefined();
      expect(process.env.SUPABASE_URL).toMatch(/^https:\/\/.+\.supabase\.co$/);
    });

    it('should apply security headers to OpenAPI endpoints', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/v1/openapi.json'
      });

      expect(response.headers['x-content-type-options']).toBe('nosniff');
      expect(response.headers['strict-transport-security']).toContain('max-age=31536000');
      expect(response.headers['cross-origin-opener-policy']).toBe('same-origin');
    });
  });

  describe('OpenAPI Endpoints', () => {
    it('should expose OpenAPI spec at /v1/openapi.json', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/v1/openapi.json'
      });

      expect(response.statusCode).toBe(200);
      expect(response.headers['content-type']).toMatch(/application\/json/);

      const spec = JSON.parse(response.payload);
      expect(spec.openapi).toMatch(/^3\./);
      expect(spec.info).toBeDefined();
      expect(spec.paths).toBeDefined();
      expect(spec.paths['/v1/auth/signup']).toBeDefined();
    });

    it('should serve Swagger UI at /v1/docs', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/v1/docs'
      });

      expect(response.statusCode).toBe(200);
      expect(response.headers['content-type']).toMatch(/text\/html/);
      expect(response.payload).toContain('swagger');
    });
  });

  describe('Schema Validation', () => {
    it('should validate request schemas', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/auth/signup',
        payload: {
          email: 'invalid-email',
          password: 'short'
        }
      });

      // Should return proper error status (validation working)
      expect([400, 401, 422]).toContain(response.statusCode);
      expect(response.headers['content-type']).toMatch(/application\/json/);
    });
  });
});
```

## Key Principles

### 1. Plugin Loading Order
- Supabase → Auth → Security Headers → Swagger → Routes
- Dependencies must be loaded before dependents

### 2. Schema-First Development
- Define JSON schemas for all request/response bodies
- Use JSON Schema Draft 7 specification
- Include validation, documentation, and type safety

### 3. Security Integration
- Security headers applied to all OpenAPI endpoints
- CSP compatibility with Swagger UI
- No sensitive data in OpenAPI specification

### 4. CI/CD Integration
- Export script generates static OpenAPI file
- No runtime dependencies for export
- Suitable for automated documentation pipelines

### 5. Type Safety
- TypeScript declarations for Fastify extensions
- Full type checking for schemas and routes
- Integration with existing type system

## Validation Checklist

- [ ] OpenAPI 3.x specification accessible at `/v1/openapi.json`
- [ ] Swagger UI accessible at `/v1/docs`
- [ ] All plugins load in correct order without errors
- [ ] Security headers applied to OpenAPI endpoints
- [ ] Schema validation active for all routes
- [ ] Export script generates valid OpenAPI file
- [ ] TypeScript compilation without errors
- [ ] Integration tests cover plugin interactions
- [ ] Error response schemas documented

## Common Pitfalls

### ❌ Plugin Loading Order Issues
```typescript
// Wrong: Loading swagger before dependencies
await server.register(swaggerPlugin);
await server.register(supabasePlugin); // ← Swagger won't see Supabase routes
```

### ❌ Missing Schema Validation
```typescript
// Wrong: Route without schema
fastify.post('/signup', async (request, reply) => {
  // No validation, no OpenAPI documentation
});
```

### ❌ Export Script with Runtime Dependencies
```typescript
// Wrong: Export script requiring Supabase connection
const app = await build(); // ← Will fail in CI without Supabase credentials
```

### ❌ Security Headers Conflicts
```typescript
// Wrong: Conflicting CSP settings
staticCSP: false, // ← Breaks security headers plugin integration
```

## Related Patterns

- [Fastify Plugin Registration Pattern](./fastify_plugin_route_prefix_pattern.md)
- [Supabase Auth Integration Pattern](./supabase_auth_integration_pattern.md)
- [Test Environment Real vs Mock Pattern](./test_environment_real_vs_mock_pattern.md)

This pattern ensures comprehensive OpenAPI integration with full plugin ecosystem validation and production-ready automation. 