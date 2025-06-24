// backend/__tests__/setup.js

// Environment variables for testing with real Supabase
// In a real CI/CD pipeline, these would be set securely via GitHub secrets.
process.env.SUPABASE_URL = 'https://myqhpmeprpaukgagktbn.supabase.co';
process.env.SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || 'test-service-role-key-placeholder';
process.env.PORT = '10001'; // Use a different port for testing

// Note: For CI/CD, the SUPABASE_SERVICE_ROLE_KEY should be provided via GitHub secrets
// For local testing, it should be in your .env.local file 