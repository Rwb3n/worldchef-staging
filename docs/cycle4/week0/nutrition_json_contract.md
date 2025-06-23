# Nutrition Enrichment JSON Contract (stg_t009)

> Artifact: nutrition_json_contract | Generated at g112

This document defines the **request** and **response** JSON payloads used by the _nutrition enrichment_ edge function. The contract is intentionally backend‐agnostic so that callers (mobile apps, backend jobs, CLI tools) share a single canonical format.

---
## 1. Request Payload
```json
{
  "ingredients": [
    { "name": "chicken breast", "quantity": 200, "unit": "g", "preparation": "grilled" },
    { "name": "olive oil",        "quantity":   1, "unit": "tbsp" }
  ]
}
```
Field rules:
• **ingredients** – array (≥1). Each object must contain:
  • **name** *(string, required)* – human-readable ingredient label.
  • **quantity** *(number, required)* – numeric amount.
  • **unit** *(string, required)* – SI / common food units ("g", "ml", "cup", "tbsp", …).
Optional keys: **preparation** (string), **brand** (string), **fdc_id** (integer – USDA FoodData Central code).

---
## 2. Response Payload
```json
{
  "items": [
    {
      "ingredient_index": 0,
      "nutrition": { "calories": 330, "protein_g": 31, "fat_g": 20, "carbs_g": 0 }
    },
    {
      "ingredient_index": 1,
      "nutrition": { "calories": 119, "protein_g": 0, "fat_g": 14, "carbs_g": 0 }
    }
  ],
  "aggregate_totals": {
    "calories": 449,
    "protein_g": 31,
    "fat_g": 34,
    "carbs_g": 0
  },
  "source": "USDA_FDC",
  "generated_at": "2025-06-14T09:15:00Z"
}
```
Key sections:
• **items** – per-ingredient nutrition; `ingredient_index` maps to request array position.
• **aggregate_totals** – summed nutrition for entire recipe.
• **source** – enum: `USDA_FDC`, `EDAMAM_API`, `GPT_FALLBACK`.

---
## 3. Precision & Units
* All macro- & micro-nutrients use metric units (g or mg). *calories* expressed in kcal.
* Edge function must round values to **≤2 decimal places**.

---
## 4. Future Extensions
The schema purposefully avoids over-specification. New nutrients (e.g., omega-3, cholesterol) may be added under `nutrition` objects without breaking clients, provided they remain optional.

---
_End of contract._ 