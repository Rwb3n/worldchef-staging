-- Core WorldChef Database Schema
-- Created to fix nightly refresh script failures
-- Defines all tables and types referenced by seeding scripts

-- ============================================================================
-- CUSTOM TYPES
-- ============================================================================

-- User role enumeration
CREATE TYPE user_role AS ENUM ('standard', 'creator', 'moderator', 'admin');

-- Dietary preference enumeration  
CREATE TYPE dietary_type AS ENUM (
  'vegetarian', 'vegan', 'gluten_free', 'dairy_free', 'keto', 
  'paleo', 'low_carb', 'low_fat', 'halal', 'kosher'
);

-- Recipe status enumeration
CREATE TYPE recipe_status AS ENUM ('draft', 'published', 'archived', 'admin_removed');

-- Recipe difficulty enumeration
CREATE TYPE difficulty_type AS ENUM ('easy', 'medium', 'hard');

-- Cuisine type enumeration
CREATE TYPE cuisine_type AS ENUM (
  'american', 'italian', 'mexican', 'chinese', 'indian', 'thai', 
  'french', 'mediterranean', 'japanese', 'korean'
);

-- Meal type enumeration
CREATE TYPE meal_type AS ENUM (
  'breakfast', 'lunch', 'dinner', 'snack', 'dessert', 'appetizer'
);

-- ============================================================================
-- CORE TABLES
-- ============================================================================

-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  display_name VARCHAR(255) NOT NULL,
  role user_role NOT NULL DEFAULT 'standard',
  avatar_url TEXT,
  bio TEXT,
  location VARCHAR(255),
  dietary_preferences dietary_type[] DEFAULT ARRAY[]::dietary_type[],
  is_verified BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_active_at TIMESTAMPTZ,
  deleted_at TIMESTAMPTZ
);

-- Recipes table
CREATE TABLE recipes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  ingredients JSONB NOT NULL DEFAULT '[]'::JSONB,
  instructions TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  prep_time_minutes INTEGER,
  cook_time_minutes INTEGER,
  servings INTEGER CHECK (servings > 0),
  difficulty difficulty_type DEFAULT 'medium',
  cuisine cuisine_type,
  meal_type meal_type,
  dietary_tags dietary_type[] DEFAULT ARRAY[]::dietary_type[],
  nutrition_data JSONB,
  is_public BOOLEAN NOT NULL DEFAULT true,
  status recipe_status NOT NULL DEFAULT 'draft',
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

-- Recipe likes table
CREATE TABLE recipe_likes (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, recipe_id)
);

-- Recipe favorites table
CREATE TABLE recipe_favorites (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, recipe_id)
);

-- Recipe ratings table
CREATE TABLE recipe_ratings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, recipe_id)
);

-- User collections table
CREATE TABLE user_collections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  is_public BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Collection recipes table (many-to-many)
CREATE TABLE collection_recipes (
  collection_id UUID NOT NULL REFERENCES user_collections(id) ON DELETE CASCADE,
  recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  added_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (collection_id, recipe_id)
);

-- User follows table (social following)
CREATE TABLE user_follows (
  follower_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  following_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (follower_id, following_id),
  CHECK (follower_id != following_id)
);

-- Recipe collections table (alternative naming used in seeding scripts)
CREATE TABLE recipe_collections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  is_public BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Recipe collection items table (alternative naming)
CREATE TABLE recipe_collection_items (
  collection_id UUID NOT NULL REFERENCES recipe_collections(id) ON DELETE CASCADE,
  recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  added_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (collection_id, recipe_id)
);

-- ============================================================================
-- INDEXES
-- ============================================================================

-- User indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Recipe indexes
CREATE INDEX idx_recipes_author_id ON recipes(author_id);
CREATE INDEX idx_recipes_status ON recipes(status);
CREATE INDEX idx_recipes_cuisine ON recipes(cuisine);
CREATE INDEX idx_recipes_meal_type ON recipes(meal_type);
CREATE INDEX idx_recipes_created_at ON recipes(created_at);
CREATE INDEX idx_recipes_published_at ON recipes(published_at);

-- Like/favorite indexes
CREATE INDEX idx_recipe_likes_recipe_id ON recipe_likes(recipe_id);
CREATE INDEX idx_recipe_likes_created_at ON recipe_likes(created_at);
CREATE INDEX idx_recipe_favorites_recipe_id ON recipe_favorites(recipe_id);
CREATE INDEX idx_recipe_favorites_created_at ON recipe_favorites(created_at);

-- Rating indexes
CREATE INDEX idx_recipe_ratings_recipe_id ON recipe_ratings(recipe_id);
CREATE INDEX idx_recipe_ratings_rating ON recipe_ratings(rating);

-- Collection indexes
CREATE INDEX idx_user_collections_user_id ON user_collections(user_id);
CREATE INDEX idx_collection_recipes_recipe_id ON collection_recipes(recipe_id);

-- Follow indexes
CREATE INDEX idx_user_follows_follower_id ON user_follows(follower_id);
CREATE INDEX idx_user_follows_following_id ON user_follows(following_id);
CREATE INDEX idx_user_follows_created_at ON user_follows(created_at);

-- Recipe collection indexes
CREATE INDEX idx_recipe_collections_user_id ON recipe_collections(user_id);
CREATE INDEX idx_recipe_collection_items_recipe_id ON recipe_collection_items(recipe_id);

-- ============================================================================
-- CONSTRAINTS AND VALIDATION
-- ============================================================================

-- Validate ingredients JSONB structure
ALTER TABLE recipes ADD CONSTRAINT chk_ingredients_is_array 
  CHECK (jsonb_typeof(ingredients) = 'array');

-- Validate nutrition_data JSONB structure when present
ALTER TABLE recipes ADD CONSTRAINT chk_nutrition_data_structure 
  CHECK (nutrition_data IS NULL OR jsonb_typeof(nutrition_data) = 'object');

-- Validate instructions array is not empty for published recipes
ALTER TABLE recipes ADD CONSTRAINT chk_instructions_not_empty_when_published
  CHECK (status != 'published' OR array_length(instructions, 1) > 0);

-- ============================================================================
-- TRIGGERS FOR UPDATED_AT
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at triggers
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_recipes_updated_at BEFORE UPDATE ON recipes 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_recipe_ratings_updated_at BEFORE UPDATE ON recipe_ratings 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_collections_updated_at BEFORE UPDATE ON user_collections 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_recipe_collections_updated_at BEFORE UPDATE ON recipe_collections 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column(); 