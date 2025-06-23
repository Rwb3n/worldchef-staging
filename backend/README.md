# WorldChef Backend Service (`/backend`)

> Artifact: `worldchef_backend_readme` | g<g-ref> | 2025-07-19

This directory contains the production backend API server for the WorldChef project. It is a [Fastify](https://www.fastify.io/) application written in TypeScript.

## Core Responsibilities

*   Provides the primary `/v1` API for the mobile client.
*   Handles user authentication and authorization via Supabase.
*   Manages core business logic for recipes, users, and interactions.
*   Integrates with third-party services like Stripe for payments and FCM for push notifications.

## Key Architectural Decisions

The architecture of this service is governed by several key ADRs:

*   **[ADR-WCF-003: Backend Service Architecture](./docs/adr/3-ADR-WCF-003_%20Backend%20Service%20Architecture.txt)**: Chose Fastify for its performance and low overhead.
*   **[ADR-WCF-005: Authentication & Authorization Strategy](./docs/adr/5-ADR-WCF-005_%20Authentication%20&%20Authorization%20Strategy.txt)**: Selected Supabase Auth for its robust, secure, and scalable JWT-based system.
*   **[ADR-WCF-015: API Design Principles & Versioning](./docs/adr/14-ADR-WCF-015_%20API%20Design%20Principles%20&%20Versioning.txt)**: Established RESTful design principles and a `/v1` versioning scheme.

## Getting Started

### Prerequisites

*   Node.js (>=18.0.0)
*   `npm` (for dependency management)
*   A running Supabase instance (for development)
*   A valid `.env.local` file with Supabase credentials.

### Installation

From the `/backend` directory, install the dependencies:

```bash
npm install
```

### Running in Development

To run the server in development mode with hot-reloading:

```bash
npm run start
```

The server will be available at `http://localhost:3000`.

### Running Tests

Unit and integration tests are run using Jest.

```bash
npm run test
```

## Production Build & Deployment

This service is configured for deployment to Render.

### Build

To create a production-ready build (compiling TypeScript to JavaScript in `/dist`), run:

```bash
npm run build
```

### Deployment

Deployments to the staging environment are handled automatically via the **"Staging Deploy"** GitHub Actions workflow, which is triggered by pushing to the `main` branch.

The deployment configuration is managed by the root-level `render.yaml` file. For a detailed explanation of the deployment strategy, refer to the cookbook pattern:

*   **[Cookbook: Render Monorepo Backend Deployment Pattern](./docs/cookbook/render_monorepo_backend_deployment_pattern.md)**

---
*This document is a managed artifact of the Hybrid_AI_OS.* 