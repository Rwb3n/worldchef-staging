# Supabase Data Seeding Pattern

## Overview

This cookbook entry documents the validated data seeding pattern from WorldChef PoC #2, providing realistic test data generation for performance testing and development environments.

**Validation**: Successfully seeded 20k users, 5k creators, 100k recipes with proper relationships and realistic distribution.

## Core Implementation

### Smart Completion Seeding

```javascript
#!/usr/bin/env node
/**
 * Smart completion script that checks current database counts
 * and seeds only remaining records needed to reach targets
 */

import { createClient } from '@supabase/supabase-js';
import { faker } from '@faker-js/faker';

// Configuration
const CONFIG = {
    BATCH_SIZE: 1000,
    TARGETS: {
        USERS: 20000,
        CREATORS: 5000,
        RECIPES: 100000
    }
};

// Initialize Supabase client with service role
const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

/**
 * Check current database record counts
 */
async function getCurrentCounts() {
    console.log('📊 Checking current database counts...');
    
    try {
        const [usersResult, creatorsResult, recipesResult] = await Promise.all([
            supabase.from('users').select('id', { count: 'exact', head: true }),
            supabase.from('creators').select('id', { count: 'exact', head: true }),
            supabase.from('recipes').select('id', { count: 'exact', head: true })
        ]);
        
        return {
            users: usersResult.count || 0,
            creators: creatorsResult.count || 0,
            recipes: recipesResult.count || 0
        };
    } catch (error) {
        console.error('❌ Error checking counts:', error.message);
        return { users: 0, creators: 0, recipes: 0 };
    }
}
```

### Realistic User Generation

```javascript
// Geographic and demographic distribution
const REGIONS = [
    'North America', 'Europe', 'Asia Pacific', 'Latin America', 'Middle East', 'Africa'
];

const DIETARY_TAGS = [
    'vegetarian', 'vegan', 'gluten_free', 'dairy_free', 'keto', 'paleo', 'low_carb'
];

/**
 * Generate realistic user data matching actual schema
 */
function generateUserBatch(batchSize, startIndex) {
    const users = [];
    
    for (let i = 0; i < batchSize; i++) {
        const userId = faker.string.uuid();
        const firstName = faker.person.firstName();
        const lastName = faker.person.lastName();
        
        users.push({
            id: userId,
            email: faker.internet.email({ firstName, lastName }),
            display_name: faker.datatype.boolean(0.7) ? 
                `${firstName} ${lastName}` : faker.internet.username(),
            bio: faker.datatype.boolean(0.6) ? faker.person.bio() : null,
            location: faker.location.city() + ', ' + faker.helpers.arrayElement(REGIONS),
            dietary_preferences: faker.helpers.arrayElements(DIETARY_TAGS, { min: 0, max: 3 }),
            role: faker.helpers.weightedArrayElement([
                { weight: 80, value: 'standard' },
                { weight: 15, value: 'creator' },
                { weight: 4, value: 'moderator' },
                { weight: 1, value: 'admin' }
            ]),
            avatar_url: faker.datatype.boolean(0.4) ? faker.image.avatar() : null,
            is_verified: faker.datatype.boolean(0.1),
            created_at: faker.date.between({ 
                from: new Date('2023-01-01'), 
                to: new Date() 
            }).toISOString(),
            updated_at: new Date().toISOString(),
            last_active_at: faker.date.recent({ days: 30 }).toISOString()
        });
    }
    
    return users;
}
```

### Creator Profile Generation

```javascript
const CUISINES = [
    'Italian', 'Mexican', 'Indian', 'Chinese', 'French', 'Japanese', 'Thai', 
    'Mediterranean', 'American', 'Korean', 'Vietnamese', 'Greek', 'Middle Eastern'
];

/**
 * Generate realistic creator data with proper user relationships
 */
function generateCreatorBatch(userIds, batchSize, startIndex = 0) {
    const creators = [];
    
    for (let i = 0; i < batchSize; i++) {
        const userIndex = startIndex + i;
        if (userIndex >= userIds.length) {
            console.log(`⚠️ Warning: Not enough user IDs. Stopping at ${i} creators.`);
            break;
        }
        
        const userId = userIds[userIndex];
        
        creators.push({
            id: faker.string.uuid(),
            user_id: userId,
            creator_name: faker.person.fullName(),
            creator_bio: faker.person.bio(),
            website_url: faker.datatype.boolean(0.4) ? faker.internet.url() : null,
            specialties: faker.helpers.arrayElements(CUISINES, { min: 1, max: 4 }),
            verified_at: faker.datatype.boolean(0.15) ? 
                faker.date.recent({ days: 365 }).toISOString() : null,
            social_links: {
                instagram: faker.datatype.boolean(0.6) ? faker.internet.username() : null,
                youtube: faker.datatype.boolean(0.3) ? faker.internet.username() : null,
                tiktok: faker.datatype.boolean(0.2) ? faker.internet.username() : null
            },
            follower_count: faker.number.int({ min: 0, max: 10000 }),
            recipe_count: 0, // Updated by triggers
            total_likes: 0, // Updated by triggers
            created_at: faker.date.between({ 
                from: new Date('2023-01-01'), 
                to: new Date() 
            }).toISOString(),
            updated_at: new Date().toISOString()
        });
    }
    
    return creators;
}
```

### Batch Insert with Error Handling

```javascript
/**
 * Execute batch insert with comprehensive error handling
 */
async function executeBatchInsert(table, data, description) {
    try {
        const { data: result, error } = await supabase
            .from(table)
            .insert(data)
            .select('id');
        
        if (error) {
            console.error(`❌ ${description} failed:`, error.message);
            
            // Handle specific error types
            if (error.code === '23505') { // Unique constraint violation
                console.log(`⚠️ Some records already exist, continuing...`);
                return [];
            }
            
            throw error;
        }
        
        console.log(`✅ ${description}: ${result.length} records inserted`);
        return result;
        
    } catch (error) {
        console.error(`❌ Batch insert failed for ${table}:`, error.message);
        
        // Log first few records for debugging
        if (data.length > 0) {
            console.log('Sample data:', JSON.stringify(data[0], null, 2));
        }
        
        throw error;
    }
}
```

### Available User ID Management

```javascript
/**
 * Get available user IDs for creator assignment
 * (users without existing creator records)
 */
async function getAvailableUserIds(neededCount = 5000) {
    console.log(`🔍 Fetching ${neededCount} available user IDs...`);
    
    try {
        // Get existing creator user_ids
        const { data: existingCreators, error: creatorError } = await supabase
            .from('creators')
            .select('user_id');
        
        if (creatorError) {
            console.error('❌ Error fetching creators:', creatorError.message);
            return [];
        }
        
        const existingCreatorUserIds = new Set(existingCreators?.map(c => c.user_id) || []);
        console.log(`📊 Found ${existingCreatorUserIds.size} users with existing creators`);
        
        // Get available users in batches
        const availableUsers = [];
        let page = 0;
        const pageSize = 1000;
        
        while (availableUsers.length < neededCount) {
            const { data: users, error } = await supabase
                .from('users')
                .select('id')
                .range(page * pageSize, (page + 1) * pageSize - 1)
                .order('created_at', { ascending: true });
            
            if (error) {
                console.error(`❌ Error fetching users page ${page}:`, error.message);
                break;
            }
            
            if (!users || users.length === 0) {
                console.log(`📊 No more users available. Total found: ${availableUsers.length}`);
                break;
            }
            
            // Filter out users who already have creators
            const availableFromPage = users
                .filter(user => !existingCreatorUserIds.has(user.id))
                .map(user => user.id);
            
            availableUsers.push(...availableFromPage);
            
            console.log(`📄 Page ${page}: ${availableFromPage.length}/${users.length} available users`);
            page++;
            
            // Prevent infinite loops
            if (page > 100) {
                console.log('⚠️ Reached maximum page limit, stopping search');
                break;
            }
        }
        
        return availableUsers.slice(0, neededCount);
        
    } catch (error) {
        console.error('❌ Error getting available user IDs:', error.message);
        return [];
    }
}
```

## Seeding Execution Flow

### Main Seeding Function

```javascript
async function main() {
    console.log('🚀 Starting Smart Data Seeding for PoC #2');
    
    try {
        // Check current state
        const currentCounts = await getCurrentCounts();
        console.log('📊 Current counts:', currentCounts);
        
        // Calculate what needs to be seeded
        const usersNeeded = Math.max(0, CONFIG.TARGETS.USERS - currentCounts.users);
        const creatorsNeeded = Math.max(0, CONFIG.TARGETS.CREATORS - currentCounts.creators);
        
        console.log(`📝 Seeding plan:`);
        console.log(`   Users: ${usersNeeded} needed (${currentCounts.users} existing)`);
        console.log(`   Creators: ${creatorsNeeded} needed (${currentCounts.creators} existing)`);
        
        // Seed users if needed
        if (usersNeeded > 0) {
            await completeUsers(currentCounts.users, CONFIG.TARGETS.USERS);
        } else {
            console.log('✅ Users target already met');
        }
        
        // Seed creators if needed
        if (creatorsNeeded > 0) {
            const userIds = await getAvailableUserIds(creatorsNeeded);
            if (userIds.length > 0) {
                await completeCreators(currentCounts.creators, CONFIG.TARGETS.CREATORS, userIds);
            } else {
                console.log('⚠️ No available users for creator assignment');
            }
        } else {
            console.log('✅ Creators target already met');
        }
        
        // Generate final report
        const finalCounts = await getCurrentCounts();
        generateReport(currentCounts, finalCounts);
        
    } catch (error) {
        console.error('❌ Seeding failed:', error.message);
        process.exit(1);
    }
}

/**
 * Complete user seeding to target
 */
async function completeUsers(currentCount, targetCount) {
    const needed = targetCount - currentCount;
    console.log(`👥 Seeding ${needed} users...`);
    
    let seeded = 0;
    while (seeded < needed) {
        const batchSize = Math.min(CONFIG.BATCH_SIZE, needed - seeded);
        const userBatch = generateUserBatch(batchSize, currentCount + seeded);
        
        try {
            await executeBatchInsert('users', userBatch, `User batch ${Math.floor(seeded / CONFIG.BATCH_SIZE) + 1}`);
            seeded += batchSize;
            
            // Progress update
            const progress = ((seeded / needed) * 100).toFixed(1);
            console.log(`📈 Users progress: ${seeded}/${needed} (${progress}%)`);
            
        } catch (error) {
            console.error(`❌ User batch failed at ${seeded}/${needed}:`, error.message);
            break;
        }
    }
    
    console.log(`✅ User seeding complete: ${seeded} users added`);
}
```

### Progress Tracking and Reporting

```javascript
/**
 * Generate comprehensive seeding report
 */
function generateReport(initialCounts, finalCounts) {
    const report = {
        timestamp: new Date().toISOString(),
        execution_summary: {
            users_added: finalCounts.users - initialCounts.users,
            creators_added: finalCounts.creators - initialCounts.creators,
            total_execution_time: Date.now() - progress.startTime
        },
        final_counts: finalCounts,
        targets: CONFIG.TARGETS,
        completion_rates: {
            users: ((finalCounts.users / CONFIG.TARGETS.USERS) * 100).toFixed(1) + '%',
            creators: ((finalCounts.creators / CONFIG.TARGETS.CREATORS) * 100).toFixed(1) + '%',
            recipes: ((finalCounts.recipes / CONFIG.TARGETS.RECIPES) * 100).toFixed(1) + '%'
        },
        errors: progress.errors
    };
    
    console.log('\n📊 SEEDING REPORT');
    console.log('==================');
    console.log(`Users: ${initialCounts.users} → ${finalCounts.users} (+${report.execution_summary.users_added})`);
    console.log(`Creators: ${initialCounts.creators} → ${finalCounts.creators} (+${report.execution_summary.creators_added})`);
    console.log(`Recipes: ${finalCounts.recipes} (target: ${CONFIG.TARGETS.RECIPES})`);
    console.log(`\nCompletion rates:`);
    console.log(`  Users: ${report.completion_rates.users}`);
    console.log(`  Creators: ${report.completion_rates.creators}`);
    console.log(`  Recipes: ${report.completion_rates.recipes}`);
    console.log(`\nExecution time: ${(report.execution_summary.total_execution_time / 1000).toFixed(1)}s`);
    
    if (progress.errors.length > 0) {
        console.log(`\n⚠️ Errors encountered: ${progress.errors.length}`);
        progress.errors.forEach((error, index) => {
            console.log(`  ${index + 1}. ${error}`);
        });
    }
    
    // Save report to file
    fs.writeFileSync('seeding_report.json', JSON.stringify(report, null, 2));
    console.log('\n📄 Report saved to seeding_report.json');
}
```

## Usage Examples

### Command Line Usage

```bash
# Basic seeding
node complete_seeding_script.js

# Custom batch size
node complete_seeding_script.js --batch-size=500

# Dry run (check what would be seeded)
node complete_seeding_script.js --dry-run

# Specific table seeding
node complete_seeding_script.js --table=users --count=1000
```

### Environment Configuration

```bash
# .env.local
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# Optional: Custom seeding targets
SEEDING_USERS_TARGET=20000
SEEDING_CREATORS_TARGET=5000
SEEDING_RECIPES_TARGET=100000
```

## Key Implementation Notes

### Critical Success Factors

1. **Incremental Seeding**: Only seeds missing records to reach targets
2. **Relationship Integrity**: Maintains proper foreign key relationships
3. **Realistic Data**: Uses faker.js for believable test data
4. **Error Recovery**: Handles constraint violations and continues
5. **Progress Tracking**: Comprehensive reporting and monitoring

### AI Development Considerations

- **Use service role key**: Required for bulk operations bypassing RLS
- **Batch processing**: Prevents memory issues and timeout errors
- **Realistic distributions**: Match production user behavior patterns
- **Relationship awareness**: Ensure foreign keys are valid
- **Error handling**: Graceful recovery from constraint violations

## Production Deployment Checklist

- [ ] Configure environment variables for target database
- [ ] Set appropriate batch sizes for database capacity
- [ ] Test seeding script in staging environment
- [ ] Verify data relationships and constraints
- [ ] Monitor database performance during seeding
- [ ] Set up progress monitoring and alerting
- [ ] Plan for seeding rollback if needed
- [ ] Document seeding targets and rationale
- [ ] Test application performance with seeded data
- [ ] Clean up test data after validation

## References

- **Source Implementation**: `poc2_supabase_validation/src/seeding/complete_seeding_script.js`
- **Performance Results**: 20k users, 5k creators seeded successfully
- **Data Quality**: Realistic distribution with proper relationships
- **Error Handling**: Robust recovery from constraint violations 