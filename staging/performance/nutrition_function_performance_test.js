import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

/*
 * k6 Performance Test: Optimized Nutrition Enrichment Edge Function
 * 
 * Task: t003_execute_performance_tests (g158)
 * Target: p95 latency ≤ 300ms with cache validation
 * Function URL: https://myqhpmeprpaukgagktbn.supabase.co/functions/v1/nutrition_enrichment
 */

// Custom metrics
const cacheHitRate = new Rate('cache_hit_rate');
const cacheMissRate = new Rate('cache_miss_rate');
const processingTime = new Trend('processing_time_ms');

// Test configuration
export const options = {
  stages: [
    // Warm-up phase
    { duration: '30s', target: 2 },
    
    // Load testing phase
    { duration: '2m', target: 10 },
    
    // Peak load phase  
    { duration: '1m', target: 20 },
    
    // Cool-down phase
    { duration: '30s', target: 2 },
  ],
  
  thresholds: {
    // Performance targets
    'http_req_duration{expected_response:true}': ['p(95)<300'], // p95 < 300ms
    'http_req_duration{expected_response:true}': ['p(50)<150'], // p50 < 150ms
    'http_req_duration{expected_response:true}': ['avg<200'],   // avg < 200ms
    
    // Success rate
    'http_req_failed': ['rate<0.05'], // Error rate < 5%
    
    // Cache effectiveness
    'cache_hit_rate': ['rate>0.6'], // Cache hit rate > 60% after warm-up
  },
};

// Test data: Common ingredients for cache testing
const testIngredients = [
  // Common ingredients (should hit cache after first request)
  [
    { name: 'chicken breast', quantity: 100, unit: 'g' },
    { name: 'brown rice', quantity: 50, unit: 'g' },
    { name: 'broccoli', quantity: 80, unit: 'g' }
  ],
  [
    { name: 'salmon fillet', quantity: 120, unit: 'g' },
    { name: 'quinoa', quantity: 40, unit: 'g' },
    { name: 'spinach', quantity: 60, unit: 'g' }
  ],
  [
    { name: 'ground beef', quantity: 100, unit: 'g' },
    { name: 'sweet potato', quantity: 150, unit: 'g' },
    { name: 'carrots', quantity: 70, unit: 'g' }
  ],
  
  // Less common ingredients (likely cache misses)
  [
    { name: 'duck breast', quantity: 100, unit: 'g' },
    { name: 'forbidden rice', quantity: 50, unit: 'g' },
    { name: 'romanesco', quantity: 80, unit: 'g' }
  ],
  [
    { name: 'venison', quantity: 100, unit: 'g' },
    { name: 'teff', quantity: 40, unit: 'g' },
    { name: 'kohlrabi', quantity: 90, unit: 'g' }
  ]
];

// Function URL
const FUNCTION_URL = 'https://myqhpmeprpaukgagktbn.supabase.co/functions/v1/nutrition_enrichment';

export default function () {
  // Select random ingredient set
  const ingredients = testIngredients[Math.floor(Math.random() * testIngredients.length)];
  
  const payload = JSON.stringify({
    ingredients: ingredients
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im15cWhwbWVwcnBhdWtnYWdrdGJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3NTEzNjcsImV4cCI6MjA0OTMyNzM2N30.tUGNEkOuBJFYOoT1SgHWBOhvGNwJIZVY0LdP_wJi7cc'
    },
  };

  const startTime = Date.now();
  const response = http.post(FUNCTION_URL, payload, params);
  const endTime = Date.now();
  const requestDuration = endTime - startTime;

  // Basic response validation
  const isSuccess = check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 1000ms': (r) => r.timings.duration < 1000,
    'response has items': (r) => {
      try {
        const body = JSON.parse(r.body);
        return body.items && body.items.length > 0;
      } catch (e) {
        return false;
      }
    },
    'response has aggregate totals': (r) => {
      try {
        const body = JSON.parse(r.body);
        return body.aggregate_totals && 
               typeof body.aggregate_totals.calories === 'number';
      } catch (e) {
        return false;
      }
    },
  });

  if (isSuccess && response.status === 200) {
    try {
      const body = JSON.parse(response.body);
      
      // Track cache performance metrics
      if (body.cache_performance) {
        const hits = body.cache_performance.hits || 0;
        const misses = body.cache_performance.misses || 0;
        const total = hits + misses;
        
        if (total > 0) {
          // Record cache hit/miss rates
          for (let i = 0; i < hits; i++) {
            cacheHitRate.add(1);
          }
          for (let i = 0; i < misses; i++) {
            cacheMissRate.add(1);
          }
        }
      }
      
      // Track processing time from function
      if (body.processing_time_ms) {
        processingTime.add(body.processing_time_ms);
      }
      
      // Additional validation checks
      check(response, {
        'has cache performance data': () => body.cache_performance !== undefined,
        'has processing time': () => body.processing_time_ms !== undefined,
        'processing time reasonable': () => body.processing_time_ms < 500,
        'source is USDA_FDC': () => body.source === 'USDA_FDC',
        'has generated timestamp': () => body.generated_at !== undefined,
      });
      
      // Log cache performance for debugging
      if (body.cache_performance) {
        console.log(`Cache Performance - Hits: ${body.cache_performance.hits}, Misses: ${body.cache_performance.misses}, Hit Rate: ${body.cache_performance.hit_rate}, Processing Time: ${body.processing_time_ms}ms`);
      }
      
    } catch (e) {
      console.error('Failed to parse response body:', e.message);
    }
  } else {
    console.error(`Request failed - Status: ${response.status}, Duration: ${requestDuration}ms`);
    if (response.body) {
      console.error('Response body:', response.body);
    }
  }

  // Small delay between requests to avoid overwhelming the function
  sleep(0.1);
}

// Summary function to display results
export function handleSummary(data) {
  const cacheHits = data.metrics.cache_hit_rate ? data.metrics.cache_hit_rate.values.count : 0;
  const cacheMisses = data.metrics.cache_miss_rate ? data.metrics.cache_miss_rate.values.count : 0;
  const totalCacheRequests = cacheHits + cacheMisses;
  const cacheHitPercentage = totalCacheRequests > 0 ? (cacheHits / totalCacheRequests * 100).toFixed(1) : '0';
  
  const summary = {
    'stdout': `
=== Nutrition Function Performance Test Results ===

📊 PERFORMANCE METRICS:
- Total Requests: ${data.metrics.http_reqs.values.count}
- Success Rate: ${((1 - data.metrics.http_req_failed.values.rate) * 100).toFixed(1)}%
- Average Response Time: ${data.metrics.http_req_duration.values.avg.toFixed(2)}ms
- P50 Response Time: ${data.metrics.http_req_duration.values['p(50)'].toFixed(2)}ms
- P95 Response Time: ${data.metrics.http_req_duration.values['p(95)'].toFixed(2)}ms
- P99 Response Time: ${data.metrics.http_req_duration.values['p(99)'].toFixed(2)}ms

🎯 PERFORMANCE TARGETS:
- P95 < 300ms: ${data.metrics.http_req_duration.values['p(95)'] < 300 ? '✅ PASS' : '❌ FAIL'} (${data.metrics.http_req_duration.values['p(95)'].toFixed(2)}ms)
- P50 < 150ms: ${data.metrics.http_req_duration.values['p(50)'] < 150 ? '✅ PASS' : '❌ FAIL'} (${data.metrics.http_req_duration.values['p(50)'].toFixed(2)}ms)
- Error Rate < 5%: ${data.metrics.http_req_failed.values.rate < 0.05 ? '✅ PASS' : '❌ FAIL'} (${(data.metrics.http_req_failed.values.rate * 100).toFixed(1)}%)

💾 CACHE PERFORMANCE:
- Cache Hits: ${cacheHits}
- Cache Misses: ${cacheMisses}
- Cache Hit Rate: ${cacheHitPercentage}%
- Cache Target (>60%): ${parseFloat(cacheHitPercentage) > 60 ? '✅ PASS' : '❌ FAIL'}

⚡ FUNCTION PROCESSING:
- Avg Processing Time: ${data.metrics.processing_time_ms ? data.metrics.processing_time_ms.values.avg.toFixed(2) + 'ms' : 'N/A'}
- Max Processing Time: ${data.metrics.processing_time_ms ? data.metrics.processing_time_ms.values.max.toFixed(2) + 'ms' : 'N/A'}

🏆 OVERALL RESULT: ${
  data.metrics.http_req_duration.values['p(95)'] < 300 && 
  data.metrics.http_req_failed.values.rate < 0.05 && 
  parseFloat(cacheHitPercentage) > 60 
    ? '✅ ALL TARGETS MET' 
    : '❌ SOME TARGETS MISSED'
}
`,
  };
  
  return summary;
} 