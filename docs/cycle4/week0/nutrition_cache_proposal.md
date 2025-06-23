# Nutrition Enrichment Caching Layer – Design Proposal (stg_t009_c004)

> Artifact: nutrition_cache_proposal | Generated at g114

## 1. Objectives
• **Reduce USDA API traffic** & stay within rate-limits / cost caps.  
• **Speed up edge function responses** for repeat ingredient lookups.  
• **Maintain freshness** (handle USDA data updates) with a reasonable TTL.

## 2. Key Concept: `ingredient_hash`
A deterministic SHA-256 hash of the *canonical* ingredient string, built from:  
`<normalized-name>|<unit>|<quantity>` where:
* **normalized-name** → lower-cased, trimmed, ASCII-folded, singularized.
* **unit** → SI or culinary units mapped to canonical symbol (g, ml, tbsp, …).
* **quantity** → numeric, right-trim zeros.

Example: `"chicken breast" 200 g` → canonical string `chicken breast|g|200` → hash.

## 3. Storage Options Evaluated
| Option | Latency (p95) | Cost | Notes |
|--------|--------------|------|-------|
| **Supabase Postgres** | ≈2-4 ms (same region) | $ | Durable, indexed, simple |
| Deno KV (beta) | ≈1-3 ms | Free (quota) | No SQL needed, but region-locked; less observability |
| Upstash Redis | ≈1-2 ms | $$ | Extra infra, adds network hop |

**Recommendation** → **Supabase Postgres** table `nutrition_cache` (keeps everything in one stack, supports SQL TTL cleanup, easy JSONB storage, and can be queried via PostgREST). If later <5 ms p95 is too slow we can front-layer Deno KV as a read-through cache.

## 3. Potential Gaps & Risks (updated per review)

| Risk / Gap | Impact | Mitigation |
|------------|--------|-----------|
| **Unit-conversion inflation** – Same ingredient submitted in `g`, `kg`, `oz` etc. creates distinct hashes & lowers hit ratio | Higher USDA API calls / cost | Add canonical-weight conversion step: convert weight (mass/volume) to **grams (g)** or **millilitres (ml)** _before hashing_; persist both original and canonical fields for audit |
| **USDA licensing** – Storing full `fdc_food` JSON may breach redistribution terms | Legal / compliance | Default schema stores only `fdc_id` + derived macros; raw payload storage behind feature flag after legal approval |
| **TTL too aggressive** – USDA DB updates ~monthly; 24 h expiry may churn cache | ↑ API cost | Make TTL configurable via ENV `NUTRITION_CACHE_TTL_HOURS` (default **168 h / 7 days**); keep shorter `AI_TTL_HOURS` for GPT-fallback rows |
| **Concurrency spikes (thundering herd)** | Duplicate USDA calls & latency | Wrap miss-fetch-insert in `SELECT … FOR UPDATE SKIP LOCKED` or advisory lock (`pg_advisory_xact_lock(hash)`);
If lock held → read row after lock releases |
| **Metrics visibility** – Stats view undefined | Ops monitoring blind spot | Create materialized view `telemetry.nutrition_cache_stats` + Logflare edge log counters `cache_hit` bool; expose Grafana dashboard |

## 4. Compatibility with Wider Architecture
• Aligns with **ADR-WCF-003** (minimal infra, edge-function compute).  
• JSONB nutrition storage remains unchanged (ADR-WCF-006b).  
• Re-using Postgres avoids new services like Redis at this stage.

## 5. Recommendations Before Merge
1. **Schema migration** w/ new TTL env vars.  
2. **Unit canonicalisation** helper with conversion lookup table (g → g, kg → g, oz → g, cup → ml, etc.).  
3. **Concurrency guard** via advisory lock or row-level lock.  
4. **Metrics & alerting** objects.  
5. **License review** before optional raw JSON storage.

## 4. Schema
```sql
create table if not exists nutrition_cache (
  ingredient_hash text primary key,
  canonical_string text not null,
  macros jsonb not null,           -- { calories, protein_g, fat_g, carbs_g, … }
  fdc_id integer,                  -- USDA reference used
  updated_at timestamptz not null default now(),
  expires_at timestamptz           -- NULL = never expires (rare)
);
create index if not exists nutrition_cache_expiry_idx on nutrition_cache (expires_at);
```

TTL policy:  
* **24 h** default expiry.  
* Nightly cron (Supabase scheduled function) purges expired rows.

## 5. Edge Function Flow (read-through)
1. Compute `ingredient_hash`.  
2. `select macros from nutrition_cache where ingredient_hash = $1 and (expires_at is null or expires_at > now())`.  
   *If hit* → return cached macros.  
3. *If miss* → call USDA flow (existing logic).  
   • On success, `insert ... on conflict do update set macros = $2, updated_at = now(), expires_at = now() + interval '24 hours'`.  
4. Return macros.

All DB traffic uses `supabaseServiceRole` key (secure env var) over pooled connection.

## 6. Future Enhancements
* **Stale-While-Revalidate** strategy: serve cached but simultaneously refresh async if (now-updated_at) > 12 h.  
* **Additional nutrients** → store full USDA response in column `fdc_food jsonb` (nullable) for richer data.
* **Hit metrics**: track cache_hit / miss counts via `telemetry.nutrition_cache_stats` view.

---
_If approved, next PR will add table migration & read-through logic to edge function._ 

---
*Revised at g115 based on stakeholder feedback.* 