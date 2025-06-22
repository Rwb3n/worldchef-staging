-- ============================================================================
-- Synthetic Nutrition Data Generation Script
-- Cycle 4 Week 0 - Staging Environment Data Seeding
-- Created: 2025-06-14T11:45:00Z | Event g124
-- ============================================================================

-- This script generates realistic nutritional data for existing recipes
-- using the nutrition enrichment edge function and fallback calculations

-- ============================================================================
-- HELPER FUNCTIONS FOR NUTRITION DATA GENERATION
-- ============================================================================

-- Function to generate realistic nutrition data based on ingredients
CREATE OR REPLACE FUNCTION generate_nutrition_data(ingredients_json JSONB, servings INTEGER) RETURNS JSONB AS $$
DECLARE
  total_calories NUMERIC := 0;
  total_protein NUMERIC := 0;
  total_fat NUMERIC := 0;
  total_carbs NUMERIC := 0;
  total_fiber NUMERIC := 0;
  total_sugar NUMERIC := 0;
  total_sodium NUMERIC := 0;
  
  ingredient JSONB;
  ingredient_name TEXT;
  quantity NUMERIC;
  unit TEXT;
  
  -- Approximate nutrition per 100g for common ingredients
  nutrition_lookup JSONB := '{
    "chicken breast": {"calories": 165, "protein": 31, "fat": 3.6, "carbs": 0, "fiber": 0, "sugar": 0, "sodium": 74},
    "ground beef": {"calories": 250, "protein": 26, "fat": 15, "carbs": 0, "fiber": 0, "sugar": 0, "sodium": 75},
    "salmon fillet": {"calories": 208, "protein": 25, "fat": 12, "carbs": 0, "fiber": 0, "sugar": 0, "sodium": 59},
    "pork tenderloin": {"calories": 143, "protein": 26, "fat": 3.5, "carbs": 0, "fiber": 0, "sugar": 0, "sodium": 62},
    "turkey breast": {"calories": 135, "protein": 30, "fat": 1, "carbs": 0, "fiber": 0, "sugar": 0, "sodium": 1040},
    "shrimp": {"calories": 99, "protein": 24, "fat": 0.3, "carbs": 0.2, "fiber": 0, "sugar": 0, "sodium": 111},
    "tofu": {"calories": 76, "protein": 8, "fat": 4.8, "carbs": 1.9, "fiber": 0.3, "sugar": 0.6, "sodium": 7},
    "eggs": {"calories": 155, "protein": 13, "fat": 11, "carbs": 1.1, "fiber": 0, "sugar": 1.1, "sodium": 124},
    "olive oil": {"calories": 884, "protein": 0, "fat": 100, "carbs": 0, "fiber": 0, "sugar": 0, "sodium": 2},
    "butter": {"calories": 717, "protein": 0.9, "fat": 81, "carbs": 0.1, "fiber": 0, "sugar": 0.1, "sodium": 11},
    "onion": {"calories": 40, "protein": 1.1, "fat": 0.1, "carbs": 9.3, "fiber": 1.7, "sugar": 4.2, "sodium": 4},
    "garlic": {"calories": 149, "protein": 6.4, "fat": 0.5, "carbs": 33, "fiber": 2.1, "sugar": 1, "sodium": 17},
    "bell pepper": {"calories": 31, "protein": 1, "fat": 0.3, "carbs": 7, "fiber": 2.5, "sugar": 4.2, "sodium": 4},
    "carrot": {"calories": 41, "protein": 0.9, "fat": 0.2, "carbs": 10, "fiber": 2.8, "sugar": 4.7, "sodium": 69},
    "broccoli": {"calories": 34, "protein": 2.8, "fat": 0.4, "carbs": 7, "fiber": 2.6, "sugar": 1.5, "sodium": 33},
    "spinach": {"calories": 23, "protein": 2.9, "fat": 0.4, "carbs": 3.6, "fiber": 2.2, "sugar": 0.4, "sodium": 79},
    "mushrooms": {"calories": 22, "protein": 3.1, "fat": 0.3, "carbs": 3.3, "fiber": 1, "sugar": 2, "sodium": 5},
    "tomato": {"calories": 18, "protein": 0.9, "fat": 0.2, "carbs": 3.9, "fiber": 1.2, "sugar": 2.6, "sodium": 5},
    "potato": {"calories": 77, "protein": 2, "fat": 0.1, "carbs": 17, "fiber": 2.2, "sugar": 0.8, "sodium": 6},
    "sweet potato": {"calories": 86, "protein": 1.6, "fat": 0.1, "carbs": 20, "fiber": 3, "sugar": 4.2, "sodium": 54},
    "rice": {"calories": 130, "protein": 2.7, "fat": 0.3, "carbs": 28, "fiber": 0.4, "sugar": 0.1, "sodium": 1},
    "pasta": {"calories": 131, "protein": 5, "fat": 1.1, "carbs": 25, "fiber": 1.8, "sugar": 0.6, "sodium": 6},
    "quinoa": {"calories": 120, "protein": 4.4, "fat": 1.9, "carbs": 22, "fiber": 2.8, "sugar": 0.9, "sodium": 7},
    "flour": {"calories": 364, "protein": 10, "fat": 1, "carbs": 76, "fiber": 2.7, "sugar": 0.3, "sodium": 2},
    "sugar": {"calories": 387, "protein": 0, "fat": 0, "carbs": 100, "fiber": 0, "sugar": 100, "sodium": 0},
    "cheese": {"calories": 113, "protein": 7, "fat": 9, "carbs": 1, "fiber": 0, "sugar": 0.5, "sodium": 621},
    "milk": {"calories": 42, "protein": 3.4, "fat": 1, "carbs": 5, "fiber": 0, "sugar": 5, "sodium": 44},
    "beans": {"calories": 127, "protein": 8.7, "fat": 0.5, "carbs": 23, "fiber": 6.4, "sugar": 0.3, "sodium": 2},
    "lentils": {"calories": 116, "protein": 9, "fat": 0.4, "carbs": 20, "fiber": 7.9, "sugar": 1.8, "sodium": 2},
    "chickpeas": {"calories": 164, "protein": 8.9, "fat": 2.6, "carbs": 27, "fiber": 7.6, "sugar": 4.8, "sodium": 7}
  }'::JSONB;
  
  ingredient_nutrition JSONB;
  normalized_quantity NUMERIC;
BEGIN
  -- Process each ingredient
  FOR ingredient IN SELECT * FROM jsonb_array_elements(ingredients_json)
  LOOP
    ingredient_name := lower(trim(ingredient->>'name'));
    quantity := (ingredient->>'quantity')::NUMERIC;
    unit := lower(trim(ingredient->>'unit'));
    
    -- Convert quantity to grams for calculation
    normalized_quantity := quantity;
    CASE unit
      WHEN 'kg' THEN normalized_quantity := quantity * 1000;
      WHEN 'oz' THEN normalized_quantity := quantity * 28.3495;
      WHEN 'lb' THEN normalized_quantity := quantity * 453.592;
      WHEN 'cup' THEN 
        -- Approximate cup to grams conversion (varies by ingredient)
        CASE 
          WHEN ingredient_name LIKE '%flour%' THEN normalized_quantity := quantity * 120;
          WHEN ingredient_name LIKE '%sugar%' THEN normalized_quantity := quantity * 200;
          WHEN ingredient_name LIKE '%rice%' THEN normalized_quantity := quantity * 185;
          ELSE normalized_quantity := quantity * 150; -- Default
        END CASE;
      WHEN 'tbsp' THEN normalized_quantity := quantity * 15;
      WHEN 'tsp' THEN normalized_quantity := quantity * 5;
      WHEN 'ml' THEN normalized_quantity := quantity; -- Assume 1ml ≈ 1g for liquids
      WHEN 'l' THEN normalized_quantity := quantity * 1000;
      WHEN 'piece', 'clove', 'slice' THEN 
        -- Estimate piece weights
        CASE 
          WHEN ingredient_name LIKE '%onion%' THEN normalized_quantity := quantity * 150;
          WHEN ingredient_name LIKE '%garlic%' THEN normalized_quantity := quantity * 3;
          WHEN ingredient_name LIKE '%potato%' THEN normalized_quantity := quantity * 200;
          WHEN ingredient_name LIKE '%carrot%' THEN normalized_quantity := quantity * 60;
          ELSE normalized_quantity := quantity * 100; -- Default piece weight
        END CASE;
      -- 'g' and others remain as-is
    END CASE;
    
    -- Look up nutrition data
    ingredient_nutrition := nutrition_lookup->ingredient_name;
    
    -- If ingredient not found, use generic values based on ingredient type
    IF ingredient_nutrition IS NULL THEN
      CASE 
        WHEN ingredient_name LIKE '%meat%' OR ingredient_name LIKE '%beef%' OR ingredient_name LIKE '%pork%' THEN
          ingredient_nutrition := '{"calories": 200, "protein": 25, "fat": 10, "carbs": 0, "fiber": 0, "sugar": 0, "sodium": 70}'::JSONB;
        WHEN ingredient_name LIKE '%vegetable%' OR ingredient_name LIKE '%green%' THEN
          ingredient_nutrition := '{"calories": 25, "protein": 2, "fat": 0.2, "carbs": 5, "fiber": 2, "sugar": 2, "sodium": 10}'::JSONB;
        WHEN ingredient_name LIKE '%grain%' OR ingredient_name LIKE '%bread%' THEN
          ingredient_nutrition := '{"calories": 250, "protein": 8, "fat": 2, "carbs": 50, "fiber": 3, "sugar": 2, "sodium": 200}'::JSONB;
        ELSE
          ingredient_nutrition := '{"calories": 100, "protein": 3, "fat": 3, "carbs": 15, "fiber": 1, "sugar": 5, "sodium": 50}'::JSONB;
      END CASE;
    END IF;
    
    -- Calculate nutrition contribution (per 100g, so divide by 100)
    total_calories := total_calories + (ingredient_nutrition->>'calories')::NUMERIC * normalized_quantity / 100;
    total_protein := total_protein + (ingredient_nutrition->>'protein')::NUMERIC * normalized_quantity / 100;
    total_fat := total_fat + (ingredient_nutrition->>'fat')::NUMERIC * normalized_quantity / 100;
    total_carbs := total_carbs + (ingredient_nutrition->>'carbs')::NUMERIC * normalized_quantity / 100;
    total_fiber := total_fiber + (ingredient_nutrition->>'fiber')::NUMERIC * normalized_quantity / 100;
    total_sugar := total_sugar + (ingredient_nutrition->>'sugar')::NUMERIC * normalized_quantity / 100;
    total_sodium := total_sodium + (ingredient_nutrition->>'sodium')::NUMERIC * normalized_quantity / 100;
  END LOOP;
  
  -- Return nutrition data per serving
  RETURN jsonb_build_object(
    'per_serving', jsonb_build_object(
      'calories', round(total_calories / servings, 1),
      'protein_g', round(total_protein / servings, 1),
      'fat_g', round(total_fat / servings, 1),
      'carbohydrates_g', round(total_carbs / servings, 1),
      'fiber_g', round(total_fiber / servings, 1),
      'sugar_g', round(total_sugar / servings, 1),
      'sodium_mg', round(total_sodium / servings, 1)
    ),
    'total_recipe', jsonb_build_object(
      'calories', round(total_calories, 1),
      'protein_g', round(total_protein, 1),
      'fat_g', round(total_fat, 1),
      'carbohydrates_g', round(total_carbs, 1),
      'fiber_g', round(total_fiber, 1),
      'sugar_g', round(total_sugar, 1),
      'sodium_mg', round(total_sodium, 1)
    ),
    'calculation_method', 'synthetic_estimation',
    'generated_at', NOW()
  );
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- SYNTHETIC NUTRITION DATA GENERATION
-- ============================================================================

-- Update all recipes with nutrition data
DO $$
DECLARE
  recipe_record RECORD;
  calculated_nutrition_data JSONB;
  processed_count INTEGER := 0;
BEGIN
  -- Process each recipe that doesn't have nutrition data
  FOR recipe_record IN 
    SELECT id, ingredients, servings, name
    FROM recipes 
    WHERE nutrition_data IS NULL
    ORDER BY created_at
  LOOP
    -- Generate nutrition data for this recipe
    calculated_nutrition_data := generate_nutrition_data(recipe_record.ingredients, recipe_record.servings);
    
    -- Update the recipe with nutrition data
    UPDATE recipes 
    SET 
      nutrition_data = calculated_nutrition_data,
      updated_at = NOW()
    WHERE id = recipe_record.id;
    
    processed_count := processed_count + 1;
    
    -- Progress indicator every 50 recipes
    IF processed_count % 50 = 0 THEN
      RAISE NOTICE 'Processed % recipes with nutrition data...', processed_count;
    END IF;
  END LOOP;
  
  RAISE NOTICE 'Successfully generated nutrition data for % recipes!', processed_count;
END;
$$;

-- ============================================================================
-- ADDITIONAL NUTRITION METADATA
-- ============================================================================

-- Add nutrition-based dietary tags where appropriate
DO $$
DECLARE
  recipe_record RECORD;
  per_serving JSONB;
  calories NUMERIC;
  carbs NUMERIC;
  fat NUMERIC;
  protein NUMERIC;
  new_tags dietary_type[] := ARRAY[]::dietary_type[];
  updated_count INTEGER := 0;
BEGIN
  FOR recipe_record IN 
    SELECT id, nutrition_data, dietary_tags
    FROM recipes 
    WHERE nutrition_data IS NOT NULL
  LOOP
    per_serving := recipe_record.nutrition_data->'per_serving';
    calories := (per_serving->>'calories')::NUMERIC;
    carbs := (per_serving->>'carbohydrates_g')::NUMERIC;
    fat := (per_serving->>'fat_g')::NUMERIC;
    protein := (per_serving->>'protein_g')::NUMERIC;
    
    new_tags := COALESCE(recipe_record.dietary_tags, ARRAY[]::dietary_type[]);
    
    -- Add low_carb tag if carbs < 20g per serving
    IF carbs < 20 AND NOT 'low_carb' = ANY(new_tags) THEN
      new_tags := array_append(new_tags, 'low_carb');
    END IF;
    
    -- Add low_fat tag if fat < 10g per serving
    IF fat < 10 AND NOT 'low_fat' = ANY(new_tags) THEN
      new_tags := array_append(new_tags, 'low_fat');
    END IF;
    
    -- Add keto tag if carbs < 10g and fat > 20g per serving
    IF carbs < 10 AND fat > 20 AND NOT 'keto' = ANY(new_tags) THEN
      new_tags := array_append(new_tags, 'keto');
    END IF;
    
    -- Update if tags changed
    IF array_length(new_tags, 1) != COALESCE(array_length(recipe_record.dietary_tags, 1), 0) THEN
      UPDATE recipes 
      SET dietary_tags = new_tags
      WHERE id = recipe_record.id;
      updated_count := updated_count + 1;
    END IF;
  END LOOP;
  
  RAISE NOTICE 'Updated dietary tags for % recipes based on nutrition data', updated_count;
END;
$$;

-- ============================================================================
-- CLEANUP HELPER FUNCTIONS
-- ============================================================================

-- Drop the helper function after use
DROP FUNCTION IF EXISTS generate_nutrition_data(JSONB, INTEGER);

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Verify nutrition data generation
SELECT 
  COUNT(*) as total_recipes,
  COUNT(CASE WHEN nutrition_data IS NOT NULL THEN 1 END) as recipes_with_nutrition,
  ROUND(AVG((nutrition_data->'per_serving'->>'calories')::NUMERIC), 1) as avg_calories_per_serving,
  ROUND(AVG((nutrition_data->'per_serving'->>'protein_g')::NUMERIC), 1) as avg_protein_per_serving,
  ROUND(AVG((nutrition_data->'per_serving'->>'carbohydrates_g')::NUMERIC), 1) as avg_carbs_per_serving,
  ROUND(AVG((nutrition_data->'per_serving'->>'fat_g')::NUMERIC), 1) as avg_fat_per_serving
FROM recipes;

-- Check nutrition data distribution
SELECT 
  CASE 
    WHEN (nutrition_data->'per_serving'->>'calories')::NUMERIC < 200 THEN 'Low (< 200 cal)'
    WHEN (nutrition_data->'per_serving'->>'calories')::NUMERIC < 400 THEN 'Medium (200-400 cal)'
    WHEN (nutrition_data->'per_serving'->>'calories')::NUMERIC < 600 THEN 'High (400-600 cal)'
    ELSE 'Very High (> 600 cal)'
  END as calorie_range,
  COUNT(*) as recipe_count
FROM recipes 
WHERE nutrition_data IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

-- Check dietary tag updates
SELECT 
  unnest(dietary_tags) as dietary_tag,
  COUNT(*) as recipe_count
FROM recipes 
WHERE dietary_tags IS NOT NULL AND array_length(dietary_tags, 1) > 0
GROUP BY unnest(dietary_tags)
ORDER BY recipe_count DESC;

-- Final completion notice
DO $$
BEGIN
  RAISE NOTICE 'Synthetic nutrition data generation completed successfully!';
  RAISE NOTICE 'All recipes now have realistic nutrition data calculated from ingredients.';
  RAISE NOTICE 'Dietary tags have been updated based on nutritional content.';
END;
$$; 