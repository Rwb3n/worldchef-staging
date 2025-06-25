# Cookbook: Fastify Schema Validation Debugging Pattern

**Pattern:** Systematic Debugging for Fastify Schema Validation Issues  
**Source:** Cycle 4 Stripe Integration Debugging  
**Validated in:** Production backend validation (g115)  
**Use Cases:** Hooks errors, empty responses, schema validation failures

This pattern provides a systematic approach to debugging Fastify schema validation issues that often manifest as hooks errors or unexpected empty responses.

## Problem Symptoms

- `TypeError: Cannot read properties of undefined (reading 'length')` in Fastify hooks
- Empty response objects `{}` from endpoints that should return data
- Tests passing with minimal implementations but failing with full implementations
- Supertest integration tests failing while direct testing works

## Root Cause Analysis

### Common Misdiagnosis
- **Assumed**: Fastify hooks compatibility issues
- **Assumed**: Content type parser conflicts
- **Assumed**: Plugin registration problems

### Actual Root Causes
1. **Response Schema Filtering**: Fastify filters out properties not defined in response schema
2. **Test Method Incompatibility**: Some testing approaches trigger hooks errors
3. **Schema Compliance**: Route implementations not matching expected schema structure

## Debugging Pattern

### Step 1: Isolate the Implementation

```typescript
// Create minimal route without dependencies
async function paymentsRoutes(fastify: FastifyInstance, options: FastifyPluginOptions) {
  // Minimal test route without any dependencies
  fastify.get('/payments/test', async (request, reply) => {
    return { message: 'Route working' };
  });

  // Minimal POST route without schema
  fastify.post('/payments/checkout', async (request, reply) => {
    return { message: 'Endpoint reached', body: request.body };
  });
}
```

**Test**: Verify basic route registration and server startup.

### Step 2: Add External Dependencies Incrementally

```typescript
// Add external library import and initialization
import Stripe from 'stripe';

async function paymentsRoutes(fastify: FastifyInstance, options: FastifyPluginOptions) {
  // Initialize external service
  const stripeKey = process.env.STRIPE_SECRET_KEY;
  if (!stripeKey) {
    throw new Error('STRIPE_SECRET_KEY environment variable is required');
  }
  const stripe = new Stripe(stripeKey);

  // Test route with external service
  fastify.get('/payments/test', async (request, reply) => {
    return { message: 'Route working', serviceInitialized: !!stripe };
  });
}
```

**Test**: Verify external service integration doesn't cause issues.

### Step 3: Add Schema Validation

```typescript
// Add schema import and apply to routes
import { checkoutSchema } from '../../../schemas/payment_schemas';

// Apply schema to route
fastify.post('/payments/checkout', { schema: checkoutSchema }, async (request, reply) => {
  return { message: 'Endpoint with schema', body: request.body };
});
```

**Test**: This is where schema validation issues typically manifest.

### Step 4: Diagnose Schema Compliance

```typescript
// Check actual vs expected response structure
fastify.post('/payments/checkout', { schema: checkoutSchema }, async (request, reply) => {
  const response = { message: 'Test', body: request.body };
  
  // Log what we're trying to return
  fastify.log.info('Attempting to return:', response);
  
  return response;
});
```

**Expected Result**: If response is `{}`, schema is filtering out properties.

### Step 5: Fix Schema Compliance

```typescript
// Ensure response matches schema exactly
fastify.post('/payments/checkout', { schema: checkoutSchema }, async (request, reply) => {
  // Check response schema definition
  // checkoutSchema.response.200.properties = { id: { type: 'string' } }
  
  // Return only properties defined in schema
  return { id: 'test_session_id' };
});
```

**Test**: Response should now contain expected properties.

### Step 6: Implement Full Functionality

```typescript
// Add full implementation while maintaining schema compliance
fastify.post('/payments/checkout', { schema: checkoutSchema }, async (request, reply) => {
  try {
    const { amount, currency } = request.body as { amount: number; currency: string };
    
    const session = await stripe.checkout.sessions.create({
      // ... full Stripe configuration
    });

    // CRITICAL: Return only schema-defined properties
    return { id: session.id };
  } catch (error: any) {
    fastify.log.error('Operation failed:', error);
    reply.status(500).send({ 
      error: 'Internal server error',
      message: 'Operation failed'
    });
  }
});
```

## Testing Strategy

### Use Fastify.inject() for Integration Tests

```typescript
// PREFER: Direct Fastify testing
describe('Route Integration', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    app = await build({ logger: false });
    await app.ready();
  });

  it('should work correctly', async () => {
    const response = await app.inject({
      method: 'POST',
      url: '/v1/payments/checkout',
      payload: { amount: 1000, currency: 'usd' }
    });

    expect(response.statusCode).toBe(200);
    const json = response.json();
    expect(json.id).toBeDefined();
  });
});
```

### Avoid Supertest for Fastify (When Problematic)

```typescript
// AVOID: Can trigger hooks errors in some configurations
import request from 'supertest';

it('might cause hooks errors', async () => {
  const response = await request(app.server)
    .post('/v1/payments/checkout')
    .send({ amount: 1000, currency: 'usd' });
  // May fail with hooks error
});
```

## Schema Definition Best Practices

### Response Schema Compliance

```typescript
export const apiSchema = {
  response: {
    200: {
      type: 'object',
      properties: {
        // ONLY these properties will be returned
        id: { type: 'string' },
        status: { type: 'string' }
        // Any other properties in route response will be filtered out
      }
    }
  }
};
```

### Error Response Consistency

```typescript
export const standardErrorResponses = {
  400: {
    type: 'object',
    properties: {
      error: { type: 'string' },
      message: { type: 'string' }
    }
  },
  500: {
    type: 'object',
    properties: {
      error: { type: 'string' },
      message: { type: 'string' }
    }
  }
};

// Use in all schemas
export const mySchema = {
  // ... request schema
  response: {
    200: { /* success schema */ },
    ...standardErrorResponses
  }
};
```

## Debugging Checklist

### When You See Hooks Errors
- [ ] Remove all schemas temporarily - does it work?
- [ ] Check response object vs schema definition
- [ ] Try `Fastify.inject()` instead of `supertest`
- [ ] Verify environment variable loading

### When You See Empty Responses `{}`
- [ ] Compare route return object to response schema
- [ ] Log actual return object before schema validation
- [ ] Check for extra properties not in schema
- [ ] Verify required properties are present

### When External Integration Fails
- [ ] Test without external service first
- [ ] Add external service without schema
- [ ] Add schema after confirming service works
- [ ] Check environment variable configuration

## Environment Debugging

### Validate Environment Loading

```typescript
// Log environment status (never log actual values)
const requiredEnvVars = ['STRIPE_SECRET_KEY', 'STRIPE_WEBHOOK_SECRET'];
requiredEnvVars.forEach(varName => {
  const value = process.env[varName];
  if (value) {
    fastify.log.info(`${varName}: loaded (length: ${value.length})`);
  } else {
    fastify.log.error(`${varName}: MISSING`);
  }
});
```

### Monorepo Path Resolution

```typescript
// Correct dotenv path for backend/src/ in monorepo
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.resolve(__dirname, '../../../.env.local') });

// Verify path resolution
const envPath = path.resolve(__dirname, '../../../.env.local');
fastify.log.info(`Loading environment from: ${envPath}`);
fastify.log.info(`Environment file exists: ${fs.existsSync(envPath)}`);
```

## Prevention Strategies

1. **Schema-First Development**: Define schemas before implementing routes
2. **Incremental Testing**: Test each layer of complexity separately
3. **Response Validation**: Always verify actual vs expected response structure
4. **Environment Validation**: Check environment loading at startup
5. **Test Method Consistency**: Use `Fastify.inject()` for integration tests

## Performance Impact

- **Schema Validation**: <1ms overhead per request
- **Response Filtering**: Minimal CPU impact
- **Debugging Overhead**: Only during development
- **Production Impact**: None when properly implemented

This debugging pattern has proven effective for resolving complex integration issues that initially appear to be framework bugs but are actually configuration or compliance issues. 