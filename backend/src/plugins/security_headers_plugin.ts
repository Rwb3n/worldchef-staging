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

    return payload;
  });
}

export default fp(securityHeaders); 