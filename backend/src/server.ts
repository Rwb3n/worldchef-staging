import fastify, { FastifyInstance } from 'fastify';
import authPlugin from './plugins/auth_plugin';
import securityHeadersPlugin from './plugins/security_headers_plugin';
import authRoutes from './routes/v1/auth';

export async function build(opts = {}): Promise<FastifyInstance> {
  const app = fastify(opts);

  // Register plugins
  app.register(authPlugin);
  app.register(securityHeadersPlugin);

  // Register routes
  app.register(authRoutes, { prefix: '/v1/auth' });

  // Health check endpoint
  app.get('/health', async (request, reply) => {
    return {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      message: 'WorldChef staging API is running',
      service: process.env.API_MODE ? 'api' : 'web'
    };
  });

  // Root endpoint
  app.get('/', async (request, reply) => {
    return {
      name: 'WorldChef API',
      version: '1.0.0',
      environment: process.env.NODE_ENV || 'development',
      mode: process.env.API_MODE ? 'api' : 'web'
    };
  });

  return app;
}


// Start server only if this file is run directly
if (require.main === module) {
  const start = async () => {
    const app = await build({ logger: true });
    try {
      const port = parseInt(process.env.PORT || '10000', 10);
      const host = '0.0.0.0';
      
      await app.listen({ port, host });

    } catch (err) {
      app.log.error(err);
      process.exit(1);
    }
  };
  start();
} 