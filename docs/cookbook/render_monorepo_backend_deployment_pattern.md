# Render Monorepo Backend Deployment Pattern

> Artifact: render_monorepo_backend_deployment_pattern | g<g-ref> | 2025-07-19

## 1. Context

This document describes the standard pattern for deploying a Node.js/TypeScript backend service from a monorepo workspace to Render. This pattern uses a root-level `render.yaml` file to define the service, its build process, and its environment, ensuring a reliable and repeatable deployment pipeline.

This pattern was established during Cycle 4, Week 1, while implementing the authentication service in the `backend` workspace.

## 2. Problem

Deploying a service from a monorepo requires specific configuration to ensure the deployment platform (Render) targets the correct directory, runs the appropriate build steps, and starts the application correctly. A standard Node.js deployment assumes the application is in the root, which is not the case here. We need a way to:

*   Specify the service's root directory within the monorepo (e.g., `/backend`).
*   Handle TypeScript compilation as part of the build process.
*   Run the compiled JavaScript in production, not the TypeScript source with a development tool like `ts-node`.
*   Manage environment variables and secrets securely.

## 3. Solution

The solution involves a combination of scripts in `package.json` and a well-defined `render.yaml` file at the project root.

### 3.1. `package.json` Scripts

The service's `package.json` (e.g., `backend/package.json`) must contain dedicated scripts for building and starting the application in a production environment.

```json
{
  "scripts": {
    "test": "jest",
    "start": "ts-node src/server.ts",
    "build": "tsc",
    "start:prod": "node dist/server.js"
  }
}
```

*   **`build`**: This script invokes the TypeScript compiler (`tsc`), which compiles the source code from `src/` into JavaScript output in the `dist/` directory (as configured in `tsconfig.json`).
*   **`start:prod`**: This script runs the compiled application entry point (`dist/server.js`) using Node.js. This is the command Render will use to run the live service.

### 3.2. Root `render.yaml` Configuration

A single `render.yaml` file at the monorepo root defines all services. For our backend service, the configuration is as follows:

```yaml
services:
  - type: web
    name: worldchef-backend
    rootDir: backend
    plan: starter
    runtime: node
    buildCommand: "npm install && npm run build"
    startCommand: "npm run start:prod"
    envVars:
      - key: NODE_ENV
        value: production
      - key: SUPABASE_URL
        value: https://myqhpmeprpaukgagktbn.supabase.co
      - fromGroup: worldchef-staging-secrets
    autoDeploy: false
```

#### Key Configuration Fields:

*   **`type: web`**: Defines the service as a web service.
*   **`name`**: A unique name for the service on Render.
*   **`rootDir: backend`**: This is the crucial field for monorepos. It tells Render to execute all commands from within the `/backend` directory.
*   **`runtime: node`**: Specifies the native Node.js runtime environment.
*   **`buildCommand: "npm install && npm run build"`**: Defines the sequence for building the service. It first installs dependencies and then runs our `build` script (`tsc`).
*   **`startCommand: "npm run start:prod"`**: The command to run the service in production. This executes our newly defined `start:prod` script.
*   **`envVars`**:
    *   Hardcoded values like `NODE_ENV` and `SUPABASE_URL` can be set directly.
    *   **`fromGroup: worldchef-staging-secrets`**: This is the secure way to manage secrets. It instructs Render to inject all variables from a secret group named `worldchef-staging-secrets` into the service's environment. This avoids hardcoding sensitive keys like `SUPABASE_SERVICE_ROLE_KEY`.
*   **`autoDeploy: false`**: This is set to `false` to prevent automatic deployments on every push to `main`. Deployments are managed manually via the "Staging Deploy" GitHub Actions workflow.

## 4. Implementation

1.  **Add Scripts**: Ensure the `build` and `start:prod` scripts exist in the relevant `package.json`.
2.  **Create `render.yaml`**: Place the `render.yaml` file in the project's root directory.
3.  **Configure Secrets**: Create a "Secret Group" in the Render dashboard (e.g., `worldchef-staging-secrets`) and add all necessary secret environment variables.
4.  **Deploy**: Deployments are triggered by the [Staging Deploy Workflow](../.github/workflows/staging-deploy.yml), which uses a deploy hook.

This pattern provides a robust, secure, and clear method for deploying services from our monorepo to Render. 