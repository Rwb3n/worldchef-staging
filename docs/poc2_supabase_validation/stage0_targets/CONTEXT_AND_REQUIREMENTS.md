# PoC #2 Context & Requirements Reference
## 🎯 **Complete Decision Context for Supabase Validation**

**Document Purpose**: Comprehensive reference to all decision context, architectural requirements, and lessons learned that inform PoC #2 Supabase validation.

---

## **📋 Primary Decision Context**

### **🔴 ADR-WCF-001d: Database & BaaS Platform (CRITICAL)**
**Source**: `docs/adr/4-ADR-WCF-001d_ Database & BaaS Platform.txt`  
**Status**: ACCEPTED - Supabase chosen contingent on PoC validation  
**Mandate**: This PoC is **mandated by ADR-WCF-001d** with specific failure criteria

**Key Context for PoC #2**:
- **Budget Constraint**: $75/month overall backend cap post-Cycle 3
- **Critical Performance Targets**:
  - Read Query p95 < 150ms (with RLS)
  - Write Operations p95 < 200ms  
  - Edge Function Cold Start < 800ms, Warm < 200ms
- **Cost Projection Requirements**:
  - 10k MAU target ≤ $50-100/month
  - **PoC FAILURE** if >$150/month at 10k MAU
- **Failure Triggers Alternative**: Disaggregated Stack PoC if Supabase fails
- **RLS Feasibility**: Core security requirement with <30% performance overhead
- **Backup/DR**: Operational procedures must be validated

### **🟡 PoC #1 Mobile Stack Selection - Lessons Learned**
**Source**: `docs/poc1_mobile_stack_selection/README.md`  
**Outcome**: **Flutter selected with 90% confidence**  
**Methodology**: Evidence-based evaluation with quantitative metrics

**Critical Lessons for PoC #2**:
- **Testing Infrastructure Reliability**: Decisive factor (Flutter 100% vs RN 21% test pass rate)
- **Evidence-Based Decision Making**: Quantitative + qualitative assessment framework
- **Risk Mitigation**: Comprehensive contingency planning
- **Documentation Standards**: Complete knowledge preservation
- **Success Metrics**: Clear pass/fail criteria with confidence levels
- **Quality Gates**: Stage-by-stage validation with deliverables

---

## **🏗️ Schema & Data Architecture Requirements**

### **🔵 ADR-WCF-006a: Core Entity Data Modeling (Relational)**
**Source**: `docs/adr/6-ADR-WCF-006a_ Core Entity Data Modeling Strategy.txt`  
**Status**: ACCEPTED  

**Schema Requirements for PoC #2**:
```sql
-- Core Tables Required
users (id, email, display_name, avatar_url, created_at, updated_at, deleted_at)
creators (id, user_id, display_name, bio, status, recipes_count, followers_count, deleted_at)
recipes (id, creator_id, title, slug, description, status, likes_count, collections_count, deleted_at)
recipe_likes (user_id, recipe_id, created_at) -- Primary Key: (user_id, recipe_id)
recipe_collections (id, user_id, name, is_public, items_count, deleted_at)
collection_recipes (collection_id, recipe_id, added_at) -- Primary Key: (collection_id, recipe_id)
creator_followers (follower_user_id, creator_id, created_at) -- Primary Key: (follower_user_id, creator_id)

-- Key Features for PoC Testing
- Soft Deletes with Views: active_recipes, active_users, active_creators
- Denormalized Counters: Updated by database triggers
- UUID Primary Keys: uuid_generate_v4()
- ENUMs: recipe_status ('draft', 'published', 'archived', 'admin_removed')
```

**Performance Considerations**:
- **Indexing Strategy**: Status + published_at, creator feeds, FTS indexes
- **Soft Delete Views**: Query simplification with WHERE deleted_at IS NULL
- **Trigger Performance**: Counter updates on writes (must test under load)

### **🔵 ADR-WCF-006b: JSONB Usage for Semi-Structured Data**
**Source**: `docs/adr/7-ADR-WCF-006b_ JSONB Usage for Semi-Structured Recipe Data.txt`  
**Status**: ACCEPTED  

**JSONB Requirements for PoC #2**:
```sql
-- Normalized Ingredients (Relational)
ingredients (id, name, name_fts_vector, created_at)
recipe_ingredients (id, recipe_id, ingredient_id, quantity, unit, notes, display_order)

-- JSONB Fields in recipes table
steps JSONB -- Array of step objects with id, step_number, description, image_url
nutrition JSONB -- Object with calories, nutrients, source_info
json_content_version INT DEFAULT 1 -- Schema versioning
version INT NOT NULL DEFAULT 1 -- Optimistic locking
```

**PoC Testing Requirements**:
- **Ingredient Search Performance**: FTS + trigram indexes on ingredient names
- **JSONB Validation**: CHECK constraints for basic structure validation
- **Data Seeding**: Realistic recipe data with steps and nutrition
- **Query Performance**: Recipe display with JSONB fields under load

---

## **🔐 Security & Authorization Requirements**

### **🔵 ADR-WCF-005: Authentication & Authorization Strategy**
**Source**: `docs/adr/5-ADR-WCF-005_ Authentication & Authorization Strategy.txt`  
**Status**: ACCEPTED  

**RLS Requirements for PoC #2**:
- **Supabase Auth Integration**: JWT validation with role-based access
- **Row Level Security Policies**: Core entities (recipes, collections, creators)
- **Performance Impact Testing**: RLS overhead vs non-RLS baseline
- **Multi-User Testing**: JWT pool for realistic load testing
- **Role-Based Access**: User/creator role differentiation

**Critical RLS Policies to Implement**:
```sql
-- Recipe Access Policies
- Public recipes readable by all authenticated users
- Draft recipes only by creator
- Recipe mutations only by creator
- Creator profile visibility rules
- Collection access (public vs private)
```

**Performance Requirements**:
- **RLS Overhead**: <30% performance impact vs service_role queries
- **JWT Validation**: <5ms average latency in API layer
- **Multi-tenant Performance**: Consistent performance across user roles

---

## **⚡ Performance & Scale Requirements**

### **🎯 Quantitative Performance Targets (from ADR-WCF-001d)**

| **Benchmark Category** | **Target (p95)** | **Acceptable** | **Failure Threshold** |
|------------------------|------------------|----------------|----------------------|
| **Read Query (RLS)** | < 120ms | < 150ms | > 150ms |
| **Write Flow (RPC)** | < 200ms | < 260ms | > 260ms |
| **Edge Function Warm** | < 150ms | < 195ms | > 195ms |
| **Edge Function Cold** | < 800ms | < 1040ms | > 1040ms |
| **Error Rate** | < 0.5% | < 1% | ≥ 1% |

### **📊 Data Scale Requirements (MVP Realistic)**
- **Users**: 20,000 (varied roles for RLS testing)
- **Creators**: 5,000 (subset of users)
- **Recipes**: 100,000 (realistic JSONB content)
- **Interactions**: 500k likes, 100k collection items, 50k follows
- **Data Distribution**: Realistic popularity curves (some viral recipes/creators)

### **💰 Cost Modeling Requirements**

| **MAU Scale** | **Target Budget** | **Success Threshold** | **Failure Threshold** |
|---------------|------------------|---------------------|----------------------|
| **1k MAU** | Free Tier preferred | < $10/month | > $25/month |
| **5k MAU** | < $25/month | < $40/month | > $75/month |
| **10k MAU** | ≤ $75/month | ≤ $100/month | > $150/month |

**Cost Model Requirements**:
- **Usage Assumptions**: Sessions/user, reads/writes per session, edge function calls
- **Service Breakdown**: DB compute, storage, egress, auth, edge functions
- **Sensitivity Analysis**: Usage variance scenarios (±50%)
- **Real PoC Data**: Actual usage metrics from benchmarking

---

## **🛠️ Implementation & Operational Requirements**

### **🔧 Environment Setup Requirements**
- **Supabase Project**: Dedicated "worldchef-poc" in us-west-2
- **Tier Assessment**: Free vs Pro tier for 100k+ records
- **Extensions**: pg_trgm, unaccent, pg_stat_statements (if available)
- **Monitoring**: Dashboard metrics, query logging for analysis

### **🧪 Testing Infrastructure Requirements**
- **k6 Load Testing**: Proven framework for HTTP benchmarking
- **JWT Pool**: 100+ valid tokens for realistic multi-user testing
- **Edge Function Deployment**: nutritionEnrich with 50ms CPU simulation
- **Data Integrity**: Comprehensive seeding verification

### **📈 Benchmarking Methodology**
Following PoC #1 Success Pattern:
1. **Quantitative Metrics**: Objective performance measurements
2. **Qualitative Assessment**: Developer experience evaluation
3. **Risk Analysis**: Comprehensive failure scenario planning
4. **Evidence Documentation**: Complete audit trail
5. **Decision Confidence**: Target ≥90% confidence level

---

## **🚨 Risk Management & Contingencies**

### **⚠️ Identified Risks from Context**
1. **Free Tier Limitations**: May require Pro upgrade for 100k records
2. **RLS Performance Impact**: Could exceed 30% overhead threshold
3. **Cost Model Accuracy**: Assumptions may not reflect real usage
4. **Load Testing Restrictions**: Supabase DDoS protection triggers
5. **Edge Function Cold Starts**: Unpredictable latency spikes

### **🔄 Contingency Plans**
- **Performance Failure**: Document optimization attempts, recommend target adjustments
- **Cost Failure**: Trigger Disaggregated Stack PoC per ADR-WCF-001d
- **Technical Blockers**: Escalate to Supabase support with PoC context
- **Timeline Pressure**: Prioritize critical path (Stages 4-6)

---

## **🎯 Success Criteria & Decision Framework**

### **✅ PoC Success Scenario**
- All performance targets met with <1% error rate
- Cost projections within budget constraints
- RLS overhead <30% with functional security
- Operational procedures validated (backup/restore)
- ≥90% confidence recommendation for production use

### **❌ PoC Failure Scenario**
- 2+ performance targets missed by >30%
- 10k MAU cost projection >$150/month
- RLS performance overhead ≥30%
- Critical operational limitations discovered
- <70% confidence in production readiness

### **🔄 Decision Outcomes**
- **Success**: Begin production Supabase implementation
- **Failure**: Initiate Disaggregated Stack PoC evaluation
- **Partial**: Document limitations, risk mitigation for constrained implementation

---

## **📚 Referenced Documentation**

### **Primary Context Sources**
- `docs/adr/4-ADR-WCF-001d_Database_BaaS_Platform.txt` - **MANDATE SOURCE**
- `docs/adr/6-ADR-WCF-006a_Core_Entity_Data_Modeling.txt` - Schema requirements
- `docs/adr/7-ADR-WCF-006b_JSONB_Usage_Strategy.txt` - JSONB implementation
- `docs/adr/5-ADR-WCF-005_Authentication_Authorization.txt` - RLS requirements
- `docs/poc1_mobile_stack_selection/README.md` - Methodology lessons
- `docs/source/PoC_Plan_2_Supabase_Performance_Cost_Validation.txt` - Original plan

### **Supporting Context**
- `docs/adr/` - Complete ADR collection for architectural context
- `plans/plan_poc2_supabase_validation.txt` - Implementation plan
- `state.txt` - Current project state and progress

---

**Context Status**: ✅ **COMPLETE**  
**Requirements Clarity**: ✅ **COMPREHENSIVE**  
**Decision Framework**: ✅ **EVIDENCE-BASED**  
**Ready for**: Stage 0 Performance Targets & MAU Assumptions Finalization 