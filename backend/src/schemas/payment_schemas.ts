// backend/src/schemas/payment_schemas.ts
// Pattern: JSON Schema validation | Source: ADR-WCF-015 §XIV | ADR-WCF-015 compliance

export const checkoutSchema = {
  body: {
    type: 'object',
    required: ['amount', 'currency'],
    properties: {
      amount: {
        type: 'integer',
        minimum: 50,
        description: 'Payment amount in cents (minimum 50 cents)'
      },
      currency: {
        type: 'string',
        enum: ['usd', 'eur', 'gbp'],
        description: 'Payment currency code'
      }
    },
    additionalProperties: false
  },
  response: {
    200: {
      type: 'object',
      properties: {
        id: { 
          type: 'string',
          description: 'Stripe checkout session ID'
        }
      }
    },
    400: {
      type: 'object',
      properties: {
        error: { type: 'string' },
        message: { type: 'string' }
      }
    },
    500: {
      type: 'object',
      properties: {
        error: { type: 'string' },
        message: { type: 'string' }
      }
    }
  },
  tags: ['payments'],
  summary: 'Create Stripe checkout session',
  description: 'Create a new Stripe checkout session for payment processing'
};

export const webhookSchema = {
  headers: {
    type: 'object',
    required: ['stripe-signature'],
    properties: {
      'stripe-signature': {
        type: 'string',
        description: 'Stripe webhook signature'
      }
    }
  },
  response: {
    200: {
      type: 'object',
      properties: {
        received: { type: 'boolean' }
      }
    },
    400: {
      type: 'object',
      properties: {
        error: { type: 'string' },
        message: { type: 'string' }
      }
    }
  },
  tags: ['payments'],
  summary: 'Process Stripe webhook',
  description: 'Handle Stripe webhook events with signature verification'
}; 