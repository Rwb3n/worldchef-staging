/* ANNOTATION_BLOCK_START
{
  "artifact_id": "worldchef_poc_device_config",
  "version_tag": "1.0.0-setup",
  "g_created": 8,
  "g_last_modified": 8,
  "description": "Comprehensive guide for configuring physical test devices, emulators, and simulators for both Flutter and React Native PoC testing with network simulation capabilities.",
  "artifact_type": "DOCUMENTATION",
  "status_in_lifecycle": "PRODUCTION",
  "purpose_statement": "Ensures consistent and correctly configured testing environments across both PoCs, including driver setup, OS versions, network simulation, and deployment prerequisites.",
  "key_logic_points": [
    "Physical device configuration for Android (Google Pixel 5) and iOS (iPhone 11)",
    "Android emulator setup with API level 31+ for consistent testing",
    "iOS simulator setup with iOS 15+ runtime installation",
    "Network simulation configuration for realistic testing conditions",
    "USB debugging and developer certificate management",
    "Troubleshooting guide for common setup issues"
  ],
  "interfaces_provided": [
    {
      "name": "Device Setup Procedures",
      "interface_type": "DOCUMENTATION",
      "details": "Step-by-step instructions for configuring all required test devices and environments",
      "notes": "Includes verification steps and troubleshooting for each configuration"
    }
  ],
  "requisites": [
    { "description": "Android Studio latest stable with Android SDK", "type": "DEVELOPMENT_ENVIRONMENT" },
    { "description": "Xcode latest stable with iOS simulators", "type": "DEVELOPMENT_ENVIRONMENT" },
    { "description": "Physical devices: Google Pixel 5 (Android 12+) and iPhone 11 (iOS 15+)", "type": "HARDWARE_REQUIREMENT" },
    { "description": "USB cables and appropriate drivers for device connection", "type": "HARDWARE_REQUIREMENT" }
  ],
  "external_dependencies": [],
  "internal_dependencies": [],
  "dependents": ["worldchef_poc_flutter", "worldchef_poc_rn"],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "N/A - Documentation",
    "manual_review_comment": "Comprehensive device configuration guide created with detailed setup procedures, verification steps, and troubleshooting information for both physical and virtual test environments."
  }
}
ANNOTATION_BLOCK_END */

# WorldChef PoC - Test Device & Simulator Configuration Guide

> **📋 Navigation**: This document is part of the WorldChef PoC documentation suite. See [Stage 1 Onboarding Guide](./stage1_onboarding_guide.md) for complete project overview and navigation.

Comprehensive guide for configuring physical test devices, emulators, and simulators for both Flutter and React Native PoC testing.

## Overview

This guide ensures consistent testing environments across both PoCs with proper device configuration, network simulation, and development prerequisites.

## Target Device Specifications

### Physical Devices
- **Android**: Google Pixel 5 (Android 12+)
- **iOS**: iPhone 11 (iOS 15+)

### Virtual Devices
- **Android Emulator**: API Level 31+ (Android 12)
- **iOS Simulator**: iOS 15+ Runtime

## Prerequisites

### Development Environment
- **Android Studio**: Latest stable version
- **Xcode**: Latest stable version (macOS only)
- **USB Cables**: USB-C for Pixel 5, Lightning for iPhone 11
- **Host Machine**: Windows 10+, macOS 11+, or Ubuntu 20.04+

### Required Downloads
- Android SDK Platform Tools
- iOS Simulator Runtimes (if not included with Xcode)
- Device-specific USB drivers (Windows/Linux)

## Physical Device Configuration

### Google Pixel 5 (Android) Setup

#### 1. Enable Developer Options
```bash
# On device: Settings > About phone > Build number (tap 7 times)
# Navigate to: Settings > System > Developer options
```

#### 2. Enable USB Debugging
- Developer options > USB debugging (Enable)
- Developer options > Install via USB (Enable)
- Developer options > USB debugging (Security settings) (Enable)

#### 3. Install ADB Drivers (Windows/Linux)
```bash
# Windows: Download Google USB Driver
# Linux: Install android-tools-adb
sudo apt install android-tools-adb android-tools-fastboot

# Verify connection
adb devices
# Expected output: device serial number with "device" status
```

#### 4. Verify Flutter Connection
```bash
flutter devices
# Should list the connected Pixel 5
```

#### 5. Verify React Native/Expo Connection
```bash
# With device connected and Expo dev server running
expo start
# Select "a" for Android device
```

### iPhone 11 (iOS) Setup

#### 1. Enable Developer Mode (iOS 16+)
- Settings > Privacy & Security > Developer Mode (Enable)
- Restart device when prompted

#### 2. Trust Development Certificate
- Connect to macOS via USB
- When prompted "Trust This Computer?" select "Trust"
- Enter device passcode

#### 3. Install Development Profile (if required)
- Xcode > Window > Devices and Simulators
- Select your iPhone 11
- Click "Use for Development"

#### 4. Verify Xcode Connection
- Xcode > Window > Devices and Simulators
- Device should appear with green indicator

#### 5. Verify Flutter Connection
```bash
flutter devices
# Should list the connected iPhone 11
```

#### 6. Verify React Native/Expo Connection
```bash
# With device connected and Expo dev server running
expo start
# Select "i" for iOS device
```

## Virtual Device Configuration

### Android Emulator Setup

#### 1. Create AVD (Android Virtual Device)
```bash
# Via Android Studio:
# Tools > AVD Manager > Create Virtual Device

# Recommended configuration:
# - Device: Pixel 5
# - System Image: API 31 (Android 12.0)
# - RAM: 4GB
# - Internal Storage: 8GB
# - Graphics: Hardware - GLES 2.0
```

#### 2. Configure Advanced Settings
- Enable "Hardware keyboard"
- Set "Boot option" to "Cold boot"
- Configure "Emulated Performance" to "Hardware"

#### 3. Launch and Verify
```bash
# Start emulator
emulator -avd Pixel_5_API_31

# Verify with Flutter
flutter devices

# Verify with React Native
expo start
```

### iOS Simulator Setup

#### 1. Install iOS 15 Runtime (if needed)
```bash
# Via Xcode:
# Xcode > Preferences > Components > Simulators
# Download iOS 15.0+ if not present

# Verify available runtimes
xcrun simctl list runtimes
```

#### 2. Create iOS Simulator
```bash
# Via Xcode:
# Xcode > Window > Devices and Simulators > Simulators
# Click "+" to add new simulator

# Recommended configuration:
# - Device Type: iPhone 11
# - iOS Version: 15.0+
```

#### 3. Launch and Verify
```bash
# Start simulator
open -a Simulator

# Or via command line
xcrun simctl boot "iPhone 11"

# Verify with Flutter
flutter devices

# Verify with React Native
expo start
```

## Network Simulation Configuration

### Method 1: Device/Simulator Network Throttling

#### Android Emulator
```bash
# Via Extended Controls
# Click "..." in emulator toolbar
# Navigate to "Cellular" tab
# Set "Network Speed" to "3G" or custom
# Set "Network Latency" to "Medium"
```

#### iOS Simulator
```bash
# Via Simulator menu:
# Device > Network Link Conditioner
# Choose "3G" or "Very Bad Network"
```

#### Physical Devices
- **Android**: Settings > Developer options > Select USB configuration > MTP
- **iOS**: Settings > Developer > Network Link Conditioner

### Method 2: Network Proxy Tools (Recommended)

#### Charles Proxy Setup
```bash
# Install Charles Proxy
# Configure device proxy settings:
# WiFi Settings > Proxy > Manual
# Host: [Your computer IP]
# Port: 8888

# Enable throttling:
# Proxy > Throttle Settings
# Enable throttling
# Throttle preset: 3G
```

#### Alternative Tools
- **Proxyman** (macOS)
- **Fiddler** (Windows)
- **mitmproxy** (Cross-platform)

## Development Certificates & Provisioning

### iOS Development Certificates

#### Automatic Certificate Management
```bash
# In Xcode project:
# Project settings > Signing & Capabilities
# Team: [Your Apple ID]
# Automatically manage signing: Enabled
```

#### Manual Certificate Management
1. Apple Developer Account > Certificates
2. Create iOS Development Certificate
3. Download and install in Keychain
4. Create Development Provisioning Profile
5. Include target device UDIDs

### Android Debug Certificates
```bash
# Debug keystore is automatically created
# Location: ~/.android/debug.keystore
# Password: android
# Key alias: androiddebugkey

# Verify keystore
keytool -list -v -keystore ~/.android/debug.keystore
```

## Network Configuration for Mock Server Access

### Mock Server IP Configuration

#### Local Development
- **Host Machine**: `http://localhost:3000`
- **Android Emulator**: `http://10.0.2.2:3000`
- **iOS Simulator**: `http://localhost:3000` or `http://127.0.0.1:3000`

#### Physical Devices
```bash
# Find your machine's IP address
# Windows
ipconfig | findstr IPv4

# macOS/Linux
ifconfig | grep inet

# Use this IP for device configuration
# Example: http://192.168.1.100:3000
```

### Environment Configuration

#### Flutter (.env or constants)
```dart
// lib/config/environment.dart
class Environment {
  static const String mockServerBaseUrl = 
    String.fromEnvironment('MOCK_SERVER_BASE_URL', 
      defaultValue: 'http://localhost:3000');
}
```

#### React Native (Expo)
```javascript
// config/environment.js
const Environment = {
  mockServerBaseUrl: process.env.EXPO_PUBLIC_MOCK_SERVER_BASE_URL || 'http://localhost:3000'
};
```

## Verification Checklist

### Physical Device Verification
- [ ] Google Pixel 5 appears in `adb devices`
- [ ] Google Pixel 5 appears in `flutter devices`
- [ ] iPhone 11 appears in Xcode Devices window
- [ ] iPhone 11 appears in `flutter devices`
- [ ] Both devices can access mock server endpoints
- [ ] USB debugging enabled and functional
- [ ] Development certificates installed (iOS)

### Virtual Device Verification
- [ ] Android emulator (API 31+) launches successfully
- [ ] Android emulator appears in `flutter devices`
- [ ] iOS simulator (iOS 15+) launches successfully
- [ ] iOS simulator appears in `flutter devices`
- [ ] Both virtual devices can access mock server
- [ ] Network throttling configured and functional

### Network Simulation Verification
- [ ] Network throttling tools installed and configured
- [ ] 3G simulation profile active
- [ ] Response times increased as expected (80-150ms + network latency)
- [ ] Mock server accessible from all configured devices

## Troubleshooting

### Common Android Issues

#### Device Not Detected
```bash
# Restart ADB server
adb kill-server
adb start-server

# Check USB connection mode
# Ensure "File Transfer" mode is selected on device

# Windows: Update USB drivers
# Download Google USB Driver from Android Studio SDK Manager
```

#### Permission Denied
```bash
# Linux: Add user to plugdev group
sudo usermod -a -G plugdev $USER
# Logout and login again

# Create/update udev rules
sudo nano /etc/udev/rules.d/51-android.rules
# Add device-specific rules
```

### Common iOS Issues

#### Device Not Trusted
- Disconnect and reconnect USB cable
- Ensure "Trust This Computer" is selected
- Check Lightning cable integrity

#### Provisioning Profile Issues
- Verify Apple ID is signed in to Xcode
- Check device UDID is included in provisioning profile
- Refresh provisioning profiles in Xcode

#### Simulator Issues
```bash
# Reset simulator
xcrun simctl erase all

# Reinstall simulator runtime
# Xcode > Preferences > Components
```

### Network Issues

#### Mock Server Connection Failed
1. Verify mock server is running (`npm start`)
2. Check firewall settings
3. Verify IP address configuration
4. Test with curl: `curl http://[IP]:3000/recipes`

#### CORS Issues
- Verify device IP is in CORS whitelist
- Check browser developer tools for CORS errors
- Update mock server CORS configuration if needed

## Performance Testing Setup

### Baseline Measurements
- Record native app launch times
- Measure network request latency without throttling
- Establish device performance baselines

### Throttled Network Testing
- Configure consistent 3G simulation
- Measure API response times with network latency
- Test offline/online transitions

## Security Considerations

### Development Certificates
- Use debug certificates only for development
- Rotate certificates if compromised
- Store provisioning profiles securely

### Network Security
- Use HTTPS for production servers
- Implement certificate pinning for production
- Monitor network traffic during testing

---

## Summary

This configuration guide ensures consistent testing environments across both Flutter and React Native PoCs. All devices should be configured with:

1. **Physical Devices**: USB debugging enabled, development certificates installed
2. **Virtual Devices**: Consistent OS versions and hardware configurations
3. **Network Simulation**: 3G throttling for realistic testing conditions
4. **Mock Server Access**: Proper IP configuration for all target devices

**Next Steps**: After completing device configuration, proceed with AI tooling setup (Task 005) and time tracking setup (Task 006), then perform integration smoke testing (Task 008).

---

*Last Updated: Stage 1 Setup Phase*  
*Configuration Guide Version: 1.0.0*  
*Maintained by: PoC Team* 