-- g116 – Create nutrition_cache table and telemetry view
-- stg_t009_c004

create table if not exists nutrition_cache (
  ingredient_hash text primary key,
  canonical_string text not null,
  macros jsonb not null,
  fdc_id integer,
  updated_at timestamptz not null default now(),
  expires_at timestamptz null
);

create index if not exists nutrition_cache_expiry_idx on nutrition_cache (expires_at);

-- Daily statistics for Grafana
create materialized view if not exists telemetry_nutrition_cache_stats as
select date_trunc('day', updated_at) as day,
       count(*)                      as writes
from nutrition_cache
where updated_at > now() - interval '30 days'
group by 1
order by 1 desc; 