🎫 Ticket 1: fastify-validation-spike
Title: Validate Fastify Baseline Performance and DX

Goal:
Confirm Fastify can meet performance, routing, and schema validation requirements under load.

Tasks:
Scaffold Fastify server with one GET /ping and one POST /echo route
Apply JSON schema validation using fastify-schema or zod
Add middleware for request logging, JWT parsing stub
Write k6 test: 100 virtual users, 60s duration
Record latency: p95 ≤ 200 ms

Acceptance Criteria:
Fastify server boots under 500 ms
POST /echo route rejects malformed body
k6 report shows p95 < 200 ms
Dev logs confirm schema validation working

Output:
Repo branch spike/fastify-validation
k6 summary JSON
Decision: “Adopt / Reconsider” written in Validation Checklist

