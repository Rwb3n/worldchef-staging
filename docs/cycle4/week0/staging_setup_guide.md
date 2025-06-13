# Staging Environment Setup Guide
## Cycle 4 Week 0 - Complete Implementation Guide

**Document Version:** 1.0  
**Created:** 2025-06-13T16:00:00Z  
**Updated:** 2025-06-13T16:00:00Z  
**Global Event:** g89  

## Overview

This guide provides step-by-step instructions for setting up the complete WorldChef staging environment, including infrastructure provisioning, database setup, CI/CD pipeline configuration, and synthetic data seeding.

## Prerequisites

### Required Tools and Access

- **Cloud Provider Account** (AWS/GCP/Azure) with appropriate permissions
- **Supabase Account** with project creation permissions
- **GitHub Repository** with Actions enabled
- **Domain Management** access for staging.worldchef.example.com
- **Docker** and **kubectl** installed locally
- **Node.js 18+** and **npm** for local development
- **PostgreSQL client** (psql) for database operations

### Required Secrets and Environment Variables

```bash
# Database Configuration
SUPABASE_URL=https://your-staging-project.supabase.co
SUPABASE_ANON_KEY=eyJ...staging-anon-key
SUPABASE_SERVICE_ROLE_KEY=eyJ...staging-service-key
SUPABASE_DB_PASSWORD=your-staging-db-password

# External Services
STRIPE_SECRET_KEY=sk_test_...staging-stripe-key
STRIPE_WEBHOOK_SECRET=whsec_...staging-webhook-secret
FCM_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"

# Infrastructure
KUBE_CONFIG=base64-encoded-kubeconfig
STAGING_API_TOKEN=your-staging-api-token

# Monitoring
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
SNYK_TOKEN=your-snyk-security-token
```

## Phase 1: Infrastructure Provisioning

### Step 1.1: Cloud Infrastructure Setup

1. **Create Kubernetes Cluster**
   ```bash
   # Example for AWS EKS
   eksctl create cluster \
     --name worldchef-staging \
     --region us-east-1 \
     --node-type t3.medium \
     --nodes 2 \
     --nodes-min 1 \
     --nodes-max 4 \
     --managed
   ```

2. **Configure Networking**
   ```bash
   # Create namespace
   kubectl create namespace staging
   
   # Apply network policies
   kubectl apply -f k8s/staging/network-policies.yaml
   ```

3. **Set up Load Balancer and Ingress**
   ```bash
   # Install ingress controller
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/aws/deploy.yaml
   
   # Apply ingress configuration
   kubectl apply -f k8s/staging/ingress.yaml
   ```

### Step 1.2: Domain and TLS Configuration

1. **Configure DNS**
   ```bash
   # Get load balancer external IP
   kubectl get svc -n ingress-nginx
   
   # Create DNS A record
   # staging.worldchef.example.com -> EXTERNAL-IP
   ```

2. **Set up TLS Certificates**
   ```bash
   # Install cert-manager
   kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
   
   # Apply certificate issuer
   kubectl apply -f k8s/staging/cert-issuer.yaml
   ```

## Phase 2: Supabase Database Setup

### Step 2.1: Create Supabase Project

1. **Create New Project**
   - Go to [Supabase Dashboard](https://supabase.com/dashboard)
   - Click "New Project"
   - Name: `worldchef-staging`
   - Region: `us-east-1` (or closest to your infrastructure)
   - Database Password: Generate strong password

2. **Configure Project Settings**
   ```sql
   -- Enable required extensions
   CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
   CREATE EXTENSION IF NOT EXISTS "pgcrypto";
   CREATE EXTENSION IF NOT EXISTS "pg_trgm";
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
   ```

## Phase 3: Application Deployment

### Step 3.1: Container Build and Registry

1. **Create Dockerfile.staging**
   ```dockerfile
   FROM node:18-alpine
   
   WORKDIR /app
   
   # Copy package files
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

2. **Build and Push Image**
   ```bash
   # Build image
   docker build -f Dockerfile.staging -t worldchef-staging:latest .
   
   # Tag for registry
   docker tag worldchef-staging:latest ghcr.io/your-org/worldchef-staging:latest
   
   # Push to registry
   docker push ghcr.io/your-org/worldchef-staging:latest
   ```

### Step 3.2: Kubernetes Deployment

1. **Create Deployment Configuration**
   ```yaml
   # k8s/staging/deployment.yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: worldchef-staging
     namespace: staging
   spec:
     replicas: 2
     selector:
       matchLabels:
         app: worldchef-staging
     template:
       metadata:
         labels:
           app: worldchef-staging
       spec:
         containers:
         - name: worldchef-staging
           image: ghcr.io/your-org/worldchef-staging:latest
           ports:
           - containerPort: 3000
           env:
           - name: NODE_ENV
             value: "staging"
           envFrom:
           - configMapRef:
               name: worldchef-staging-config
           - secretRef:
               name: worldchef-staging-secrets
           livenessProbe:
             httpGet:
               path: /health
               port: 3000
             initialDelaySeconds: 30
             periodSeconds: 10
           readinessProbe:
             httpGet:
               path: /ping
               port: 3000
             initialDelaySeconds: 5
             periodSeconds: 5
   ```

2. **Deploy Application**
   ```bash
   # Apply deployment
   kubectl apply -f k8s/staging/deployment.yaml
   
   # Apply service
   kubectl apply -f k8s/staging/service.yaml
   
   # Check deployment status
   kubectl get pods -n staging
   kubectl logs -f deployment/worldchef-staging -n staging
   ```

## Phase 4: CI/CD Pipeline Setup

### Step 4.1: GitHub Secrets Configuration

1. **Add Required Secrets**
   ```bash
   # Navigate to GitHub repository settings
   # Settings > Secrets and variables > Actions
   
   # Add the following secrets:
   SUPABASE_SERVICE_ROLE_KEY
   STRIPE_SECRET_KEY
   FCM_PRIVATE_KEY
   JWT_SECRET
   KUBE_CONFIG (base64 encoded)
   STAGING_API_TOKEN
   SLACK_WEBHOOK_URL
   SNYK_TOKEN
   ```

2. **Configure Environment Protection**
   ```bash
   # Settings > Environments
   # Create "staging" environment
   # Add protection rules:
   # - Required reviewers (optional)
   # - Wait timer: 0 minutes
   # - Deployment branches: staging only
   ```

### Step 4.2: Workflow Testing

1. **Test Pipeline**
   ```bash
   # Create staging branch
   git checkout -b staging
   git push origin staging
   
   # Monitor workflow execution
   # GitHub > Actions > Staging Deployment Pipeline
   ```

2. **Verify Deployment**
   ```bash
   # Check application health
   curl https://staging.worldchef.example.com/health
   
   # Test API endpoints
   curl https://staging.worldchef.example.com/v1/recipes?limit=5
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

## Phase 6: Monitoring and Alerting

### Step 6.1: Application Monitoring

1. **Install Monitoring Stack**
   ```bash
   # Install Prometheus and Grafana
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   
   helm install prometheus prometheus-community/kube-prometheus-stack \
     --namespace monitoring \
     --create-namespace
   ```

2. **Configure Dashboards**
   ```bash
   # Access Grafana
   kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
   
   # Import WorldChef staging dashboard
   # Dashboard ID: custom-worldchef-staging.json
   ```

### Step 6.2: Log Aggregation

1. **Set up Log Collection**
   ```bash
   # Install Fluentd or similar
   kubectl apply -f k8s/monitoring/fluentd-daemonset.yaml
   ```

2. **Configure Log Forwarding**
   ```yaml
   # Forward logs to centralized logging service
   # Configure in fluentd-config.yaml
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
   kubectl logs -f deployment/worldchef-staging -n staging
   
   # Check resource limits
   kubectl describe pod -n staging
   ```

3. **Performance Issues**
   ```bash
   # Check resource utilization
   kubectl top pods -n staging
   
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

## Success Criteria Checklist

### Infrastructure
- [ ] Staging environment accessible at staging.worldchef.example.com
- [ ] TLS certificate valid and auto-renewing
- [ ] Load balancer health checks passing
- [ ] Auto-scaling configured and tested

### Application
- [ ] Fastify servers responding to health checks
- [ ] All API endpoints functional
- [ ] Authentication and authorization working
- [ ] External service integrations verified

### Database
- [ ] Supabase connection established
- [ ] Schema deployed successfully
- [ ] RLS policies active and tested
- [ ] Edge functions deployed and functional

### CI/CD
- [ ] GitHub Actions pipeline executing successfully
- [ ] Automated testing passing (≥80% coverage)
- [ ] Security scanning with zero critical issues
- [ ] Deployment verification working

### Data
- [ ] 500+ synthetic users generated
- [ ] 1000+ synthetic recipes created
- [ ] Nightly data refresh automated
- [ ] Data validation queries passing

### Monitoring
- [ ] Application metrics collected
- [ ] Error rate and latency alerts configured
- [ ] Slack notifications working
- [ ] Log aggregation functional

### Security
- [ ] OWASP ZAP scan passing
- [ ] Secrets properly managed
- [ ] Network security configured
- [ ] Access controls verified

## Next Steps

1. **Week 1 Validation Track**
   - Execute Fastify load testing
   - Validate Stripe integration
   - Test FCM push notifications

2. **Backend Development (Weeks 1-3)**
   - Implement MVP API endpoints
   - Deploy authentication middleware
   - Configure search indexing

3. **Mobile Development (Weeks 2-4)**
   - Connect mobile apps to staging API
   - Test end-to-end user flows
   - Validate push notification delivery

---

**Status:** IMPLEMENTATION READY  
**Next Action:** Begin infrastructure provisioning  
**Owner:** DevOps Engineer  
**Estimated Completion:** End of Week 0 