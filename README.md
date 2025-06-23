# WorldChef Monorepo

> One repo – two apps: a Node/Fastify backend and a Flutter mobile client, powered by Supabase & Stripe.

## Directory Overview

| Path | Purpose |
|------|---------|
| `backend/` | Production API server (Fastify) & unit tests |
| `mobile/` | Flutter client (Riverpod) |
| `shared/` | Reusable DTOs, constants, validation schemas |
| `infra/` | Render.com spec, Docker files, GitHub Actions |
| `scripts/` | Seeders, migration helpers, DevOps utilities |
| `docs/` | Living docs (ADRs, architecture, plans) |
| `archive/` | Frozen PoCs / deprecated code |

## Quick-start (local dev)

```bash
# Prereqs: Node 18+, npm 9+, Docker, Flutter 3.16+, Supabase CLI
npm install           # installs root workspaces
cd infra && docker compose up -d db  # start Postgres for Supabase
npm --workspace backend run dev      # run API on :3000
flutter run                          # run mobile
```

## Deployment

The services in this monorepo are configured for deployment to Render. All deployment configuration is managed by the `render.yaml` file in the root of this project.

### Backend Service (`/backend`)

The backend is a Node.js/TypeScript application deployed as a "Web Service" on Render.

**Triggering a Deployment:**

1.  **Commit and Push:** Ensure all your changes are committed and pushed to the `main` branch.
2.  **Run Workflow:** Navigate to the **Actions** tab of the GitHub repository and manually run the **"Staging Deploy"** workflow.

This workflow will:
*   Install dependencies.
*   Run tests.
*   Build the TypeScript code into JavaScript.
*   Trigger a deployment on Render using a secure deploy hook.
*   Perform a health check against the live service.

For detailed information on the deployment configuration and pattern, see the cookbook entry:

*   **[Cookbook: Render Monorepo Backend Deployment Pattern](./docs/cookbook/render_monorepo_backend_deployment_pattern.md)**

## Tests
```bash
npm --workspace backend test
flutter test
```

## Documentation
– Architecture: `docs/architecture.md`
– ADRs: `docs/adr/` 