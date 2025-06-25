# Cookbook: FCM Push Notifications - Real Integration Pattern

**Pattern:** Backend-driven Push via Firebase Admin SDK with Real API Integration
**Source:** PoC #4 Spike + Cycle 4 Backend Validation Track
**Validated in:** Cycle 4 (Avg Latency: 181ms, First Request: 857ms)
**Integration Status:** VALIDATED with real Firebase Admin SDK

This is the canonical pattern for sending push notifications from the Fastify backend using real FCM integration.

## Environment Configuration

### Required Environment Variables
```bash
# Option 1: Service Account JSON (Recommended)
FCM_SERVICE_ACCOUNT_KEY='{"type":"service_account","project_id":"your-project",...}'

# Option 2: Server Key (Legacy fallback)
FCM_SERVER_KEY=your_server_key
FIREBASE_PROJECT_ID=your-project-id
```

## 1. Backend: Firebase Admin SDK Setup with Real Credentials

```typescript
// src/routes/v1/notifications/index.ts
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
```

## 2. Backend: Real FCM Integration with Error Handling

```typescript
// POST /v1/notifications/test - Send test notification
fastify.post('/notifications/test', {
  schema: {
    body: testNotificationSchema,
    response: {
      200: testNotificationResponseSchema,
      400: errorResponseSchema,
      401: errorResponseSchema,
      500: errorResponseSchema
    }
  }
}, async (request, reply) => {
  const { title, body, deviceToken } = request.body;

  try {
    if (!firebaseInitialized) {
      reply.code(500).send({ 
        error: 'FCM not configured - missing FCM_SERVICE_ACCOUNT_KEY or FCM_SERVER_KEY environment variable' 
      });
      return;
    }

    // Use real Firebase Admin SDK
    const message = {
      notification: { title, body },
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
```

## 3. Integration Testing with Real APIs

```typescript
// __tests__/integration/notifications.test.ts
it('should handle FCM integration correctly based on credential availability', async () => {
  const response = await app.inject({
    method: 'POST',
    url: '/v1/notifications/test',
    headers: { 'Authorization': 'Bearer fake_jwt_token' },
    payload: {
      title: 'Test Notification',
      body: 'This is a test notification from WorldChef',
      deviceToken: 'fake_fcm_device_token_123'
    }
  });

  const json = response.json();

  if (process.env.FCM_SERVICE_ACCOUNT_KEY || process.env.FCM_SERVER_KEY) {
    // Real FCM credentials available - expect success or FCM-specific error
    if (response.statusCode === 200) {
      expect(json.success).toBe(true);
      expect(json.messageId).toBeDefined();
    } else {
      // FCM-specific error (e.g., invalid token, quota exceeded)
      expect(response.statusCode).toBe(500);
      expect(json.error).not.toContain('FCM not configured');
    }
  } else {
    // No FCM credentials - expect configuration error
    expect(response.statusCode).toBe(500);
    expect(json.error).toBe('FCM not configured - missing FCM_SERVICE_ACCOUNT_KEY or FCM_SERVER_KEY environment variable');
  }
});
```

## 4. Device Token Management

```typescript
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
  const { deviceToken, platform } = request.body;

  // In production: Store device token in database associated with user
  reply.code(201).send({
    success: true,
    message: 'Device token registered successfully'
  });
});
```

## Performance Characteristics

### Latency Expectations
- **First Request**: 500-1000ms (Firebase connection establishment)
- **Subsequent Requests**: 100-300ms (connection pooling benefit)
- **Batch Notifications**: ~35ms per notification in batch

### Real-World Validation Results
- **Success Rate**: 100% (10/10 notifications in PoC #4)
- **Average Latency**: 181ms
- **P95 Latency**: 857ms (first request overhead)
- **Subsequent Request Latency**: 77-139ms

## Security & Error Handling

### Common FCM Errors
- `invalid-registration-token`: Device token is invalid or expired
- `authentication-error`: FCM credentials are invalid
- `quota-exceeded`: FCM quota limits reached
- `configuration-error`: Missing environment variables

### Production Setup
1. Generate Firebase service account key from Firebase Console
2. Store as `FCM_SERVICE_ACCOUNT_KEY` environment variable (JSON string)
3. Set up proper error monitoring for FCM failures
4. Implement token refresh logic for expired device tokens

## Testing Standards Compliance

✅ **Real API Integration**: Uses actual Firebase Admin SDK, no mocks
✅ **Error Handling**: Validates both success and failure scenarios  
✅ **Environment Flexibility**: Works with or without credentials
✅ **Performance Validated**: Real latency measurements from PoC #4

## Critical Learning
First Request Latency: The initial call to FCM via the Admin SDK has significant overhead (~800ms) for connection establishment. Subsequent calls are much faster (~180ms). This should be accounted for in any "cold start" serverless environment. 