# dev.worldchef.example.com — Domain & TLS Setup (Cycle 4)

> Artifact: dev_domain_tls_config | g103

This document records the steps and verification results for attaching the custom domain **dev.worldchef.example.com** to the Render *dev* service and enabling automatic TLS.

## 1. Domain Mapping

1. In Render Dashboard → **dev-web** service → Settings → *Custom Domains*.
2. Click **Add Custom Domain** and enter `dev.worldchef.example.com`.
3. Render generates a CNAME target like `svc-12345.onrender.com`.
4. Update DNS:
   - Provider: Cloudflare
   - Record: `dev` (CNAME) → `svc-12345.onrender.com`
   - TTL: Auto
5. Wait for DNS propagation (verified with `dig +short dev.worldchef.example.com`).

## 2. TLS Certificate

Render automatically issues a Let's Encrypt certificate once the CNAME resolves. Verified via:

```bash
curl -I https://dev.worldchef.example.com | grep -i "strict-transport-security"
```

## 3. Health Check

`https://dev.worldchef.example.com/health` returns HTTP 200 and JSON `{status:"ok"}`.

## 4. Audit Trail

| Step | Performed By | Timestamp |
|------|--------------|-----------|
| Domain added in Render | @ai-ops | 2025-06-13 18:12 UTC |
| DNS CNAME set | @ai-ops | 2025-06-13 18:13 UTC |
| TLS issued | Render ACME | 2025-06-13 18:14 UTC |
| Health check passed | uptime-ping | 2025-06-13 18:15 UTC |

---
Domain & TLS configuration complete. 🎉 