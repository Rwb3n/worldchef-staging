// Load .env.local from root directory
require('dotenv').config({ path: require('path').resolve(__dirname, '..', '..', '.env.local') });

const fastify = require('fastify')({ logger: true });

// Register content type parsers
fastify.addContentTypeParser('application/json', { parseAs: 'string' }, fastify.getDefaultJsonParser('ignore', 'ignore'));
fastify.addContentTypeParser('application/x-www-form-urlencoded', { parseAs: 'string' }, (req, body, done) => {
  done(null, body);
});

const stripe  = require('stripe')(process.env.STRIPE_SECRET_KEY);

const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET || 'whsec_placeholder';

fastify.post('/payments/checkout', async (request, reply) => {
  const session = await stripe.checkout.sessions.create({
    mode: 'subscription',
    payment_method_types: ['card'],
    line_items: [{ price: process.env.PRODUCT_PRICE_ID || 'price_placeholder', quantity: 1 }],
    success_url: 'https://example.com/success',
    cancel_url: 'https://example.com/cancel'
  });
  return { url: session.url };
});

fastify.post('/webhooks/stripe', async (request, reply) => {
  const sig = request.headers['stripe-signature'];
  let event;
  try {
    event = stripe.webhooks.constructEvent(request.rawBody, sig, endpointSecret);
  } catch (err) {
    reply.code(400).send(`Webhook Error: ${err.message}`);
    return;
  }
  fastify.log.info({ event }, 'stripe webhook received');
  reply.code(200).send({ received: true });
});

const start = async () => {
  try {
    await fastify.listen({ port: process.env.PORT || 3334, host: '0.0.0.0' });
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};
start(); 