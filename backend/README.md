# WorldChef Backend Service

**Artifact ID:** `worldchef_backend_readme`  
**Version:** 1.0  
**Last Updated:** g153
**Associated Plan:** `cycle4_week1_execution`

## 1. Overview

This directory contains the source code for the primary WorldChef backend API service. It is a [Fastify](https://www.fastify.io/) application responsible for handling business logic, user authentication, and data interaction for the WorldChef mobile client.

Its creation and implementation are governed by the tasks defined in the project's active operational plans. This service was scaffolded as part of task `t001_infrastructure_reality_capture` and is being extended with authentication endpoints under task `t002_implement_authentication` in plan `plan_cycle4_week1_execution`.

## 2. Architectural Context & Design Decisions

The architecture and implementation patterns for this service are derived from several key project documents:

-   **Backend Architecture:** [ADR-WCF-003_ Backend Service Architecture.txt](../../docs/adr/3-ADR-WCF-003_Backend%20Service%20Architecture.txt)
-   **Authentication Strategy:** [ADR-WCF-005_ Authentication & Authorization Strategy.txt](../../docs/adr/5-ADR-WCF-005_%20Authentication%20&%20Authorization%20Strategy.txt)
-   **API Design Principles:** [ADR-WCF-015_ API Design Principles & Versioning.txt](../../docs/adr/14-ADR-WCF-015_%20API%20Design%20Principles%20&%20Versioning.txt)
-   **Implementation Pattern (Auth):** [Cookbook: Supabase Authentication Integration](../../docs/cookbook/supabase_auth_integration_pattern.md)

This service validates user identity via JWTs issued by Supabase, following the pattern specified in the cookbook. It does **not** handle user credential storage directly.

## 3. Operational Environment (Staging)

The status of this service in the live staging environment is tracked by the Infrastructure Reality Capture protocol.

-   **Deployment Status:** NOT YET DEPLOYED (as of g152)
-   **Live Configuration Capture:** [`staging/reality_capture/render_config.json`](../../staging/reality_capture/render_config.json)
-   **Deployment Guide:** [`docs/cycle4/week0/minimal_app_deployment_guide.md`](../../docs/cycle4/week0/minimal_app_deployment_guide.md)

Deployment to Render is the next step after the core authentication endpoints are implemented and tested.

## 4. Technical Details

### Environment Variables

This service requires a `.env.local` file at the **root of the monorepo**. This file is not read-accessible by the AI OS due to permissions but must be present for local execution. Its schema is defined in [`docs/cycle4/week0/staging_env_config.md`](../../docs/cycle4/week0/staging_env_config.md).

**Key Variables:**
- `SUPABASE_URL`: The URL of the Supabase project.
- `SUPABASE_SERVICE_ROLE_KEY`: The service role key for backend-to-database communication.
- `PORT`: The port the server will listen on (defaults to 10000).

### Scripts

From this directory (`/backend`):

-   `npm install`: Installs local dependencies.
-   `npm start`: Runs the server via `node src/server.js`.
-   `npm run dev`: Runs the server (currently identical to `start`).

---
*This document is a managed artifact of the Hybrid_AI_OS.* 