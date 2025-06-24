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
        // API endpoints should not be cached - use most restrictive settings
        reply.header('Cache-Control', 'no-store, no-cache, must-revalidate, private, max-age=0');
        reply.header('Pragma', 'no-cache');
        reply.header('Expires', '0');
      } else if (url === '/robots.txt') {
        // robots.txt can be cached for a reasonable time but should be refreshed periodically
        reply.header('Cache-Control', 'public, max-age=86400, must-revalidate');
      } else if (url === '/sitemap.xml') {
        // sitemap.xml can be cached but should be validated
        reply.header('Cache-Control', 'public, max-age=3600, must-revalidate');
      } else if (url === '/' || url === '') {
        // Root endpoint - dynamic content, should not be cached
        reply.header('Cache-Control', 'no-store, no-cache, must-revalidate, private, max-age=0');
        reply.header('Pragma', 'no-cache');
        reply.header('Expires', '0');
      } else {
        // Default: no caching for dynamic content with explicit directives
        reply.header('Cache-Control', 'no-store, no-cache, must-revalidate, private, max-age=0');
        reply.header('Pragma', 'no-cache');
        reply.header('Expires', '0');
      }
    }

    return payload;
  });
}

export default fp(securityHeaders); 