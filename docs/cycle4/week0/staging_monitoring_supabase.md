# Staging Monitoring – Supabase Native Dashboard

Task: stg_t004_c001 – Monitoring dashboard setup  
Event: g130  

We are leveraging the built-in Supabase project dashboard for initial staging monitoring.  No external Grafana instance is required at this stage.  

Monitored Metrics:
1. **API Request Count & Avg Latency** – realtime view in "API" tab
2. **Edge Function Invocation p95** – "Edge Functions" → performance chart
3. **DB Connections & CPU/Memory** – "Database" → "Performance"
4. **Error Rates (4xx / 5xx)** – "API" tab error panel
5. **Storage Bandwidth & Usage** – "Storage" tab

Dashboard Access:
Supabase → Project → Dashboard (default). Bookmark:  
`https://app.supabase.com/project/myqhpmeprpaukgagktbn/overview`  

Health-check annotations and alert thresholds are defined separately (see staging_alert_config.md).  

Future Work:
• Migrate to Grafana Cloud or Observe Inc. if advanced multi-service dashboards are needed. 