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

// Health check endpoint
server.get('/health', async (request, reply) => {
  return {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    message: 'WorldChef staging API is running',
    service: process.env.API_MODE ? 'api' : 'web'
  };
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