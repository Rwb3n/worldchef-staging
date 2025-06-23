# WorldChef – Cycle 4

Welcome to Cycle 4 of the WorldChef platform! This short guide will get any development agent—from humans to AI copilots—productive in minutes.

## 1. What's inside Cycle 4?

Cycle 4 focuses on delivering a production-ready staging environment, a **lightweight dev environment auto-deployed from the *develop* branch**, synthetic data pipeline, CI/CD hardening, and beta-grade UX polish across web and mobile clients.

```
📂 docs/cycle4/        — Planning & reference docs
📂 staging/            — Infrastructure & data-gen scripts
📂 src/                — Service & client source code (module-specific)
```

## 2. Prerequisites

• Node ≥ 18, npm ≥ 9  
• Docker ≥ 24  
• Supabase CLI  
• Stripe CLI (test mode)  
• k6 (load testing)  
• Access to `staging.worldchef.example.com` VPN/SSO

## 3. Quick start

```bash
# 1 – Clone & install
$ git clone https://github.com/worldchef/worldchef.git && cd worldchef
$ npm ci

# 2 – Seed env vars (create .env from template)
$ cp .env.example .env  # ask DevOps for secrets vault access

# 3 – Spin up everything locally
$ npm run dev          # web, api, edge-functions auto-reload

# 4 – Run the test suite
$ npm test
```

## 4. Connecting to dev & staging

### Dev (auto-deployed on every push to *develop*)
1. Visit https://dev.worldchef.example.com  
2. Feature branches merge → preview instantly.  
3. No VPN required (IP-restricted + basic auth).

<!-- AI_ANNOTATION_START
{
  "annotation": "AI_EDIT",
  "g": 135,
  "task_id": "cr_t003",
  "plan_id": "cycle4_remediation",
  "edited_by": "Hybrid_AI_OS",
  "timestamp": "2025-06-14T18:00:00Z"
}
AI_ANNOTATION_END -->

### Staging (manual promotion of *v* tags)
1. Create a Git tag starting with `v` (e.g., `v0.5.0-beta`) on the desired commit and push it to `main`.  
2. Approve the "Staging Deploy" workflow in GitHub Actions (this triggers a fresh deploy on Render).  
3. Once the Render build completes, visit https://worldchef-staging.onrender.com to verify the release.

## 5. Contributing workflow

• Create a branch `<ticket>/<short-slug>` off `staging`.  
• Commit with Conventional Commits (`feat:`, `fix:`…).  
• Push & open PR → CI must pass.  
• Two approvals OR AI-Validate ✅ → auto-merge.

## 6. Essential docs

• Dev environment guide → `docs/cycle4/week0/dev_environment.md`  
• Staging setup guide   → `docs/cycle4/week0/staging_setup_guide.md`  
• Infra config          → `docs/cycle4/week0/staging_infrastructure_config.md`  
• MVP feature set       → `docs/cycle4/mvp_feat_set.md`

---
Happy hacking! 🚀 