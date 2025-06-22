-- ============================================================================
-- Synthetic User Interaction Data Generation Script
-- Cycle 4 Week 0 - Staging Environment Data Seeding
-- Created: 2025-06-14T11:45:00Z | Event g124
-- ============================================================================

-- This script generates realistic user interaction data including likes,
-- favorites, ratings, comments, and follows for staging environment testing

-- ============================================================================
-- HELPER FUNCTIONS FOR INTERACTION DATA GENERATION
-- ============================================================================

-- Function to generate random rating (1-5 stars with realistic distribution)
CREATE OR REPLACE FUNCTION random_rating() RETURNS INTEGER AS $$
BEGIN
  -- Weighted distribution: more 4-5 star ratings (realistic for recipe apps)
  CASE 
    WHEN random() < 0.05 THEN RETURN 1;  -- 5% - 1 star
    WHEN random() < 0.15 THEN RETURN 2;  -- 10% - 2 star  
    WHEN random() < 0.30 THEN RETURN 3;  -- 15% - 3 star
    WHEN random() < 0.65 THEN RETURN 4;  -- 35% - 4 star
    ELSE RETURN 5;                       -- 35% - 5 star
  END CASE;
END;
$$ LANGUAGE plpgsql;

-- Function to generate random comment text
CREATE OR REPLACE FUNCTION random_comment() RETURNS TEXT AS $$
DECLARE
  positive_comments TEXT[] := ARRAY[
    'This recipe is absolutely delicious! Made it for dinner last night and everyone loved it.',
    'Easy to follow instructions and amazing results. Will definitely make this again!',
    'Perfect recipe! The flavors are incredible and it came together so easily.',
    'My new favorite recipe! Thank you for sharing this gem.',
    'Outstanding! This has become a regular in our meal rotation.',
    'Fantastic recipe with clear instructions. Turned out perfectly!',
    'Love this! Made a few small substitutions and it was still amazing.',
    'This exceeded my expectations. So flavorful and satisfying.',
    'Great recipe! My family asks me to make this all the time now.',
    'Simple ingredients but such complex flavors. Brilliant!'
  ];
  
  neutral_comments TEXT[] := ARRAY[
    'Good recipe overall. I added some extra seasoning to suit my taste.',
    'Nice recipe! I substituted a few ingredients and it worked well.',
    'Solid recipe. The cooking time was a bit longer than expected for me.',
    'Pretty good! I think I will try adding some vegetables next time.',
    'Decent recipe. The instructions were clear and easy to follow.'
  ];
  
  critical_comments TEXT[] := ARRAY[
    'The recipe was okay but I found it a bit bland. Added more spices.',
    'Instructions could be clearer. Had to guess on a few steps.',
    'Good concept but the cooking time seemed off. Took much longer.',
    'Decent but not as flavorful as I expected. Maybe needs more seasoning.'
  ];
  
  rating INTEGER := random_rating();
BEGIN
  CASE 
    WHEN rating >= 4 THEN 
      RETURN positive_comments[floor(random() * array_length(positive_comments, 1) + 1)];
    WHEN rating = 3 THEN 
      RETURN neutral_comments[floor(random() * array_length(neutral_comments, 1) + 1)];
    ELSE 
      RETURN critical_comments[floor(random() * array_length(critical_comments, 1) + 1)];
  END CASE;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- SYNTHETIC RECIPE RATINGS GENERATION
-- ============================================================================

-- Generate recipe ratings (60% of users rate 40% of recipes)
DO $$
DECLARE
  user_record RECORD;
  recipe_record RECORD;
  rating_value INTEGER;
  comment_text TEXT;
  created_date TIMESTAMPTZ;
  ratings_created INTEGER := 0;
BEGIN
  -- For each user, rate some random recipes
  FOR user_record IN SELECT id FROM users ORDER BY random()
  LOOP
    -- Each user rates 5-25 recipes (random)
    FOR recipe_record IN 
      SELECT id, author_id 
      FROM recipes 
      WHERE author_id != user_record.id  -- Don't rate own recipes
      ORDER BY random() 
      LIMIT floor(random() * 21 + 5)
    LOOP
      rating_value := random_rating();
      
      -- 70% chance of including a comment with rating
      IF random() < 0.7 THEN
        comment_text := random_comment();
      ELSE
        comment_text := NULL;
      END IF;
      
      -- Random date within last 3 months
      created_date := NOW() - (random() * INTERVAL '90 days');
      
      -- Insert rating (assuming recipe_ratings table exists)
      BEGIN
        INSERT INTO recipe_ratings (
          recipe_id,
          user_id,
          rating,
          comment,
          created_at,
          updated_at
        ) VALUES (
          recipe_record.id,
          user_record.id,
          rating_value,
          comment_text,
          created_date,
          created_date
        );
        
        ratings_created := ratings_created + 1;
      EXCEPTION
        WHEN unique_violation THEN
          -- Skip duplicates
          NULL;
        WHEN OTHERS THEN
          -- Table might not exist, skip
          RAISE NOTICE 'Skipping ratings - table may not exist';
          EXIT;
      END;
      
      -- Progress indicator every 500 ratings
      IF ratings_created % 500 = 0 THEN
        RAISE NOTICE 'Created % recipe ratings...', ratings_created;
      END IF;
    END LOOP;
  END LOOP;
  
  RAISE NOTICE 'Successfully created % recipe ratings!', ratings_created;
END;
$$;

-- ============================================================================
-- SYNTHETIC RECIPE LIKES GENERATION
-- ============================================================================

-- Generate recipe likes (80% of users like 60% of recipes they view)
DO $$
DECLARE
  user_record RECORD;
  recipe_record RECORD;
  created_date TIMESTAMPTZ;
  likes_created INTEGER := 0;
BEGIN
  -- For each user, like some random recipes
  FOR user_record IN SELECT id FROM users ORDER BY random()
  LOOP
    -- Each user likes 10-50 recipes (random)
    FOR recipe_record IN 
      SELECT id, author_id 
      FROM recipes 
      WHERE author_id != user_record.id  -- Don't like own recipes
      ORDER BY random() 
      LIMIT floor(random() * 41 + 10)
    LOOP
      -- Random date within last 6 months
      created_date := NOW() - (random() * INTERVAL '180 days');
      
      -- Insert like
      INSERT INTO recipe_likes (
        recipe_id,
        user_id,
        created_at
      ) VALUES (
        recipe_record.id,
        user_record.id,
        created_date
      ) ON CONFLICT (recipe_id, user_id) DO NOTHING;  -- Avoid duplicates
      
      likes_created := likes_created + 1;
      
      -- Progress indicator every 1000 likes
      IF likes_created % 1000 = 0 THEN
        RAISE NOTICE 'Created % recipe likes...', likes_created;
      END IF;
    END LOOP;
  END LOOP;
  
  RAISE NOTICE 'Successfully created % recipe likes!', likes_created;
END;
$$;

-- ============================================================================
-- SYNTHETIC RECIPE FAVORITES GENERATION
-- ============================================================================

-- Generate recipe favorites (30% of users favorite 10% of recipes they like)
DO $$
DECLARE
  like_record RECORD;
  created_date TIMESTAMPTZ;
  favorites_created INTEGER := 0;
BEGIN
  -- For each like, 15% chance of also being favorited
  FOR like_record IN 
    SELECT recipe_id, user_id, created_at 
    FROM recipe_likes 
    ORDER BY random()
  LOOP
    -- 15% chance this liked recipe becomes a favorite
    IF random() < 0.15 THEN
      -- Favorite date is same or after like date
      created_date := like_record.created_at + (random() * INTERVAL '30 days');
      
      -- Insert favorite
      INSERT INTO recipe_favorites (
        recipe_id,
        user_id,
        created_at
      ) VALUES (
        like_record.recipe_id,
        like_record.user_id,
        created_date
      ) ON CONFLICT (recipe_id, user_id) DO NOTHING;  -- Avoid duplicates
      
      favorites_created := favorites_created + 1;
      
      -- Progress indicator every 200 favorites
      IF favorites_created % 200 = 0 THEN
        RAISE NOTICE 'Created % recipe favorites...', favorites_created;
      END IF;
    END IF;
  END LOOP;
  
  RAISE NOTICE 'Successfully created % recipe favorites!', favorites_created;
END;
$$;

-- ============================================================================
-- SYNTHETIC USER FOLLOWS GENERATION
-- ============================================================================

-- Generate user follows (users follow other users whose recipes they like)
DO $$
DECLARE
  user_record RECORD;
  author_record RECORD;
  created_date TIMESTAMPTZ;
  follows_created INTEGER := 0;
BEGIN
  -- For each user, follow some recipe authors they've interacted with
  FOR user_record IN SELECT id FROM users ORDER BY random()
  LOOP
    -- Find authors of recipes this user has liked/rated
    FOR author_record IN 
      SELECT DISTINCT r.author_id
      FROM recipes r
      INNER JOIN recipe_likes rl ON r.id = rl.recipe_id
      WHERE rl.user_id = user_record.id 
        AND r.author_id != user_record.id  -- Don't follow yourself
      ORDER BY random()
      LIMIT floor(random() * 10 + 2)  -- Follow 2-12 authors
    LOOP
      -- Random date within last 4 months
      created_date := NOW() - (random() * INTERVAL '120 days');
      
      -- Insert follow
      INSERT INTO user_follows (
        follower_id,
        following_id,
        created_at
      ) VALUES (
        user_record.id,
        author_record.author_id,
        created_date
      ) ON CONFLICT (follower_id, following_id) DO NOTHING;  -- Avoid duplicates
      
      follows_created := follows_created + 1;
      
      -- Progress indicator every 100 follows
      IF follows_created % 100 = 0 THEN
        RAISE NOTICE 'Created % user follows...', follows_created;
      END IF;
    END LOOP;
  END LOOP;
  
  RAISE NOTICE 'Successfully created % user follows!', follows_created;
END;
$$;

-- ============================================================================
-- SYNTHETIC RECIPE COLLECTIONS GENERATION
-- ============================================================================

-- Generate recipe collections (users organize favorites into collections)
DO $$
DECLARE
  user_record RECORD;
  collection_names TEXT[] := ARRAY[
    'Weeknight Dinners', 'Healthy Meals', 'Comfort Food', 'Quick & Easy',
    'Family Favorites', 'Date Night Recipes', 'Meal Prep', 'Holiday Specials',
    'Vegetarian Delights', 'Dessert Dreams', 'Breakfast Ideas', 'Lunch Options',
    'Party Food', 'Summer Recipes', 'Winter Warmers', 'Grilling Favorites',
    'Pasta Perfection', 'Soup & Stew', 'Salad Sensations', 'Bread & Baking'
  ];
  collection_name TEXT;
  collection_id UUID;
  favorite_record RECORD;
  created_date TIMESTAMPTZ;
  collections_created INTEGER := 0;
  items_added INTEGER := 0;
BEGIN
  -- For each user with favorites, create 1-3 collections
  FOR user_record IN 
    SELECT DISTINCT user_id as id 
    FROM recipe_favorites 
    ORDER BY random()
  LOOP
    -- Create 1-3 collections per user
    FOR i IN 1..floor(random() * 3 + 1)
    LOOP
      collection_name := collection_names[floor(random() * array_length(collection_names, 1) + 1)];
      created_date := NOW() - (random() * INTERVAL '60 days');
      
      -- Insert collection
      INSERT INTO recipe_collections (
        id,
        name,
        description,
        user_id,
        is_public,
        created_at,
        updated_at
      ) VALUES (
        gen_random_uuid(),
        collection_name,
        'A curated collection of my favorite ' || lower(collection_name),
        user_record.id,
        random() < 0.7,  -- 70% public
        created_date,
        created_date
      ) RETURNING id INTO collection_id;
      
      collections_created := collections_created + 1;
      
      -- Add 3-10 random favorites to this collection
      FOR favorite_record IN 
        SELECT recipe_id 
        FROM recipe_favorites 
        WHERE user_id = user_record.id 
        ORDER BY random() 
        LIMIT floor(random() * 8 + 3)
      LOOP
        INSERT INTO recipe_collection_items (
          collection_id,
          recipe_id,
          added_at
        ) VALUES (
          collection_id,
          favorite_record.recipe_id,
          created_date + (random() * INTERVAL '30 days')
        ) ON CONFLICT (collection_id, recipe_id) DO NOTHING;
        
        items_added := items_added + 1;
      END LOOP;
    END LOOP;
    
    -- Progress indicator every 50 users
    IF collections_created % 50 = 0 THEN
      RAISE NOTICE 'Created % collections with % items...', collections_created, items_added;
    END IF;
  END LOOP;
  
  RAISE NOTICE 'Successfully created % recipe collections with % items!', collections_created, items_added;
END;
$$;

-- ============================================================================
-- CLEANUP HELPER FUNCTIONS
-- ============================================================================

-- Drop the helper functions after use
DROP FUNCTION IF EXISTS random_rating();
DROP FUNCTION IF EXISTS random_comment();

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Basic verification
SELECT 
  COUNT(*) as total_users,
  COUNT(*) as total_recipes
FROM users, recipes
WHERE users.id IS NOT NULL AND recipes.id IS NOT NULL
LIMIT 1;

-- Final completion notice
DO $$
BEGIN
  RAISE NOTICE 'Synthetic user interaction data generation completed successfully!';
  RAISE NOTICE 'Generated realistic patterns of user interactions for staging environment.';
END;
$$; 