# Staging Environment Setup Guide
## Cycle 4 Week 0 - Render + Supabase Implementation

**Document Version:** 2.0  
**Created:** 2025-06-13T16:00:00Z  
**Updated:** 2025-01-31T16:00:00Z  
**Global Event:** g135  
**Architecture Status:** VALIDATED (per ADR Checkpoint 2)

## Overview

This guide provides step-by-step instructions for setting up the WorldChef staging environment using **Render** for hosting and **Supabase** for backend services. This reflects the validated architecture from ADR Checkpoint 2 and supports the Week 0-1 validation track per the Cycle 4 scope document.

## Prerequisites

### Required Tools and Access

- **Render Account** with service creation permissions (Free tier available)
- **Supabase Account** with project creation permissions (Free tier available)
- **GitHub Repository** with WorldChef codebase and Actions enabled
- **Node.js 18+** and **npm** for local development and testing
- **PostgreSQL client** (psql) for database operations (optional)
- **k6** for load testing (Week 1 validation requirement)

### Required Environment Variables (Week 0 Focus)

```bash
# Application Configuration
NODE_ENV=staging
PORT=3000

# Supabase Configuration (VALIDATED)
SUPABASE_URL=https://your-staging-project.supabase.co
SUPABASE_ANON_KEY=eyJ...staging-anon-key
SUPABASE_SERVICE_ROLE_KEY=eyJ...staging-service-key

# Nutrition Enrichment (VALIDATED for cr_t004)
USDA_API_KEY=NomPDEcHKIOOAKMd1bjRfOBTTeuNjSA8FogNkI7d
# NOTE: This key must be set in THREE places:
# 1. Render Environment: For the main API service.
# 2. Supabase Secrets: For the nutrition_enrichment edge function.
# 3. Local Development: In your .env.local file.

# Week 1 Validation Track (to be added)
STRIPE_SECRET_KEY=sk_test_...staging-stripe-key
STRIPE_WEBHOOK_SECRET=whsec_...staging-webhook-secret
FCM_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
FCM_PROJECT_ID=worldchef-staging
FCM_CLIENT_EMAIL=firebase-adminsdk-...@worldchef-staging.iam.gserviceaccount.com

# Optional for Week 0
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
```

## Phase 1: Render Service Setup

### Step 1.1: Create Render Services

1. **Create API Service**
   - Go to [Render Dashboard](https://dashboard.render.com)
   - Click "New +" → "Web Service"
   - Connect GitHub repository: `your-org/worldchef`
   - Service Details:
     - **Name:** `worldchef-staging-api`
     - **Environment:** `Node`
     - **Build Command:** `npm ci`
     - **Start Command:** `npm start`
     - **Health Check Path:** `/healthz`

2. **Configure API Service Environment**
   ```bash
   # In Render dashboard, add environment variables:
   NODE_ENV=staging
   PORT=3000
   SUPABASE_URL=https://your-staging-project.supabase.co
   SUPABASE_ANON_KEY=eyJ...staging-anon-key
   SUPABASE_SERVICE_ROLE_KEY=eyJ...staging-service-key
   USDA_API_KEY=...your-usda-api-key...
   ```

3. **Create Web Service (Optional for Week 0)**
   ```bash
   # For Flutter Web deployment (if needed)
   # Name: worldchef-staging-web
   # Environment: Static Site
   # Build Command: flutter build web
   # Publish Directory: build/web
   ```

### Step 1.2: Verify Service Deployment

1. **Check Service URLs**
   - API Service: `https://worldchef-staging-api.onrender.com`
   - Web Service: `https://worldchef-staging-web.onrender.com` (if created)

2. **Test Health Check**
   ```bash
   # Test health check endpoint
   curl https://worldchef-staging-api.onrender.com/healthz
   
   # Expected response:
   # {"status":"healthy","timestamp":"2025-01-31T16:00:00.000Z","uptime":123.45}
   ```

## Phase 2: Supabase Database Setup (VALIDATED)

### Step 2.1: Create Supabase Project

1. **Create New Project**
   - Go to [Supabase Dashboard](https://supabase.com/dashboard)
   - Click "New Project"
   - **Name:** `worldchef-staging`
   - **Region:** Choose closest to your location (Render auto-selects optimal region)
   - **Database Password:** Generate strong password (save securely)

2. **Configure Project Settings (Pre-validated)**
   ```sql
   -- Extensions validated in PoC #2
   CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
   CREATE EXTENSION IF NOT EXISTS "pgcrypto";
   CREATE EXTENSION IF NOT EXISTS "pg_trgm";
   CREATE EXTENSION IF NOT EXISTS "unaccent";
   ```

### Step 2.2: Deploy Database Schema

1. **Run Migration Scripts**
   ```bash
   # Connect to Supabase database
   psql "postgresql://postgres:[password]@db.your-staging-project.supabase.co:5432/postgres"
   
   # Execute schema migration
   \i poc2_supabase_validation/src/schema/migration_scripts.sql
   
   # Apply RLS policies
   \i poc2_supabase_validation/src/schema/rls_policies.sql
   ```

2. **Verify Schema Deployment**
   ```sql
   -- Check tables
   \dt
   
   -- Verify RLS policies
   SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
   FROM pg_policies 
   WHERE schemaname = 'public';
   ```

### Step 2.3: Configure Edge Functions

1. **Deploy Edge Functions**
   ```bash
   # Install Supabase CLI
   npm install -g supabase
   
   # Login to Supabase
   supabase login
   
   # Link to staging project
   supabase link --project-ref your-staging-project-ref
   
   # Deploy edge functions
   supabase functions deploy nutritionEnrich
   
   # Set the USDA API Key as a secret for the function
   supabase secrets set --env-file ./path/to/your/prod.env
   
   # CRITICAL: The nutrition_enrichment function requires the USDA_API_KEY.
   # You MUST set it using the Supabase CLI for it to be available in the function's runtime.
   supabase secrets set USDA_API_KEY=...your-usda-api-key...
   ```

## Phase 3: Application Code Preparation (Week 0)

### Step 3.1: Create Minimal Fastify Application

1. **Create app.js (if not exists)**
   ```javascript
   // app.js - Minimal Fastify application for Week 0-1 validation
   const fastify = require('fastify')({ logger: true });
   const { createClient } = require('@supabase/supabase-js');
   
   // Initialize Supabase client (validated in PoC #2)
   const supabase = createClient(
     process.env.SUPABASE_URL,
     process.env.SUPABASE_ANON_KEY
   );
   
   // Health check endpoint (Render standard)
   fastify.get('/healthz', async (request, reply) => {
     try {
       // Test Supabase connection
       const { data, error } = await supabase.from('users').select('count').limit(1);
       
       return {
         status: 'healthy',
         timestamp: new Date().toISOString(),
         uptime: process.uptime(),
         database: error ? 'unhealthy' : 'healthy'
       };
     } catch (err) {
       reply.code(503);
       return {
         status: 'unhealthy',
         error: err.message,
         timestamp: new Date().toISOString()
       };
     }
   });
   
   // Hello world endpoint for Week 1 PoC validation
   fastify.get('/hello', async (request, reply) => {
     return { message: 'Hello WorldChef Staging!' };
   });
   
   // Start server
   const start = async () => {
     try {
       await fastify.listen({ port: process.env.PORT || 3000, host: '0.0.0.0' });
       console.log('🚀 Server ready for validation!');
     } catch (err) {
       fastify.log.error(err);
       process.exit(1);
     }
   };
   
   start();
   ```

2. **Update package.json**
   ```json
   {
     "name": "worldchef-staging",
     "version": "1.0.0",
     "scripts": {
       "start": "node app.js",
       "dev": "nodemon app.js"
     },
     "dependencies": {
       "fastify": "^4.0.0",
       "@supabase/supabase-js": "^2.0.0"
     },
     "engines": {
       "node": "18.x"
     }
   }
   ```

### Step 3.2: Deploy to Render

1. **Deploy via Render Dashboard**
   - Services should auto-deploy when code is pushed to connected GitHub repository
   - Monitor deployment in Render dashboard
   - Check logs for successful startup

2. **Verify Deployment**
   ```bash
   # Test health check endpoint
   curl https://worldchef-staging-api.onrender.com/healthz
   
   # Test hello endpoint (for Week 1 PoC)
   curl https://worldchef-staging-api.onrender.com/hello
   
   # Expected responses:
   # Health: {"status":"healthy","timestamp":"2025-01-31T16:00:00.000Z","uptime":123.45}
   # Hello: {"message":"Hello WorldChef Staging!"}
   ```

## Phase 4: CI/CD Pipeline Setup (Week 0)

### Step 4.1: GitHub Integration with Render

1. **Configure Auto-Deploy (Optional for Week 0)**
   - In Render Dashboard, go to your service settings
   - **Auto-Deploy:** Set to "No" for manual deploys during Week 0-1 validation
   - **Branch:** Connect to `main` branch for staging
   - **Deploy Hook:** Copy webhook URL for manual triggers

2. **GitHub Secrets (Week 1 Validation)**
   ```bash
   # Navigate to GitHub repository settings
   # Settings > Secrets and variables > Actions
   
   # Add the following secrets (for Week 1 validation):
   SUPABASE_SERVICE_ROLE_KEY
   STRIPE_SECRET_KEY
   FCM_PRIVATE_KEY
   RENDER_DEPLOY_HOOK_URL
   SLACK_WEBHOOK_URL
   ```

### Step 4.2: Manual Deployment Testing (Week 0)

1. **Test Manual Deploy**
   ```bash
   # Push changes to main branch
   git add .
   git commit -m "feat: add minimal Fastify app for Week 0 validation"
   git push origin main
   
   # Trigger manual deploy in Render dashboard
   # Or use deploy hook:
   curl -X POST $RENDER_DEPLOY_HOOK_URL
   ```

2. **Verify Deployment**
   ```bash
   # Check application health
   curl https://worldchef-staging-api.onrender.com/healthz
   
   # Test hello endpoint
   curl https://worldchef-staging-api.onrender.com/hello
   
   # Monitor logs in Render dashboard
   ```

## Phase 5: Synthetic Data Setup

### Step 5.1: Data Generation Scripts

1. **Execute User Generation**
   ```bash
   # Connect to staging database
   psql "postgresql://postgres:[password]@db.your-staging-project.supabase.co:5432/postgres"
   
   # Run user generation script
   \i staging/data-generation/01_synthetic_users.sql
   ```

2. **Execute Recipe Generation**
   ```bash
   # Run recipe generation script
   \i staging/data-generation/02_synthetic_recipes.sql
   ```

3. **Verify Data Generation**
   ```sql
   -- Check user counts
   SELECT role, COUNT(*) 
   FROM users 
   WHERE email LIKE '%@staging.worldchef.example.com' 
   GROUP BY role;
   
   -- Check recipe counts
   SELECT visibility, COUNT(*) 
   FROM recipes r
   JOIN creators c ON r.creator_id = c.id
   JOIN users u ON c.user_id = u.id
   WHERE u.email LIKE '%@staging.worldchef.example.com'
   GROUP BY visibility;
   ```

### Step 5.2: Nightly Refresh Setup

1. **Configure Automation**
   ```bash
   # Make script executable
   chmod +x staging/automation/nightly-refresh.sh
   
   # Test script execution
   ./staging/automation/nightly-refresh.sh
   ```

2. **Set up Cron Job**
   ```bash
   # Add to crontab (runs at 2 AM daily)
   0 2 * * * /path/to/worldchef/staging/automation/nightly-refresh.sh
   ```

## Phase 6: Basic Monitoring (Week 0 Focus)

### Step 6.1: Render Built-in Monitoring

1. **Access Service Metrics**
   - Go to Render Dashboard → Your Service
   - Monitor CPU/Memory usage, response times
   - Check deployment logs and error rates
   - Set up basic email notifications

2. **Supabase Monitoring**
   ```bash
   # Access Supabase dashboard metrics
   # Monitor database performance
   # Check edge function execution times
   # Review API usage and quotas
   ```

### Step 6.2: Basic Alerting (Week 0)

1. **Render Notifications**
   - Service health notifications via email
   - Deploy failure notifications
   - Basic resource usage alerts

2. **Optional Slack Integration**
   ```bash
   # Set up webhook for critical alerts
   SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
   ```

## Phase 7: Security Configuration

### Step 7.1: Network Security

1. **Configure Security Groups**
   ```bash
   # Restrict ingress to HTTPS only
   # Allow internal cluster communication
   # Block unnecessary ports
   ```

2. **Set up WAF Rules**
   ```bash
   # Configure Web Application Firewall
   # Rate limiting
   # SQL injection protection
   # XSS protection
   ```

### Step 7.2: Secret Management

1. **Rotate Secrets**
   ```bash
   # Set up quarterly secret rotation
   # Document rotation procedures
   # Test secret rotation process
   ```

## Phase 8: Validation and Testing

### Step 8.1: End-to-End Testing

1. **API Testing**
   ```bash
   # Run comprehensive API tests
   npm run test:e2e:staging
   
   # Performance testing
   k6 run staging/tests/load-test.js
   ```

2. **Security Testing**
   ```bash
   # Run OWASP ZAP scan
   zap-baseline.py -t https://staging.worldchef.example.com
   
   # Vulnerability scanning
   npm audit --audit-level=high
   ```

### Step 8.2: Performance Validation

1. **Load Testing**
   ```bash
   # Test with 100 concurrent users
   k6 run --vus 100 --duration 60s staging/tests/load-test.js
   
   # Verify p95 latency < 200ms
   ```

2. **Database Performance**
   ```sql
   -- Check query performance
   EXPLAIN ANALYZE SELECT * FROM recipes WHERE visibility = 'public' LIMIT 20;
   
   -- Verify index usage
   SELECT schemaname, tablename, indexname, idx_tup_read, idx_tup_fetch 
   FROM pg_stat_user_indexes;
   ```

## Troubleshooting Guide

<!-- AI_ANNOTATION_START
{
  "annotation": "AI_EDIT",
  "g": 135,
  "task_id": "cr_t003",
  "plan_id": "cycle4_remediation",
  "edited_by": "Hybrid_AI_OS",
  "timestamp": "2025-06-14T18:15:00Z"
}
AI_ANNOTATION_END -->

### Common Issues

1. **Database Connection Failures**
   ```bash
   # Check Supabase project status
   # Verify connection string
   # Check firewall rules
   ```

2. **Deployment Failures**
   ```bash
   # Check pod logs
   render services logs worldchef-staging-api
   
   # Check resource limits
   render services list-instances worldchef-staging-api
   ```

3. **Performance Issues**
   ```bash
   # Check resource utilization
   render services metrics worldchef-staging-api --live
   
   # Monitor database connections
   SELECT count(*) FROM pg_stat_activity;
   ```

## Maintenance Procedures

### Daily Tasks
- [ ] Check application health status
- [ ] Review error logs
- [ ] Verify data refresh completion
- [ ] Monitor resource usage

### Weekly Tasks
- [ ] Review security scan results
- [ ] Update dependencies
- [ ] Performance baseline review
- [ ] Cost analysis

### Monthly Tasks
- [ ] Rotate secrets
- [ ] Update container images
- [ ] Capacity planning review
- [ ] Disaster recovery testing

## Week 0 Success Criteria Checklist

### Infrastructure (Week 0)
- [ ] Render API service created and deployed: `worldchef-staging-api.onrender.com`
- [ ] Supabase project created with staging database
- [ ] GitHub repository connected to Render service
- [ ] Environment variables configured in Render dashboard
- [ ] Health check endpoint `/healthz` responding successfully

### Application (Week 0)
- [ ] Minimal Fastify application deployed and running
- [ ] Health check endpoint functional with database connectivity test
- [ ] Hello world endpoint functional for Week 1 PoC testing
- [ ] Render service logs accessible and error-free
- [ ] Manual deployment process tested and documented

### Database (Week 0)
- [ ] Supabase project provisioned and accessible
- [ ] Core schema deployed (from ADR Checkpoint 2 validation)
- [ ] Database extensions enabled (uuid-ossp, pgcrypto, pg_trgm, unaccent)
- [ ] Connection from Render service verified
- [ ] Basic RLS policies active (validated in PoC #2)

### Week 1 Validation Preparation
- [ ] k6 load testing tool installed and configured
- [ ] Stripe test account created with test keys
- [ ] Firebase project created for FCM testing
- [ ] Test device registered for push notification validation
- [ ] Validation procedures documented

### Monitoring (Basic for Week 0)
- [ ] Render dashboard accessible with service metrics
- [ ] Supabase dashboard accessible with database metrics
- [ ] Basic email notifications configured
- [ ] Service deployment and health status visible

### Security (Week 0)
- [ ] HTTPS enabled by default on Render services
- [ ] Environment variables properly secured in Render
- [ ] Supabase RLS policies active (validated in PoC #2)
- [ ] No sensitive data committed to repository

## Next Steps (Per Cycle 4 Scope Document)

### Week 0 Immediate Actions
1. **Complete Infrastructure Setup** (Days 1-2)
   - Create Render services and connect GitHub
   - Deploy minimal Fastify application
   - Verify health check endpoints

2. **Supabase Database Setup** (Days 2-3)
   - Create staging project and deploy schema
   - Test database connectivity from Render
   - Verify basic functionality

3. **Week 1 Validation Preparation** (Days 4-5)
   - Prepare k6 load testing scripts
   - Set up Stripe test environment
   - Configure Firebase for FCM testing

### Week 1 Validation Track (MANDATORY SIGN-OFF)
1. **Fastify Backend PoC**
   - Hello-world endpoint with schema validation
   - k6 load test: **p95 ≤200ms under 100 virtual users**
   
2. **Stripe Checkout & Webhook PoC**
   - Initiate checkout session successfully
   - **Capture webhook events end-to-end**
   
3. **Push Notification Smoke Test**
   - Register device token
   - **Deliver test notification within 3 seconds**

### Success Gate (Week 1 Day 6)
- [ ] **Executive Sponsor Sign-off** on all validation results
- [ ] All three PoCs completed with documented results
- [ ] Go/No-Go decision for backend integration (items 5-6 in scope)

---

**Status:** READY FOR WEEK 0 IMPLEMENTATION  
**Next Action:** Create Render services and deploy minimal app  
**Owner:** Tech Lead  
**Target Completion:** Week 0 Day 5 

<!-- AI_ANNOTATION_START
{
  "annotation": "AI_EDIT",
  "g": 137,
  "task_id": "cr_t004",
  "plan_id": "cycle4_remediation",
  "edited_by": "Hybrid_AI_OS",
  "timestamp": "2025-06-14T18:45:00Z"
}
AI_ANNOTATION_END -->

### Appendix A: USDA API Integration Notes

The `nutrition_enrichment` edge function relies on the USDA FoodData Central API. During implementation (Task `cr_t004`), several key details were discovered that are critical for correct integration:

1.  **API Response Structure**: The structure of the `foodNutrients` array in the API response is flat. Key values are accessed directly, not through a nested `nutrient` object.
    *   **Nutrient ID**: `nutrient.nutrientNumber` (e.g., "208")
    *   **Nutrient Value**: `nutrient.value` (e.g., 165)

2.  **Core Nutrient IDs**: The specific `nutrientNumber` values for the core macros are:
    *   **Calories**: `"208"` (Energy in kcal)
    *   **Protein**: `"203"`
    *   **Fat**: `"204"` (Total lipid)
    *   **Carbohydrates**: `"205"` (By difference)

3.  **Secret Management**: The `USDA_API_KEY` must be set as a secret for the Supabase function via the CLI (`supabase secrets set`) for it to be available at runtime. It is *not* inherited from the project's main environment variables.

These details are already implemented in the current version of the `nutrition_enrichment/index.ts` function. This note serves as a persistent record to aid future debugging and development.