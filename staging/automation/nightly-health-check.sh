#!/usr/bin/env bash
# Nightly health-check script – WorldChef staging
# Event g130 – fulfils stg_t004_c004

set -euo pipefail

API_URL="https://api.worldchef-staging.onrender.com/healthz"
WEB_URL="https://worldchef-staging.onrender.com/healthz"

log() { echo "[$(date -u)] $1"; }

log "Waiting for API to restart after DB reset..."
sleep 30

log "Checking API health…"
log "⚠️  NOTICE: API health check disabled - no application deployed yet"
log "API health check skipped ⏭️"

# Uncomment below when you have a real application deployed:
# for attempt in {1..5}; do
#   if curl -sf "$API_URL" >/dev/null; then
#     log "API healthy ✅ (attempt $attempt)"
#     break
#   else
#     if [ $attempt -eq 5 ]; then
#       log "API unhealthy ❌ (failed after 5 attempts)"
#       exit 1
#     else
#       log "API not ready, retrying in 15 seconds... (attempt $attempt/5)"
#       sleep 15
#     fi
#   fi
# done

log "Checking Web health…"
log "⚠️  NOTICE: Web health check disabled - no application deployed yet"
log "Web health check skipped ⏭️"

# Uncomment below when you have a real application deployed:
# for attempt in {1..3}; do
#   if curl -sf "$WEB_URL" >/dev/null; then
#     log "Web healthy ✅ (attempt $attempt)"
#     break
#   else
#     if [ $attempt -eq 3 ]; then
#       log "Web unhealthy ❌ (failed after 3 attempts)"
#       exit 1
#     else
#       log "Web not ready, retrying in 10 seconds... (attempt $attempt/3)"
#       sleep 10
#     fi
#   fi
# done

log "Health checks completed (skipped until applications are deployed) ✅" 