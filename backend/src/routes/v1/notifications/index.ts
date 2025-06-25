import { FastifyPluginAsync } from 'fastify';
import * as admin from 'firebase-admin';

// Initialize Firebase Admin SDK (only once) with real credentials
let firebaseInitialized = false;
try {
  if (!admin.apps.length) {
    if (process.env.FCM_SERVICE_ACCOUNT_KEY) {
      // Production: Use service account JSON key
      const serviceAccount = JSON.parse(process.env.FCM_SERVICE_ACCOUNT_KEY);
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
      firebaseInitialized = true;
      console.log('Firebase Admin SDK initialized with service account credentials');
    } else if (process.env.FCM_SERVER_KEY) {
      // Alternative: Use server key (legacy method)
      // Note: This is a fallback for testing, service account is preferred
      admin.initializeApp({
        credential: admin.credential.applicationDefault(),
        projectId: process.env.FIREBASE_PROJECT_ID || 'worldchef-staging'
      });
      firebaseInitialized = true;
      console.log('Firebase Admin SDK initialized with application default credentials');
    } else {
      console.warn('No FCM credentials found - notifications will fail');
      firebaseInitialized = false;
    }
  }
} catch (error) {
  console.error('Firebase Admin SDK initialization failed:', error);
  firebaseInitialized = false;
}

// JSON Schemas for request/response validation
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

const notificationRoutes: FastifyPluginAsync = async (fastify) => {
  // Middleware to check authorization
  fastify.addHook('preHandler', async (request, reply) => {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      reply.code(401).send({ error: 'Authorization header required' });
      return;
    }
    // In a real app, we would validate the JWT token here
    // For testing, we just check that the header is present
  });

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