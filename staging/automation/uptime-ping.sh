#!/usr/bin/env bash
# uptime-ping.sh — Cycle 4 (g97)
# Pings staging & dev endpoints every 60 seconds and logs failures.

URLS=(
  "https://dev.worldchef.example.com/healthz"
  "https://worldchef-staging.onrender.com/healthz"
)

while true; do
  for url in "${URLS[@]}"; do
    ts=$(date '+%Y-%m-%dT%H:%M:%S%z')
    if curl -fs --max-time 5 "$url" > /dev/null; then
      echo "$ts OK $url"
    else
      echo "$ts FAIL $url" | tee -a /var/log/worldchef/uptime.log
      # TODO: integrate with Slack webhook
    fi
  done
  sleep 60
done 