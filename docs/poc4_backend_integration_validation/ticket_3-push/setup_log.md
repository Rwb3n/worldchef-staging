# FCM (Firebase Cloud Messaging) Validation Setup

## Overview
This document outlines the setup process for validating Firebase Cloud Messaging (FCM) push notification delivery and latency performance.

## Prerequisites

### 1. Firebase Project Configuration
- ✅ Firebase project already exists: `worldchef-3fd9e`
- ✅ Service account key available: `worldchef-3fd9e-firebase-adminsdk-fbsvc-2aa90b8a25.json`
- ✅ Project ID: `worldchef-3fd9e`

### 2. Environment Variables Required
Add to your `.env.local` file:
```bash
# Firebase Configuration
FIREBASE_PROJECT_ID=worldchef-3fd9e
FIREBASE_SERVICE_ACCOUNT_PATH=./worldchef-3fd9e-firebase-adminsdk-fbsvc-2aa90b8a25.json

# FCM Testing
FCM_TEST_TOKEN=YOUR_DEVICE_FCM_TOKEN_HERE
FCM_PORT=3335
```

## Setup Steps

### Step 1: Install Dependencies
```bash
cd spike/fcm-poc
npm install
```

### Step 2: Get FCM Test Token
You need a valid FCM token from a real device or web app to test push notifications.

**Option A: Use Firebase Console Test**
1. Go to Firebase Console → Project Settings → Cloud Messaging
2. Use the "Send test message" feature to get a token

**Option B: Use a Mobile App**
1. Integrate FCM SDK in your Flutter/React Native app
2. Get the token programmatically
3. Add it to `.env.local` as `FCM_TEST_TOKEN`

**Option C: Use Web App (Quickest for Testing)**
Create a simple HTML file to get a web FCM token:

```html
<!DOCTYPE html>
<html>
<head>
    <title>FCM Token Generator</title>
</head>
<body>
    <h1>FCM Token Generator</h1>
    <button id="getToken">Get FCM Token</button>
    <div id="token"></div>

    <script type="module">
        import { initializeApp } from 'https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js';
        import { getMessaging, getToken } from 'https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging.js';

        const firebaseConfig = {
            apiKey: "YOUR_API_KEY",
            authDomain: "worldchef-3fd9e.firebaseapp.com",
            projectId: "worldchef-3fd9e",
            storageBucket: "worldchef-3fd9e.appspot.com",
            messagingSenderId: "YOUR_SENDER_ID",
            appId: "YOUR_APP_ID"
        };

        const app = initializeApp(firebaseConfig);
        const messaging = getMessaging(app);

        document.getElementById('getToken').addEventListener('click', async () => {
            try {
                const token = await getToken(messaging, {
                    vapidKey: 'YOUR_VAPID_KEY'
                });
                document.getElementById('token').innerHTML = `<strong>Token:</strong><br><textarea rows="5" cols="80">${token}</textarea>`;
                console.log('FCM Token:', token);
            } catch (error) {
                console.error('Error getting token:', error);
                document.getElementById('token').innerHTML = `<strong>Error:</strong> ${error.message}`;
            }
        });
    </script>
</body>
</html>
```

### Step 3: Start FCM Server
```bash
cd spike/fcm-poc
npm run dev
```

The server will start on port 3335 with the following endpoints:
- `GET /ping` - Health check
- `POST /push/send` - Send single push notification
- `POST /push/batch` - Send batch push notifications

### Step 4: Run Validation Tests
```bash
npm test
```

This will:
1. Send 10 individual push notifications
2. Send 1 batch notification (5 recipients)
3. Measure latency and success rates
4. Generate `fcm_test_results.json` with detailed metrics

## Validation Targets

### Success Criteria
- **Success Rate:** ≥95% of notifications delivered successfully
- **P95 Latency:** ≤500ms for FCM API response time
- **Batch Support:** Successfully send to multiple recipients

### Expected Latency Breakdown
- **FCM API Call:** 100-300ms (network to Google's servers)
- **Total Request:** 150-400ms (including local processing)

## Troubleshooting

### Common Issues

1. **"Service account key not found"**
   - Ensure `worldchef-3fd9e-firebase-adminsdk-fbsvc-2aa90b8a25.json` exists in project root
   - Check `FIREBASE_SERVICE_ACCOUNT_PATH` in `.env.local`

2. **"Invalid FCM token"**
   - Generate a fresh FCM token from a real device/web app
   - Ensure token is not expired (tokens can expire)

3. **"Project not found"**
   - Verify `FIREBASE_PROJECT_ID` matches your Firebase project
   - Check Firebase project permissions

4. **High latency**
   - FCM latency depends on Google's servers and network conditions
   - 200-500ms is normal for international requests

### Manual Testing
You can manually test endpoints using PowerShell:

```powershell
# Test server health
Invoke-WebRequest -Uri http://localhost:3335/ping -Method GET

# Send single notification
$body = @{
    token = "YOUR_FCM_TOKEN"
    title = "Manual Test"
    body = "Testing FCM from PowerShell"
} | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:3335/push/send -Method POST -Body $body -ContentType "application/json"
```

## Next Steps
1. Get a valid FCM token for testing
2. Update `.env.local` with the token
3. Run the validation tests
4. Review results and proceed to success flag generation

## Files Created
- `spike/fcm-poc/package.json` - Dependencies and scripts
- `spike/fcm-poc/index.js` - FCM server with push endpoints
- `spike/fcm-poc/test_push.js` - Automated validation test suite
- `docs/poc4_backend_integration_validation/ticket_3-push/setup_log.md` - This setup guide 