/// <reference types="jest" />
/// <reference path="../../src/types/fastify.d.ts" />

// backend/__tests__/integration/swagger_plugin.test.ts
// Task: plan_gap_closure t004 (TEST_CREATION) – Red step
// This test validates that the Fastify Swagger plugin exposes documentation endpoints
// and that **all** registered HTTP routes are present in the generated OpenAPI spec.
// The test is expected to FAIL initially because the notifications & payments routes
// are not yet documented in docs/api/openapi_v1.json.

import { FastifyInstance } from 'fastify';
import { describe, it, expect, beforeAll, afterAll } from '@jest/globals';
import { build } from '../../src/server';

// List of critical routes that **must** be present in the OpenAPI spec.
// The list is derived from ADR-WCF-015 §XIV and current route registrations.
const REQUIRED_ROUTES = [
  '/v1/auth/signup',
  '/v1/auth/login',
  '/v1/notifications', // <-- Expected missing => test should fail (Red)
  '/v1/payments',     // <-- Expected missing => test should fail (Red)
  '/health'  // Updated to match production health endpoint from aiconfig.json
];

describe('Swagger Plugin & OpenAPI Coverage', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    app = await build({ logger: false });
    await app.ready();
  });

  afterAll(async () => {
    await app.close();
  });

  it('should expose Swagger UI at /v1/docs', async () => {
    const res = await app.inject({ method: 'GET', url: '/v1/docs' });
    expect(res.statusCode).toBe(200);
    expect(res.headers['content-type']).toMatch(/text\/html/);
  });

  it('should expose raw OpenAPI JSON at /v1/openapi.json', async () => {
    const res = await app.inject({ method: 'GET', url: '/v1/openapi.json' });
    expect(res.statusCode).toBe(200);
    expect(res.headers['content-type']).toMatch(/application\/json/);
  });

  it('should include all registered routes in the OpenAPI spec', async () => {
    const res = await app.inject({ method: 'GET', url: '/v1/openapi.json' });
    const spec = JSON.parse(res.payload);
    
    REQUIRED_ROUTES.forEach((route) => {
      expect(spec.paths[route]).toBeDefined();
    });
  });
}); 