# Cycle 4 – Mobile MVP Workstream

**Document Status**: 🚀 **Kickoff Guide**  
**Created**: 2025-06-24  
**Global Event**: 124  

---

## 1. Why this README?
This file is the single entry-point for every engineer working on the Mobile MVP during Cycle 4 (Weeks 2-4). It distills goals, scope, timeline, coding standards, and links to every canonical artifact you need.

> **Start here every morning; update your task status file before EOD.**

---

## 2. Goals & Success Criteria

| Goal | Metric | Source |
|------|--------|--------|
| Ship Home Feed, Recipe Detail, Checkout screens | All integration tests pass on CI | plan_cycle4_mobile_mvp tasks t001-t009 |
| Offline & Performance | TTI <2 s, <2 rebuilds per interaction | ADR-025 perf targets |
| Push & Deep-links | Token registration + deep-link to detail | Cookbook → fcm_push_notification_pattern.md |
| Test Coverage | ≥70 % new Dart code | CI coverage gate |
| Developer Workflow | PR passes CI & one review | dev_guidelines in plan |

Closed-beta launch (Week 6) is blocked until these criteria are green.

---

## 3. Timeline Snapshot

| Week | Focus | Key Deliverable |
|------|-------|-----------------|
| **2** (24-30 Jun) | Red ➜ Green Home Feed | t001 failing tests → t002 implementation |
| **3** (01-07 Jul) | Detail screen + Offline/Perf | t004-t006 completion |
| **4** (08-14 Jul) | Checkout + Push/Deep-link | t007-t009 completion |
| **5** (15-21 Jul) | Polish & QA hand-off | Coverage, golden stability |
| **6** (22-28 Jul) | Beta readiness gate | Go/No-Go decision |

_Exact dates will auto-shift if plan tasks slip — keep status files current!_

---

## 4. Canonical Artifacts

| Artifact | Path | Purpose |
|----------|------|---------|
| Mobile Plan | `plans/plan_cycle4_mobile_mvp.txt` | Task breakdown, dependencies, complexity |
| Status Templates | `status/plan_cycle4_mobile_mvp_task_*_status.md` | Update these daily |
| Source of Truth | `docs/cycle4/CYCLE4_CLOSED_BETA_READINESS_SOURCE_OF_TRUTH.md` | Overall Cycle 4 status |
| MVP Feature Map | `docs/cycle4/mvp_feat_set.md` | API ↔ screen mapping |
| Project Charter | `docs/source/cycle 4 project charter.txt` | High-level objectives |
| Relevant ADRs | 004, 007, 010a/b, 025 | Architecture contracts |
| Cookbook Entries | see table below | Implementation patterns |
| **UI/Design Specs** | **`docs/ui_specifications/`** | **Visual specs, design tokens, component library** |
| **UI Plan** | **`plans/plan_ui_comprehensive_planning.txt`** | **UI specification tasks and timeline** |
| **UI Integration** | **`docs/cycle4/mobile_mvp/integration_strategy.md`**| **How UI and MVP plans coordinate** |
| **Widgetbook** | **`mobile/lib/widgetbook/README.md`** | **Visual component testing and validation** |

### Key Cookbook Patterns
* `flutter_widgetbook_deployment_pattern.md` – CI/CD for visual testing
* flutter_server_state_provider.md – AsyncNotifier pagination
* flutter_optimistic_mutation.md – optimistic like/favorite
* stripe_payment_pattern.md – native sheet integration
* flutter_persistence_pattern.md – Hive offline cache
* fcm_push_notification_pattern.md – token & deep-link handling

---

## 5. Development Workflow (condensed)

1. **Sync** `develop` → create branch `<ticket>/<slug>` (see plan guidelines).  
2. Implement or test **only** the task you own; don't jump ahead.  
3. Update your **status file**: checklist, summary, validation.  
4. Open PR → ensure CI green → request review.  
5. Once merged, unblock the next task and notify in #mobile-mvp channel.  

> **CI shortcuts:** run `flutter analyze && flutter test` locally before pushing.

---

## 6. Dependencies & Secrets

| Item | How to obtain |
|------|--------------|
| Supabase Anon Key | `supabase/get_anon_key.sh` (staging project) |
| Stripe Publishable Key (test) | 1Password ➜ `WorldChef/Stripe Staging` |
| Firebase `google-services.json` | Provided in LastPass folder `WorldChef Mobile` |
| .env | Copy `.env.example` → `.env` and fill placeholders |

_Never commit secrets. CI reads them from repo secrets._

---

## 7. Open Questions / Risks
* **UI Dependency**: MVP implementation is BLOCKED until UI Plan Phase 1&2 are complete. See `integration_strategy.md`.
* Design tweaks mid-sprint → must be updated in `design_tokens.md` first.
* Stripe SDK on certain Samsung devices occasionally crashes; track in t007 status.
* Push tokens on Android 13 require `POST_NOTIFICATIONS` runtime permission.

---

## 8. Contact & Support

| Role | Slack handle |
|------|-------------|
| Tech Lead | @ruben.ai |
| Mobile Squad Lead | @yemi |
| QA Lead | @qa-bot |
| DevOps Support | @devops-ai |

---

Happy building! Keep status artifacts current and reach out early if blockers arise. 