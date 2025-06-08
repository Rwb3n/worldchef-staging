#!/usr/bin/env node

/**
 * Performance Testing Script for React Native PoC
 * 
 * This script provides automated performance testing capabilities
 * to collect metrics comparable to Flutter PoC testing.
 */

const fs = require('fs');
const path = require('path');

class ReactNativePerformanceTester {
  constructor() {
    this.results = {
      bundleSize: {},
      performance: {},
      memory: {},
      timestamps: {}
    };
    this.startTime = Date.now();
  }

  log(message) {
    const timestamp = new Date().toISOString();
    console.log(`[${timestamp}] ${message}`);
  }

  async runBundleSizeTest() {
    this.log('🏗️  Running bundle size analysis...');
    
    try {
      // Check if build exists
      const distPath = path.join(__dirname, '../dist');
      if (fs.existsSync(distPath)) {
        const stats = fs.statSync(distPath);
        this.results.bundleSize.totalSize = this.formatBytes(stats.size);
        this.log(`   Total bundle size: ${this.results.bundleSize.totalSize}`);
      } else {
        this.log('   ⚠️  No bundle found. Run: npx expo export --platform android');
        this.results.bundleSize.note = 'Bundle not found - run expo export first';
      }
    } catch (error) {
      this.log(`   ❌ Bundle size test failed: ${error.message}`);
    }
  }

  async runMemoryTest() {
    this.log('🧠 Running memory analysis...');
    
    // Check for performance metrics from global storage
    const metricsPath = path.join(__dirname, '../performance-metrics.json');
    if (fs.existsSync(metricsPath)) {
      const metrics = JSON.parse(fs.readFileSync(metricsPath, 'utf8'));
      this.results.memory = metrics.memory || {};
      this.log(`   Found ${Object.keys(this.results.memory).length} memory metrics`);
    } else {
      this.log('   ℹ️  Run app with performance monitoring to collect memory data');
    }
  }

  async runPerformanceTest() {
    this.log('⚡ Analyzing performance metrics...');
    
    // Check for FPS and TTI data from console logs or stored metrics
    const metricsPath = path.join(__dirname, '../performance-metrics.json');
    if (fs.existsSync(metricsPath)) {
      const metrics = JSON.parse(fs.readFileSync(metricsPath, 'utf8'));
      this.results.performance = {
        tti: metrics.tti || {},
        fps: metrics.fps || 'Run app with performance monitor',
        navigation: metrics.navigation || {}
      };
      this.log(`   TTI metrics: ${Object.keys(this.results.performance.tti).length} screens`);
    } else {
      this.log('   ℹ️  Performance metrics will be collected during app usage');
    }
  }

  formatBytes(bytes, decimals = 2) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const dm = decimals < 0 ? 0 : decimals;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
  }

  generateReport() {
    const reportPath = path.join(__dirname, '../performance-report.json');
    const reportData = {
      testDate: new Date().toISOString(),
      framework: 'React Native',
      expo_version: '53.0.0',
      react_native_version: '0.79.3',
      device: 'To be filled manually',
      results: this.results,
      instructions: {
        next_steps: [
          '1. Start the app: npm start',
          '2. Navigate through screens to collect TTI data',
          '3. Scroll through recipe list for 30+ seconds',
          '4. Check console for FPS measurements',
          '5. Re-run this script to update metrics'
        ],
        comparison_needed: {
          flutter_fps: '59.2 FPS average',
          flutter_tti: 'Check Flutter performance docs',
          flutter_bundle: 'Check Flutter bundle size'
        }
      }
    };

    fs.writeFileSync(reportPath, JSON.stringify(reportData, null, 2));
    this.log(`📊 Report saved to: ${reportPath}`);
    
    return reportData;
  }

  async run() {
    this.log('🚀 Starting React Native Performance Test Suite');
    this.log('================================================');
    
    await this.runBundleSizeTest();
    await this.runMemoryTest();
    await this.runPerformanceTest();
    
    const report = this.generateReport();
    
    this.log('================================================');
    this.log('📈 Performance Test Results Summary:');
    console.log('');
    
    // Bundle Size
    console.log('📦 Bundle Size:');
    if (report.results.bundleSize.totalSize) {
      console.log(`   • Total Size: ${report.results.bundleSize.totalSize}`);
    } else {
      console.log('   • Total Size: Run expo export to measure');
    }
    console.log('');
    
    // TTI Results
    console.log('⚡ Time to Interactive:');
    const ttiData = report.results.performance.tti || {};
    if (Object.keys(ttiData).length > 0) {
      Object.entries(ttiData).forEach(([screen, time]) => {
        console.log(`   • ${screen}: ${time}ms`);
      });
    } else {
      console.log('   • Use the app to collect TTI data');
    }
    console.log('');
    
    // Memory Results
    console.log('🧠 Memory Tracking:');
    const memoryData = report.results.memory || {};
    if (Object.keys(memoryData).length > 0) {
      Object.entries(memoryData).forEach(([component, duration]) => {
        console.log(`   • ${component}: ${duration}ms active`);
      });
    } else {
      console.log('   • Use the app to collect memory data');
    }
    console.log('');
    
    console.log('📋 Next Steps:');
    report.instructions.next_steps.forEach((step, index) => {
      console.log(`   ${index + 1}. ${step}`);
    });
    
    console.log('');
    console.log('🔗 For comparison with Flutter metrics, see:');
    console.log('   • docs/flutter_performance_data_summary.md');
    console.log('   • docs/flutter_list_performance.md');
    
    this.log(`✅ Performance test completed in ${Date.now() - this.startTime}ms`);
  }
}

// Run the performance test
if (require.main === module) {
  const tester = new ReactNativePerformanceTester();
  tester.run().catch(error => {
    console.error('❌ Performance test failed:', error);
    process.exit(1);
  });
}

module.exports = ReactNativePerformanceTester; 