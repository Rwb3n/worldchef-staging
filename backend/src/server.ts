import dotenv from 'dotenv';
import path from 'path';
dotenv.config({ path: path.resolve(__dirname, '../../../.env.local') });
// fallback to .env if .env.local does not exist
import fs from 'fs';
const envLocalPath = path.resolve(__dirname, '../../../.env.local');
const envPath = path.resolve(__dirname, '../../../.env');
if (!fs.existsSync(envLocalPath) && fs.existsSync(envPath)) {
  dotenv.config({ path: envPath });
}
import Fastify, { FastifyInstance, FastifyServerOptions } from 'fastify';
import supabasePlugin from './plugins/supabase_plugin';
import authPlugin from './plugins/auth_plugin';
import securityHeadersPlugin from './plugins/security_headers_plugin';
import cacheControlPlugin from './plugins/cache_control_plugin';
import swaggerPlugin from './plugins/swagger_plugin';
import authRoutes from './routes/v1/auth';
import statusRoute from './routes/v1/status';
import paymentsRoutes from './routes/v1/payments/index';
import notificationRoutes from './routes/v1/notifications/index';

export async function build(opts: FastifyServerOptions = {}): Promise<FastifyInstance> {
  const server = Fastify({
    logger: opts.logger !== undefined ? opts.logger : true,
    ...opts
  });

  try {
    // Register plugins with error handling
    await server.register(supabasePlugin);
    await server.register(authPlugin);
    await server.register(securityHeadersPlugin);
    await server.register(cacheControlPlugin);

    // Register routes BEFORE swagger plugin for dynamic generation
    await server.register(authRoutes, { prefix: '/v1/auth' });
    await server.register(statusRoute, { prefix: '/v1' });
    await server.register(paymentsRoutes, { prefix: '/v1' });
    await server.register(notificationRoutes, { prefix: '/v1' });

    // Register swagger plugin AFTER routes for dynamic OpenAPI generation
    await server.register(swaggerPlugin);
  } catch (error) {
    console.error('Error registering plugins or routes:', error);
    throw error;
  }

  // Health check endpoint
  server.get('/health', async (request, reply) => {
    reply.type('application/json');
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV || 'development'
    };
  });

  // Basic SEO/crawler endpoints
  server.get('/robots.txt', async (request, reply) => {
    reply.type('text/plain');
    return `User-agent: *
Disallow: /v1/auth/
Disallow: /health

# This is a staging API server
# Production robots.txt will be different`;
  });

  server.get('/sitemap.xml', async (request, reply) => {
    reply.type('application/xml');
    return `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://worldchef-staging.onrender.com/</loc>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>
</urlset>`;
  });

  // Root endpoint
  server.get('/', async (request, reply) => {
    reply.type('application/json');
    return {
      name: 'WorldChef API',
      version: '1.0.0',
      environment: process.env.NODE_ENV || 'development',
      mode: process.env.API_MODE ? 'api' : 'web'
    };
  });

  return server;
}

const start = async () => {
  try {
    const server = await build();
    const port = parseInt(process.env.PORT || '10000', 10);
    const host = '0.0.0.0';
    await server.listen({ port, host });
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};

// Only start the server if this file is run directly
if (require.main === module) {
  start();
} 