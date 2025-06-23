# Minimal Application Deployment Guide
## Quick Fix for Health Check Issues

**Document Version:** 1.0  
**Created:** 2025-01-31T16:00:00Z  
**Priority:** IMMEDIATE - Required for health checks to work  

## 🎯 Objective

Deploy the minimal Node.js application (`app.js` + `package.json`) to Render so that health checks can actually succeed instead of being skipped.

## 📋 Prerequisites

- ✅ Render account with staging workspace access
- ✅ GitHub repository with the minimal app files
- ✅ `app.js` and `package.json` committed to repository

## 🚀 Deployment Steps

### Step 1: Create Render Web Service

1. **Login to Render Dashboard**
   - Go to [render.com](https://render.com)
   - Navigate to your staging workspace

2. **Create New Web Service**
   ```
   Service Type: Web Service
   Repository: your-github-repo/worldchef
   Name: worldchef-staging-web
   Region: Oregon (US West) or closest to your location
   Branch: main (or your current branch)
   Root Directory: . (root)
   ```

3. **Configure Build Settings**
   ```
   Build Command: npm install
   Start Command: npm start
   ```

4. **Set Environment Variables**
   ```
   NODE_ENV=staging
   PORT=10000
   ```

### Step 2: Create Render API Service

1. **Create Second Web Service**
   ```
   Service Type: Web Service  
   Repository: your-github-repo/worldchef
   Name: worldchef-staging-api
   Region: Oregon (US West) or closest to your location
   Branch: main (or your current branch)
   Root Directory: . (root)
   ```

2. **Configure Build Settings**
   ```
   Build Command: npm install
   Start Command: npm start
   ```

3. **Set Environment Variables**
   ```
   NODE_ENV=staging
   PORT=10000
   API_MODE=true
   ```

### Step 3: Configure Health Check Settings

1. **For Both Services, Set Health Check Path**
   ```
   Health Check Path: /healthz
   ```

2. **Verify Service URLs Match Expected Pattern**
   - Web service should be: `https://worldchef-staging.onrender.com`
   - API service should be: `https://api.worldchef-staging.onrender.com`
   - *(If URLs don't match, update the health check script accordingly)*

### Step 4: Test Health Endpoints

1. **Wait for Deployment to Complete** (usually 2-5 minutes)

2. **Test Health Endpoints Manually**
   ```bash
   # Test web service
   curl https://worldchef-staging.onrender.com/healthz
   
   # Test API service  
   curl https://api.worldchef-staging.onrender.com/healthz
   
   # Expected response:
   {
     "status": "healthy",
     "timestamp": "2025-01-31T16:00:00.000Z",
     "message": "WorldChef staging API is running"
   }
   ```

## 🔧 Enable Health Checks in Automation

Once the services are deployed and responding, update the health check script:

### Step 1: Re-enable Health Checks

1. **Edit `staging/automation/nightly-health-check.sh`**

2. **Comment out the skip logic and uncomment the actual checks:**
   ```bash
   # Comment out these lines:
   # log "⚠️  NOTICE: API health check disabled - no application deployed yet"
   # log "API health check skipped ⏭️"
   
   # Uncomment the actual health check logic:
   for attempt in {1..5}; do
     if curl -sf "$API_URL" >/dev/null; then
       log "API healthy ✅ (attempt $attempt)"
       break
     else
       if [ $attempt -eq 5 ]; then
         log "API unhealthy ❌ (failed after 5 attempts)"
         exit 1
       else
         log "API not ready, retrying in 15 seconds... (attempt $attempt/5)"
         sleep 15
       fi
     fi
   done
   ```

3. **Do the same for Web health checks**

## ✅ Expected Results

After deployment and re-enabling health checks:

```bash
[CHECK] Starting health checks …
[2025-01-31 16:00:00] Waiting for API to restart after DB reset...
[2025-01-31 16:00:30] Checking API health…
[2025-01-31 16:00:31] API healthy ✅ (attempt 1)
[2025-01-31 16:00:31] Checking Web health…
[2025-01-31 16:00:32] Web healthy ✅ (attempt 1)
[2025-01-31 16:00:32] Both checks passed.
```

## 🔍 Troubleshooting

### If Health Checks Still Fail

1. **Check Service Status in Render Dashboard**
   - Ensure both services show "Live" status
   - Check deployment logs for errors

2. **Verify URLs in Health Check Script**
   ```bash
   # Make sure these match your actual Render service URLs:
   API_URL="https://api.worldchef-staging.onrender.com/healthz"
   WEB_URL="https://worldchef-staging.onrender.com/healthz"
   ```

3. **Test Services Manually**
   ```bash
   # Test from command line:
   curl -v https://worldchef-staging.onrender.com/healthz
   curl -v https://api.worldchef-staging.onrender.com/healthz
   ```

4. **Check for Free Tier Sleep Issues**
   - Render free tier services sleep after 15 minutes
   - First request after sleep takes 10-30 seconds to wake up
   - This is why health checks have retry logic

### If Services Won't Deploy

1. **Check Build Logs in Render Dashboard**
2. **Verify `package.json` dependencies are correct**
3. **Ensure `app.js` syntax is valid**

## 🎉 Success Criteria

✅ **Health check script runs without errors**  
✅ **Both API and Web services respond to `/healthz`**  
✅ **Nightly refresh completes successfully including health checks**  
✅ **Services stay awake during normal business hours**

## 🔄 Next Steps

Once health checks are working:
1. **Add actual application features** to the minimal app
2. **Implement proper routing** for API vs Web differentiation
3. **Add database connectivity** to health checks
4. **Set up monitoring** for the deployed services 