# Fastify Spike Scaffold Log (g80)

- Created `spike/fastify-validation/` directory.
- Added `index.js` Fastify server with `/ping` and `/echo` routes.
- Added `package.json` with Fastify and pino-pretty deps.
- Added `loadtest.js` k6 script (100 VU × 60 s hitting `/ping`).

Next steps:
1. Run `npm install` inside the directory.
2. Verify `npm run dev` serves endpoints.
3. Execute `npm run test:load` and store `k6_summary.json`. 