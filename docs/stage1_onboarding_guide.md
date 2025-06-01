# Stage 1 Onboarding Guide - WorldChef PoC Setup

Welcome to the WorldChef Mobile Stack Comparison PoC! This guide provides a comprehensive overview of Stage 1 setup tasks and serves as your central navigation hub for all setup-related documentation and repositories.

## Purpose & Overview

Stage 1 focuses on establishing consistent, version-controlled development environments for both Flutter and React Native PoCs. The goal is to create a fair comparison foundation with identical tooling, data sources, and validation processes.

## Quick Start Checklist

Use this checklist to track your progress through Stage 1:

- [ ] **Shared Templates** - Review CI guidelines and this onboarding guide
- [ ] **Flutter Project** - Initialize Flutter project with CI and tooling
- [ ] **React Native Project** - Initialize React Native project with CI and tooling  
- [ ] **Mock Data Server** - Set up consistent data source for both projects
- [ ] **Device Configuration** - Configure test devices and emulators
- [ ] **AI Tooling** - Set up AI-assisted development environment
- [ ] **Time Tracking** - Establish effort measurement system
- [ ] **Integration Test** - Verify end-to-end setup with smoke test

## Repositories & Key Artifacts

### Project Repositories
| Repository | Technology | Purpose | Status |
|------------|------------|---------|---------|
| `worldchef_poc_flutter` | Flutter | Flutter PoC implementation | 🔄 Setup Phase |
| `worldchef_poc_rn` | React Native/Expo | React Native PoC implementation | 🔄 Setup Phase |
| `worldchef_poc_mock_server` | Node.js | Shared mock data server | 🔄 Setup Phase |

### Documentation Hub

#### Setup & Configuration Guides
- **[CI Template Guidelines](./ci_template_guidelines.md)** - Shared CI/CD standards for both projects
- **[Device Configuration Guide](./device_configuration.md)** - Physical device and emulator setup
- **[AI Tooling Guide](./ai_tooling_guide.md)** - AI development environment setup
- **[Time Tracking Guide](./time_tracking_guide.md)** - Effort measurement procedures

#### Templates & Tools
- **[Time Tracking Template](./time_tracking_template.xlsx)** - Excel template for effort logging
- **[AI Prompt Templates](./ai_prompt_templates.md)** - Reusable AI prompts for development

#### Server Documentation
- **[Mock Server README](../worldchef_poc_mock_server/README.md)** - API endpoints and configuration

#### Validation & Testing
- **[Stage 1 Smoke Test Report](./smoke_test_report_stage1.md)** - Integration validation results

## Development Environment Requirements

### Common Prerequisites
- **Git** - Latest stable version for version control
- **GitHub Account** - For repository hosting and CI/CD
- **Code Editor** - VS Code recommended with platform-specific extensions

### Flutter-Specific Requirements
- **Flutter SDK** - Latest stable version
- **Android Studio** - Latest stable with Flutter plugins
- **Xcode** - Latest stable (macOS only, for iOS development)

### React Native-Specific Requirements
- **Node.js** - Latest LTS version
- **Expo CLI** - Latest stable version
- **EAS CLI** - For advanced build configurations

### Testing Requirements
- **Physical Devices** - Google Pixel 5 (Android 12+), iPhone 11 (iOS 15+)
- **Emulators/Simulators** - Android API 31+, iOS 15+ simulator

## Setup Process Overview

### Phase 1: Foundation (Parallel Execution Possible)
1. **Task 007** - Create shared CI template and this onboarding guide ✅
2. **Task 006** - Set up time tracking mechanism
3. **Task 005** - Configure AI tooling and security
4. **Task 004** - Configure test devices and emulators

### Phase 2: Project Initialization (Parallel Execution Possible)
5. **Task 001** - Initialize Flutter project with CI
6. **Task 002** - Initialize React Native project with CI
7. **Task 003** - Set up mock data server

### Phase 3: Integration Validation
8. **Task 008** - Perform smoke test to verify setup

## Key Success Criteria

By the end of Stage 1, you should have:

✅ **Consistent CI/CD** - Both projects have equivalent CI pipelines  
✅ **Version Control** - All code is properly version-controlled with remote repositories  
✅ **Mock Data Access** - Both projects can successfully fetch data from the mock server  
✅ **Device Readiness** - Physical devices and emulators are configured and accessible  
✅ **AI Environment** - Secure AI tooling setup with documented prompting strategy  
✅ **Tracking System** - Time and effort tracking mechanism in place  
✅ **Documentation** - Complete setup documentation for team reference  

## Troubleshooting & Support

### Common Issues
- **Build Failures** - Check platform-specific SDK installations and versions
- **Device Connection** - Verify USB debugging (Android) and device trust (iOS)
- **CI Failures** - Review secrets configuration and repository permissions
- **Mock Server Access** - Check network configuration and CORS settings

### Getting Help
- Review the relevant guide documentation first
- Check the CI template guidelines for build issues
- Consult the device configuration guide for hardware problems
- Refer to time tracking procedures for measurement questions

## Next Steps

After completing Stage 1, you'll be ready for:
- **Stage 2** - Flutter PoC feature implementation
- **Stage 3** - React Native PoC feature implementation  
- **Stage 4** - Comparative analysis and reporting

## Maintenance Notes

This document should be updated as:
- New repositories are created or URLs change
- Documentation artifacts are added or reorganized
- Setup procedures are refined based on team feedback
- New requirements or constraints are identified

---

*Last Updated: Stage 1 Setup Phase*  
*Document Version: 1.0*  
*Maintained by: PoC Team Lead* 