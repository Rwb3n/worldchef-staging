import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend, Counter } from 'k6/metrics';
import { scenario } from 'k6/execution';

/*
 * Fastify Backend Performance Test
 * 
 * Based on: docs/cookbook/fastify_comprehensive_testing_pattern.md
 * Task: t004_k6_test_creation (g116)
 * Target: p95 latency ≤ 200ms under 100 virtual users
 * 
 * Validation Track requirement for Cycle 4 MVP backend validation
 */

// Backend Configuration
const BACKEND_URL = __ENV.BACKEND_URL || 'http://localhost:10000';
const TARGET_ENDPOINT = '/v1/status';

// Custom Metrics for Fastify backend monitoring
const coldStartLatency = new Trend('cold_start_duration', true);
const warmExecutionLatency = new Trend('warm_execution_duration', true);
const burstLoadLatency = new Trend('burst_load_duration', true);
const backendErrors = new Rate('backend_errors');
const totalRequests = new Counter('total_requests');
const successfulRequests = new Counter('successful_requests');

// Performance targets aligned with Cycle 4 Validation Track requirements
export const options = {
    scenarios: {
        // Cold start measurement (server initialization)
        cold_start_test: {
            executor: 'shared-iterations',
            vus: 1,
            iterations: 5,
            maxDuration: '30s',
            tags: { test_type: 'cold_start' },
        },
        
        // Warm performance testing (main validation - 100 VUs requirement)
        warm_performance_test: {
            executor: 'ramping-vus',
            startVUs: 0,
            stages: [
                { duration: '30s', target: 10 },    // Initial ramp
                { duration: '1m', target: 50 },     // Mid-scale load
                { duration: '1m', target: 100 },    // Target load (100 VUs)
                { duration: '2m', target: 100 },    // Sustained target load
                { duration: '30s', target: 0 },     // Ramp down
            ],
            startTime: '40s',    // starts after cold start finishes
            tags: { test_type: 'warm_performance' },
        },
        
        // Burst load testing (stress beyond target)
        burst_load_test: {
            executor: 'constant-vus',
            vus: 150,
            duration: '60s',
            startTime: '6m10s',  // starts 30s after warm performance completes
            tags: { test_type: 'burst_load' },
        },
    },
    
    thresholds: {
        // Primary requirement: p95 latency ≤200ms under 100 VUs
        'warm_execution_duration': [
            'p(95)<200',  // CRITICAL: Validation Track requirement
            'p(50)<100',  // Secondary target for good UX
            'avg<120'     // Average target
        ],
        
        // Additional performance targets
        'cold_start_duration': ['p(95)<500'],      // Cold start allowance
        'burst_load_duration': ['p(95)<300'],      // Burst handling
        'backend_errors': ['rate<0.01'],           // <1% error rate
        'http_req_failed': ['rate<0.01'],          // <1% HTTP failures
        
        // Success rate requirements
        'checks': ['rate>0.99'],                   // >99% check success rate
    },
};

/**
 * Generate request headers for Fastify backend
 */
function getRequestHeaders() {
    return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'k6-fastify-test/1.0 (Validation-Track)',
        'Connection': 'keep-alive'
    };
}

/**
 * Test Fastify status endpoint with comprehensive validation
 */
function testFastifyStatus(testType = 'general') {
    const headers = getRequestHeaders();
    
    const startTime = new Date();
    const response = http.get(
        `${BACKEND_URL}${TARGET_ENDPOINT}`,
        { 
            headers: headers,
            timeout: testType === 'cold_start' ? '5s' : '3s',
            tags: { 
                api: 'true', 
                endpoint: 'status',
                test_type: testType 
            }
        }
    );
    const duration = new Date() - startTime;
    
    totalRequests.add(1);
    
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
    
    // Comprehensive validation checks
    const success = check(response, {
        [`${testType} - status 200`]: (r) => r.status === 200,
        [`${testType} - response time reasonable`]: (r) => r.timings.duration < (testType === 'cold_start' ? 2000 : 1000),
        [`${testType} - content type JSON`]: (r) => r.headers['Content-Type'] && r.headers['Content-Type'].includes('application/json'),
        [`${testType} - has status field`]: (r) => {
            try {
                const body = JSON.parse(r.body);
                return body.status === 'ok';
            } catch (e) {
                return false;
            }
        },
        [`${testType} - response body valid`]: (r) => {
            try {
                const body = JSON.parse(r.body);
                return typeof body === 'object' && body !== null;
            } catch (e) {
                return false;
            }
        }
    });
    
    if (success) {
        successfulRequests.add(1);
    } else {
        backendErrors.add(1);
    }
    
    // Log errors for debugging
    if (response.status !== 200) {
        console.error(`${testType} - HTTP ${response.status}: ${response.body}`);
    }
    
    return response;
}

/**
 * Test additional endpoints for comprehensive validation
 */
function testFastifyDocumentation(testType = 'general') {
    const headers = getRequestHeaders();
    
    // Test OpenAPI spec endpoint
    const openapiResponse = http.get(
        `${BACKEND_URL}/docs/json`,
        { 
            headers: headers,
            timeout: '3s',
            tags: { 
                api: 'true', 
                endpoint: 'openapi',
                test_type: testType 
            }
        }
    );
    
    check(openapiResponse, {
        [`${testType} - OpenAPI spec accessible`]: (r) => r.status === 200,
        [`${testType} - OpenAPI spec is JSON`]: (r) => {
            try {
                const body = JSON.parse(r.body);
                return body.openapi && body.info;
            } catch (e) {
                return false;
            }
        }
    });
    
    // Test Swagger UI endpoint (lighter check)
    if (Math.random() < 0.1) { // Only 10% of the time to avoid overloading
        const swaggerResponse = http.get(
            `${BACKEND_URL}/docs`,
            { 
                headers: { ...headers, 'Accept': 'text/html' },
                timeout: '3s',
                tags: { 
                    api: 'true', 
                    endpoint: 'swagger_ui',
                    test_type: testType 
                }
            }
        );
        
        check(swaggerResponse, {
            [`${testType} - Swagger UI accessible`]: (r) => r.status === 200,
            [`${testType} - Swagger UI is HTML`]: (r) => r.body.includes('<title>Swagger UI</title>')
        });
    }
}

// Test scenarios execution functions
export function setup() {
    console.log('🚀 Starting Fastify Backend Performance Test');
    console.log(`📍 Target: ${BACKEND_URL}${TARGET_ENDPOINT}`);
    console.log('🎯 Goal: p95 latency ≤200ms under 100 VUs');
    
    // Warm-up request to ensure server is ready
    const warmupResponse = http.get(`${BACKEND_URL}${TARGET_ENDPOINT}`);
    if (warmupResponse.status !== 200) {
        console.error(`❌ Warmup failed: HTTP ${warmupResponse.status}`);
        throw new Error('Backend not accessible for testing');
    }
    
    console.log('✅ Backend accessible, starting load test...');
    return { backend_url: BACKEND_URL };
}

export default function () {
    const testType = scenario.name.replace('_test', '');
    
    // Primary test: Status endpoint
    testFastifyStatus(testType);
    
    // Secondary test: Documentation endpoints (less frequent)
    if (Math.random() < 0.2) { // 20% of requests
        testFastifyDocumentation(testType);
    }
    
    // Realistic think time between requests
    sleep(Math.random() * 0.5 + 0.1); // 0.1-0.6 seconds
}

export function teardown(data) {
    console.log('🏁 Fastify Backend Performance Test Complete');
}

export function handleSummary(data) {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const filename = `k6_fastify_results_${timestamp}.json`;
    
    // Extract key metrics for summary
    const warmP95 = data.metrics.warm_execution_duration?.values?.['p(95)'];
    const warmAvg = data.metrics.warm_execution_duration?.values?.avg;
    const errorRate = data.metrics.backend_errors?.values?.rate || 0;
    const totalReqs = data.metrics.total_requests?.values?.count || 0;
    const successReqs = data.metrics.successful_requests?.values?.count || 0;
    
    console.log('\n📊 FASTIFY PERFORMANCE SUMMARY');
    console.log('================================');
    console.log(`🎯 Target: p95 ≤200ms under 100 VUs`);
    console.log(`📈 Warm p95: ${warmP95 ? warmP95.toFixed(2) + 'ms' : 'N/A'} ${warmP95 <= 200 ? '✅' : '❌'}`);
    console.log(`📊 Warm avg: ${warmAvg ? warmAvg.toFixed(2) + 'ms' : 'N/A'}`);
    console.log(`🔥 Error rate: ${(errorRate * 100).toFixed(2)}% ${errorRate < 0.01 ? '✅' : '❌'}`);
    console.log(`📋 Total requests: ${totalReqs}`);
    console.log(`✅ Successful: ${successReqs} (${totalReqs > 0 ? ((successReqs/totalReqs)*100).toFixed(1) : 0}%)`);
    
    const validationStatus = warmP95 <= 200 && errorRate < 0.01 ? 'PASSED' : 'FAILED';
    console.log(`\n🏆 VALIDATION: ${validationStatus}`);
    
    return {
        [`staging/performance/${filename}`]: JSON.stringify(data, null, 2),
        stdout: JSON.stringify({
            summary: {
                validation_status: validationStatus,
                warm_p95_ms: warmP95,
                warm_avg_ms: warmAvg,
                error_rate_percent: errorRate * 100,
                total_requests: totalReqs,
                successful_requests: successReqs,
                target_met: warmP95 <= 200,
                timestamp: new Date().toISOString()
            }
        }, null, 2)
    };
} 