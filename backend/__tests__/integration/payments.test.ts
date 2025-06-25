import request from 'supertest';
import { FastifyInstance } from 'fastify';
// Real integration test: use actual Stripe SDK and test keys
import { build } from '../../src/server';

describe('Stripe Payment Integration (Real API)', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    app = await build({ logger: false });
  });

  afterAll(async () => {
    await app.close();
  });

  it('should create a real Stripe checkout session on POST /v1/payments/checkout', async () => {
    const response = await request(app.server)
      .post('/v1/payments/checkout')
      .send({ amount: 1000, currency: 'usd' });

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('id');
    expect(typeof response.body.id).toBe('string');
    expect(response.body.id).toMatch(/^cs_test_/); // Stripe test session id
  });

  it('should return 400 for invalid webhook signature on POST /v1/payments/webhooks', async () => {
    const response = await request(app.server)
      .post('/v1/payments/webhooks')
      .set('stripe-signature', 'invalid_signature')
      .send({ id: 'evt_test_123', type: 'checkout.session.completed' });

    expect(response.status).toBe(400);
    expect(response.body).toHaveProperty('error');
  });
}); 