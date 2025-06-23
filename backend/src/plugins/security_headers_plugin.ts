import { FastifyInstance, FastifyPluginOptions, FastifyReply, FastifyRequest } from 'fastify';
import fp from 'fastify-plugin';

async function securityHeaders(fastify: FastifyInstance, options: FastifyPluginOptions) {
  fastify.addHook('onSend', async (request: FastifyRequest, reply: FastifyReply, payload: any) => {
    reply.header('X-Content-Type-Options', 'nosniff');
    reply.header('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
    reply.header('Cross-Origin-Opener-Policy', 'same-origin');
    reply.header('Cross-Origin-Embedder-Policy', 'require-corp');

    if (!reply.hasHeader('Cache-Control')) {
      reply.header('Cache-Control', 'no-store');
    }

    return payload;
  });
}

export default fp(securityHeaders); 