# Staging Infrastructure Configuration
## Cycle 4 Week 0 - Render-Based Infrastructure

**Document Version:** 2.0  
**Created:** 2025-06-13T16:00:00Z  
**Updated:** 2025-01-31T16:00:00Z  
**Global Event:** g135  
**Architecture Status:** VALIDATED (per ADR Checkpoint 2)

## Overview

This document outlines the staging infrastructure configuration for WorldChef Cycle 4 closed-beta readiness using **Render as the hosting platform**. The staging environment implements the validated architecture from the Architectural Decision Checkpoint 2, specifically using Fastify + Supabase as confirmed through successful PoC validations.

## Infrastructure Architecture

### Validated Technology Stack (per ADR Checkpoint 2)

**✅ VALIDATED COMPONENTS:**
- **Mobile Framework:** Flutter 3.x (88% vs 63% AI generation success vs React Native)
- **State Management:** Riverpod 2.x (100% CI pass rate, <50ms optimistic updates)
- **Backend API:** Fastify (design validated, ready for Week 1 PoC)
- **Database/BaaS:** Supabase (88.5% success score, 75% under budget)
- **Authentication:** Supabase Auth + JWT validation
- **Payments:** Stripe (subject to Week 1 validation)
- **Push Notifications:** Firebase Cloud Messaging (subject to Week 1 validation)

### Core Components

1. **Render Web Services**
   - **API Service:** `api.worldchef-staging.onrender.com` (Fastify application)
   - **Web Service:** `worldchef-staging.onrender.com` (Flutter web or admin interface)
   - **Health Check Endpoints:** `/healthz` (Render standard)
   - **Auto-scaling:** Render's built-in scaling (2-10 instances)
   - **Free Tier:** 750 hours/month per service

2. **Supabase Backend Services (VALIDATED)**
   - **Staging Project:** Dedicated Supabase instance
   - **Database:** PostgreSQL with validated schema
   - **Edge Functions:** Nutrition enrichment (deployed via MCP)
   - **Row Level Security:** Validated RLS policies
   - **Performance:** 90.84ms p95 read (39% better than target)

3. **Render Domain & TLS**
   - **Primary URLs:** 
     - `https://worldchef-staging.onrender.com` (Web service)
     - `https://api.worldchef-staging.onrender.com` (API service)
   - **TLS:** Automatic HTTPS via Render
   - **Custom Domain:** Optional (not required for Week 0-1)

4. **Storage & Media**
   - **Supabase Storage:** For recipe images (integrated with validated backend)
   - **CDN:** Supabase built-in CDN
   - **Cost:** Included in validated $25/month Supabase budget

## Environment Configuration

### Required Environment Variables

```bash
# Application Configuration
NODE_ENV=staging
PORT=3000
API_VERSION=v1
CORS_ORIGIN=https://staging.worldchef.example.com

# Supabase Configuration
SUPABASE_URL=https://your-staging-project.supabase.co
SUPABASE_ANON_KEY=eyJ...staging-anon-key
SUPABASE_SERVICE_ROLE_KEY=eyJ...staging-service-key

# Database Configuration
DATABASE_URL=postgresql://postgres:[password]@db.your-staging-project.supabase.co:5432/postgres
DB_POOL_SIZE=10
DB_TIMEOUT=30000

# Authentication
JWT_SECRET=your-staging-jwt-secret-256-bit
JWT_EXPIRES_IN=24h
BCRYPT_ROUNDS=12

# External Services (Test Mode)
STRIPE_SECRET_KEY=sk_test_...staging-stripe-key
STRIPE_WEBHOOK_SECRET=whsec_...staging-webhook-secret
STRIPE_PRODUCT_PRICE_ID=price_...staging-price-id

# Push Notifications
FCM_PROJECT_ID=worldchef-staging
FCM_PRIVATE_KEY_ID=your-staging-key-id
FCM_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
FCM_CLIENT_EMAIL=firebase-adminsdk-...@worldchef-staging.iam.gserviceaccount.com
FCM_CLIENT_ID=your-staging-client-id
FCM_AUTH_URI=https://accounts.google.com/o/oauth2/auth
FCM_TOKEN_URI=https://oauth2.googleapis.com/token

# Image Storage
S3_BUCKET_NAME=worldchef-staging-images
S3_REGION=us-east-1
S3_ACCESS_KEY_ID=AKIA...staging-access-key
S3_SECRET_ACCESS_KEY=your-staging-secret-key
CDN_BASE_URL=https://cdn-staging.worldchef.example.com

# Monitoring & Logging
LOG_LEVEL=info
SENTRY_DSN=https://...@sentry.io/staging-project-id
DATADOG_API_KEY=your-staging-datadog-key

# Feature Flags (Staging Defaults)
ENABLE_PAYMENTS=true
ENABLE_PUSH_NOTIFICATIONS=true
ENABLE_SEARCH_INDEXING=true
ENABLE_ANALYTICS=false
ENABLE_DEBUG_LOGGING=true
```

### Secrets Management

- **Development:** Use `.env.staging` file (not committed to git)
- **CI/CD:** GitHub Secrets for automated deployment
- **Runtime:** Cloud provider secret management (AWS Secrets Manager, etc.)
- **Rotation:** Quarterly secret rotation schedule

## Deployment Configuration

### Render Service Configuration

```yaml
# render.yaml - Render Blueprint for staging deployment
services:
  - type: web
    name: worldchef-staging-api
    env: node
    buildCommand: npm ci
    startCommand: npm start
    healthCheckPath: /healthz
    autoDeploy: false  # Manual deploys during Week 0-1 validation
    envVars:
      - key: NODE_ENV
        value: staging
      - key: PORT
        value: 3000
    scaling:
      minInstances: 1
      maxInstances: 3
      targetMemoryPercent: 80
      targetCPUPercent: 70

  - type: web
    name: worldchef-staging-web
    env: static
    buildCommand: flutter build web
    publishPath: ./build/web
    pullRequestPreviewsEnabled: false
```

### Health Check Implementation (Render Standard)

```javascript
// Health check endpoint for Render
app.get('/healthz', async (req, res) => {
  try {
    const checks = {
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      database: await checkSupabaseConnection(),
      memory: process.memoryUsage(),
      status: 'healthy'
    };
    
    res.status(200).json(checks);
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      error: error.message,
      timestamp: new Date().toISOString()
    });
  }
});
```

## Network & Security

### Render Network Configuration

- **HTTPS:** Automatic TLS/SSL for all services
- **CDN:** Global CDN included with all web services
- **DDoS Protection:** Built-in DDoS mitigation
- **Geographic Distribution:** Multi-region edge caching

### Security Policies (Render + Supabase)

1. **Access Control**
   - **Render Dashboard:** Team member invitations with role-based access
   - **GitHub Integration:** Secure repository access with deploy keys
   - **Supabase:** RLS policies validated in PoC (88.5% success score)

2. **Data Protection (VALIDATED)**
   - **Encryption:** TLS 1.3 automatic on Render + Supabase
   - **Secrets Management:** Render environment variables + GitHub secrets
   - **Database Security:** Supabase RLS policies proven functional in testing

3. **Compliance**
   - **GDPR:** Synthetic data only during staging
   - **Security Scanning:** OWASP compliance validated in PoC
   - **Audit Logging:** Render + Supabase built-in logging

## Monitoring & Observability

### Health Checks

```javascript
// Health check endpoint implementation
app.get('/health', async (req, res) => {
  const checks = {
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    database: await checkDatabaseConnection(),
    supabase: await checkSupabaseConnection(),
    storage: await checkS3Connection(),
    memory: process.memoryUsage(),
    cpu: process.cpuUsage()
  };
  
  const isHealthy = checks.database && checks.supabase && checks.storage;
  
  res.status(isHealthy ? 200 : 503).json({
    status: isHealthy ? 'healthy' : 'unhealthy',
    checks
  });
});
```

### Metrics Collection

- **Application Metrics:** Response times, error rates, throughput
- **Infrastructure Metrics:** CPU, memory, disk, network utilization
- **Business Metrics:** User registrations, recipe creations, API usage
- **Custom Metrics:** Synthetic data refresh status, test execution results

### Alerting Thresholds

```yaml
alerts:
  critical:
    - error_rate > 5%
    - response_time_p95 > 2000ms
    - cpu_utilization > 90%
    - memory_utilization > 95%
    - disk_usage > 85%
  
  warning:
    - error_rate > 1%
    - response_time_p95 > 1000ms
    - cpu_utilization > 70%
    - memory_utilization > 80%
    - failed_health_checks > 2
```

## Cost Management

### Resource Optimization

- **Compute:** Right-sized instances with auto-scaling
- **Storage:** Lifecycle policies for image cleanup
- **Database:** Connection pooling and query optimization
- **CDN:** Caching strategies to reduce origin requests

### Budget Monitoring

- **Monthly Budget:** $75 maximum (as per business requirements)
- **Cost Alerts:** 50%, 75%, 90% of budget thresholds
- **Resource Tagging:** Consistent tagging for cost allocation
- **Regular Reviews:** Weekly cost analysis and optimization

## Disaster Recovery

### Backup Strategy

- **Database:** Daily automated backups with 7-day retention
- **Application Code:** Git-based versioning with tagged releases
- **Configuration:** Infrastructure as Code (IaC) templates
- **Images:** S3 cross-region replication for critical assets

### Recovery Procedures

1. **Application Failure:** Automatic container restart and health checks
2. **Database Issues:** Point-in-time recovery from Supabase backups
3. **Infrastructure Failure:** IaC-based environment recreation
4. **Data Corruption:** Restore from nightly synthetic data refresh

## Week 0 Validation Checklist (Cycle 4 Scope)

### Infrastructure Readiness

- [ ] **Render Services:** API and Web services created and configured
- [ ] **Supabase Project:** Staging project created with validated schema
- [ ] **Environment Variables:** All required env vars configured in Render
- [ ] **GitHub Integration:** Repository connected to Render services
- [ ] **Health Checks:** `/healthz` endpoint responding on both services

### Week 1 Validation Track (Per Scope Document)

- [ ] **Fastify Backend PoC**
  - Hello-world endpoint with schema validation
  - k6 load test: p95 latency ≤200ms under 100 virtual users
  - Health check endpoint responding correctly

- [ ] **Stripe Checkout & Webhook PoC**
  - Initiate checkout session successfully
  - Capture webhook events end-to-end
  - Test payment flow with Stripe test keys

- [ ] **Push Notification Smoke Test**
  - Register device token successfully
  - Deliver test notification to physical device
  - Verify delivery within 3 seconds

### Success Criteria (from Scope Document)

**MANDATORY SIGN-OFF REQUIREMENTS:**
- [ ] **Fastify p95 latency ≤200ms** under 100 virtual users
- [ ] **Stripe checkout flow + webhook** captured end-to-end
- [ ] **Push notifications delivered** to physical device within 3 seconds
- [ ] **Executive Sponsor Sign-off** on validation results (Week 1 Day 6)

### Monitoring & Alerting (Basic for Week 0-1)

- [ ] **Render Logs:** Service logs accessible and searchable
- [ ] **Supabase Monitoring:** Database performance metrics visible
- [ ] **Basic Alerting:** Service down notifications configured
- [ ] **Health Check Monitoring:** Automated health check status

## Next Steps (Week 0 Focus)

1. **Render Service Setup** (Week 0 Day 1-2)
   - Create API service: `worldchef-staging-api`
   - Create Web service: `worldchef-staging-web`
   - Configure environment variables
   - Deploy minimal "Hello World" endpoints

2. **Supabase Integration** (Week 0 Day 2-3)
   - Create staging Supabase project
   - Deploy validated schema from ADR Checkpoint 2
   - Configure environment variables
   - Test database connectivity

3. **Week 1 Validation Preparation** (Week 0 Day 4-5)
   - Prepare Fastify PoC with k6 load tests
   - Set up Stripe test environment
   - Configure Firebase for push notifications
   - Document validation procedures

## References

- [Cycle 4 Closed-Beta Readiness Scope Document](../../source/Cycle%204%20ClosedBeta%20Readiness%20Scope%20Document.txt)
- [MVP Feature Set & User Flows](../../source/MVP%20Feature%20Set%20&%20User%20Flows.txt)
- [Business Overview](../../source/businessoverview.txt)
- [PoC #4 Backend Integration Validation Results](../../poc4_backend_integration_validation/)

---

**Status:** READY FOR IMPLEMENTATION  
**Next Action:** Begin infrastructure provisioning (stg_t001)  
**Owner:** DevOps Engineer  
**Estimated Completion:** End of Week 0 Day 2 