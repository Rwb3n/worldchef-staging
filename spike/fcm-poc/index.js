// Load .env.local from root directory
require('dotenv').config({ path: require('path').resolve(__dirname, '..', '..', '.env.local') });

const fastify = require('fastify')({ logger: true });
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
const serviceAccount = require('./worldchef-3fd9e-firebase-adminsdk-fbsvc-2aa90b8a25.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: process.env.FIREBASE_PROJECT_ID || 'worldchef-3fd9e'
});

// Health check endpoint
fastify.get('/ping', async (request, reply) => {
  return { status: 'ok', timestamp: new Date().toISOString() };
});

// Send single push notification
fastify.post('/push/send', async (request, reply) => {
  const { token, title, body, data } = request.body;
  
  if (!token) {
    return reply.code(400).send({ error: 'FCM token is required' });
  }

  const message = {
    notification: {
      title: title || 'Test Notification',
      body: body || 'This is a test push notification from WorldChef'
    },
    data: data || {
      test: 'true',
      timestamp: Date.now().toString()
    },
    token: token
  };

  try {
    const startTime = Date.now();
    const response = await admin.messaging().send(message);
    const latency = Date.now() - startTime;
    
    fastify.log.info({ response, latency }, 'FCM message sent successfully');
    
    return {
      success: true,
      messageId: response,
      latency_ms: latency,
      timestamp: new Date().toISOString()
    };
  } catch (error) {
    fastify.log.error({ error }, 'FCM send failed');
    return reply.code(500).send({
      success: false,
      error: error.message,
      code: error.code
    });
  }
});

// Send batch push notifications
fastify.post('/push/batch', async (request, reply) => {
  const { tokens, title, body, data } = request.body;
  
  if (!tokens || !Array.isArray(tokens) || tokens.length === 0) {
    return reply.code(400).send({ error: 'Array of FCM tokens is required' });
  }

  const message = {
    notification: {
      title: title || 'Batch Test Notification',
      body: body || 'This is a batch test push notification from WorldChef'
    },
    data: data || {
      test: 'true',
      batch: 'true',
      timestamp: Date.now().toString()
    },
    tokens: tokens
  };

  try {
    const startTime = Date.now();
    const response = await admin.messaging().sendEachForMulticast(message);
    const latency = Date.now() - startTime;
    
    fastify.log.info({ 
      successCount: response.successCount,
      failureCount: response.failureCount,
      latency 
    }, 'FCM batch sent');
    
    return {
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount,
      responses: response.responses.map((resp, idx) => ({
        token: tokens[idx],
        success: resp.success,
        messageId: resp.messageId,
        error: resp.error?.message
      })),
      latency_ms: latency,
      timestamp: new Date().toISOString()
    };
  } catch (error) {
    fastify.log.error({ error }, 'FCM batch send failed');
    return reply.code(500).send({
      success: false,
      error: error.message,
      code: error.code
    });
  }
});

const start = async () => {
  try {
    await fastify.listen({ port: process.env.FCM_PORT || 3335, host: '0.0.0.0' });
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start(); 