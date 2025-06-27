import * as admin from 'firebase-admin';

export function initializeFirebaseAdmin() {
  let firebaseInitialized = false;
  try {
    if (!admin.apps.length) {
      if (process.env.FCM_SERVICE_ACCOUNT_KEY) {
        const serviceAccount = JSON.parse(process.env.FCM_SERVICE_ACCOUNT_KEY);
        admin.initializeApp({
          credential: admin.credential.cert(serviceAccount),
        });
        firebaseInitialized = true;
        console.log('Firebase Admin SDK initialized with service account credentials');
      } else if (process.env.FCM_SERVER_KEY) {
        admin.initializeApp({
          credential: admin.credential.applicationDefault(),
          projectId: process.env.FIREBASE_PROJECT_ID || 'worldchef-staging'
        });
        firebaseInitialized = true;
        console.log('Firebase Admin SDK initialized with application default credentials');
      } else {
        console.warn('No FCM credentials found - notifications will fail');
        firebaseInitialized = false;
      }
    }
  } catch (error) {
    console.error('Firebase Admin SDK initialization failed:', error);
    firebaseInitialized = false;
  }
  return firebaseInitialized;
}
