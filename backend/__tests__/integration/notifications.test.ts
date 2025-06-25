import { build } from '../../src/server';
import { FastifyInstance } from 'fastify';

describe('FCM Push Notification Integration', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    app = await build({ logger: false });
    await app.ready();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('Device Token Management', () => {
    it('should register device token on POST /v1/users/me/device-tokens', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/users/me/device-tokens',
        headers: {
          'Authorization': 'Bearer fake_jwt_token'
        },
        payload: {
          deviceToken: 'fake_fcm_device_token_123',
          platform: 'android'
        }
      });

      expect(response.statusCode).toBe(201);
      const json = response.json();
      expect(json.success).toBe(true);
      expect(json.message).toBe('Device token registered successfully');
    });

    it('should return 400 for invalid device token format', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/users/me/device-tokens',
        headers: {
          'Authorization': 'Bearer fake_jwt_token'
        },
        payload: {
          deviceToken: '',
          platform: 'android'
        }
      });

      expect(response.statusCode).toBe(400);
      const json = response.json();
      expect(json.error).toBeDefined();
    });

    it('should return 401 for missing authorization header', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/users/me/device-tokens',
        payload: {
          deviceToken: 'fake_fcm_device_token_123',
          platform: 'android'
        }
      });

      expect(response.statusCode).toBe(401);
    });
  });

  describe('Test Notification Sending', () => {
    it('should handle FCM integration correctly based on credential availability', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/notifications/test',
        headers: {
          'Authorization': 'Bearer fake_jwt_token'
        },
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
          // Success case: FCM credentials valid and notification sent
          expect(json.success).toBe(true);
          expect(json.messageId).toBeDefined();
          expect(typeof json.messageId).toBe('string');
        } else {
          // FCM-specific error (e.g., invalid token, quota exceeded)
          expect(response.statusCode).toBe(500);
          expect(json.error).toBeDefined();
          expect(typeof json.error).toBe('string');
          // Should not be a configuration error
          expect(json.error).not.toContain('FCM not configured');
        }
      } else {
        // No FCM credentials - expect configuration error
        expect(response.statusCode).toBe(500);
        expect(json.error).toBe('FCM not configured - missing FCM_SERVICE_ACCOUNT_KEY or FCM_SERVER_KEY environment variable');
      }
    });

    it('should return 400 for missing notification title', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/notifications/test',
        headers: {
          'Authorization': 'Bearer fake_jwt_token'
        },
        payload: {
          body: 'This is a test notification from WorldChef',
          deviceToken: 'fake_fcm_device_token_123'
        }
      });

      expect(response.statusCode).toBe(400);
      const json = response.json();
      expect(json.error).toBeDefined();
    });

    it('should return 400 for missing device token', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/notifications/test',
        headers: {
          'Authorization': 'Bearer fake_jwt_token'
        },
        payload: {
          title: 'Test Notification',
          body: 'This is a test notification from WorldChef'
        }
      });

      expect(response.statusCode).toBe(400);
      const json = response.json();
      expect(json.error).toBeDefined();
    });

    it('should return 401 for missing authorization header', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/notifications/test',
        payload: {
          title: 'Test Notification',
          body: 'This is a test notification from WorldChef',
          deviceToken: 'fake_fcm_device_token_123'
        }
      });

      expect(response.statusCode).toBe(401);
    });
  });
}); 