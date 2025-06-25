import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

// Custom metrics for cache performance tracking
const cacheHitRate = new Rate('cache_hit_rate');
const warmLatency = new Rate('warm_requests_under_300ms');

export const options = {
  scenarios: {
    cache_validation: {
      executor: 'per-vu-iterations',
      vus: 1,
      iterations: 2, // First call (miss), second call (should hit)
      maxDuration: '60s',
    },
  },
  thresholds: {
    'cache_hit_rate': ['rate>=0.8'], // Expect ≥80% hit rate (will FAIL initially)
    'warm_requests_under_300ms': ['rate>=0.9'], // Expect ≥90% under 300ms (will FAIL initially)
    'http_req_duration{name:warm}': ['p(95)<300'], // p95 warm latency ≤300ms (will FAIL initially)
  },
};

const EDGE_FUNCTION_URL = 'https://myqhpmeprpaukgagktbn.supabase.co/functions/v1/nutrition_enrichment';

// Test payload with consistent ingredients for cache validation
const testPayload = {
  ingredients: [
    { name: "chicken breast", quantity: 100, unit: "g" },
    { name: "brown rice", quantity: 50, unit: "g" },
    { name: "broccoli", quantity: 75, unit: "g" }
  ]
};

export default function() {
  const iteration = __ITER;
  const isWarmRequest = iteration > 0;
  
  console.log(`Iteration ${iteration}: ${isWarmRequest ? 'WARM' : 'COLD'} request`);
  
  const params = {
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${__ENV.SUPABASE_ANON_KEY}`,
    },
    tags: { name: isWarmRequest ? 'warm' : 'cold' },
  };

  const startTime = Date.now();
  const response = http.post(EDGE_FUNCTION_URL, JSON.stringify(testPayload), params);
  const endTime = Date.now();
  const latency = endTime - startTime;

  // Basic response validation
  const responseChecks = check(response, {
    'status is 200': (r) => r.status === 200,
    'response has items': (r) => {
      try {
        const body = JSON.parse(r.body);
        return Array.isArray(body.items) && body.items.length > 0;
      } catch (e) {
        return false;
      }
    },
    'response has cache_performance': (r) => {
      try {
        const body = JSON.parse(r.body);
        return body.cache_performance && 
               typeof body.cache_performance.hit_rate === 'string';
      } catch (e) {
        return false;
      }
    },
  });

  if (response.status === 200) {
    try {
      const body = JSON.parse(response.body);
      const hitRate = parseFloat(body.cache_performance.hit_rate.replace('%', '')) / 100;
      
      console.log(`Cache hit rate: ${body.cache_performance.hit_rate}`);
      console.log(`Processing time: ${body.processing_time_ms}ms`);
      console.log(`Total latency: ${latency}ms`);
      
      // Track cache performance
      cacheHitRate.add(hitRate);
      
      // Track warm request latency performance
      if (isWarmRequest) {
        warmLatency.add(latency < 300);
        console.log(`Warm request latency check: ${latency}ms ${latency < 300 ? 'PASS' : 'FAIL'}`);
      }
      
    } catch (e) {
      console.error('Failed to parse response body:', e);
    }
  } else {
    console.error(`Request failed with status ${response.status}: ${response.body}`);
  }

  // Small delay between iterations to ensure cache write completes
  if (!isWarmRequest) {
    sleep(2);
  }
}

export function handleSummary(data) {
  const cacheHitRateValue = data.metrics.cache_hit_rate?.values?.rate || 0;
  const warmLatencySuccess = data.metrics.warm_requests_under_300ms?.values?.rate || 0;
  const p95Latency = data.metrics['http_req_duration{name:warm}']?.values?.['p(95)'] || 0;

  console.log('\n=== EDGE FUNCTION CACHE TEST RESULTS ===');
  console.log(`Cache Hit Rate: ${(cacheHitRateValue * 100).toFixed(1)}% (Target: ≥80%)`);
  console.log(`Warm Requests Under 300ms: ${(warmLatencySuccess * 100).toFixed(1)}% (Target: ≥90%)`);
  console.log(`Warm P95 Latency: ${p95Latency.toFixed(1)}ms (Target: ≤300ms)`);
  
  const testResults = {
    cache_hit_rate_pct: (cacheHitRateValue * 100).toFixed(1),
    warm_latency_success_pct: (warmLatencySuccess * 100).toFixed(1),
    warm_p95_latency_ms: p95Latency.toFixed(1),
    test_status: (cacheHitRateValue >= 0.8 && warmLatencySuccess >= 0.9 && p95Latency <= 300) ? 'PASS' : 'FAIL',
    timestamp: new Date().toISOString(),
  };

  return {
    'stdout': JSON.stringify(testResults, null, 2),
    'edge_function_cache_test_results.json': JSON.stringify(testResults, null, 2),
  };
} 