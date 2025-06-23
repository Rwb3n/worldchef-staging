# Staging Alert Thresholds

Task: stg_t004_c002 – Error-rate & latency alert configuration  
Event: g130  

Initial alerting will rely on Supabase e-mail alerts (Settings → Alerts) which are available even on the free tier.

| Metric | Threshold | Duration | Action |
|--------|-----------|----------|--------|
| API latency p95 | > 800 ms | 10 min | Send email to on-call list |
| Edge Function latency p95 | > 1 s | 10 min | Email |
| 5xx error rate | ≥ 2 % of requests | 5 min | Email |
| Database connections | ≥ 85 % of limit | 5 min | Email |
| Storage used | ≥ 80 % of 500 MB quota | Daily | Email |

Configuration Steps:
1. Supabase Dashboard → **Settings → Alerts**.
2. Add each rule with the thresholds above.
3. Notification channel: default project owner email (can be updated later).

Future Enhancements (roll-over):
• Integrate Slack or PagerDuty once we upgrade from email-only notifications.  Checklist item stg_t004_c003 remains **PENDING** until then. 