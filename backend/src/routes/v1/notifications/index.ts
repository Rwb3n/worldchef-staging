import { FastifyPluginAsync } from 'fastify';
import deviceTokensRoutes from './device_tokens';
import testNotificationsRoutes from './test_notifications';

const notificationRoutes: FastifyPluginAsync = async (fastify) => {
  fastify.register(deviceTokensRoutes);
  fastify.register(testNotificationsRoutes);

  // GET /v1/notifications - Basic status endpoint (for Swagger coverage)
  fastify.get('/notifications', {
    schema: {
      description: 'Get notifications service status',
      tags: ['notifications'],
      response: {
        200: {
          type: 'object',
          properties: {
            status: { type: 'string' },
            version: { type: 'string' },
          }
        }
      }
    }
  }, async (_request, reply) => {
    return { status: 'ok', version: '1.0.0' };
  });
};

export default notificationRoutes;