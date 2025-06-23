<!-- AI_ANNOTATION_START
{
  "annotation": "AI_EDIT",
  "g": 135,
  "task_id": "cr_t003",
  "plan_id": "cycle4_remediation",
  "edited_by": "Hybrid_AI_OS",
  "timestamp": "2025-06-14T18:12:00Z"
}
AI_ANNOTATION_END -->

# WorldChef Dev Environment (Cycle 4)

This document describes how the *dev* environment is provisioned on **Render** and how developers can interact with it. The dev environment is auto-deployed from the `develop` branch to accelerate feedback loops and is **NOT** intended for QA or performance testing—that's what *staging* is for.

---

## 1. Infrastructure Snapshot

| Component | Render Service | Notes |
|-----------|----------------|-------|
| Domain    | dev.worldchef.example.com | Basic-auth shielded; no VPN required |
| Runtime   | Node 20 (Dockerless) | Auto-scales 0 → 1 → 2 instances |
| Database  | Supabase *dev* project | Free tier; nightly snapshot to S3 bucket |
| Storage   | Render Disk (10 GiB) | Purged weekly by maintenance job |

## 2. CI → CD Flow

1. **Push** to `develop` triggers the `Dev Deploy` GitHub Actions workflow.
2. The workflow installs dependencies, runs unit tests (<80 s), performs OWASP-ZAP quick scan, and deploys to Render via deploy hook.
3. On success, Render builds & starts the service. Slack `#dev-deploys` receives a summary with commit SHA and 🥐.
4. Rollback = re-run the previous successful workflow run (Render re-deploys the last green build).

## 3. Local Preview Links

• Frontend: https://dev.worldchef.example.com  
• API: https://dev.worldchef.example.com/api  
• Edge functions: https://dev.worldchef.example.com/edge

## 4. Getting Access

No VPN or Kubernetes credentials required. Basic-auth credentials are stored in 1Password → "WorldChef Dev".

## 5. Data Policy

Data is **non-persistent**: a nightly GitHub Actions workflow resets the database with synthetic data scripts.  
If you need a long-lived record, tag it with `__KEEP__` comment—refresh script skips those rows.

---
Happy coding on *dev*! 🚀 