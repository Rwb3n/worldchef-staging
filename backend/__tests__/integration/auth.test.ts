/// <reference types="jest" />

// backend/__tests__/integration/auth.test.ts

import { FastifyInstance } from 'fastify';
import { describe, it, expect, beforeAll, afterAll, beforeEach } from '@jest/globals';
import { build } from '../../src/server';

describe('Auth Routes', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    app = await build({ logger: false });
    await app.ready();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('POST /v1/auth/signup', () => {
    it('should return 401 for invalid signup data', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/auth/signup',
        payload: {
          email: 'invalid-email',
          password: 'short'
        }
      });

      // Supabase returns 401 for invalid email format or weak password
      expect(response.statusCode).toBe(401);
    });

    it('should return 401 for missing required fields', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/auth/signup',
        payload: {}
      });

      // Supabase returns 401 for missing email/password
      expect(response.statusCode).toBe(401);
    });
  });

  describe('POST /v1/auth/login', () => {
    it('should return 401 for invalid credentials', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/auth/login',
        payload: {
          email: 'nonexistent@example.com',
          password: 'wrongpassword'
        }
      });

      expect(response.statusCode).toBe(401);
    });

    it('should return 401 for missing credentials', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/auth/login',
        payload: {}
      });

      expect(response.statusCode).toBe(401);
    });
  });
  
  describe('Health Check', () => {
    it('should return 200 for health endpoint', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/health',
      });

      console.log('Health endpoint status:', response.statusCode);
      console.log('Health endpoint payload:', response.payload);

      expect(response.statusCode).toBe(200);
    });

    it('should list all available routes', async () => {
      // Test explicit assumptions about route registration
      const testRoutes = [
        // Test routes that should definitely exist
        { method: 'GET', url: '/health', expected: 'should work' },
        { method: 'GET', url: '/', expected: 'should work' },
        
        // Test auth routes with prefix (what we expect)
        { method: 'POST', url: '/v1/auth/signup', expected: 'should work - returns 401 for empty payload' },
        { method: 'POST', url: '/v1/auth/login', expected: 'should work - returns 401 for empty payload' },
        
        // Test auth routes without prefix (should return 404)
        { method: 'POST', url: '/signup', expected: 'should return 404 - prefix required' },
        { method: 'POST', url: '/login', expected: 'should return 404 - prefix required' },
        
        // Test if routes are registered under different paths (should return 404)
        { method: 'POST', url: '/auth/signup', expected: 'should return 404 - wrong prefix' },
        { method: 'POST', url: '/auth/login', expected: 'should return 404 - wrong prefix' },
      ];
      
      console.log('=== EXPLICIT ROUTE TESTING ===');
      for (const test of testRoutes) {
        const response = await app.inject({
          method: test.method as any,
          url: test.url,
          payload: test.method === 'POST' ? {} : undefined,
        });
        console.log(`${test.method} ${test.url}: ${response.statusCode} (${test.expected})`);
      }
      
      // Also test if we can access the Fastify instance's route information directly
      console.log('=== FASTIFY INTERNAL ROUTE CHECK ===');
      try {
        // Access internal route information if possible
        const routes = (app as any).routes || [];
        console.log('Number of registered routes:', routes.length);
        
        // Try to print routes using Fastify's internal method
        if (typeof app.printRoutes === 'function') {
          console.log('Attempting to print routes...');
          app.printRoutes();
        }
      } catch (error) {
        console.log('Could not access internal route information:', (error as Error).message);
      }
    });
  });
  
  // Note: For positive test cases (successful signup/login), we would need 
  // either a test database or more complex test setup with cleanup
}); 