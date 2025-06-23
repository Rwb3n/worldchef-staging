# Stripe Spike Setup Log (g83)

- Created `spike/stripe-poc/` with Fastify server (`index.js`).
- Added `package.json` with Fastify + Stripe SDK.
- Environment variables needed:
  - `STRIPE_SECRET_KEY`
  - `STRIPE_WEBHOOK_SECRET`
  - `PRODUCT_PRICE_ID`
- Endpoints:
  - `POST /payments/checkout` → returns checkout `url`.
  - `POST /webhooks/stripe` → verifies signature.
- Next steps:
  1. `npm install` inside `spike/stripe-poc`.
  2. Use Stripe dashboard or CLI to create test Product & Price; set `PRODUCT_PRICE_ID`.
  3. Run `stripe listen --forward-to localhost:3334/webhooks/stripe` to capture webhooks during tests.
- Added `latency_test.js` k6 script (20 iterations) for automated latency capture. 