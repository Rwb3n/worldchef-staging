# WorldChef Code Patterns Index

> Canonical quick-reference for developers and reviewers.  Each line links to a detailed cookbook recipe.  
> _Last rebuild: 2025-06-24 – Cycle 4 Gap Closure Cookbook Pattern Addition_

---

## 🟦 Flutter (Mobile Client)

| # | Pattern | When to Use | Cookbook |
|---|---------|-------------|----------|
| F1 | Riverpod AsyncNotifier – Server State | Fetch & cache remote data with granularity. | [flutter_server_state_provider](../cookbook/flutter_server_state_provider.md) |
| F2 | Optimistic Mutation with rollback (StateNotifier) | Instant-feel likes/follows with error recovery. | [flutter_optimistic_mutation](../cookbook/flutter_optimistic_mutation.md) |
| F3 | Dio API Service + Retry | Authenticated HTTP requests with retry & timeout. | [flutter_api_service_pattern](../cookbook/flutter_api_service_pattern.md) |
| F4 | JSON Model Code-gen | Type-safe JSON models via `build_runner`. | [flutter_json_model_pattern](../cookbook/flutter_json_model_pattern.md) |
| F5 | Form Validation Pattern | Declarative, type-safe form validation. | [flutter_form_validation_pattern](../cookbook/flutter_form_validation_pattern.md) |
| F6 | Persistence Layer (Hive + prefs) | Local caching & offline support. | [flutter_persistence_pattern](../cookbook/flutter_persistence_pattern.md) |

## 🟥 Fastify Backend (Node.js)

| # | Pattern | When to Use | Cookbook |
|---|---------|-------------|----------|
| B1 | Plugin Route Prefix | Consistent route group prefixes & encapsulation. | [fastify_plugin_route_prefix_pattern](../cookbook/fastify_plugin_route_prefix_pattern.md) |
| B2 | OpenAPI / Swagger Integration | Auto-generate spec & interactive docs. | [fastify_openapi_swagger_integration_pattern](../cookbook/fastify_openapi_swagger_integration_pattern.md) |
| B3 | Manual OpenAPI Generation | Fallback when auto-generation fails with sub-plugins. | [fastify_manual_openapi_generation_pattern](../cookbook/fastify_manual_openapi_generation_pattern.md) |
| B4 | Comprehensive Testing | Full-stack Fastify tests incl. plugins & env. | [fastify_comprehensive_testing_pattern](../cookbook/fastify_comprehensive_testing_pattern.md) |
| B5 | Image Upload Endpoint | Multipart uploads → Supabase Storage. | [fastify_image_upload_pattern](../cookbook/fastify_image_upload_pattern.md) |
| B6 | External API Read-through Cache | Cache upstream API responses in Postgres. | [backend_external_api_cache](../cookbook/backend_external_api_cache.md) |

## 🟩 Supabase (DB, Auth, Edge Functions)

| # | Pattern | When to Use | Cookbook |
|---|---------|-------------|----------|
| S1 | Auth Integration (JWT) | Validate Supabase JWT in Fastify plugins. | [supabase_auth_integration_pattern](../cookbook/supabase_auth_integration_pattern.md) |
| S2 | Data Seeding Pattern | Realistic synthetic data generation. | [supabase_data_seeding_pattern](../cookbook/supabase_data_seeding_pattern.md) |
| S3 | Edge Function – External API Integration | Call USDA / third-party APIs from Edge. | [supabase_edge_function_external_api_integration_pattern](../cookbook/supabase_edge_function_external_api_integration_pattern.md) |
| S4 | Edge Function – Debugging | Debug Edge functions locally & in prod. | [supabase_edge_function_debugging_pattern](../cookbook/supabase_edge_function_debugging_pattern.md) |
| S5 | Edge Function – Cache Debugging | Diagnose cache miss/hit issues. | [supabase_edge_function_cache_debugging_pattern](../cookbook/supabase_edge_function_cache_debugging_pattern.md) |
| S6 | Edge Function – Prod Deployment | Deploy & version Edge functions safely. | [supabase_edge_function_production_deployment_pattern](../cookbook/supabase_edge_function_production_deployment_pattern.md) |
| S7 | RLS Security Pattern | Author & test Row Level Security policies. | [supabase_rls_security_pattern](../cookbook/supabase_rls_security_pattern.md) |
| S8 | Performance Testing | k6 load tests & Supabase tuning. | [supabase_performance_testing_pattern](../cookbook/supabase_performance_testing_pattern.md) |
| S9 | Edge Function Performance Optimization | Cache optimization & batch querying for 45% improvement. | [supabase_edge_function_performance_optimization_pattern](../cookbook/supabase_edge_function_performance_optimization_pattern.md) |

## 🟨 DevOps / CI-CD / Hosting

| # | Pattern | Purpose | Cookbook |
|---|---------|---------|----------|
| D1 | GitHub Actions Monorepo Workflow | Parallel builds & deployments in monorepo. | [github_actions_monorepo_pattern](../cookbook/github_actions_monorepo_pattern.md) |
| D2 | Render Monorepo Backend Deployment | Zero-downtime Fastify deploy on Render. | [render_monorepo_backend_deployment_pattern](../cookbook/render_monorepo_backend_deployment_pattern.md) |
| D3 | Render Troubleshooting | Common Render deployment pitfalls. | [render_deployment_troubleshooting_pattern](../cookbook/render_deployment_troubleshooting_pattern.md) |
| D4 | Stripe Hosted Checkout | Secure payment flows & webhook handling. | [stripe_payment_pattern](../cookbook/stripe_payment_pattern.md) |
| D5 | FCM Push Notifications | Firebase Cloud Messaging integration. | [fcm_push_notification_pattern](../cookbook/fcm_push_notification_pattern.md) |
| D6 | Postgres Full-Text Search | pg_trgm + unaccent search setup. | [postgres_full_text_search_pattern](../cookbook/postgres_full_text_search_pattern.md) |

## 🟪 Testing & Debugging

| # | Pattern | Scope | Cookbook |
|---|---------|-------|----------|
| T1 | Mock API Testing | Use msw / mock-server for deterministic tests. | [mock_api_testing_pattern](../cookbook/mock_api_testing_pattern.md) |
| T2 | Real vs Mock Env Matrix | Decision matrix for real vs mocked deps. | [test_environment_real_vs_mock_pattern](../cookbook/test_environment_real_vs_mock_pattern.md) |
| T3 | Test-Driven Debugging | Use failing tests to drive bug fixes. | [test_driven_debugging_pattern](../cookbook/test_driven_debugging_pattern.md) |
| T4 | TDD Gap Closure Methodology | Systematic gap identification & TDD-driven closure. | [tdd_gap_closure_methodology_pattern](../cookbook/tdd_gap_closure_methodology_pattern.md) |

---

### Adding / Updating Entries
1. Create or update the detailed recipe in `docs/cookbook/`.
2. Append a row in the appropriate category table above.
3. Keep categories alphabetically sorted; increment IDs accordingly.

---
_Auto-generated index managed by Hybrid AI OS._ 