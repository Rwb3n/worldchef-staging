# Staging Infrastructure Configuration
## Cycle 4 Week 0 - Infrastructure Provisioning

**Document Version:** 1.0  
**Created:** 2025-06-13T16:00:00Z  
**Updated:** 2025-06-13T16:00:00Z  
**Global Event:** g89  

## Overview

This document outlines the complete staging infrastructure configuration for WorldChef Cycle 4 closed-beta readiness. The staging environment mirrors production architecture while providing isolated testing capabilities with automated data refresh and comprehensive monitoring.

## Infrastructure Architecture

### Core Components

1. **Fastify Application Servers**
   - Load-balanced instances behind reverse proxy
   - Health check endpoints at `/health` and `/ping`
   - Auto-scaling based on CPU/memory thresholds
   - Container orchestration with restart policies

2. **Supabase Backend Services**
   - Dedicated staging project with isolated database
   - Edge functions for nutrition enrichment and background jobs
   - Row Level Security (RLS) policies matching production
   - Connection pooling optimized for staging workloads

3. **Domain & TLS Configuration**
   - Primary domain: `staging.worldchef.example.com`
   - TLS certificates managed via Let's Encrypt or cloud provider
   - DNS configuration with appropriate TTL settings
   - CDN integration for static assets and images

4. **Storage & Media**
   - S3-compatible bucket for recipe images
   - Image optimization pipeline with multiple sizes
   - CDN distribution for global access
   - Automated cleanup policies for cost management

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

### Container Specification

```dockerfile
# Staging-optimized Dockerfile
FROM node:18-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy application code
COPY . .

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Run as non-root user
USER node

EXPOSE 3000

CMD ["npm", "start"]
```

### Load Balancer Configuration

```yaml
# Load balancer health checks
health_check:
  path: /health
  interval: 30s
  timeout: 5s
  healthy_threshold: 2
  unhealthy_threshold: 3

# Auto-scaling rules
auto_scaling:
  min_instances: 2
  max_instances: 10
  target_cpu_utilization: 70%
  target_memory_utilization: 80%
  scale_up_cooldown: 300s
  scale_down_cooldown: 600s
```

## Network & Security

### Network Configuration

- **VPC:** Dedicated staging VPC with private subnets
- **Security Groups:** Restrictive ingress rules (HTTPS only)
- **NAT Gateway:** For outbound internet access from private subnets
- **VPN Access:** Optional VPN for internal team access

### Security Policies

1. **Access Control**
   - IP whitelist for administrative access
   - Multi-factor authentication for deployment accounts
   - Role-based access control (RBAC) for team members

2. **Data Protection**
   - Encryption at rest for all data stores
   - TLS 1.3 for all communications
   - Regular security scanning with OWASP-ZAP

3. **Compliance**
   - GDPR-compliant data handling (synthetic data only)
   - Regular vulnerability assessments
   - Audit logging for all administrative actions

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

## Validation Checklist

### Infrastructure Readiness

- [ ] Domain configured with valid TLS certificate
- [ ] Load balancer health checks passing
- [ ] Auto-scaling policies tested and verified
- [ ] Security groups and firewall rules configured
- [ ] VPN access established for team members

### Application Deployment

- [ ] Fastify servers deployed and responding to health checks
- [ ] Environment variables properly configured
- [ ] Database connections established and tested
- [ ] External service integrations verified (Stripe, FCM)
- [ ] Image upload and storage functionality working

### Monitoring & Alerting

- [ ] Monitoring dashboard accessible and populated
- [ ] Alert rules configured and tested
- [ ] Slack integration for critical notifications
- [ ] Log aggregation and search functionality
- [ ] Performance metrics baseline established

### Security & Compliance

- [ ] OWASP-ZAP security scan completed with zero critical issues
- [ ] Access controls tested and verified
- [ ] Secrets properly managed and rotated
- [ ] Audit logging enabled and functional
- [ ] Data encryption verified at rest and in transit

## Next Steps

1. **Execute Infrastructure Provisioning** (stg_t001)
   - Provision cloud resources using IaC templates
   - Configure networking and security groups
   - Set up domain and TLS certificates
   - Deploy initial Fastify application

2. **Supabase Database Setup** (stg_t002)
   - Create staging Supabase project
   - Deploy schema and RLS policies
   - Configure edge functions
   - Test database connectivity

3. **CI/CD Pipeline Integration** (stg_t003)
   - Configure GitHub Actions workflow
   - Set up automated testing gates
   - Implement deployment verification
   - Test rollback procedures

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