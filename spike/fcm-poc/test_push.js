// Load .env.local from root directory
require('dotenv').config({ path: require('path').resolve(__dirname, '..', '..', '.env.local') });

const http = require('http');

// Test configuration
const SERVER_URL = 'http://localhost:3335';
const TEST_TOKEN = process.env.FCM_TEST_TOKEN || 'PLACEHOLDER_TOKEN';
const NUM_TESTS = 10;

function sendRequest(path, data) {
  return new Promise((resolve, reject) => {
    const postData = JSON.stringify(data);
    
    const options = {
      hostname: 'localhost',
      port: 3335,
      path: path,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData)
      }
    };

    const startTime = Date.now();
    const req = http.request(options, (res) => {
      let responseData = '';
      
      res.on('data', (chunk) => {
        responseData += chunk;
      });
      
      res.on('end', () => {
        const endTime = Date.now();
        const totalLatency = endTime - startTime;
        
        try {
          const parsedResponse = JSON.parse(responseData);
          resolve({
            statusCode: res.statusCode,
            response: parsedResponse,
            totalLatency_ms: totalLatency,
            fcmLatency_ms: parsedResponse.latency_ms || null
          });
        } catch (error) {
          reject(new Error(`Failed to parse response: ${error.message}`));
        }
      });
    });

    req.on('error', (error) => {
      reject(error);
    });

    req.write(postData);
    req.end();
  });
}

async function runSinglePushTest() {
  console.log('\n🔥 Running Single Push Notification Tests');
  console.log('==========================================');
  
  const results = [];
  
  for (let i = 1; i <= NUM_TESTS; i++) {
    try {
      console.log(`Test ${i}/${NUM_TESTS}...`);
      
      const result = await sendRequest('/push/send', {
        token: TEST_TOKEN,
        title: `Test Push #${i}`,
        body: `This is test notification number ${i}`,
        data: {
          testId: i.toString(),
          timestamp: Date.now().toString()
        }
      });
      
      results.push(result);
      
      if (result.statusCode === 200 && result.response.success) {
        console.log(`  ✅ Success - FCM: ${result.fcmLatency_ms}ms, Total: ${result.totalLatency_ms}ms`);
      } else {
        console.log(`  ❌ Failed - Status: ${result.statusCode}, Error: ${result.response.error}`);
      }
      
      // Small delay between requests
      await new Promise(resolve => setTimeout(resolve, 100));
      
    } catch (error) {
      console.log(`  ❌ Error: ${error.message}`);
      results.push({ error: error.message });
    }
  }
  
  return results;
}

async function runBatchPushTest() {
  console.log('\n📦 Running Batch Push Notification Test');
  console.log('=======================================');
  
  // Create array of test tokens (using same token multiple times for testing)
  const tokens = Array(5).fill(TEST_TOKEN);
  
  try {
    const result = await sendRequest('/push/batch', {
      tokens: tokens,
      title: 'Batch Test Notification',
      body: 'This is a batch test from WorldChef FCM validation',
      data: {
        batchTest: 'true',
        timestamp: Date.now().toString()
      }
    });
    
    if (result.statusCode === 200 && result.response.success) {
      console.log(`✅ Batch Success - ${result.response.successCount}/${tokens.length} sent`);
      console.log(`   FCM Latency: ${result.fcmLatency_ms}ms, Total: ${result.totalLatency_ms}ms`);
    } else {
      console.log(`❌ Batch Failed - Status: ${result.statusCode}, Error: ${result.response.error}`);
    }
    
    return result;
    
  } catch (error) {
    console.log(`❌ Batch Error: ${error.message}`);
    return { error: error.message };
  }
}

function calculateStats(results) {
  const successful = results.filter(r => r.statusCode === 200 && r.response && r.response.success);
  const failed = results.filter(r => r.statusCode !== 200 || !r.response || !r.response.success);
  
  if (successful.length === 0) {
    return {
      successRate: 0,
      totalTests: results.length,
      successful: 0,
      failed: failed.length
    };
  }
  
  const fcmLatencies = successful.map(r => r.fcmLatency_ms).filter(l => l !== null);
  const totalLatencies = successful.map(r => r.totalLatency_ms);
  
  const avgFcmLatency = fcmLatencies.length > 0 ? fcmLatencies.reduce((a, b) => a + b, 0) / fcmLatencies.length : 0;
  const avgTotalLatency = totalLatencies.reduce((a, b) => a + b, 0) / totalLatencies.length;
  
  const sortedFcm = fcmLatencies.sort((a, b) => a - b);
  const sortedTotal = totalLatencies.sort((a, b) => a - b);
  
  const p95FcmLatency = fcmLatencies.length > 0 ? sortedFcm[Math.floor(sortedFcm.length * 0.95)] : 0;
  const p95TotalLatency = sortedTotal[Math.floor(sortedTotal.length * 0.95)];
  
  return {
    successRate: (successful.length / results.length) * 100,
    totalTests: results.length,
    successful: successful.length,
    failed: failed.length,
    avgFcmLatency_ms: Math.round(avgFcmLatency),
    avgTotalLatency_ms: Math.round(avgTotalLatency),
    p95FcmLatency_ms: p95FcmLatency,
    p95TotalLatency_ms: p95TotalLatency,
    maxFcmLatency_ms: fcmLatencies.length > 0 ? Math.max(...fcmLatencies) : 0,
    maxTotalLatency_ms: Math.max(...totalLatencies)
  };
}

async function main() {
  console.log('🚀 WorldChef FCM Validation Test Suite');
  console.log('=====================================');
  console.log(`Server: ${SERVER_URL}`);
  console.log(`Test Token: ${TEST_TOKEN.substring(0, 20)}...`);
  console.log(`Number of Tests: ${NUM_TESTS}`);
  
  // Test server connectivity
  try {
    const http = require('http');
    const pingResult = await new Promise((resolve, reject) => {
      const req = http.get('http://localhost:3335/ping', (res) => {
        resolve({ statusCode: res.statusCode });
      });
      req.on('error', reject);
    });
    
    if (pingResult.statusCode === 200) {
      console.log('✅ Server is responding');
    } else {
      console.log('❌ Server ping failed');
      process.exit(1);
    }
  } catch (error) {
    console.log(`❌ Cannot connect to server: ${error.message}`);
    console.log('Make sure the FCM server is running: npm run dev');
    process.exit(1);
  }
  
  // Run tests
  const singleResults = await runSinglePushTest();
  const batchResult = await runBatchPushTest();
  
  // Calculate and display statistics
  console.log('\n📊 Test Results Summary');
  console.log('======================');
  
  const stats = calculateStats(singleResults);
  
  console.log(`Success Rate: ${stats.successRate.toFixed(1)}% (${stats.successful}/${stats.totalTests})`);
  console.log(`Average FCM Latency: ${stats.avgFcmLatency_ms}ms`);
  console.log(`Average Total Latency: ${stats.avgTotalLatency_ms}ms`);
  console.log(`P95 FCM Latency: ${stats.p95FcmLatency_ms}ms`);
  console.log(`P95 Total Latency: ${stats.p95TotalLatency_ms}ms`);
  console.log(`Max FCM Latency: ${stats.maxFcmLatency_ms}ms`);
  console.log(`Max Total Latency: ${stats.maxTotalLatency_ms}ms`);
  
  // Validation against targets
  console.log('\n🎯 Target Validation');
  console.log('===================');
  console.log(`Success Rate Target: ≥95% - ${stats.successRate >= 95 ? '✅ PASS' : '❌ FAIL'}`);
  console.log(`P95 Latency Target: ≤500ms - ${stats.p95FcmLatency_ms <= 500 ? '✅ PASS' : '❌ FAIL'}`);
  
  // Save results to JSON
  const finalResults = {
    timestamp: new Date().toISOString(),
    testConfig: {
      serverUrl: SERVER_URL,
      numTests: NUM_TESTS,
      testToken: TEST_TOKEN.substring(0, 20) + '...'
    },
    singlePushTests: {
      results: singleResults,
      statistics: stats
    },
    batchTest: batchResult,
    validation: {
      successRatePass: stats.successRate >= 95,
      latencyPass: stats.p95FcmLatency_ms <= 500,
      overallPass: stats.successRate >= 95 && stats.p95FcmLatency_ms <= 500
    }
  };
  
  require('fs').writeFileSync('fcm_test_results.json', JSON.stringify(finalResults, null, 2));
  console.log('\n💾 Results saved to fcm_test_results.json');
  
  if (finalResults.validation.overallPass) {
    console.log('\n🎉 FCM VALIDATION PASSED!');
    process.exit(0);
  } else {
    console.log('\n❌ FCM VALIDATION FAILED');
    process.exit(1);
  }
}

main().catch(console.error); 