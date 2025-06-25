# Cycle 4 – Week 0 Staging On-Ramp

> Status: **Baseline Complete**  |  Last updated: 2025-06-24  |  Event g182
>
> Week 0 establishes a *clean staging baseline* before development sprints begin.  
> It captures infrastructure config, environment variables, seed data contracts, and smoke-test results that will be referenced throughout Cycle 4.

---

## 📂 Directory Map
| File | Purpose |
|------|---------|
| `staging_setup_guide.md` | End-to-end checklist to stand up the staging stack on Render + Supabase. |
| `staging_infrastructure_config.md` | Render service definitions & autoscaling parameters. |
| `staging_env_config.md` | Canonical list of required environment variables (non-secret). |
| `staging_image_config.md` | Container registry / tag strategy for multi-service deploys. |
| `staging_supabase_config.md` | Supabase project settings (extensions, RLS defaults, storage buckets). |
| `staging_monitoring_supabase.md` | How to enable query log & real-time metrics in Supabase dash. |
| `staging_alert_config.md` | Alertmanager & Grafana OnCall integration notes. |
| `staging_current_state.md` | Snapshot of staging health & key metrics after initial deploy. |
| `staging_progress_tracker.md` | Check-list tracker for week0 tasks (autoscale, TLS, smoke tests…). |
| `dev_environment.md` | Local dev environment prerequisites & tooling setup. |
| `dev_domain_tls_config.md` | Custom domain + Let's Encrypt TLS for staging API. |
| `minimal_app_deployment_guide.md` | One-pager for minimal repo → staging deploy (CI shortcuts). |
| `nutrition_cache_proposal.md` | Design doc for Postgres-backed nutrition cache (precursor to Edge func). |
| `nutrition_json_contract.md` | Canonical JSON contract for nutrition data payloads. |
| `synthetic_data_guide.md` | NEW – Lightweight 300-user / 600-recipe dataset & refresh workflow. |
| `nutrition_smoke_test.md` | k6 script spec for basic nutrition edge-function call. |
| `nutrition_smoke_test_results.md` | Latest results after initial deploy (hit / miss latency). |
| `fdc_api.json` | Example USDA FoodData Central response – used in contract tests. |

---

## 🔑 Key Outcomes of Week 0
1. **Infrastructure baseline** – Staging cluster up & healthy, TLS in place.
2. **Data readiness** – Synthetic dataset + nutrition cache contract locked.
3. **Monitoring & Alerts** – Supabase logs streamed to Grafana; basic uptime ping.
4. **Smoke-tests green** – Edge function / API endpoints pass k6 & Postman checks.

These artifacts are *frozen* at the end of Week 0 and will only be amended via Change Control (see ADR-Change-Management).

---

### Editing Guidelines
* Treat this README as a single source of truth for Week 0 reference docs.  
* Keep the table alphabetically sorted by filename.  
* Add a one-line purpose for any new file dropped into this folder.

---
_“Start with a solid foundation; the rest is just incremental gains.”_ 