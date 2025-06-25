import { FastifyInstance, FastifyPluginOptions } from 'fastify';
import Stripe from 'stripe';
import { checkoutSchema, webhookSchema } from '../../../schemas/payment_schemas';

async function paymentsRoutes(fastify: FastifyInstance, options: FastifyPluginOptions) {
  // Initialize Stripe with environment variable (loaded at runtime)
  const stripeKey = process.env.STRIPE_SECRET_KEY;
  if (!stripeKey) {
    throw new Error('STRIPE_SECRET_KEY environment variable is required');
  }
  fastify.log.info(`Initializing Stripe with key length: ${stripeKey.length}`);
  const stripe = new Stripe(stripeKey);

  // Minimal test route without any dependencies
  fastify.get('/payments/test', async (request, reply) => {
    return { message: 'Payment routes working', stripeInitialized: !!stripe };
  });

  // POST /v1/payments/checkout
  fastify.post('/payments/checkout', { schema: checkoutSchema }, async (request, reply) => {
    try {
      const { amount, currency } = request.body as { amount: number; currency: string };
      
      const session = await stripe.checkout.sessions.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency,
            product_data: {
              name: 'WorldChef Recipe Access',
            },
            unit_amount: amount,
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: 'https://worldchef.app/success?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: 'https://worldchef.app/cancel',
      });

      return { id: session.id };
    } catch (error: any) {
      fastify.log.error('Stripe checkout session creation failed:', error);
      reply.status(500).send({ 
        error: 'Internal server error',
        message: 'Failed to create checkout session'
      });
    }
  });

  // POST /v1/payments/webhooks - Simplified without signature verification for now
  fastify.post('/payments/webhooks', { schema: webhookSchema }, async (request, reply) => {
    try {
      // For now, just log the webhook and return success
      // TODO: Add signature verification once basic route works
      fastify.log.info('Webhook received:', request.body);
      reply.status(200).send({ received: true });
    } catch (error: any) {
      fastify.log.error('Webhook processing failed:', error);
      reply.status(500).send({ 
        error: 'Internal server error',
        message: 'Failed to process webhook'
      });
    }
  });

  // GET /v1/payments - Service status
  fastify.get('/payments', {
    schema: {
      description: 'Payments service status',
      tags: ['payments'],
      response: {
        200: {
          type: 'object',
          properties: {
            status: { type: 'string' },
            stripeInitialized: { type: 'boolean' }
          }
        }
      }
    }
  }, async (_request, reply) => {
    return { status: 'ok', stripeInitialized: !!stripe };
  });
}

export default paymentsRoutes; 