// backend/__tests__/setup.js

// Mock environment variables for testing
// In a real CI/CD pipeline, these would be set securely.
process.env.SUPABASE_URL = 'https://mock.supabase.co';
process.env.SUPABASE_SERVICE_ROLE_KEY = 'mock-service-role-key';
process.env.PORT = '10001'; // Use a different port for testing 