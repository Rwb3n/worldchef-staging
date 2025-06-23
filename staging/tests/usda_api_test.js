// Test script to understand USDA API response structure
const USDA_API_KEY = process.env.USDA_API_KEY || "DEMO_KEY";

const USDA_NUTRIENTS = {
  calories: 208,  // Energy (kcal) - corrected from 1008
  protein: 203,   // Protein
  fat: 204,       // Total lipid (fat)
  carbs: 205,     // Carbohydrate, by difference
};

// Helper: extract macro-nutrients from FDC food response (fixed version)
function extractMacros(food) {
  const macros = { calories: 0, protein_g: 0, fat_g: 0, carbs_g: 0 };
  if (!food?.foodNutrients) return macros;
  
  console.log("Processing foodNutrients:", food.foodNutrients.length, "items");
  
  for (const n of food.foodNutrients) {
    // USDA API returns nutrientNumber (not nested nutrient.number) and value (not amount)
    const num = Number(n.nutrientNumber);
    const amt = Number(n.value || 0);
    
    console.log(`  Nutrient ${num}: ${amt} (looking for: ${Object.values(USDA_NUTRIENTS).join(', ')})`);
    
    switch (num) {
      case USDA_NUTRIENTS.calories:
        macros.calories = amt; 
        console.log(`    -> Set calories to ${amt}`);
        break;
      case USDA_NUTRIENTS.protein:
        macros.protein_g = amt; 
        console.log(`    -> Set protein to ${amt}g`);
        break;
      case USDA_NUTRIENTS.fat:
        macros.fat_g = amt; 
        console.log(`    -> Set fat to ${amt}g`);
        break;
      case USDA_NUTRIENTS.carbs:
        macros.carbs_g = amt; 
        console.log(`    -> Set carbs to ${amt}g`);
        break;
    }
  }
  return macros;
}

async function testUSDAAPI() {
  const ingredient = "chicken breast";
  const searchUrl = `https://api.nal.usda.gov/fdc/v1/foods/search?api_key=${USDA_API_KEY}&query=${encodeURIComponent(ingredient)}&pageSize=1&nutrients=${Object.values(USDA_NUTRIENTS).join(',')}`;
  
  console.log("Testing USDA API with:", ingredient);
  console.log("Nutrient IDs:", USDA_NUTRIENTS);
  
  try {
    const response = await fetch(searchUrl);
    const data = await response.json();
    
    if (data.foods && data.foods[0]) {
      const food = data.foods[0];
      console.log("\n=== FOOD ITEM ===");
      console.log("Description:", food.description);
      console.log("FDC ID:", food.fdcId);
      
      console.log("\n=== EXTRACTING MACROS ===");
      const macros = extractMacros(food);
      
      console.log("\n=== FINAL RESULTS ===");
      console.log("Macros:", macros);
      
      // Check if we got valid data
      const hasData = macros.calories > 0 || macros.protein_g > 0 || macros.fat_g > 0 || macros.carbs_g > 0;
      console.log("Has nutrition data:", hasData);
      
    } else {
      console.log("No foods found in response");
      console.log("Response:", JSON.stringify(data, null, 2));
    }
    
  } catch (error) {
    console.error("Error:", error);
  }
}

testUSDAAPI(); 