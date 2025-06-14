#!/usr/bin/env bash
# Nightly health-check script – WorldChef staging
# Event g130 – fulfils stg_t004_c004

set -euo pipefail

API_URL="https://api.worldchef-staging.onrender.com/api/health"
WEB_URL="https://worldchef-staging.onrender.com/"

log() { echo "[$(date -u)] $1"; }

log "Checking API health…"
if curl -sf "$API_URL" >/dev/null; then
  log "API healthy ✅"
else
  log "API unhealthy ❌"
  exit 1
fi

log "Checking Web health…"
if curl -sf "$WEB_URL" >/dev/null; then
  log "Web healthy ✅"
else
  log "Web unhealthy ❌"
  exit 1
fi

log "Both checks passed." 