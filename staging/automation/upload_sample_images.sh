#!/usr/bin/env bash
# Upload 10 placeholder images to Supabase Storage (worldchef bucket)
# Event g131 – fulfils stg_t006_c002

set -euo pipefail

SUPABASE_URL="https://myqhpmeprpaukgagktbn.supabase.co"
SERVICE_ROLE_KEY="${SUPABASE_SERVICE_ROLE_KEY:-}"

if [[ -z "$SERVICE_ROLE_KEY" ]]; then
  echo "SUPABASE_SERVICE_ROLE_KEY env-var required" && exit 1
fi

temp_dir=$(mktemp -d)
cdn_base="$SUPABASE_URL/storage/v1/object/worldchef/recipes/placeholder"

for i in {1..10}; do
  img="$temp_dir/img_$i.jpg"
  curl -s "https://picsum.photos/seed/$i/800/600" -o "$img"
  curl -s -X POST "$SUPABASE_URL/storage/v1/upload/worldchef/recipes/placeholder/img_$i.jpg" \
    -H "Authorization: Bearer $SERVICE_ROLE_KEY" \
    -H "Content-Type: image/jpeg" \
    --data-binary "@$img"
  echo "Uploaded $cdn_base/img_$i.jpg"
done

echo "Sample images uploaded." 