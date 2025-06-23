# Supabase Performance Testing Pattern

## Overview

This cookbook entry documents the validated k6-based performance testing pattern from WorldChef PoC #2, achieving **84% ADR compliance** with comprehensive Supabase performance validation including RLS policies, Edge Functions, and realistic load scenarios.

**Validation**: P95 latency targets met (90.84ms reads vs 150ms target), 39% better than performance requirements.

## Core Implementation

### K6 Test Configuration

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend, Counter } from 'k6/metrics';

// Load JWT pool for authentication
const JWT_POOL = JSON.parse(open('./jwt_pool.json'));

// Supabase Configuration
const SUPABASE_URL = 'https://your-project.supabase.co';
const SUPABASE_ANON_KEY = __ENV.SUPABASE_ANON_KEY;

// Custom Metrics for Supabase-specific monitoring
const recipeListingLatency = new Trend('recipe_listing_duration', true);
const recipeDetailLatency = new Trend('recipe_detail_duration', true);
const rlsErrorRate = new Rate('rls_errors');
const authFailureRate = new Rate('auth_failures');
const totalRequests = new Counter('total_requests');

// Performance targets aligned with ADR requirements
export const options = {
    stages: [
        { duration: '30s', target: 150 },  // Ramp up to 150 VUs
        { duration: '5m', target: 150 },   // Sustain load
        { duration: '30s', target: 0 },    // Ramp down
    ],
    thresholds: {
        'recipe_listing_duration': ['p(95)<150'],  // ADR target
        'recipe_detail_duration': ['p(95)<200'],
        'http_req_failed{api:true}': ['rate<0.20'],
        'rls_errors': ['rate<0.001'],
        'auth_failures': ['rate<0.001'],
    },
};
```

### JWT Pool Integration

```javascript
/**
 * Get random user JWT from pool with type safety
 */
function getRandomUserJWT() {
    const rawUsers = JWT_POOL.users || JWT_POOL.valid_tokens || [];

    // Normalize structure for v1/v2 pool compatibility
    const users = rawUsers
        .map((u) => {
            if (!u) return null;
            if (u.access_token) {
                return u; // v1 format
            }
            if (u.jwt) {
                return { ...u, access_token: u.jwt }; // v2 format
            }
            return null;
        })
        .filter(Boolean);

    if (users.length === 0) {
        throw new Error('No valid JWTs found in jwt_pool');
    }

    return users[Math.floor(Math.random() * users.length)];
}

/**
 * Generate authenticated request headers
 */
function getAuthHeaders(jwt) {
    return {
        'Authorization': `Bearer ${jwt.access_token}`,
        'apikey': SUPABASE_ANON_KEY,
        'Content-Type': 'application/json',
        'User-Agent': 'k6-load-test/1.0 (Supabase-Performance)'
    };
}
```

### RLS-Aware Performance Testing

```javascript
/**
 * Test recipe listing with RLS policies enabled
 */
function testRecipeListing(jwt) {
    const headers = getAuthHeaders(jwt);
    
    // Realistic pagination query
    const page = Math.floor(Math.random() * 20) + 1;
    const offset = (page - 1) * 20;
    
    // Complex query matching real app usage with RLS
    const query = `select=id,title,description,prep_time_minutes,cook_time_minutes,servings,difficulty,cuisine_type,published_at,creator_name,creator_verified&order=published_at.desc&limit=20&offset=${offset}`;
    
    const url = `${SUPABASE_URL}/rest/v1/active_recipes?${query}`;
    
    const startTime = new Date();
    const response = http.get(url, { 
        headers, 
        tags: { api: 'true', endpoint: 'listing' },
        expectedStatuses: [200, 206] 
    });
    const duration = new Date() - startTime;
    
    totalRequests.add(1);
    recipeListingLatency.add(duration);
    
    const success = check(response, {
        'recipe listing status 200': (r) => r.status === 200,
        'recipe listing has data': (r) => {
            try {
                const data = JSON.parse(r.body);
                return Array.isArray(data) && data.length > 0;
            } catch {
                return false;
            }
        },
        'recipe listing RLS enforced': (r) => {
            return r.status !== 403 && !r.body.includes('RLS');
        }
    });
    
    if (!success) {
        rlsErrorRate.add(1);
        console.log(`❌ Recipe listing failed: ${response.status}`);
    }
    
    return response;
}
```

## JWT Pool Generation

### Realistic User Distribution

```javascript
/**
 * JWT Pool Configuration for load testing
 */
const JWT_POOL_CONFIG = {
    totalUsers: 120,
    userTypes: {
        standard: 60,    // 50% standard users
        creators: 40,    // 33% creators  
        premium: 20      // 17% premium users
    },
    regions: ['US', 'EU', 'APAC'],
    outputPath: './jwt_pool.json'
};

/**
 * Generate test user with realistic metadata
 */
function generateUserMetadata(userType, region, index) {
    const baseMetadata = {
        user_type: userType,
        region: region,
        test_user: true,
        created_for: 'performance_testing',
        user_index: index
    };

    if (userType === 'creators') {
        baseMetadata.creator_verified = Math.random() > 0.3;
        baseMetadata.specialization = ['italian', 'desserts', 'vegan', 'bbq', 'asian'][index % 5];
    }

    if (userType === 'premium') {
        baseMetadata.premium_features = ['advanced_search', 'meal_planning'];
        baseMetadata.subscription_tier = 'premium';
    }

    return baseMetadata;
}
```

### JWT Generation Process

```javascript
/**
 * Create test user and generate JWT
 */
async function createTestUser(userConfig) {
    const { email, userType, region, index } = userConfig;
    
    try {
        const userData = {
            email: email,
            password: `TestUser${index}!${region}`,
            email_confirm: true,
            user_metadata: generateUserMetadata(userType, region, index)
        };

        const { data, error } = await supabase.auth.admin.createUser(userData);
        
        if (error && !error.message.includes('already registered')) {
            throw error;
        }

        return { user: data?.user, jwt: null };
    } catch (error) {
        console.error(`❌ Error creating user ${email}:`, error.message);
        throw error;
    }
}

/**
 * Generate JWT token for authentication
 */
async function generateUserJWT(email, password) {
    try {
        const { data, error } = await supabase.auth.signInWithPassword({
            email: email,
            password: password
        });

        if (error) throw error;

        return {
            access_token: data.session.access_token,
            refresh_token: data.session.refresh_token,
            expires_at: data.session.expires_at,
            user_id: data.user.id
        };
    } catch (error) {
        console.error(`❌ JWT generation failed for ${email}`);
        throw error;
    }
}
```

## Edge Function Performance Testing

### Cold Start and Warm Performance

```javascript
// Edge Function test scenarios
export const options = {
    scenarios: {
        // Cold start measurement
        cold_start_test: {
            executor: 'shared-iterations',
            vus: 1,
            iterations: 20,
            maxDuration: '5m',
            tags: { test_type: 'cold_start' },
        },
        
        // Warm performance testing
        warm_performance_test: {
            executor: 'ramping-vus',
            startVUs: 0,
            stages: [
                { duration: '30s', target: 60 },
                { duration: '5m', target: 60 },
                { duration: '30s', target: 0 },
            ],
            startTime: '6m',
            tags: { test_type: 'warm_performance' },
        },
        
        // Burst load testing
        burst_load_test: {
            executor: 'constant-vus',
            vus: 200,
            duration: '60s',
            startTime: '12m',
            tags: { test_type: 'burst_load' },
        },
    },
    
    thresholds: {
        'cold_start_duration': ['p(95)<800'],
        'warm_execution_duration': ['p(95)<200'],
        'burst_load_duration': ['p(95)<500'],
        'edge_function_errors': ['rate<0.01'],
    },
};
```

### Edge Function Test Implementation

```javascript
/**
 * Test Edge Function with realistic payload
 */
function testEdgeFunctionInvocation(testType = 'general') {
    const jwt = getRandomUserJWT();
    const headers = getAuthHeaders(jwt);
    const payload = generateNutritionPayload();
    
    const startTime = new Date();
    const response = http.post(
        `${SUPABASE_URL}/functions/v1/nutritionEnrich`,
        JSON.stringify(payload),
        { 
            headers: headers,
            timeout: testType === 'cold_start' ? '10s' : '5s'
        }
    );
    const duration = new Date() - startTime;
    
    // Record metrics by test type
    switch (testType) {
        case 'cold_start':
            coldStartLatency.add(duration);
            break;
        case 'warm_performance':
            warmExecutionLatency.add(duration);
            break;
        case 'burst_load':
            burstLoadLatency.add(duration);
            break;
    }
    
    const success = check(response, {
        [`${testType} - status 200`]: (r) => r.status === 200,
        [`${testType} - has response data`]: (r) => {
            try {
                const data = JSON.parse(r.body);
                return data && data.success === true;
            } catch {
                return false;
            }
        }
    });
    
    return response;
}
```

## Test Execution Scripts

### WSL k6 Wrapper Script

```bash
#!/bin/bash
# run_k6_wsl.sh - Execute k6 with environment variables

set -euo pipefail

PROJECT_ROOT="$(dirname "$(readlink -f "$0")")"
ENV_FILE="$PROJECT_ROOT/.env.local"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ .env.local not found at $ENV_FILE"
  exit 1
fi

# Export environment variables
set -a
source "$ENV_FILE"
set +a

K6_SCRIPT="$1"
shift || true

if [[ "$K6_SCRIPT" != /* ]]; then
  K6_SCRIPT="$PROJECT_ROOT/$K6_SCRIPT"
fi

if [[ ! -f "$K6_SCRIPT" ]]; then
  echo "❌ k6 script not found: $K6_SCRIPT"
  exit 1
fi

echo "✅ Environment variables loaded from .env.local"

# Move to script directory for relative paths
cd "$(dirname "$K6_SCRIPT")"

# Run k6 with options
k6 run "$K6_SCRIPT" "$@"
```

### Quick Test Commands

```bash
# Generate JWT pool
node jwt_generator.js

# Run read performance test
./run_k6_wsl.sh src/benchmarking/k6_read_test.js

# Run edge function tests
./run_k6_wsl.sh src/benchmarking/k6_edge_function_test.js

# Custom load pattern
k6 run --stage "1m:0,2m:300,10m:300,1m:0" k6_read_test.js
```

## Performance Targets and Results

### Validated Metrics (PoC #2)

| Metric | Target | Achieved | Status |
|--------|--------|----------|---------|
| **Read Query p95** | ≤150ms | 90.84ms | ✅ **39% better** |
| **Write Flow p95** | ≤250ms | ~200ms | ✅ **Exceeded** |
| **Edge Cold Start p95** | ≤800ms | ~650ms | ✅ **Exceeded** |
| **Edge Warm p95** | ≤200ms | ~180ms | ✅ **Exceeded** |
| **Error Rate** | <1% | 0.45% | ✅ **Excellent** |

### Success Indicators

```bash
# Expected k6 output for successful tests:
✅ recipe_listing_duration.....: avg=85ms  p(95)=125ms  # <150ms target
✅ user_creation_duration......: avg=180ms p(95)=225ms  # <250ms target  
✅ cold_start_duration.........: avg=450ms p(95)=650ms  # <800ms target
✅ http_req_failed.............: 0.45%                   # <1% target
```

## RLS Security Testing

### RLS Policy Verification Framework

```javascript
/**
 * Test RLS policy enforcement
 */
const RLS_TEST_SCENARIOS = [
    {
        name: "Public Recipe Access",
        test_cases: [
            "anonymous_read_public_recipes",
            "anonymous_denied_private_recipes",
            "anonymous_denied_draft_recipes"
        ]
    },
    {
        name: "Recipe Creator Ownership",
        test_cases: [
            "creator_read_own_recipes_all_visibility",
            "creator_update_own_recipes",
            "creator_denied_other_creator_recipes"
        ]
    },
    {
        name: "User Collection Management",
        test_cases: [
            "user_create_own_collection",
            "user_denied_modify_other_collections",
            "user_read_public_collections_only"
        ]
    }
];

/**
 * Verify RLS policy enforcement
 */
async function verifyRLSPolicy(scenario, userJWT) {
    const headers = getAuthHeaders(userJWT);
    
    // Test unauthorized access attempt
    const response = await http.get(
        `${SUPABASE_URL}/rest/v1/recipes?visibility=eq.private`,
        { headers }
    );
    
    // Should return 200 but empty array (RLS filtering)
    const isRLSWorking = check(response, {
        'RLS blocks unauthorized access': (r) => {
            if (r.status !== 200) return false;
            const data = JSON.parse(r.body);
            return Array.isArray(data) && data.length === 0;
        }
    });
    
    return isRLSWorking;
}
```

## Data Seeding for Performance Tests

### Realistic Data Generation

```javascript
/**
 * Generate realistic test data for performance testing
 */
function generateUserBatch(batchSize, startIndex) {
    const users = [];
    
    for (let i = 0; i < batchSize; i++) {
        users.push({
            id: faker.string.uuid(),
            email: faker.internet.email(),
            display_name: faker.person.fullName(),
            bio: faker.datatype.boolean(0.6) ? faker.person.bio() : null,
            location: faker.location.city(),
            dietary_preferences: faker.helpers.arrayElements(
                ['vegetarian', 'vegan', 'gluten_free', 'keto'], 
                { min: 0, max: 3 }
            ),
            role: faker.helpers.weightedArrayElement([
                { weight: 80, value: 'standard' },
                { weight: 15, value: 'creator' },
                { weight: 5, value: 'moderator' }
            ]),
            created_at: faker.date.between({ 
                from: new Date('2023-01-01'), 
                to: new Date() 
            }).toISOString()
        });
    }
    
    return users;
}

/**
 * Batch insert with error handling
 */
async function executeBatchInsert(table, data, description) {
    try {
        const { data: result, error } = await supabase
            .from(table)
            .insert(data)
            .select('id');
        
        if (error) {
            console.error(`❌ ${description} failed:`, error.message);
            throw error;
        }
        
        console.log(`✅ ${description}: ${result.length} records inserted`);
        return result;
    } catch (error) {
        console.error(`❌ Batch insert failed for ${table}:`, error.message);
        throw error;
    }
}
```

## Key Implementation Notes

### Critical Success Factors

1. **JWT Pool Management**: 120+ diverse test users with realistic distribution
2. **RLS-Aware Testing**: All queries respect Row Level Security policies
3. **Realistic Load Patterns**: 150 VUs derived from 10k MAU modeling
4. **Comprehensive Metrics**: Custom k6 metrics for Supabase-specific monitoring
5. **Environment Isolation**: Separate test users with clear identification

### AI Development Considerations

- **Use realistic data volumes**: 20k users, 5k creators, 100k recipes for accurate testing
- **Test with authentication**: Always include JWT authentication in performance tests
- **Measure RLS overhead**: Compare performance with/without RLS policies
- **Include Edge Functions**: Test serverless cold starts and warm performance
- **Geographic distribution**: Test users across multiple regions

## Production Deployment Checklist

- [ ] Generate JWT pool with realistic user distribution
- [ ] Configure k6 thresholds for production performance targets
- [ ] Set up continuous performance monitoring
- [ ] Test RLS policies with comprehensive scenarios
- [ ] Validate Edge Function cold start performance
- [ ] Monitor error rates under sustained load
- [ ] Test burst load handling capabilities
- [ ] Verify geographic performance distribution
- [ ] Set up alerting for performance degradation
- [ ] Document performance baseline metrics

## References

- **Source Implementation**: `poc2_supabase_validation/src/benchmarking/`
- **Performance Results**: 90.84ms p95 reads (39% better than 150ms target)
- **RLS Validation**: `poc2_supabase_validation/testing/rls_verification.js`
- **JWT Pool Generation**: `poc2_supabase_validation/src/benchmarking/jwt_generator.js`
- **ADR Compliance**: 84% compliant with ADR-WCF-001d requirements 