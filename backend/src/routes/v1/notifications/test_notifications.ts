import { FastifyPluginAsync } from 'fastify';
import * as admin from 'firebase-admin';
import { initializeFirebaseAdmin } from '@utils/firebase_admin';

const firebaseInitialized = initializeFirebaseAdmin();

const testNotificationSchema = {
  type: 'object',
  required: ['title', 'body', 'deviceToken'],
  properties: {
    title: { type: 'string', minLength: 1 },
    body: { type: 'string', minLength: 1 },
    deviceToken: { type: 'string', minLength: 1 }
  }
} as const;

const testNotificationResponseSchema = {
  type: 'object',
  properties: {
    success: { type: 'boolean' },
    messageId: { type: 'string' }
  }
} as const;

const errorResponseSchema = {
  type: 'object',
  properties: {
    error: { type: 'string' }
  }
} as const;

const testNotificationsRoutes: FastifyPluginAsync = async (fastify) => {
  // POST /v1/notifications/test - Send test notification
  fastify.post('/notifications/test', {
    schema: {
      body: testNotificationSchema,
      response: {
        200: testNotificationResponseSchema,
        400: errorResponseSchema,
        401: errorResponseSchema
      }
    }
  }, async (request, reply) => {
    const { title, body, deviceToken } = request.body as { title: string; body: string; deviceToken: string };

    if (!title || title.trim() === '') {
      reply.code(400).send({ error: 'Notification title is required' });
      return;
    }

    if (!body || body.trim() === '') {
      reply.code(400).send({ error: 'Notification body is required' });
      return;
    }

    if (!deviceToken || deviceToken.trim() === '') {
      reply.code(400).send({ error: 'Device token is required' });
      return;
    }

    try {
      if (!firebaseInitialized) {
        reply.code(500).send({
          error: 'FCM not configured - missing FCM_SERVICE_ACCOUNT_KEY or FCM_SERVER_KEY environment variable'
        });
        return;
      }

      // Use real Firebase Admin SDK
      const message = {
        notification: {
          title: title,
          body: body
        },
        token: deviceToken
      };

      const messageId = await admin.messaging().send(message);
      
      reply.code(200).send({
        success: true,
        messageId: messageId
      });
    } catch (error) {
      fastify.log.error('FCM send error:', error);
      
      // Provide specific error messages for common FCM issues
      let errorMessage = 'Failed to send notification';
      if (error instanceof Error) {
        if (error.message.includes('invalid-registration-token')) {
          errorMessage = 'Invalid device token';
        } else if (error.message.includes('authentication-error')) {
          errorMessage = 'FCM authentication failed - check credentials';
        } else if (error.message.includes('quota-exceeded')) {
          errorMessage = 'FCM quota exceeded';
        } else {
          errorMessage = `FCM error: ${error.message}`;
        }
      }
      
      reply.code(500).send({ error: errorMessage });
    }
  });
};

export default testNotificationsRoutes;
