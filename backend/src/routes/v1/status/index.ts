import { FastifyInstance, FastifyPluginOptions } from 'fastify';

async function statusRoute(fastify: FastifyInstance, options: FastifyPluginOptions) {
  fastify.get('/status', {
    schema: {
      description: 'Health check endpoint to verify the server is running.',
      tags: ['Status'],
      response: {
        200: {
          description: 'Successful response',
          type: 'object',
          properties: {
            status: { type: 'string', example: 'ok' }
          }
        }
      }
    }
  }, async (request, reply) => {
    return reply.code(200).send({ status: 'ok' });
  });
};

export default statusRoute; 