import { FastifyInstance, FastifyPluginOptions, FastifyReply, FastifyRequest } from 'fastify';
import fp from 'fastify-plugin';

async function securityHeaders(fastify: FastifyInstance, options: FastifyPluginOptions) {
  fastify.addHook('onSend', async (request: FastifyRequest, reply: FastifyReply, payload: any) => {
    // Basic security headers
    reply.header('X-Content-Type-Options', 'nosniff');
    reply.header('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
    
    // Enhanced Cross-Origin policies for Spectre vulnerability protection
    reply.header('Cross-Origin-Opener-Policy', 'same-origin');
    reply.header('Cross-Origin-Embedder-Policy', 'require-corp');
    reply.header('Cross-Origin-Resource-Policy', 'same-origin');

    // More specific cache control based on route type
    if (!reply.hasHeader('Cache-Control')) {
      const url = request.url;
      
      if (url === '/health' || url.startsWith('/v1/auth/')) {
        // API endpoints should not be cached
        reply.header('Cache-Control', 'no-store, no-cache, must-revalidate, private');
        reply.header('Pragma', 'no-cache');
        reply.header('Expires', '0');
      } else if (url === '/robots.txt' || url === '/sitemap.xml') {
        // Static files can be cached briefly
        reply.header('Cache-Control', 'public, max-age=3600');
      } else {
        // Default: no caching for dynamic content
        reply.header('Cache-Control', 'no-store, no-cache, must-revalidate, private');
        reply.header('Pragma', 'no-cache');
      }
    }

    return payload;
  });
}

export default fp(securityHeaders); 