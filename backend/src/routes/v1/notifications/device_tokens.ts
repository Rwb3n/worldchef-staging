import { FastifyPluginAsync } from 'fastify';

const deviceTokenSchema = {
  type: 'object',
  required: ['deviceToken', 'platform'],
  properties: {
    deviceToken: { type: 'string', minLength: 1 },
    platform: { type: 'string', enum: ['android', 'ios'] }
  }
} as const;

const deviceTokenResponseSchema = {
  type: 'object',
  properties: {
    success: { type: 'boolean' },
    message: { type: 'string' }
  }
} as const;

const errorResponseSchema = {
  type: 'object',
  properties: {
    error: { type: 'string' }
  }
} as const;

const deviceTokensRoutes: FastifyPluginAsync = async (fastify) => {
  // POST /v1/users/me/device-tokens - Register device token
  fastify.post('/users/me/device-tokens', {
    schema: {
      body: deviceTokenSchema,
      response: {
        201: deviceTokenResponseSchema,
        400: errorResponseSchema,
        401: errorResponseSchema
      }
    }
  }, async (request, reply) => {
    const { deviceToken, platform } = request.body as { deviceToken: string; platform: string };

    if (!deviceToken || deviceToken.trim() === '') {
      reply.code(400).send({ error: 'Device token cannot be empty' });
      return;
    }

    // In a real app, we would:
    // 1. Get user ID from JWT token
    // 2. Store device token in database associated with user
    // 3. Handle token updates/duplicates
    
    // For testing, we just validate the input and return success
    reply.code(201).send({
      success: true,
      message: 'Device token registered successfully'
    });
  });
};

export default deviceTokensRoutes;
