# Cookbook: Test Environment - Real vs Mock Integration

**Pattern:** Strategic Test Environment Configuration for Backend Services
**Source:** Authentication Test Environment Migration (Cycle 4, Week 1)
**Validated in:** Cycle 4 - Task t002

This pattern provides guidance on when to use real service integration vs mocking in test environments, with specific focus on authentication and external services.

## Problem Statement

Test environments often use mocked services to avoid external dependencies, but this can lead to unrealistic test conditions, network errors, and false confidence in system behavior. The challenge is determining when to use real services vs mocks for optimal test coverage and reliability.

## Decision Framework

### Use Real Services When:
- ✅ **Authentication flows** - Real auth providers return correct HTTP status codes
- ✅ **HTTP status code validation** - Mocks may not match real service behavior
- ✅ **Integration contract testing** - Verify actual API contracts
- ✅ **CI/CD pipeline validation** - Ensure deployment readiness
- ✅ **Performance characteristics** - Real latency and response patterns

### Use Mocks When:
- ✅ **Unit testing** - Isolate component behavior
- ✅ **Offline development** - No network dependency
- ✅ **Rate limit avoidance** - Prevent API quota consumption
- ✅ **Error scenario testing** - Controlled failure injection
- ✅ **Speed optimization** - Faster test execution for large suites

## Implementation Patterns

### Pattern 1: Real Service Integration

#### Test Setup Configuration
```javascript
// backend/__tests__/setup.js
// Environment variables for testing with real services
process.env.SUPABASE_URL = 'https://myqhpmeprpaukgagktbn.supabase.co';
process.env.SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || 'test-placeholder';
process.env.PORT = '10001'; // Use different port for testing

// Note: For CI/CD, credentials should be provided via GitHub secrets
// For local testing, they should be in your .env.local file
```

#### CI/CD Pipeline Configuration
```yaml
# .github/workflows/staging-deploy.yml
- name: Run unit tests (with coverage gate)
  run: |
    yarn test:ci --coverage
  env:
    JEST_JUNIT_OUTPUT_DIR: ./reports
    SUPABASE_URL: https://myqhpmeprpaukgagktbn.supabase.co
    SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}
```

#### Test Expectations Alignment
```typescript
// Update test expectations to match real service behavior
describe('POST /v1/auth/signup', () => {
  it('should return 401 for invalid signup data', async () => {
    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/signup',
      payload: {
        email: 'invalid-email',
        password: 'short'
      }
    });

    // Supabase returns 401 for invalid email format or weak password
    expect(response.statusCode).toBe(401);
  });
});
```

### Pattern 2: Mock Service Integration

#### Jest Mock Configuration
```javascript
// backend/__tests__/setup.js
jest.mock('@supabase/supabase-js', () => ({
  createClient: jest.fn(() => ({
    auth: {
      signUp: jest.fn().mockResolvedValue({
        data: null,
        error: { message: 'Invalid email or password', status: 400 }
      }),
      signInWithPassword: jest.fn().mockResolvedValue({
        data: null,
        error: { message: 'Invalid login credentials', status: 401 }
      })
    }
  }))
}));
```

#### Controlled Error Scenarios
```typescript
// Test specific error conditions
it('should handle network timeout', async () => {
  // Mock network timeout
  jest.mocked(supabase.auth.signUp).mockRejectedValueOnce(
    new Error('Network timeout')
  );

  const response = await app.inject({
    method: 'POST',
    url: '/v1/auth/signup',
    payload: { email: 'test@example.com', password: 'password123' }
  });

  expect(response.statusCode).toBe(500);
});
```

## Migration Strategy: Mock to Real

### Step 1: Identify Integration Points
```javascript
// Audit current mock usage
const mockAudit = {
  authentication: 'mock.supabase.co', // ❌ Causing network errors
  database: 'in-memory sqlite',       // ✅ Good for unit tests
  payments: 'stripe test mode',       // ✅ Real test environment
  notifications: 'mock FCM',          // ✅ Avoid spam in development
};
```

### Step 2: Gradual Migration
```javascript
// Environment-based configuration
const getTestConfig = () => {
  const useRealServices = process.env.TEST_INTEGRATION_MODE === 'real';
  
  return {
    supabaseUrl: useRealServices 
      ? 'https://myqhpmeprpaukgagktbn.supabase.co'
      : 'mock://supabase',
    
    stripeKey: useRealServices
      ? process.env.STRIPE_TEST_KEY
      : 'mock_stripe_key'
  };
};
```

### Step 3: Test Expectation Updates
```typescript
// Create expectation helpers
const getExpectedAuthStatus = (scenario: string) => {
  const isRealService = process.env.SUPABASE_URL?.includes('supabase.co');
  
  const expectations = {
    invalidCredentials: isRealService ? 401 : 400,
    missingFields: isRealService ? 401 : 400,
    networkError: isRealService ? 500 : 404
  };
  
  return expectations[scenario];
};
```

## Benefits Analysis

### Real Service Integration Benefits
- **Authentic Behavior**: Tests actual service responses and status codes
- **Contract Validation**: Ensures API contracts are correctly implemented
- **Deployment Confidence**: CI/CD tests match production behavior
- **Performance Insights**: Real latency and response characteristics
- **Error Handling**: Actual error conditions and edge cases

### Real Service Integration Costs
- **External Dependencies**: Tests require network connectivity
- **Rate Limits**: May consume API quotas during testing
- **Slower Execution**: Network calls add latency
- **Environment Management**: Requires test service configuration
- **Credential Management**: Secure handling of test credentials

### Mock Integration Benefits
- **Speed**: Fast test execution without network calls
- **Isolation**: No external dependencies
- **Controlled Scenarios**: Precise error condition testing
- **Offline Development**: Works without internet connectivity
- **Cost Efficiency**: No API usage charges

### Mock Integration Costs
- **Drift Risk**: Mocks may not match real service behavior
- **False Confidence**: Tests pass but real integration fails
- **Maintenance Overhead**: Mocks need updates when services change
- **Limited Scenarios**: May not cover all real-world edge cases

## Decision Matrix

| Test Type | Authentication | Database | Payments | Notifications | External APIs |
|-----------|---------------|----------|----------|---------------|---------------|
| **Unit Tests** | Mock | Mock | Mock | Mock | Mock |
| **Integration Tests** | Real | Real | Test Mode | Mock | Real |
| **E2E Tests** | Real | Real | Test Mode | Real | Real |
| **Performance Tests** | Real | Real | Test Mode | Mock | Real |
| **Local Development** | Real | Local | Test Mode | Mock | Mock |

## Implementation Checklist

### For Real Service Integration:
- [ ] Configure test environment credentials securely
- [ ] Set up CI/CD environment variables
- [ ] Update test expectations to match real service behavior
- [ ] Implement proper cleanup for test data
- [ ] Add retry logic for network flakiness
- [ ] Monitor API usage and rate limits

### For Mock Integration:
- [ ] Implement realistic response latency
- [ ] Match real service HTTP status codes
- [ ] Include comprehensive error scenarios
- [ ] Keep mocks synchronized with service updates
- [ ] Document mock behavior and limitations
- [ ] Provide easy toggle between mock and real

## Key Principles

1. **Match Production Behavior**: Test environments should mirror production as closely as possible
2. **Fail Fast**: Real service integration catches issues earlier in development
3. **Secure Credentials**: Use proper secret management for test environments
4. **Monitor Usage**: Track API consumption in test environments
5. **Document Decisions**: Clearly document when and why to use real vs mock services

## Anti-Patterns to Avoid

### ❌ Mock Everything
```javascript
// Don't mock services that are critical to integration validation
process.env.SUPABASE_URL = 'mock://supabase'; // May hide real integration issues
```

### ❌ Use Production Services in Tests
```javascript
// Never use production credentials or endpoints in tests
process.env.SUPABASE_URL = 'https://production.supabase.co'; // ❌ DANGEROUS
```

### ❌ Ignore Status Code Differences
```typescript
// Don't assume mock status codes match real services
expect(response.statusCode).toBe(400); // May be 401 in real service
```

### ❌ No Cleanup Strategy
```javascript
// Always clean up test data in real service environments
afterEach(async () => {
  // Clean up test users, data, etc.
});
```

This pattern ensures optimal test coverage while maintaining realistic service integration validation. 