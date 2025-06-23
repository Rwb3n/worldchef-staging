# Cookbook: Stripe Payments with Hosted Checkout

**Pattern:** Stripe Hosted Checkout & Webhook Validation
**Source:** PoC #4 Spike (`spike/stripe-poc`)
**Validated in:** Cycle 4 (p95 latency: 180ms session creation, 65ms webhook verify)

This is the canonical pattern for handling one-time payments and subscriptions.

### 1. Backend: Creating the Checkout Session (Fastify)

```typescript
// src/routes/payments.ts
import Stripe from 'stripe';
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

fastify.post('/v1/payments/checkout', async (req, reply) => {
  const { priceId, customerId } = req.body as any;

  const session = await stripe.checkout.sessions.create({
    payment_method_types: ['card'],
    mode: 'subscription', // or 'payment' for one-time
    customer: customerId, // Optional: for existing customers
    line_items: [{ price: priceId, quantity: 1 }],
    success_url: 'https://app.worldchef.com/payment-success',
    cancel_url: 'https://app.worldchef.com/payment-cancelled',
  });

  reply.send({ url: session.url });
});
```

### 2. Backend: Verifying Webhook Signatures (Fastify)

```typescript
// src/routes/webhooks.ts

// Use `rawBody` parser for Stripe signature verification
fastify.post('/v1/webhooks/stripe', { config: { rawBody: true } }, async (req, reply) => {
  const sig = req.headers['stripe-signature'] as string;
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET!;

  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(req.rawBody!, sig, webhookSecret);
  } catch (err: any) {
    return reply.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle the event
  switch (event.type) {
    case 'checkout.session.completed':
      // Grant subscription access to the user
      console.log('Payment was successful!');
      break;
    // ... handle other event types
  }

  reply.send({ received: true });
});
``` 