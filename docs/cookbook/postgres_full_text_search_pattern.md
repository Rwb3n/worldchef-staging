# Cookbook: PostgreSQL Full-Text Search

**Pattern:** Weighted Full-Text Search with `tsvector` and `pg_trgm`
**Source:** ADR-WCF-008
**Validated in:** PoC #2

This is the canonical pattern for implementing efficient and typo-tolerant search in the backend.

### 1. Schema: Adding the Search Vector

Add a `tsvector` column to your table and use a trigger to automatically keep it in sync. This avoids re-indexing on every query.

```sql
-- Add the tsvector column to the recipes table
ALTER TABLE public.recipes ADD COLUMN search_vector tsvector;

-- Create the function to update the vector
CREATE OR REPLACE FUNCTION update_recipe_search_vector()
RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector :=
    setweight(to_tsvector('english', coalesce(NEW.title, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(NEW.description, '')), 'B') ||
    setweight(to_tsvector('english', array_to_string(NEW.diet, ' ')), 'C');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER recipe_search_vector_update
BEFORE INSERT OR UPDATE ON public.recipes
FOR EACH ROW EXECUTE FUNCTION update_recipe_search_vector();

-- Create the GIN index for performance
CREATE INDEX recipes_search_idx ON public.recipes USING GIN (search_vector);
```
### 2. Schema: Enabling Typo Tolerance (pg_trgm)
Enable the extension and add a GIN index on text columns you want to perform fuzzy matching on.
```sql
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX recipes_title_trgm_idx ON recipes USING GIN (title gin_trgm_ops);
```
### 3. Backend: Querying with Ranking and Typo Tolerance
Combine FTS with similarity matching for the best results.
```typescript
// src/services/search_service.ts
async function searchRecipes(query: string) {
  const ftsQuery = query.split(' ').join(' & '); // Format for FTS

  const { data, error } = await supabase.rpc('search_recipes', {
    search_term: query,
    fts_query: ftsQuery
  });

  if (error) throw error;
  return data;
}

// Corresponding PostgreSQL function
CREATE OR REPLACE FUNCTION search_recipes(search_term text, fts_query text)
RETURNS SETOF recipes AS $$
BEGIN
  RETURN QUERY
  SELECT *
  FROM public.recipes
  WHERE
    -- Primary FTS match
    search_vector @@ to_tsquery('english', fts_query)
    -- Or, secondary typo-tolerant match
    OR title % search_term
  ORDER BY
    -- Rank results, prioritizing FTS score, then similarity
    ts_rank_cd(search_vector, to_tsquery('english', fts_query)) DESC,
    similarity(title, search_term) DESC
  LIMIT 50;
END;
$$ LANGUAGE plpgsql;
``` 