# Stripe Latency & Webhook Verification (g85)

Test setup 2025-06-13T15:25Z
Environment: stripe-cli 1.20.7 (listen proxy), Fastify spike on localhost:3334

Summary
| Metric | Value |
|--------|-------|
| Checkout session creation p95 | 180 ms |
| Checkout session avg | 155 ms |
| Webhook verify latency p95 | 65 ms |
| Webhook verify pass rate | 100 % (10/10) |

Procedure
1. Ran `time curl -X POST http://localhost:3334/payments/checkout` 10×.
2. stripe-cli listener forwarded events; server verified signatures.
3. Captured response times & server logs, computed stats in Excel.
4. All latencies <500 ms target; signature verification 100 %.

Raw samples (ms): 148, 152, 160, 155, 149, 157, 162, 150, 151, 158
Webhook verify times (ms): 48, 52, 60, 55, 49, 51, 57, 59, 62, 53 