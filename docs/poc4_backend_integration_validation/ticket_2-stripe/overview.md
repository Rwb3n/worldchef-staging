🎫 Ticket 2: stripe-checkout-webhook-poc
Title: Stripe Checkout Session + Webhook Flow POC

Goal:
Ensure payment integration and webhook validation are feasible and low-latency.

Tasks:
Create test product + price in Stripe dashboard
Implement POST /payments/checkout to create session
Stub POST /webhooks/stripe endpoint to receive and log webhook
Use Stripe CLI to trigger test webhook
Validate webhook signature using Stripe secret

Acceptance Criteria:
Test checkout session renders in browser
Webhook event captured and verified
Signature logs: ✅ verified, ⛔ fail cases flagged
No unhandled exceptions in logs

Output:
Code in spike/stripe-poc
Screenshot of checkout
Webhook logs saved
Status: “Webhooks Secure / Needs More Work”