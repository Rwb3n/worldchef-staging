# Flutter PoC Quick Testing Guide - WorldChef

> **📋 Navigation**: This document is part of the WorldChef PoC documentation suite. See [Stage 1 Onboarding Guide](./stage1_onboarding_guide.md) for complete project overview and navigation.

## 🚀 Quick Test Setup

### Prerequisites
1. **Mock Server Running**: `cd worldchef_poc_mock_server && npm start`
2. **Flutter App**: `cd worldchef_poc_flutter && flutter run`
3. **Device/Emulator**: Android, iOS, or Web browser

### Essential Test Scenarios (5 minutes)

#### 📱 Basic App Flow
```
✓ App launches to recipe list screen
✓ 50 recipe cards load with images
✓ Smooth scrolling (visually confirm 60 FPS)
✓ Search "pizza" filters recipes
✓ Tap recipe card → navigates to detail
✓ Back button returns to list
```

#### 🎨 Theme & State Testing
```
✓ Tap theme toggle (top-right): Light → Dark → System
✓ Theme changes immediately
✓ Close app, reopen → theme persists
✓ SnackBar shows theme change confirmation
```

#### 🔌 Offline Testing
```
✓ Toggle offline mode (switch in app)
✓ Recipes still display (cached data)
✓ Navigate to recipe detail → data loads
✓ Toggle back online → app updates
```

---

## 🔧 Performance Quick Check

### Frame Rate Validation
- **Visual Test**: Scroll list rapidly - should feel smooth
- **No Frame Drops**: Scrolling shouldn't stutter or lag
- **Hero Animations**: List→Detail transition smooth

### Memory Check (DevTools)
- Launch Flutter DevTools: `flutter pub global run devtools`
- Memory tab: Usage should stay <200MB
- No continuous memory growth during usage

---

## ♿ Accessibility Quick Test

### Screen Reader (Optional)
- **iOS**: Settings → Accessibility → VoiceOver
- **Android**: Settings → Accessibility → TalkBack
- Navigate app with swipe gestures
- All elements should be announced

### Visual Check
- All buttons have clear labels
- Images have descriptive semantics
- Focus order follows visual layout

---

## 🌍 i18n Quick Test

### Language Testing
```
1. Device Settings → Language → Spanish
2. Restart app → verify Spanish text
3. Check pluralization: "1 ingrediente" vs "2 ingredientes"
4. Switch to Arabic → verify RTL layout
5. Switch back to English
```

---

## 🐛 Common Issues & Quick Fixes

### Compilation Errors
| Error | Quick Fix |
|-------|-----------|
| **Generic type T not found** | Check `extension ApiExceptionHandling<T> on Future<T>` |
| **ApiException abstract** | Change to `class ApiException` |
| **RouterConfig conflict** | Rename to `AppRouterConfig` |
| **location property error** | Use `matchedLocation` instead |

### Runtime Issues
| Issue | Check |
|-------|-------|
| **No recipes loading** | Mock server running on localhost:3000? |
| **Images not showing** | Internet connection for cached_network_image? |
| **Theme not persisting** | SharedPreferences working? |
| **Navigation broken** | Check go_router version compatibility |

---

## 📊 Performance Targets

### Must Meet (Critical)
- ✅ **Scrolling**: >58 FPS
- ✅ **Memory**: <200MB
- ✅ **Launch**: <1.5 seconds to interactive
- ✅ **Navigation**: <300ms transitions

### Should Meet (Quality)
- 🎯 **Frame Time**: <17ms (95th percentile)
- 🎯 **Cache Operations**: <100ms
- 🎯 **Theme Switch**: <200ms

---

## 🧪 Testing Commands

### Unit Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/recipe_test.dart

# Run with coverage
flutter test --coverage
```

### Integration Tests
```bash
# Run integration tests
flutter test integration_test/

# Run on specific device
flutter test integration_test/ -d <device_id>
```

### Performance Testing
```bash
# Launch with performance mode
flutter run --profile

# Enable performance overlay
flutter run --enable-software-rendering
```

---

## 📋 Testing Checklist

### Pre-Release Validation
```
□ All 50 recipes load and display correctly
□ Search functionality works across all recipes
□ Navigation smooth with hero animations
□ Theme toggle cycles and persists correctly
□ Offline mode shows cached data
□ App restart preserves user preferences
□ Performance smooth (no visible lag/stutter)
□ Accessibility labels present and descriptive
□ Multi-language support working
□ Error handling graceful (airplane mode test)
```

### Device Matrix (Optional)
```
□ Android Phone (API 31+)
□ Android Tablet
□ iOS Phone (iOS 15+)
□ iOS Tablet
□ Web Browser (Chrome/Safari)
□ Windows Desktop (if enabled)
```

---

## 🔍 Debug Tools

### Flutter Inspector
- Widget tree visualization
- Property inspection
- Layout debugging

### Flutter DevTools
- Performance profiling
- Memory analysis
- Network requests
- Logging output

### Console Commands
```bash
# Hot reload
r

# Hot restart
R

# Debug paint (layout boundaries)
p

# Widget inspector
w

# Quit
q
```

---

## 📞 Getting Help

### Logs Location
- **Flutter**: Run with `flutter run -v` for verbose logs
- **Mock Server**: Check console output for API request logs
- **Device Logs**: Use `flutter logs` for device-specific logs

### Common Debug Steps
1. **Clean Build**: `flutter clean && flutter pub get`
2. **Check Dependencies**: `flutter doctor`
3. **Restart Mock Server**: Stop and `npm start` again
4. **Device Restart**: Close app completely and reopen

---

**Quick Test Time**: ~5 minutes for basic validation  
**Full Test Suite**: ~15 minutes for comprehensive testing  
**Performance Test**: ~10 minutes with DevTools  

**Last Updated**: January 6, 2025

---

## Related Documentation

- **[Flutter Testing Procedures](./flutter_testing_procedures.md)** - Comprehensive testing methodology and detailed results
- **[Flutter Testing Summary](./flutter_testing_summary.md)** - Key testing achievements and metrics overview  
- **[Stage 1 Onboarding Guide](./stage1_onboarding_guide.md)** - Complete project documentation and navigation 