# Synthetic Data Guide – Staging Environment (Cycle 4 Week 0)

> Status: **Living Document**  |  Authored: 2025-06-24  |  Event: g181
>
> Relates to:
> • **ADR-WCF-006a – Core Entity Data Modeling (Relational)**  
> • **ADR-WCF-006b – JSONB Usage for Semi-Structured Recipe Data**  
> • **PoC #2 – Supabase Performance & Cost Validation** (Stage 3 Seeding)

---

## 1  Purpose
Staging needs realistic—but lightweight—data to support integration tests, manual QA, and nightly health-checks without exceeding Supabase free-tier limits.  This guide explains the dataset schema, generation scripts, and refresh workflow.

## 2  Dataset Overview
| Entity | Staging Volume | Schema Reference |
|--------|---------------|------------------|
| Users | **300** | `users` table – see ADR-006a |
| Recipes | **600** | `recipes` (+ JSONB `ingredients`, `instructions`) – ADR-006b |
| Nutrition Records | ~2 k | `nutrition` helper table populated for Edge function tests |
| Interactions | likes, ratings, follows, collections ≈ 5 k rows total | multiple tables: `recipe_likes`, `recipe_collection_items`, `user_follows` |

> The counts are deliberately ~0.5% of the full-scale PoC #2 dataset.  Variety is preserved (cuisines, dietary tags, JSONB complexity) while keeping DB size < 50 MB.

## 3  Generation Scripts
Located in `staging/data-generation/` and executed in numeric order:

| Script | Description |
|--------|-------------|
| `01_synthetic_users.sql` | Generates 300 users across roles & regions. |
| `02_synthetic_recipes.sql` | Seeds 600 recipes with realistic JSONB ingredients & instructions. |
| `03_synthetic_nutrition.sql` | Inserts nutrition macros for ~2 k ingredients to support `nutrition_enrichment` Edge Function. |
| `04_synthetic_interactions.sql` | Creates likes, ratings, follows & recipe collections forming realistic social graphs. |

Each script is **idempotent** and may be re-run after a fresh schema migration.

### 3.1  Adjusting Record Counts
The `FOR i IN 1..N LOOP` statements at the bottom of `01_` and `02_` scripts control volumes.  Change `N` or convert to a `psql -v users=...` variable pass-through for quick tuning.

## 4  Nightly Refresh Workflow
`staging/automation/nightly-refresh.sh` orchestrates the following steps at 03:00 UTC:
1. **Backup** current DB via `supabase db dump` (7-day retention).  
2. **Reset** schema & re-apply migrations (`supabase db reset/push`).  
3. **Seed** synthetic data via scripts above.  
4. **Storage Cleanup** – Purges recipe-image bucket (placeholder).  
5. **Health-checks** – Runs smoke tests; posts Slack notification on success.

## 5  Local Development Usage
```bash
# Prerequisites: Postgres running & migrations applied
export DATABASE_URL="postgres://localhost:5432/worldchef_local"

# Run all seed scripts
for script in staging/data-generation/*_synthetic_*.sql; do
  psql "$DATABASE_URL" -f "$script"
done
```
This populates your local DB with the same dataset used in staging so mobile & backend integration tests behave consistently.

## 6  Validation & Monitoring
* Volume & integrity assertions are embedded in each script (`RAISE NOTICE`).  
* Nightly health-check verifies:
  * Table counts match expected volumes.  
  * Edge Function `nutrition_enrichment` returns cache hits >90%.  
* Performance targets: <200 ms p95 for read queries (see ADR-Performance Targets section).

## 7  Future Enhancements
* **Parameterized Seeding** – Accept CLI vars to scale data up for load-test environments.  
* **Seed Diffing** – Detect & insert only missing rows to speed up local bootstrapping.  
* **Image Fixtures** – Upload a small set of recipe photos (~10 MB) for end-to-end media tests.

---
_Scientifically small—functionally mighty._ 