# PoC #4 – Backend Integration Validation

This README provides a concise working guide for engineers executing PoC #4. For full context, read `overview.md` in the same folder.

---

## 0. TL;DR Checklist

| Spike | Branch | Quick Start | Success Flag |
|-------|--------|------------|--------------|
| Fastify | `spike/fastify-validation` | `npm i && npm run dev` then `k6 run loadtest.js` | `✅ fastify_validated.txt` |
| Stripe  | `spike/stripe-poc` | `stripe listen --forward-to localhost:3333/webhooks/stripe` | `✅ stripe_validated.txt` |
| FCM     | `spike/fcm-poc`    | Run Flutter app on device, press *Send Test* | `✅ fcm_validated.txt` |

Place the success flag file in the repo root of each branch when metrics meet targets.

---

## 1. Environment Variables

All spikes load secrets from **`.env.local`** (never committed).  
Critical names are tracked in `aiconfig.json > environment`.

```
SUPABASE_URL=<url>
SUPABASE_ANON_KEY=<key>
SUPABASE_SERVICE_ROLE_KEY=<key>
DATABASE_URL=postgres://user:pass@host/db
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
FCM_SERVER_KEY=AAAA...:AAAA...
```

*Add new vars by updating both `.env.local` and `aiconfig.json`.*

---

## 2. Spike Workflows

### 2.1 Fastify Performance
1. `pnpm create fastify spike/fastify-validation` (or scaffold manually)  
2. Implement `/ping` and `/echo` routes with JSON schema validation.  
3. Add `pino-pretty` logger & request-id middleware.  
4. Write `loadtest.js` (k6) – 100 VU for 60 s.  
5. Run benchmark → store `k6_summary.json` + hash.

### 2.2 Stripe Checkout + Webhook
1. Ensure sandbox product/price exists – record IDs in `stripe_config.json`.  
2. Endpoint `/payments/checkout` returns `url` from `stripe.checkout.sessions.create`.  
3. Endpoint `/webhooks/stripe` verifies signature via `stripe.webhooks.constructEvent`.  
4. Use Stripe CLI `trigger payment_intent.succeeded` to simulate.  
5. Capture latency & signature verify logs.

### 2.3 FCM Push Delivery
1. Create bare-bones Flutter project under `spike/fcm-poc`.  
2. Register device token with backend `/device-token`.  
3. Send test push via POST `/push/test?token=...`.  
4. Record server send timestamp + device receipt timestamp.  
5. Repeat 10× – success rate must be 100 %, avg latency ≤3 s.

---

## 3. Success Metrics (Red-Line)

| Metric | Target |
|--------|--------|
| Fastify p95 @100 VU | **≤200 ms** |
| Fastify boot | **≤500 ms** |
| Stripe webhook latency | **≤500 ms** |
| Stripe signature verify | **100 %** pass |
| FCM delivery time | **≤3 s** |
| FCM reliability | **100 %** (10/10) |

---

## 4. Evidence & Hashing

After each run, hash evidence files:
```bash
sha256sum k6_summary.json >> evidence_index.json
```
The hash list is committed with the evidence file for tamper proofing.

---

## 5. Reporting

At Day 10, create `validation_report.md` summarising:
- Metrics vs targets (table)  
- Screenshots / logs links  
- Verdict per spike (VALIDATED / RECONSIDER)  
- Follow-up actions (if any)

---

## 6. Ownership

| Spike | DRI | Reviewer |
|-------|-----|----------|
| Fastify | Backend Lead | Chief Architect |
| Stripe  | Payments Lead | CFO Stakeholder |
| FCM     | Mobile Lead | QA Lead |

---
Ready… **Spike hard & measure everything!** 