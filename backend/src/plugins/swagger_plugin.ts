// backend/src/plugins/swagger_plugin.ts
// Pattern: Fastify plugin pattern from auth_plugin.ts | Source: ADR-WCF-015 §XIV | ADR-WCF-015 compliance

import { FastifyPluginAsync } from 'fastify';
import fp from 'fastify-plugin';
import swagger from '@fastify/swagger';
import swaggerUi from '@fastify/swagger-ui';

/**
 * Swagger / OpenAPI plugin – manual spec generation from registered routes
 * Exposes:
 *   • GET /v1/openapi.json → manually built OpenAPI 3.0 spec
 *   • Swagger UI at /v1/docs
 *
 * Follows ADR-WCF-015 §XIV requirements.
 */
const swaggerPlugin: FastifyPluginAsync = async (fastify) => {
  // 1. Register @fastify/swagger for basic setup (but we'll override the spec generation)
  await fastify.register(swagger, {
    openapi: {
      info: {
        title: 'WorldChef API',
        version: '1.0.0',
        description: 'AI-powered recipe discovery & creator platform API',
      },
      servers: [
        {
          url: 'https://worldchef-staging.onrender.com',
          description: 'Staging',
        },
      ],
    },
  });

  // Helper function to process a single route line and add it to the OpenAPI spec
  const processRouteLine = (routeLine: string, paths: Record<string, any>) => {
    if (!routeLine.trim()) return;
    
    // Parse route line format: "├── /v1/auth/signup (POST)"
    const match = routeLine.match(/[├└│]\s*─*\s*([^\s]+)\s*\(([^)]+)\)/);
    if (!match) return;
    
    const [, rawPath, methods] = match;
    // Ensure path starts with /
    const path = rawPath.startsWith('/') ? rawPath : '/' + rawPath;
    const methodList = methods.split(',').map(m => m.trim().toLowerCase());
    
    // Initialize path object if it doesn't exist
    if (!paths[path]) {
      paths[path] = {};
    }
    
    // Add each HTTP method
    for (const method of methodList) {
      if (['get', 'post', 'put', 'patch', 'delete', 'head', 'options'].includes(method)) {
        paths[path][method] = {
          summary: `${method.toUpperCase()} ${path}`,
          description: `${method.toUpperCase()} operation for ${path}`,
          responses: {
            '200': {
              description: 'Successful response',
              content: {
                'application/json': {
                  schema: {
                    type: 'object',
                  },
                },
              },
            },
          },
        };
        
        // Add request body for POST/PUT/PATCH
        if (['post', 'put', 'patch'].includes(method)) {
          paths[path][method].requestBody = {
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                },
              },
            },
          };
        }
      }
    }
  };

  // 2. Function to manually build OpenAPI spec from registered routes
  const buildOpenAPISpec = () => {
    const baseSpec = {
      openapi: '3.0.3',
      info: {
        title: 'WorldChef API',
        version: '1.0.0',
        description: 'AI-powered recipe discovery & creator platform API',
      },
      servers: [
        {
          url: 'https://worldchef-staging.onrender.com',
          description: 'Staging',
        },
      ],
      paths: {} as Record<string, any>,
    };

    // Extract routes from Fastify's internal route table
    const routes = fastify.printRoutes({ includeHooks: false, commonPrefix: false }).split('\n');
    
    for (const routeLine of routes) {
      processRouteLine(routeLine, baseSpec.paths);
    }

    return baseSpec;
  };

  // 3. Expose raw JSON spec at /v1/openapi.json
  fastify.route({
    method: 'GET',
    url: '/v1/openapi.json',
    schema: {
      summary: 'OpenAPI specification (JSON)',
      description: 'Manually generated OpenAPI 3.0 specification',
      tags: ['docs'],
      response: {
        200: {
          description: 'OpenAPI document',
          type: 'object',
          properties: {}, // any – openapi schema itself
        },
      },
    },
    handler: async (_, reply) => {
      try {
        const spec = buildOpenAPISpec();
        
        // Validate spec before sending
        if (!spec || typeof spec !== 'object') {
          fastify.log.error('Invalid spec generated:', spec);
          return reply.status(500).send({ error: 'Failed to generate OpenAPI spec' });
        }
        
        const specString = JSON.stringify(spec);
        return reply.type('application/json').send(specString);
      } catch (error) {
        fastify.log.error('Error generating OpenAPI spec:', error);
        const errorMessage = error instanceof Error ? error.message : 'Unknown error';
        return reply.status(500).send({ error: 'Failed to generate OpenAPI spec', details: errorMessage });
      }
    },
  });

  // 4. Register Swagger UI at /v1/docs, pointing to /v1/openapi.json
  await fastify.register(swaggerUi, {
    routePrefix: '/v1/docs',
    uiConfig: {
      docExpansion: 'list',
      deepLinking: true,
      url: '/v1/openapi.json',
    },
    staticCSP: true,
    transformStaticCSP: (header) => header,
  });

  fastify.log.info('Swagger plugin registered – UI /v1/docs, JSON /v1/openapi.json');
};

export default fp(swaggerPlugin); 