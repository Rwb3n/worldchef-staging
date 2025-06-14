// @ts-nocheck
// deno-lint-ignore-file no-explicit-any
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

/*
 * Nutrition Enrichment Edge Function – Provider-agnostic Skeleton (g111)
 * Contract: POST body { ingredients: Ingredient[] }
 * Returns: { nutritionData: object | null, confidence: number, provider: string }
 * Env: NUTRITION_PROVIDERS="usda,edamam,ai" (priority order)
 */

// Types
interface Ingredient { name: string; quantity: string; unit?: string }
interface NutritionResult { nutritionData: Record<string, any>; confidence: number; provider: string }

// Nutrition Enrichment Edge Function (stg_t009_c003)
// g113 – initial implementation

// Core nutrient IDs in FoodData Central
const USDA_NUTRIENTS = {
  calories: 1008,
  protein: 203,
  fat: 204,
  carbs: 205,
};

// Helper: extract macro-nutrients from FDC food response
function extractMacros(food: any) {
  const macros: Record<string, number> = { calories: 0, protein_g: 0, fat_g: 0, carbs_g: 0 };
  if (!food?.foodNutrients) return macros;
  for (const n of food.foodNutrients) {
    const num = Number(n.nutrient?.number || n.nutrientNumber);
    const amt = Number(n.amount);
    switch (num) {
      case USDA_NUTRIENTS.calories:
        macros.calories = amt; break;
      case USDA_NUTRIENTS.protein:
        macros.protein_g = amt; break;
      case USDA_NUTRIENTS.fat:
        macros.fat_g = amt; break;
      case USDA_NUTRIENTS.carbs:
        macros.carbs_g = amt; break;
    }
  }
  return macros;
}

// ⚡️ Lazy Supabase admin client for cache table (created on first use)
let _supabaseAdmin: ReturnType<typeof createClient> | null = null;
function getSupabaseAdmin() {
  if (_supabaseAdmin) return _supabaseAdmin;
  const url = Deno.env.get("SUPABASE_URL");
  const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!url || !key) {
    console.warn("[nutrition_enrichment] SUPABASE_URL or SERVICE_ROLE_KEY not set; cache disabled.");
    return null;
  }
  _supabaseAdmin = createClient(url, key);
  return _supabaseAdmin;
}

// Canonicalisation + hash util
async function ingredientHash(name: string, qty: number, unit: string): Promise<{hash: string, canonical: string}> {
  const unitMap: Record<string,string> = { g: "g", kg: "g", oz: "g", ml: "ml", l: "ml" };
  let canonicalQty = qty;
  const normalizedUnit = unit.toLowerCase();
  const canonicalUnit = unitMap[normalizedUnit] || normalizedUnit;
  if (normalizedUnit === "kg") canonicalQty = qty * 1000;
  if (normalizedUnit === "oz") canonicalQty = qty * 28.3495;
  if (normalizedUnit === "l") canonicalQty = qty * 1000;
  const canonicalStr = `${name.toLowerCase().trim()}|${canonicalUnit}|${canonicalQty}`;
  const hashBuf = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(canonicalStr));
  const hashArr = Array.from(new Uint8Array(hashBuf)).map(b=>b.toString(16).padStart(2,"0"));
  return { hash: hashArr.join(""), canonical: canonicalStr };
}

// Time-to-live in hours (default 168 = 7 days)
const TTL_HOURS = Number(Deno.env.get("NUTRITION_CACHE_TTL_HOURS") || 168);

// --- Provider registry ----------------------------------------------------
const providers: Record<string, (ing: Ingredient[]) => Promise<NutritionResult | null>> = {
  usda: async (ing) => {
    const key = Deno.env.get("USDA_API_KEY");
    if (!key) return null;
    // TODO: real call – placeholder 501
    return null;
  },
  edamam: async (ing) => {
    const appId = Deno.env.get("EDAMAM_APP_ID");
    const appKey = Deno.env.get("EDAMAM_APP_KEY");
    if (!appId || !appKey) return null;
    return null; // TODO
  },
  ai: async (ing) => {
    const openaiKey = Deno.env.get("OPENAI_API_KEY");
    if (!openaiKey) return null;
    return null; // TODO
  }
};

async function fetchNutrition(ingredients: Ingredient[]): Promise<NutritionResult | null> {
  const order = (Deno.env.get("NUTRITION_PROVIDERS") || "usda,ai").split(",");
  for (const name of order) {
    const fn = providers[name.trim()];
    if (!fn) continue;
    try {
      const res = await fn(ingredients);
      if (res && res.confidence >= 0.8) return res;
    } catch (_) {
      // fallthrough to next provider
    }
  }
  return null;
}

// --- HTTP handler ---------------------------------------------------------
// @ts-ignore Deno global
Deno.serve(async (req: Request) => {
  if (req.method !== "POST")
    return new Response("Method Not Allowed", { status: 405 });

  let body: any;
  try { body = await req.json(); } catch (_) {
    return new Response("Invalid JSON", { status: 400 });
  }
  const ingredients = Array.isArray(body?.ingredients) ? body.ingredients : [];
  if (ingredients.length === 0)
    return new Response("ingredients[] required", { status: 400 });

  const key = Deno.env.get("USDA_API_KEY");
  if (!key) return new Response("USDA key missing", { status: 500 });

  const items: any[] = [];
  const totals = { calories: 0, protein_g: 0, fat_g: 0, carbs_g: 0 };

  for (let i = 0; i < ingredients.length; i++) {
    const ing = ingredients[i];
    const { hash, canonical } = await ingredientHash(ing.name, ing.quantity || 1, ing.unit || "g");
    const admin = getSupabaseAdmin();
    let cacheHit: any = null;
    if (admin) {
      const res = await admin
        .from("nutrition_cache")
        .select("macros, expires_at")
        .eq("ingredient_hash", hash)
        .maybeSingle();
      cacheHit = res.data;
    }
    let macros;
    if (cacheHit && (!cacheHit.expires_at || new Date(cacheHit.expires_at) > new Date())) {
      macros = cacheHit.macros;
    } else {
      // 1️⃣ USDA lookup as before
      const searchUrl = `https://api.nal.usda.gov/fdc/v1/foods/search?api_key=${key}&query=${encodeURIComponent(ing.name)}&pageSize=1&nutrients=${Object.values(USDA_NUTRIENTS).join(',')}`;
      const searchRes = await fetch(searchUrl);
      const searchData = await searchRes.json();
      const first = searchData.foods?.[0];
      macros = extractMacros(first);
      const expiry = new Date(Date.now() + TTL_HOURS * 3600 * 1000).toISOString();
      if (admin) {
        // Upsert cache (ignoring errors)
        await admin.from("nutrition_cache").upsert({
          ingredient_hash: hash,
          canonical_string: canonical,
          macros,
          fdc_id: first?.fdcId || null,
          expires_at: expiry,
        });
      }
    }
    items.push({ ingredient_index: i, nutrition: macros });
    totals.calories += macros.calories;
    totals.protein_g += macros.protein_g;
    totals.fat_g += macros.fat_g;
    totals.carbs_g += macros.carbs_g;
  }

  const resp = {
    items,
    aggregate_totals: {
      calories: Math.round(totals.calories * 100) / 100,
      protein_g: Math.round(totals.protein_g * 100) / 100,
      fat_g: Math.round(totals.fat_g * 100) / 100,
      carbs_g: Math.round(totals.carbs_g * 100) / 100,
    },
    source: "USDA_FDC",
    generated_at: new Date().toISOString(),
  };

  return new Response(JSON.stringify(resp), {
    headers: { "Content-Type": "application/json" },
  });
});

export { ingredientHash }; 