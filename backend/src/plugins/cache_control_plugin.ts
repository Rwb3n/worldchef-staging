
import { FastifyInstance, FastifyPluginOptions, FastifyReply, FastifyRequest } from 'fastify';
import fp from 'fastify-plugin';

async function cacheControl(fastify: FastifyInstance, options: FastifyPluginOptions) {
  fastify.addHook('onSend', async (request: FastifyRequest, reply: FastifyReply, payload: any) => {
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

export default fp(cacheControl);
