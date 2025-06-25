-- ============================================================================
-- Synthetic User Data Generation Script
-- Cycle 4 Week 0 - Staging Environment Data Seeding
-- Created: 2025-06-13T16:00:00Z | Event g89
-- ============================================================================

-- This script generates 500+ synthetic users with realistic profiles
-- for staging environment testing and development

-- ============================================================================
-- HELPER FUNCTIONS FOR DATA GENERATION
-- ============================================================================

-- Function to generate random names
CREATE OR REPLACE FUNCTION random_first_name() RETURNS TEXT AS $$
DECLARE
  names TEXT[] := ARRAY[
    'Emma', 'Liam', 'Olivia', 'Noah', 'Ava', 'Ethan', 'Sophia', 'Mason',
    'Isabella', 'William', 'Mia', 'James', 'Charlotte', 'Benjamin', 'Amelia',
    'Lucas', 'Harper', 'Henry', 'Evelyn', 'Alexander', 'Abigail', 'Michael',
    'Emily', 'Daniel', 'Elizabeth', 'Jacob', 'Sofia', 'Logan', 'Avery',
    'Jackson', 'Ella', 'Sebastian', 'Scarlett', 'Jack', 'Grace', 'Owen',
    'Chloe', 'Samuel', 'Victoria', 'Matthew', 'Riley', 'Joseph', 'Aria',
    'Levi', 'Lily', 'David', 'Aubrey', 'John', 'Zoey', 'Wyatt', 'Penelope',
    'Carter', 'Lillian', 'Julian', 'Addison', 'Luke', 'Layla', 'Grayson',
    'Natalie', 'Isaac', 'Camila', 'Oliver', 'Hannah', 'Theodore', 'Brooklyn',
    'Jayce', 'Samantha', 'Adrian', 'Audrey', 'Jonathan', 'Aaliyah', 'Nolan',
    'Anna', 'Jeremiah', 'Allison', 'Easton', 'Savannah', 'Elias', 'Gabriella',
    'Colton', 'Claire', 'Cameron', 'Madelyn', 'Landon', 'Cora', 'Hunter',
    'Maya', 'Thomas', 'Alice', 'Aaron', 'Sarah', 'Christian', 'Hailey'
  ];
BEGIN
  RETURN names[floor(random() * array_length(names, 1) + 1)];
END;
$$ LANGUAGE plpgsql;

-- Function to generate random last names
CREATE OR REPLACE FUNCTION random_last_name() RETURNS TEXT AS $$
DECLARE
  names TEXT[] := ARRAY[
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller',
    'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez',
    'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin',
    'Lee', 'Perez', 'Thompson', 'White', 'Harris', 'Sanchez', 'Clark',
    'Ramirez', 'Lewis', 'Robinson', 'Walker', 'Young', 'Allen', 'King',
    'Wright', 'Scott', 'Torres', 'Nguyen', 'Hill', 'Flores', 'Green',
    'Adams', 'Nelson', 'Baker', 'Hall', 'Rivera', 'Campbell', 'Mitchell',
    'Carter', 'Roberts', 'Gomez', 'Phillips', 'Evans', 'Turner', 'Diaz',
    'Parker', 'Cruz', 'Edwards', 'Collins', 'Reyes', 'Stewart', 'Morris',
    'Morales', 'Murphy', 'Cook', 'Rogers', 'Gutierrez', 'Ortiz', 'Morgan',
    'Cooper', 'Peterson', 'Bailey', 'Reed', 'Kelly', 'Howard', 'Ramos',
    'Kim', 'Cox', 'Ward', 'Richardson', 'Watson', 'Brooks', 'Chavez'
  ];
BEGIN
  RETURN names[floor(random() * array_length(names, 1) + 1)];
END;
$$ LANGUAGE plpgsql;

-- Function to generate random locations
CREATE OR REPLACE FUNCTION random_location() RETURNS TEXT AS $$
DECLARE
  locations TEXT[] := ARRAY[
    'New York, NY', 'Los Angeles, CA', 'Chicago, IL', 'Houston, TX',
    'Phoenix, AZ', 'Philadelphia, PA', 'San Antonio, TX', 'San Diego, CA',
    'Dallas, TX', 'San Jose, CA', 'Austin, TX', 'Jacksonville, FL',
    'Fort Worth, TX', 'Columbus, OH', 'Charlotte, NC', 'San Francisco, CA',
    'Indianapolis, IN', 'Seattle, WA', 'Denver, CO', 'Washington, DC',
    'Boston, MA', 'El Paso, TX', 'Nashville, TN', 'Detroit, MI',
    'Oklahoma City, OK', 'Portland, OR', 'Las Vegas, NV', 'Memphis, TN',
    'Louisville, KY', 'Baltimore, MD', 'Milwaukee, WI', 'Albuquerque, NM',
    'Tucson, AZ', 'Fresno, CA', 'Sacramento, CA', 'Kansas City, MO',
    'Mesa, AZ', 'Atlanta, GA', 'Omaha, NE', 'Colorado Springs, CO',
    'Raleigh, NC', 'Miami, FL', 'Long Beach, CA', 'Virginia Beach, VA',
    'Minneapolis, MN', 'Tampa, FL', 'Oakland, CA', 'Tulsa, OK',
    'Arlington, TX', 'New Orleans, LA', 'Wichita, KS', 'Cleveland, OH',
    'London, UK', 'Paris, France', 'Tokyo, Japan', 'Sydney, Australia',
    'Toronto, Canada', 'Berlin, Germany', 'Rome, Italy', 'Madrid, Spain'
  ];
BEGIN
  RETURN locations[floor(random() * array_length(locations, 1) + 1)];
END;
$$ LANGUAGE plpgsql;

-- Function to generate random bio
CREATE OR REPLACE FUNCTION random_bio() RETURNS TEXT AS $$
DECLARE
  bio_templates TEXT[] := ARRAY[
    'Food enthusiast and home cook who loves experimenting with flavors.',
    'Professional chef with 10+ years of experience in fine dining.',
    'Passionate baker specializing in artisanal breads and pastries.',
    'Health-conscious cook focused on nutritious and delicious meals.',
    'Weekend warrior in the kitchen, always trying new recipes.',
    'Culinary student sharing my learning journey through cooking.',
    'Family recipe keeper, preserving traditions through food.',
    'Plant-based cooking advocate promoting sustainable eating.',
    'Busy parent sharing quick and healthy meal solutions.',
    'Food blogger documenting culinary adventures around the world.',
    'Retired chef now cooking for the joy of sharing recipes.',
    'College student learning to cook on a budget.',
    'Grandmother sharing decades of cooking wisdom.',
    'Fitness enthusiast creating protein-rich, healthy meals.',
    'International cuisine explorer bringing global flavors home.',
    'Seasonal cooking advocate using fresh, local ingredients.',
    'Comfort food specialist making hearty, soul-warming dishes.',
    'Minimalist cook focusing on simple, quality ingredients.',
    'Meal prep expert helping others save time in the kitchen.',
    'Cooking teacher passionate about sharing culinary skills.'
  ];
BEGIN
  RETURN bio_templates[floor(random() * array_length(bio_templates, 1) + 1)];
END;
$$ LANGUAGE plpgsql;

-- Function to generate random dietary preferences
CREATE OR REPLACE FUNCTION random_dietary_preferences() RETURNS dietary_type[] AS $$
DECLARE
  all_types dietary_type[] := ARRAY['vegetarian', 'vegan', 'gluten_free', 'dairy_free', 'keto', 'paleo', 'low_carb', 'low_fat', 'halal', 'kosher'];
  result dietary_type[] := ARRAY[]::dietary_type[];
  num_preferences INTEGER;
  i INTEGER;
BEGIN
  -- 70% chance of having no dietary restrictions
  IF random() < 0.7 THEN
    RETURN result;
  END IF;
  
  -- Otherwise, select 1-3 random preferences
  num_preferences := floor(random() * 3 + 1);
  
  FOR i IN 1..num_preferences LOOP
    result := array_append(result, all_types[floor(random() * array_length(all_types, 1) + 1)]);
  END LOOP;
  
  -- Remove duplicates
  SELECT array_agg(DISTINCT unnest) INTO result FROM unnest(result);
  
  RETURN result;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- SYNTHETIC USER DATA GENERATION
-- ============================================================================

-- Generate 300 synthetic users
DO $$
DECLARE
  i INTEGER;
  first_name TEXT;
  last_name TEXT;
  email TEXT;
  display_name TEXT;
  role_type user_role;
  bio_text TEXT;
  location_text TEXT;
  dietary_prefs dietary_type[];
  avatar_url_text TEXT;
  is_verified_bool BOOLEAN;
  created_date TIMESTAMPTZ;
  last_active_date TIMESTAMPTZ;
BEGIN
  FOR i IN 1..300 LOOP
    -- Generate basic info
    first_name := random_first_name();
    last_name := random_last_name();
    email := lower(first_name || '.' || last_name || '+' || i || '@staging.worldchef.example.com');
    display_name := first_name || ' ' || last_name;
    
    -- Assign roles (90% standard, 8% creator, 1.5% moderator, 0.5% admin)
    CASE 
      WHEN random() < 0.90 THEN role_type := 'standard';
      WHEN random() < 0.98 THEN role_type := 'creator';
      WHEN random() < 0.995 THEN role_type := 'moderator';
      ELSE role_type := 'admin';
    END CASE;
    
    -- Generate optional fields (some users have incomplete profiles)
    bio_text := CASE WHEN random() < 0.6 THEN random_bio() ELSE NULL END;
    location_text := CASE WHEN random() < 0.7 THEN random_location() ELSE NULL END;
    dietary_prefs := random_dietary_preferences();
    
    -- Avatar URL (80% have avatars)
    avatar_url_text := CASE 
      WHEN random() < 0.8 THEN 'https://staging-cdn.worldchef.example.com/avatars/user_' || i || '.jpg'
      ELSE NULL 
    END;
    
    -- Verification status (20% verified)
    is_verified_bool := random() < 0.2;
    
    -- Random creation dates (last 2 years)
    created_date := NOW() - (random() * INTERVAL '730 days');
    
    -- Last active (within last 30 days for 80% of users)
    last_active_date := CASE 
      WHEN random() < 0.8 THEN NOW() - (random() * INTERVAL '30 days')
      ELSE created_date + (random() * (NOW() - created_date))
    END;
    
    -- Insert user
    INSERT INTO users (
      email,
      display_name,
      role,
      avatar_url,
      bio,
      location,
      dietary_preferences,
      created_at,
      updated_at,
      last_active_at,
      is_verified
    ) VALUES (
      email,
      display_name,
      role_type,
      avatar_url_text,
      bio_text,
      location_text,
      dietary_prefs,
      created_date,
      created_date,
      last_active_date,
      is_verified_bool
    );
    
    -- Progress indicator
    IF i % 50 = 0 THEN
      RAISE NOTICE 'Generated % users...', i;
    END IF;
  END LOOP;
  
  RAISE NOTICE 'Successfully generated 300 synthetic users!';
END;
$$;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Verify user generation
SELECT 
  'Total Users' as metric,
  COUNT(*) as value
FROM users
WHERE email LIKE '%@staging.worldchef.example.com'

UNION ALL

SELECT 
  'By Role: ' || role::text,
  COUNT(*)
FROM users 
WHERE email LIKE '%@staging.worldchef.example.com'
GROUP BY role

UNION ALL

SELECT 
  'Verified Users',
  COUNT(*)
FROM users 
WHERE email LIKE '%@staging.worldchef.example.com' AND is_verified = true

UNION ALL

SELECT 
  'Users with Bios',
  COUNT(*)
FROM users 
WHERE email LIKE '%@staging.worldchef.example.com' AND bio IS NOT NULL

UNION ALL

SELECT 
  'Users with Dietary Preferences',
  COUNT(*)
FROM users 
WHERE email LIKE '%@staging.worldchef.example.com' AND array_length(dietary_preferences, 1) > 0;

-- Sample of generated users
SELECT 
  display_name,
  role,
  location,
  array_length(dietary_preferences, 1) as num_dietary_prefs,
  is_verified,
  created_at::date
FROM users 
WHERE email LIKE '%@staging.worldchef.example.com'
ORDER BY created_at DESC
LIMIT 10;

-- ============================================================================
-- CLEANUP FUNCTIONS
-- ============================================================================

-- Drop helper functions (uncomment if needed)
-- DROP FUNCTION IF EXISTS random_first_name();
-- DROP FUNCTION IF EXISTS random_last_name();
-- DROP FUNCTION IF EXISTS random_location();
-- DROP FUNCTION IF EXISTS random_bio();
-- DROP FUNCTION IF EXISTS random_dietary_preferences();

-- ============================================================================
-- SCRIPT COMPLETION
-- ============================================================================

SELECT 
  'Synthetic user generation completed at: ' || NOW()::text as status,
  COUNT(*) || ' users created' as result
FROM users 
WHERE email LIKE '%@staging.worldchef.example.com'; 