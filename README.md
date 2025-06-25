# WorldChef - AI-Powered Recipe Discovery Platform

> **Status**: 🚀 **Cycle 4 - Mobile MVP Development** | Backend: ✅ **Production Ready** | Mobile: 🔄 **In Progress**

**Current Phase**: Cycle4-Staging | **Version**: 1.0.0-mvp | **Last Updated**: 2025-06-24

## 🎯 Project Status Overview

| Component | Status | Details |
|-----------|--------|---------|
| **Backend API** | ✅ **PRODUCTION DEPLOYED** | [worldchef-staging.onrender.com](https://worldchef-staging.onrender.com) |
| **Edge Functions** | ✅ **PRODUCTION READY** | 45% performance improvement achieved |
| **Mobile App** | 🔄 **MVP Development** | UI Foundation + Core Features |
| **Database** | ✅ **VALIDATED** | 39% better than performance targets |
| **CI/CD** | ✅ **OPERATIONAL** | GitHub Actions + Render deployment |

### 🏆 Key Achievements
- **Performance**: Edge functions optimized to 286ms p95 (meets 300ms target)
- **Cost Efficiency**: 75% under budget at $25/month for 10K MAU
- **Test Coverage**: 100% pass rate with comprehensive integration tests
- **Architecture Validation**: All 4 PoCs completed successfully

## 📁 Directory Structure

| Path | Purpose | Status |
|------|---------|--------|
| `backend/` | **Production Fastify API** + comprehensive tests | ✅ **DEPLOYED** |
| `mobile/` | **Flutter app** (Riverpod + Widgetbook) | 🔄 **MVP Development** |
| `supabase/functions/` | **Production Edge Functions** | ✅ **DEPLOYED** |
| `docs/` | **Living documentation** (ADRs, architecture, cookbook) | ✅ **MAINTAINED** |
| `staging/` | **Production build context** + performance tests | ✅ **ACTIVE** |
| `shared/` | Reusable DTOs, constants, validation schemas | ✅ **STABLE** |
| `infra/` | Render.com deployment + Docker configuration | ✅ **OPERATIONAL** |
| `_legacy/` | ⚠️ **DEPRECATED** - Do not use for active development | ❌ **ARCHIVED** |

## 🚀 Quick Start

### Prerequisites
- Node.js 18+, Yarn (not npm)
- Flutter 3.x, Dart 3.0+
- Docker, Supabase CLI
- Git, VS Code (recommended)

### Development Setup
```bash
# Install dependencies (use Yarn, not npm)
yarn install

# Start local Supabase (optional - can use staging)
supabase start

# Run backend API server
yarn workspace worldchef-backend dev  # Runs on :3000

# Run Flutter mobile app
cd mobile && flutter run  # Runs on available device/simulator

# Run Widgetbook (UI component library) - RECOMMENDED
yarn widgetbook:dev  # Builds and serves at http://localhost:8080/

# Alternative: Run in Flutter directly
cd mobile && flutter run -t lib/widgetbook/widgetbook.dart
```

### Key Environment Variables
```bash
# Copy and configure
cp .env.example .env.local

# Required variables (get from team)
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_anon_key
STRIPE_SECRET_KEY=sk_test_...
USDA_API_KEY=your_usda_key
```

## 🏗️ Architecture & Tech Stack

### **Mobile** (Flutter 3.x)
- **State Management**: Riverpod 2.x (validated 87.5% AI success rate)
- **Performance**: 58-60 FPS, 1.2s cold launch
- **Testing**: flutter test + integration_test
- **UI Library**: Widgetbook for component validation

### **Backend** (Node.js/TypeScript)
- **Framework**: Fastify (production deployed)
- **Database**: PostgreSQL via Supabase
- **Auth**: Supabase Auth + JWT validation
- **API Docs**: OpenAPI/Swagger at `/v1/docs`

### **Database & BaaS** (Supabase)
- **Performance**: 90.84ms p95 (39% better than target)
- **Features**: RLS policies, Auth, Storage, Edge Functions
- **Cost**: $25/month for 10K MAU (75% under budget)

### **Integrations**
- **Payments**: Stripe Hosted Checkout
- **Push Notifications**: Firebase Cloud Messaging
- **Nutrition Data**: USDA FoodData Central API
- **Search**: PostgreSQL FTS + pg_trgm

## 🧪 Testing & Quality

```bash
# Backend tests (Jest + TestContainers)
yarn workspace worldchef-backend test

# Mobile tests (Flutter)
cd mobile && flutter test

# Integration tests
cd mobile && flutter test integration_test/

# Load testing (k6)
cd staging/performance && k6 run k6_fastify_load_test.js

# Lint & format
flutter analyze && dart format
```

**Quality Gates**:
- ✅ 100% CI pass rate requirement
- ✅ Zero linter errors/warnings
- ✅ Performance targets met
- ✅ Real API integration tests (no mocking external services)

## 🚀 Deployment

### **Backend** (Render.com)
- **Production URL**: https://worldchef-staging.onrender.com
- **Health Check**: `/health`
- **API Docs**: `/v1/docs`
- **Deployment**: GitHub Actions → Render deploy hook

### **Edge Functions** (Supabase)
- **Nutrition Enrichment**: v15 deployed, 286ms p95 performance
- **Cleanup Jobs**: v1 deployed
- **Monitoring**: Request ID tracking + performance metrics

### **Mobile** (Future)
- **Build System**: EAS Build (Expo Application Services)
- **Distribution**: TestFlight (iOS) + Play Console (Android)

### **Widgetbook** (GitHub Pages)
- **UI Components**: Deployed via GitHub Actions (CI green)
- **Preview**: https://rwb3n.github.io/worldchef-staging/
- **URL**: Generated per deployment

## 📚 Documentation

| Category | Location | Purpose |
|----------|----------|---------|
| **Architecture** | `docs/architecture/` | System diagrams + technical specs |
| **ADRs** | `docs/adr/` | Architectural decision records |
| **Cookbook** | `docs/cookbook/` | 25+ validated implementation patterns |
| **Cycle 4** | `docs/cycle4/` | Current development cycle docs |
| **UI Specs** | `docs/ui_specifications/` | Design system + component specs |

### **Key Cookbook Patterns**
- [Flutter Widgetbook Deployment](./docs/cookbook/flutter_widgetbook_deployment_pattern.md)
- [Supabase Edge Function Performance Optimization](./docs/cookbook/supabase_edge_function_performance_optimization_pattern.md)
- [Flutter Server State Provider](./docs/cookbook/flutter_server_state_provider.md)
- [Fastify OpenAPI Integration](./docs/cookbook/fastify_manual_openapi_generation_pattern.md)
- [FCM Push Notifications](./docs/cookbook/fcm_push_notification_pattern.md)

## 🎯 Current Development (Cycle 4)

### **Mobile MVP Scope**
- ✅ **UI Foundation**: Widgetbook + Design System
- 🔄 **Home Feed**: Recipe discovery with infinite scroll
- 🔄 **Recipe Detail**: Full recipe view with nutrition
- 🔄 **Checkout Flow**: Stripe payment integration
- 🔄 **Push Notifications**: FCM + deep linking

### **Timeline**
- **Week 2** (Jun 24-30): UI Implementation (Red → Green)
- **Week 3** (Jul 1-7): Core Features + Offline
- **Week 4** (Jul 8-14): Payments + Push
- **Week 5** (Jul 15-21): Polish + QA
- **Week 6** (Jul 22-28): Closed Beta Launch

### **Active Plans**
- [`plans/plan_cycle4_mobile_mvp.txt`](./plans/plan_cycle4_mobile_mvp.txt) - Mobile development tasks
- [`plans/plan_ui_comprehensive_planning.txt`](./plans/plan_ui_comprehensive_planning.txt) - UI specification tasks

## 🔧 Development Guidelines

### **Critical Rules**
- ⚠️ **NEVER** work in `_legacy/` directory (deprecated)
- ✅ **ALWAYS** use `yarn` instead of `npm` for package management
- ✅ **ALWAYS** follow TDD: Red → Green → Refactor
- ✅ **ALWAYS** update status files for task progress
- ✅ **ALWAYS** use real APIs in tests (no mocking external services)

### **Performance Targets**
- **Mobile**: ≥58 FPS, ≤1.5s cold launch, ≤50ms UI updates
- **Backend**: ≤200ms p95 for reads, ≤300ms p95 for Edge Functions
- **Test Coverage**: ≥70% for new code

## 🤝 Contributing

1. **Sync** `develop` branch
2. **Create** feature branch: `<ticket>/<description>`
3. **Implement** following TDD cycle
4. **Update** status file: `status/plan_*_task_*_status.md`
5. **Test** locally: `flutter analyze && flutter test`
6. **PR** with CI green + one review
7. **Merge** and notify team

## 📞 Support

- **Tech Lead**: @ruben.ai
- **Mobile Squad**: @yemi
- **DevOps**: @devops-ai
- **Documentation**: See `docs/` directory

---

**🚀 Ready to build the future of recipe discovery!** 