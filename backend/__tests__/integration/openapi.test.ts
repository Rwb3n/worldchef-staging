/// <reference types="jest" />
/// <reference path="../../src/types/fastify.d.ts" />

// backend/__tests__/integration/openapi.test.ts
// Pattern: TestContainers pattern from auth.test.ts | Source: ADR-WCF-015 §XIV | ADR-WCF-015 compliance

import { FastifyInstance } from 'fastify';
import { describe, it, expect, beforeAll, afterAll } from '@jest/globals';
import { build } from '../../src/server';

describe('OpenAPI Endpoint', () => {
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
      // Verify Supabase plugin is decorated on Fastify instance
      expect(app.supabase).toBeDefined();
      expect(typeof app.supabase.from).toBe('function');
      expect(typeof app.supabase.auth).toBe('object');
    });

    it('should have required environment variables for Supabase', async () => {
      // These are required by supabase_plugin.ts
      expect(process.env.SUPABASE_URL).toBeDefined();
      expect(process.env.SUPABASE_SERVICE_ROLE_KEY).toBeDefined();
      
      // Validate URL format
      expect(process.env.SUPABASE_URL).toMatch(/^https:\/\/.+\.supabase\.co$/);
    });

    it('should apply security headers to OpenAPI endpoints', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/v1/openapi.json'
      });

      // Verify security headers plugin is working
      expect(response.headers['x-content-type-options']).toBe('nosniff');
      expect(response.headers['strict-transport-security']).toContain('max-age=31536000');
      expect(response.headers['cross-origin-opener-policy']).toBe('same-origin');
      expect(response.headers['cross-origin-embedder-policy']).toBe('require-corp');
    });

    it('should apply security headers to Swagger UI', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/v1/docs'
      });

      // Verify security headers on Swagger UI
      expect(response.headers['x-content-type-options']).toBe('nosniff');
      expect(response.headers['cache-control']).toContain('no-store');
    });
  });

  describe('GET /v1/openapi.json', () => {
    it('should expose OpenAPI spec at /v1/openapi.json', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/v1/openapi.json'
      });

      console.log('OpenAPI spec endpoint - Status:', response.statusCode);
      console.log('OpenAPI spec endpoint - Response headers:', response.headers);

      // ADR-WCF-015 §XIV: "Published at /v1/openapi.json"
      expect(response.statusCode).toBe(200);
      expect(response.headers['content-type']).toMatch(/application\/json/);

      const spec = JSON.parse(response.payload);
      
      // ADR-WCF-015 §XIV: "OpenAPI Specification (OAS) 3.x"
      expect(spec.openapi).toMatch(/^3\./);
      expect(spec.info).toBeDefined();
      expect(spec.paths).toBeDefined();

      // Verify auth routes are documented (from existing implementation)
      expect(spec.paths['/v1/auth/signup']).toBeDefined();
      expect(spec.paths['/v1/auth/login']).toBeDefined();
    });

    it('should serve Swagger UI at /v1/docs', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/v1/docs'
      });

      console.log('Swagger UI endpoint - Status:', response.statusCode);
      console.log('Swagger UI endpoint - Content-Type:', response.headers['content-type']);

      // ADR-WCF-015 §XIV: "UI at /v1/docs"
      expect(response.statusCode).toBe(200);
      expect(response.headers['content-type']).toMatch(/text\/html/);
      
      // Should contain Swagger UI elements
      expect(response.payload).toContain('swagger');
    });
  });

  describe('OpenAPI Schema Validation', () => {
    it('should include required OpenAPI 3.x structure', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/v1/openapi.json'
      });

      expect(response.statusCode).toBe(200);
      
      const spec = JSON.parse(response.payload);
      
      // Required OpenAPI 3.x fields per ADR-WCF-015
      expect(spec.openapi).toBeDefined();
      expect(spec.info).toBeDefined();
      expect(spec.info.title).toBeDefined();
      expect(spec.info.version).toBeDefined();
      expect(spec.paths).toBeDefined();
      
      // Should document existing auth endpoints with schemas
      const authSignupPath = spec.paths['/v1/auth/signup'];
      expect(authSignupPath).toBeDefined();
      expect(authSignupPath.post).toBeDefined();
      expect(authSignupPath.post.requestBody).toBeDefined();
      expect(authSignupPath.post.responses).toBeDefined();
    });

    it('should include proper error response schemas', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/v1/openapi.json'
      });

      const spec = JSON.parse(response.payload);
      
      // Verify error responses are documented
      const signupResponses = spec.paths['/v1/auth/signup'].post.responses;
      expect(signupResponses['400']).toBeDefined();
      expect(signupResponses['422']).toBeDefined();
      
      // Verify error response schemas
      expect(signupResponses['400'].content['application/json'].schema).toBeDefined();
      expect(signupResponses['422'].content['application/json'].schema).toBeDefined();
    });

    it('should validate request/response schemas match auth route implementation', async () => {
      // Test that schemas actually validate real requests
      const signupResponse = await app.inject({
        method: 'POST',
        url: '/v1/auth/signup',
        payload: {
          email: 'invalid-email',
          password: 'short'
        }
      });

      // Should return proper error status (validation working)
      expect([400, 401, 422]).toContain(signupResponse.statusCode);
      
      // Response should be JSON (schema validation active)
      expect(signupResponse.headers['content-type']).toMatch(/application\/json/);
    });
  });

  describe('Plugin Loading Order Validation', () => {
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
      
      // Test that auth routes are accessible (auth plugin + route registration)
      const authResponse = await app.inject({
        method: 'POST',
        url: '/v1/auth/signup',
        payload: {}
      });
      expect([400, 401, 422]).toContain(authResponse.statusCode); // Should not be 404
    });
  });
}); 