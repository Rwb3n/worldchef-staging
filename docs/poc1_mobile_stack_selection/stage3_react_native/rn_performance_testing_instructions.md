# React Native Performance Testing Instructions

## Overview
This document provides step-by-step instructions for collecting React Native performance metrics that are directly comparable to the Flutter PoC results. Follow these instructions to gather comprehensive performance data.

## 🚀 Quick Start

### 1. **Setup Performance Monitoring** (Already Done ✅)
The React Native app now includes:
- ✅ **FPS Monitoring**: Real-time frame rate tracking
- ✅ **TTI Tracking**: Time to Interactive measurement for each screen
- ✅ **Memory Tracking**: Component lifecycle monitoring
- ✅ **Automated Scripts**: Performance test runner and bundle analyzer

### 2. **Start Performance Data Collection**

#### Start the App with Monitoring:
```bash
cd worldchef_poc_rn
npm start
```

#### Enable Performance Monitoring:
The app automatically starts performance monitoring when loaded. You'll see console output like:
```
🎯 FPS: 59.23 | Avg: 58.45
⚡ TTI for RecipeList: 234.56ms
🧠 Component RecipeListScreen active for: 1205ms
```

### 3. **Perform Testing Scenarios**

#### Scenario 1: Recipe List Scrolling (Match Flutter Test)
1. **Navigate** to the recipe list screen
2. **Scroll continuously** for 30+ seconds from top to bottom
3. **Record FPS data** from console output
4. **Note any frame drops** or stuttering

#### Scenario 2: Navigation Performance
1. **Navigate** from list to detail (test 10 different recipes)
2. **Navigate back** to list each time
3. **Record TTI measurements** for both screens
4. **Monitor memory usage** during navigation

#### Scenario 3: Image Loading Performance
1. **Clear app cache** (restart app)
2. **Load recipe list** and observe image loading
3. **Scroll through all images**
4. **Monitor memory usage** during image loading

### 4. **Collect Bundle Size Data**

#### Generate Production Bundle:
```bash
npm run build:bundle
```

#### Analyze Bundle Size:
```bash
npm run analyze:bundle
```

### 5. **Run Performance Analysis**

#### Generate Performance Report:
```bash
npm run test:performance
```

This generates a comprehensive report with:
- Bundle size analysis
- TTI measurements from app usage
- Memory usage patterns
- Comparison framework with Flutter metrics

## 📊 Expected Performance Metrics

### Target Measurements (To Compare with Flutter)

| Metric | Target | Flutter Baseline | Notes |
|--------|---------|------------------|-------|
| **Scrolling FPS** | 58+ FPS | 59.2 FPS | During 30s scroll test |
| **TTI Recipe List** | <800ms | [Flutter value] | Time to interactive |
| **TTI Recipe Detail** | <600ms | [Flutter value] | Screen navigation |
| **Bundle Size (Release)** | <5MB | [Flutter value] | Production build |
| **Memory Usage (Peak)** | <80MB | [Flutter value] | During scrolling |

### Data Collection Process

#### 1. **Live Performance Monitoring**
While using the app, console logs provide real-time metrics:
```
Console Output Examples:
🎯 FPS: 59.23 | Avg: 58.45        # Frame rate during scrolling
⚡ TTI for RecipeList: 234.56ms    # Screen load time
🧠 Component active for: 1205ms    # Memory lifecycle tracking
```

#### 2. **Performance Report Generation**
```bash
npm run test:performance
```

Sample Output:
```
📦 Bundle Size:
   • Total Size: 2.8 MB

⚡ Time to Interactive:
   • RecipeList: 245ms
   • RecipeDetail: 189ms

🧠 Memory Tracking:
   • RecipeListScreen: 2340ms active
   • RecipeDetailScreen: 1890ms active
```

## 🔧 Detailed Testing Procedures

### Test 1: Scrolling Performance (Primary Test)

#### Procedure:
1. **Setup**: Ensure 50 recipes loaded from mock server
2. **Action**: Scroll from top to bottom at consistent speed
3. **Duration**: 30 seconds continuous scrolling
4. **Collect**: Average FPS, minimum FPS, frame drops

#### Expected Console Output:
```
🎯 FPS: 59.45 | Avg: 58.92
🎯 FPS: 58.23 | Avg: 58.85
🎯 FPS: 59.01 | Avg: 58.90
📊 Performance Summary:
   Average FPS: 58.90
   Min FPS: 57.12
   Max FPS: 60.00
   Total samples: 30
```

### Test 2: Navigation Performance

#### Procedure:
1. **Navigate**: List → Detail (10 different recipes)
2. **Navigate**: Detail → List (back button)
3. **Measure**: TTI for each navigation
4. **Record**: Navigation timing patterns

#### Expected Console Output:
```
⚡ TTI for RecipeDetail: 189ms
⚡ TTI for RecipeList: 156ms
⚡ TTI for RecipeDetail: 201ms
```

### Test 3: Memory and Bundle Analysis

#### Bundle Size Analysis:
```bash
# 1. Generate production bundle
npm run build:bundle

# 2. Analyze bundle composition
npm run analyze:bundle

# 3. Check total size
du -sh dist/
```

#### Memory Monitoring:
- Monitor component lifecycle durations
- Track memory usage patterns during scrolling
- Identify potential memory leaks

## 📈 Results Documentation

### 1. **Update Performance Data Summary**
After collecting metrics, update `docs/rn_performance_data_summary.md`:

```markdown
| Metric | Value | Flutter Comparison |
|--------|-------|-------------------|
| Scrolling FPS (Average) | 58.90 | 59.2 (Flutter) |
| TTI Recipe List | 245ms | [Flutter value] |
| TTI Recipe Detail | 189ms | [Flutter value] |
| Bundle Size (Release) | 2.8MB | [Flutter value] |
| Memory Usage (Peak) | 67MB | [Flutter value] |
```

### 2. **Update List Performance Report**
Update `docs/rn_list_performance.md`:

```markdown
## Performance Results

### Scrolling Performance
- **Average FPS**: 58.90
- **Minimum FPS**: 57.12
- **Frame Drops**: 2.3% of frames
- **Smoothness**: Excellent

### Image Loading
- **Initial Load**: ~150ms per image
- **Cache Performance**: <50ms subsequent loads
- **Memory Impact**: +12MB during image loading
```

### 3. **Update Comparative Analysis**
Update `docs/rn_flutter_comparative_analysis.md` with head-to-head comparison.

## 🛠️ Troubleshooting

### Common Issues

#### Low FPS Performance
```bash
# Check if Hermes is enabled
grep -r "hermes" android/app/build.gradle
# Should show: hermesEnabled: true
```

#### High Memory Usage
- Check FlashList configuration
- Verify image caching settings
- Monitor component unmounting

#### Bundle Size Issues
```bash
# Analyze large dependencies
npm run analyze:bundle
# Review bundle composition and optimize
```

## 🎯 Success Criteria

### Performance Targets
- ✅ **FPS**: >58 FPS average during scrolling
- ✅ **TTI**: <800ms for list screen, <600ms for detail screen
- ✅ **Bundle**: <5MB production build
- ✅ **Memory**: <80MB peak usage
- ✅ **Smoothness**: <5% frame drops during testing

### Comparison Quality
- ✅ **Same Devices**: Use Google Pixel 5 & iPhone 11 (matching Flutter tests)
- ✅ **Same Scenarios**: 30s scrolling, navigation testing, image loading
- ✅ **Same Metrics**: FPS, TTI, memory, bundle size
- ✅ **Same Methodology**: Consistent testing procedures

## 📋 Complete Testing Checklist

- [ ] **App Setup**: Performance monitoring enabled
- [ ] **Mock Server**: Running with 50 recipes
- [ ] **Device Setup**: Same devices as Flutter testing
- [ ] **Baseline Test**: Initial performance measurement
- [ ] **Scrolling Test**: 30s continuous scroll (3 runs)
- [ ] **Navigation Test**: List↔Detail performance (10 cycles)
- [ ] **Memory Test**: Extended usage monitoring
- [ ] **Bundle Analysis**: Production build size measurement
- [ ] **Report Generation**: Performance report created
- [ ] **Documentation**: All metrics documented and compared
- [ ] **Validation**: Results verified against Flutter baseline

## 🔗 Related Documentation

- **Setup Guide**: `docs/rn_performance_testing_guide.md`
- **Flutter Comparison**: `docs/flutter_performance_data_summary.md`
- **List Performance**: `docs/flutter_list_performance.md`
- **Comparative Analysis**: `docs/rn_flutter_comparative_analysis.md`

---

*This testing procedure ensures React Native performance data is collected using the same rigorous methodology as the Flutter PoC, enabling accurate framework comparison.* 