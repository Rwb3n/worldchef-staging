// Debug cache operations for nutrition_enrichment Edge Function
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Test different client configurations
function getSupabaseAdmin() {
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const supabaseServiceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  
  console.log("Environment check:", {
    hasUrl: !!supabaseUrl,
    hasServiceKey: !!supabaseServiceRoleKey,
    urlPrefix: supabaseUrl?.substring(0, 20) + "...",
    keyPrefix: supabaseServiceRoleKey?.substring(0, 20) + "..."
  });
  
  if (!supabaseUrl || !supabaseServiceRoleKey) {
    console.error("Missing Supabase credentials");
    return null;
  }
  
  // Try different client configurations
  return createClient(supabaseUrl, supabaseServiceRoleKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false
    },
    db: {
      schema: 'public'
    }
  });
}

async function ingredientHash(
  name: string, 
  quantity: number, 
  unit: string
): Promise<{ hash: string, canonical: string }> {
  const canonical = `${name.toLowerCase().trim()}:${quantity}:${unit.toLowerCase()}`;
  
  const encoder = new TextEncoder();
  const data = encoder.encode(canonical);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  const hash = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
  
  return { hash, canonical };
}

async function debugCacheOperation() {
  console.log("🔍 Starting comprehensive cache debug...");
  
  const admin = getSupabaseAdmin();
  if (!admin) {
    console.error("❌ Failed to get Supabase admin client");
    return { success: false, error: "No admin client" };
  }
  
  console.log("✅ Supabase admin client created");
  
  // Test 1: Basic table access
  console.log("🔍 Testing basic table access...");
  try {
    const { data, error, count } = await admin
      .from("nutrition_cache")
      .select("*", { count: 'exact' });
      
    console.log("Basic table access result:", { 
      recordCount: count, 
      error: error,
      hasData: !!data 
    });
    
    if (error) {
      console.error("❌ Basic table access failed:", error);
      return { success: false, error: error, step: "basic_access" };
    }
  } catch (e) {
    console.error("❌ Basic table access exception:", e);
    return { success: false, error: e, step: "basic_access_exception" };
  }
  
  // Test 2: Simple insert with minimal data
  console.log("🔍 Testing simple insert...");
  const testHash = "debug_" + Date.now();
  try {
    const { data: insertData, error: insertError } = await admin
      .from("nutrition_cache")
      .insert({
        ingredient_hash: testHash,
        canonical_string: "debug:100:g",
        macros: { calories: 100, protein_g: 10, fat_g: 5, carbs_g: 15 },
        source: 'DEBUG_SIMPLE',
        expires_at: new Date(Date.now() + 3600000).toISOString()
      })
      .select();
      
    console.log("Simple insert result:", { insertData, insertError });
    
    if (insertError) {
      console.error("❌ Simple insert failed:", {
        code: insertError.code,
        message: insertError.message,
        details: insertError.details,
        hint: insertError.hint
      });
      return { success: false, error: insertError, step: "simple_insert" };
    }
  } catch (e) {
    console.error("❌ Simple insert exception:", e);
    return { success: false, error: e, step: "simple_insert_exception" };
  }
  
  // Test 3: Verify the insert worked
  console.log("🔍 Verifying insert...");
  try {
    const { data: verifyData, error: verifyError } = await admin
      .from("nutrition_cache")
      .select("*")
      .eq("ingredient_hash", testHash)
      .single();
      
    console.log("Verify result:", { verifyData, verifyError });
    
    if (verifyData) {
      console.log("✅ Cache operations working correctly!");
      return { 
        success: true, 
        message: "Cache operations working", 
        testRecord: verifyData 
      };
    } else {
      console.error("❌ Verification failed - no data found");
      return { success: false, error: "Verification failed", step: "verify" };
    }
  } catch (e) {
    console.error("❌ Verify exception:", e);
    return { success: false, error: e, step: "verify_exception" };
  }
}

// Debug HTTP handler
Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }

  console.log("🚀 Starting cache debug session...");
  
  const result = await debugCacheOperation();
  
  return new Response(JSON.stringify({
    debug_result: result,
    timestamp: new Date().toISOString()
  }), {
    headers: { "Content-Type": "application/json" }
  });
}); 