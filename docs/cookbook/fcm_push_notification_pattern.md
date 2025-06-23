# Cookbook: FCM Push Notifications

**Pattern:** Backend-driven Push via Firebase Admin SDK
**Source:** PoC #4 Spike (`spike/fcm-poc`)
**Validated in:** Cycle 4 (Avg Latency: 181ms, First Request: 857ms)

This is the canonical pattern for sending push notifications from the Fastify backend.

### 1. Backend: Firebase Admin SDK Setup

```typescript
// src/services/push_notification_service.ts
import * as admin from 'firebase-admin';

const serviceAccount = JSON.parse(process.env.FCM_SERVICE_ACCOUNT_KEY!);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
```
### 2. Backend: Sending a Notification (Fastify)
```typescript
// src/routes/notifications.ts
import * as admin from 'firebase-admin';

fastify.post('/v1/notifications/send', async (req, reply) => {
  const { token, title, body } = req.body as any;

  const message = {
    notification: { title, body },
    token: token,
  };

  try {
    const response = await admin.messaging().send(message);
    reply.send({ success: true, messageId: response });
  } catch (error) {
    reply.status(500).send({ success: false, error: error.message });
  }
});
```
### 3. Critical Learning
First Request Latency: The initial call to FCM via the Admin SDK has significant overhead (~800ms) for connection establishment. Subsequent calls are much faster (~180ms). This should be accounted for in any "cold start" serverless environment. 