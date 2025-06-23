# React Native Performance Testing Guide

## Overview
This guide provides step-by-step instructions for collecting React Native performance metrics that are directly comparable to the Flutter PoC measurements. The methodology ensures fair comparison between frameworks.

## Testing Environment Setup

### Required Tools
1. **Expo CLI**: For development and testing
2. **React DevTools**: For React component profiling
3. **Flipper**: For React Native performance monitoring
4. **Chrome DevTools**: For memory and JavaScript profiling
5. **Device-specific tools**: Android Studio Profiler or Xcode Instruments

### Device Requirements (Match Flutter Testing)
- **Android**: Google Pixel 5 (Android 12+) - Same as Flutter testing
- **iOS**: iPhone 11 (iOS 15+) - Same as Flutter testing
- **Network**: Stable WiFi connection
- **Background apps**: Closed for consistent results

## Performance Metrics Collection

### 1. **App Bundle Size Analysis**

#### Release Build Size
```bash
# Build release APK
npx expo build:android --type=apk

# Build iOS release
npx expo build:ios --type=archive

# Check bundle size
npx expo export --platform android
du -sh dist/
```

#### JavaScript Bundle Analysis
```bash
# Analyze bundle composition
npx expo export --platform android --dev false
npx @expo/bundle-analyzer dist/bundles/android-*.js
```

### 2. **Memory Usage Testing**

#### Android Memory Profiling
```bash
# Start app with memory profiling
adb shell am start -n com.worldchef.poc.rn/.MainActivity --es memoryProfiling true

# Monitor memory usage during recipe list scrolling
adb shell dumpsys meminfo com.worldchef.poc.rn
```

#### iOS Memory Profiling
Use Xcode Instruments with Memory Leaks and Allocations templates.

### 3. **FPS and Scrolling Performance**

#### Setup Performance Monitoring Component
Create `src/utils/PerformanceMonitor.tsx`:

```typescript
import React, { useEffect, useRef } from 'react';
import { View } from 'react-native';
import { performance } from 'react-native-performance';

export const PerformanceMonitor: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const frameCount = useRef(0);
  const startTime = useRef(performance.now());

  useEffect(() => {
    const timer = setInterval(() => {
      frameCount.current++;
      const currentTime = performance.now();
      const elapsed = currentTime - startTime.current;
      
      if (elapsed >= 1000) { // Every second
        const fps = frameCount.current / (elapsed / 1000);
        console.log(`FPS: ${fps.toFixed(2)}`);
        
        frameCount.current = 0;
        startTime.current = currentTime;
      }
    }, 16); // 60fps = ~16.67ms per frame

    return () => clearInterval(timer);
  }, []);

  return <View style={{ flex: 1 }}>{children}</View>;
};
```

#### Enable FPS Monitoring in App
Update `App.tsx`:

```typescript
import { PerformanceMonitor } from './src/utils/PerformanceMonitor';

export default function App() {
  return (
    <PerformanceMonitor>
      <ThemeProvider>
        <AppContent />
      </ThemeProvider>
    </PerformanceMonitor>
  );
}
```

### 4. **Time to Interactive (TTI) Measurement**

#### Setup TTI Tracking
Create `src/utils/TTITracker.tsx`:

```typescript
import { useEffect } from 'react';
import { performance } from 'react-native-performance';

export const useTTITracker = (screenName: string) => {
  useEffect(() => {
    const startTime = performance.now();
    
    // Mark when screen is interactive
    const timer = setTimeout(() => {
      const ttiTime = performance.now() - startTime;
      console.log(`TTI for ${screenName}: ${ttiTime.toFixed(2)}ms`);
      
      // Log to performance tracking
      performance.mark(`${screenName}-tti`);
    }, 100); // Allow for React render cycle

    return () => clearTimeout(timer);
  }, [screenName]);
};
```

#### Integrate TTI Tracking in Screens
```typescript
// In RecipeListScreen.tsx
import { useTTITracker } from '../utils/TTITracker';

const RecipeListScreen = () => {
  useTTITracker('RecipeList');
  // ... rest of component
};
```

### 5. **JavaScript Thread Performance**

#### Enable React DevTools Profiler
```typescript
// In development, wrap components with Profiler
import { Profiler } from 'react';

const onRenderCallback = (id: string, phase: string, actualDuration: number) => {
  console.log(`Component ${id} ${phase}: ${actualDuration}ms`);
};

// Wrap RecipeListScreen
<Profiler id="RecipeList" onRender={onRenderCallback}>
  <RecipeListScreen />
</Profiler>
```

## Testing Scenarios (Match Flutter Tests)

### 1. **Recipe List Scrolling Performance**

#### Test Procedure:
1. **Setup**: Load 50 recipes (same as Flutter test)
2. **Action**: Scroll from top to bottom at consistent speed
3. **Duration**: 30 seconds of continuous scrolling
4. **Metrics**: FPS, memory usage, JavaScript thread blocking

#### Data Collection:
```bash
# Enable performance monitoring
npx expo start --dev-client

# In app, navigate to recipe list
# Perform scrolling test
# Record console output for FPS data
```

### 2. **Navigation Performance**

#### Test Procedure:
1. Navigate from list to detail (10 different recipes)
2. Navigate back to list
3. Measure transition times and memory impact

### 3. **Image Loading Performance**

#### Test Procedure:
1. Clear image cache
2. Load recipe list with images
3. Measure image load times and memory usage

## Automated Performance Testing

### Performance Test Script
Create `scripts/performance-test.js`:

```javascript
const { performance } = require('react-native-performance');

class PerformanceTester {
  constructor() {
    this.metrics = {
      fps: [],
      memory: [],
      tti: [],
      imageLoad: []
    };
  }

  startTest(testName) {
    console.log(`Starting performance test: ${testName}`);
    this.testStartTime = performance.now();
  }

  recordFPS(fps) {
    this.metrics.fps.push({
      timestamp: performance.now(),
      value: fps
    });
  }

  recordMemory(memoryUsage) {
    this.metrics.memory.push({
      timestamp: performance.now(),
      value: memoryUsage
    });
  }

  endTest() {
    const duration = performance.now() - this.testStartTime;
    return {
      duration,
      averageFPS: this.calculateAverage(this.metrics.fps.map(m => m.value)),
      maxMemory: Math.max(...this.metrics.memory.map(m => m.value)),
      metrics: this.metrics
    };
  }

  calculateAverage(values) {
    return values.reduce((a, b) => a + b, 0) / values.length;
  }
}

module.exports = PerformanceTester;
```

## Data Collection & Analysis

### 1. **Collect Baseline Metrics**

Run each test 3 times and calculate averages:

```bash
# Test 1: Recipe List Scrolling
npm run test:performance:scrolling

# Test 2: Navigation Performance  
npm run test:performance:navigation

# Test 3: Image Loading
npm run test:performance:images

# Test 4: Memory Stress Test
npm run test:performance:memory
```

### 2. **Compare with Flutter Metrics**

Create comparison table matching Flutter format:

| Metric | React Native | Flutter | Difference |
|--------|-------------|---------|------------|
| **Bundle Size (Release)** | [TBD] MB | [Flutter value] MB | [%] |
| **Memory Usage (Peak)** | [TBD] MB | [Flutter value] MB | [%] |
| **Scrolling FPS (Average)** | [TBD] FPS | 59.2 FPS | [%] |
| **TTI Recipe List** | [TBD] ms | [Flutter value] ms | [%] |
| **TTI Recipe Detail** | [TBD] ms | [Flutter value] ms | [%] |
| **JavaScript Thread** | [TBD]% usage | N/A | Framework diff |

## Step-by-Step Testing Instructions

### Day 1: Setup & Baseline
1. Install performance monitoring tools
2. Enable development profiling
3. Run baseline tests on empty app
4. Document environment setup

### Day 2: Recipe List Performance
1. Load 50 recipes from mock server
2. Perform scrolling tests (3 runs)
3. Record FPS, memory, and smoothness metrics
4. Document any frame drops or stutters

### Day 3: Navigation & Detail Performance
1. Test list → detail navigation performance
2. Test detail screen rendering performance
3. Test back navigation performance
4. Measure TTI for both screens

### Day 4: Memory & Stress Testing
1. Perform extended scrolling (5+ minutes)
2. Test rapid navigation between screens
3. Monitor memory leaks and garbage collection
4. Test image caching behavior

### Day 5: Analysis & Reporting
1. Compile all metrics into comparison document
2. Analyze differences with Flutter results
3. Identify performance bottlenecks
4. Document recommendations

## Expected Deliverables

### 1. **Performance Data Summary**
Update `docs/rn_performance_data_summary.md` with:
- Bundle size analysis
- Memory usage patterns
- FPS measurements
- TTI measurements
- JavaScript thread utilization

### 2. **List Performance Report**
Update `docs/rn_list_performance.md` with:
- Scrolling performance data
- Image loading performance
- Memory usage during scrolling
- Comparison with Flutter ListView

### 3. **Comparative Analysis**
Update `docs/rn_flutter_comparative_analysis.md` with:
- Side-by-side performance comparison
- Framework-specific observations
- Performance recommendations

## Tools & Commands Quick Reference

```bash
# Start performance profiling
npx expo start --dev-client

# Enable React DevTools
npm install -g react-devtools
react-devtools

# Monitor with Flipper
open -a Flipper

# Android performance monitoring
adb shell dumpsys meminfo com.worldchef.poc.rn
adb shell dumpsys gfxinfo com.worldchef.poc.rn

# iOS performance monitoring (macOS only)
instruments -t "Time Profiler" -D trace.trace com.worldchef.poc.rn
```

## Troubleshooting

### Common Issues
- **High memory usage**: Check image caching and list virtualization
- **Low FPS**: Enable Hermes engine and check JavaScript thread
- **Slow TTI**: Optimize initial render and reduce JavaScript bundle size

### Performance Optimization Tips
- Use FlashList instead of FlatList for better scrolling
- Enable Hermes for improved JavaScript performance
- Optimize images with proper sizing and caching
- Use React.memo and useMemo for expensive calculations

---

*This guide ensures React Native performance testing follows the same rigorous methodology used for Flutter PoC evaluation, enabling fair and accurate comparison between frameworks.* 