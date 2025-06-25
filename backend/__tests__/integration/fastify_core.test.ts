/// <reference types="jest" />
/// <reference path="../../src/types/fastify.d.ts" />

import { FastifyInstance } from 'fastify';
import { describe, it, expect, beforeAll, afterAll } from '@jest/globals';
import { build } from '../../src/server';

describe('Core Fastify Server Validation', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    // We build the app once for all tests
    app = await build({ logger: false });
    await app.ready();
  });

  afterAll(async () => {
    // Close the server instance after all tests are done
    await app.close();
  });

  describe('API Health and Status', () => {
    it('should return 200 OK with status: ok from GET /v1/status', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/v1/status',
      });

      expect(response.statusCode).toBe(200);
      const payload = JSON.parse(response.payload);
      expect(payload).toEqual({ status: 'ok' });
    });
  });

  describe('API Documentation and Specification', () => {
    it('should return the OpenAPI specification from GET /docs/json', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/docs/json',
      });

      expect(response.statusCode).toBe(200);
      const payload = JSON.parse(response.payload);
      // A simple check to ensure it looks like an OpenAPI spec
      expect(payload.openapi).toMatch(/^3\./);
      expect(payload.info.title).toBe('WorldChef API');
    });

    it('should return the Swagger UI page from GET /docs', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/docs',
      });

      expect(response.statusCode).toBe(200);
      // A simple check for the swagger UI's title
      expect(response.payload).toContain('<title>Swagger UI</title>');
    });
  });
}); 