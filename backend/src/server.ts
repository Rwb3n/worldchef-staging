import Fastify from 'fastify';
import supabasePlugin from './plugins/supabase_plugin';
import authPlugin from './plugins/auth_plugin';
import securityHeadersPlugin from './plugins/security_headers_plugin';
import authRoutes from './routes/v1/auth';

const server = Fastify({ logger: true });

// Register plugins
server.register(supabasePlugin);
server.register(authPlugin);
server.register(securityHeadersPlugin);

// Register routes
server.register(authRoutes, { prefix: '/v1/auth' });

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
  return {
    name: 'WorldChef API',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    mode: process.env.API_MODE ? 'api' : 'web'
  };
});

const start = async () => {
  try {
    const port = parseInt(process.env.PORT || '10000', 10);
    const host = '0.0.0.0';
    await server.listen({ port, host });
  } catch (err) {
    server.log.error(err);
    process.exit(1);
  }
};

start(); 