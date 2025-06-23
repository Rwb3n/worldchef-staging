# Nutrition Enrichment Smoke Test (stg_t009_c006)

> Artifact: nutrition_smoke_test | Generated at g122

## Test Objective
Validate end-to-end nutrition enrichment on 10 diverse recipe ingredients to ensure:
1. USDA FDC search returns reasonable macros.
2. Cache layer functions (miss → populate, hit → retrieve).
3. JSON contract compliance.

## Test Ingredients (diverse categories)
```json
{
  "ingredients": [
    { "name": "chicken breast", "quantity": 200, "unit": "g" },
    { "name": "olive oil", "quantity": 2, "unit": "tbsp" },
    { "name": "brown rice", "quantity": 1, "unit": "cup" },
    { "name": "broccoli", "quantity": 150, "unit": "g" },
    { "name": "cheddar cheese", "quantity": 1, "unit": "oz" },
    { "name": "salmon fillet", "quantity": 6, "unit": "oz" },
    { "name": "sweet potato", "quantity": 1, "unit": "medium" },
    { "name": "almonds", "quantity": 30, "unit": "g" },
    { "name": "spinach", "quantity": 2, "unit": "cup" },
    { "name": "greek yogurt", "quantity": 150, "unit": "g" }
  ]
}
```

## Expected Behaviour
1. **First call** → USDA API lookups, cache population, response ~500-1000ms.
2. **Second call (identical)** → cache hits, response <100ms.
3. **Response format** matches JSON contract (items[], aggregate_totals, source, generated_at).

## Success Criteria
- [ ] All 10 ingredients return non-zero macros.
- [ ] Aggregate totals = sum of individual items.
- [ ] Cache hit ratio ≥90% on repeat calls.
- [ ] No 5xx errors or timeouts.

## Test Commands
```bash
# First call (cache miss)
curl -X POST https://[staging-url]/functions/v1/nutrition_enrichment \
  -H "Authorization: Bearer [anon-key]" \
  -H "Content-Type: application/json" \
  -d @smoke_test_payload.json

# Second call (cache hit)
curl -X POST https://[staging-url]/functions/v1/nutrition_enrichment \
  -H "Authorization: Bearer [anon-key]" \
  -H "Content-Type: application/json" \
  -d @smoke_test_payload.json
```

---
_Ready for execution once edge function deployed to staging._ 