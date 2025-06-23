# Staging Image Storage Configuration – Supabase Storage

Task: stg_t006_c001 / c003  
Event: g131

Bucket Details
--------------
* **Bucket name**: `worldchef`  (already created)
* **Region**: `eu-west-1`
* **Storage URL**: `https://myqhpmeprpaukgagktbn.supabase.co/storage/v1`
* **S3 endpoint**: `https://myqhpmeprpaukgagktbn.supabase.co/storage/v1/s3`  
  (Supabase's S3-compatible endpoint; user = `service_role`, key = `SUPABASE_SERVICE_ROLE_KEY`)
* **Public CDN base**: `https://myqhpmeprpaukgagktbn.supabase.co/storage/v1/object/public/worldchef/`

Permissions
-----------
* Bucket is **public-read** so mobile clients can fetch images directly.
* Write operations restricted to backend (Fastify API) via Service Role Key.
* No versioning on free tier; nightly purge script will manage drift.

Folder / Naming Convention
--------------------------
```
worldchef/
  recipes/
    {recipe_id}/hero.jpg
    {recipe_id}/step_01.jpg
  users/
    {user_id}/avatar.jpg
  tmp/
    uploads/{uuid}.jpg   # auto-deleted after processing
```

Image Optimisation (Free Tier)
------------------------------
Supabase's built-in CDN supports on-the-fly resizing via parameters:
`…/worldchef/recipes/{id}/hero.jpg?width=600&quality=75`

For staging we'll rely on these query params rather than an external optimiser.  We document the recommended widths in Figma and README.

Upload Workflow
---------------
1. Client uploads to backend endpoint `/v1/images/upload` (Fastify stub).  
2. Backend validates/mints filename, streams to Supabase Storage via `@supabase/storage-js`.  
3. Returns public URL to client.  (If avatar → triggers ImageMagick resize to ≤256×256 in edge func – **TODO prod**.)

Retention / Purge
-----------------
* Free tier limit: **50 MB**.  Sample images limited to 200 placeholders (~8 MB total).
* Nightly automation `staging/automation/nightly-health-check.sh` now calls `supabase storage rm worldchef/tmp` to remove temp uploads. 