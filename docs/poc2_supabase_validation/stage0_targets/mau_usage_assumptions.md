# PoC #2 MAU Usage Assumptions  
## 📊 **Monthly Active User Usage Patterns & Peak Concurrency Modeling**

**Document Purpose**: Define detailed MAU usage assumptions with peak concurrency derivation for accurate Supabase cost modeling and realistic load testing configuration.

**Last Updated**: 2025-01-15T23:50:00Z  
**Version**: 1.0  
**Status**: ✅ **APPROVED FOR MODELING**

---

## **👥 MAU Scale Definition & Distribution**

### **Target MAU Scenarios**
- **1k MAU**: Early MVP validation (Free tier preferred)
- **5k MAU**: Growth phase milestone 
- **10k MAU**: Critical decision point for ADR-WCF-001d

### **User Role Distribution**
- **Consumers (80%)**: Browse recipes, like content, create collections
- **Creators (15%)**: Publish recipes, manage profile, engage with followers  
- **Power Users (5%)**: Heavy usage, multiple recipes, extensive collections

---

## **⏰ Usage Pattern Modeling**

### **Session Characteristics**
- **Average Sessions per User per Month**: 12 sessions
- **Session Duration**: 8 minutes average (5-15 minute range)
- **Peak Usage Hours**: 6-8 PM local time (40% of daily activity)
- **Daily Distribution**: 70% weekdays, 30% weekends

### **Activity Breakdown per Session**

#### **Consumer Session (80% of users)**
- **Recipe Browsing**: 15 recipe views per session
- **Recipe Interactions**: 2 likes, 1 collection add per session
- **Creator Following**: 0.5 new follows per session
- **Search Activity**: 2 search queries per session

#### **Creator Session (15% of users)**  
- **Content Creation**: 0.3 new recipes per session (high-effort)
- **Recipe Management**: 2 recipe edits per session
- **Profile Updates**: 0.1 profile changes per session
- **Engagement Tracking**: 5 analytics views per session

#### **Power User Session (5% of users)**
- **Heavy Browsing**: 25 recipe views per session
- **Collection Management**: 5 collection operations per session
- **Social Activity**: 8 likes, 2 follows per session
- **Recipe Creation**: 0.5 new recipes per session

---

## **🔢 Database Operation Calculations**

### **Per-MAU Monthly Database Operations**

#### **Read Operations (Recipe Listing, Profile Views, Search)**
- Consumer: 12 sessions × 17 reads = **204 reads/month**
- Creator: 12 sessions × 22 reads = **264 reads/month**  
- Power User: 12 sessions × 30 reads = **360 reads/month**
- **Weighted Average**: (204×0.8) + (264×0.15) + (360×0.05) = **221 reads/MAU/month**

#### **Write Operations (Likes, Follows, Recipe Creation, Collections)**
- Consumer: 12 sessions × 3.5 writes = **42 writes/month**
- Creator: 12 sessions × 3.4 writes = **41 writes/month**
- Power User: 12 sessions × 7.5 writes = **90 writes/month**
- **Weighted Average**: (42×0.8) + (41×0.15) + (90×0.05) = **45 writes/MAU/month**

#### **Edge Function Calls (Nutrition Enrichment)**
- Recipe creation rate: 0.35 recipes/MAU/month (weighted)
- Nutrition enrichment: 80% of new recipes
- **Edge Calls**: **0.28 calls/MAU/month**

---

## **⚡ Peak Concurrency Derivation**

### **Concurrency Formula**
```
Peak Concurrent Users = MAU × (sessions/day ÷ 86400) × peak_factor × burst_factor
```

### **Peak Concurrency Calculations**

#### **1k MAU Scenario**
- Daily active: 1,000 ÷ 30 = 33 DAU
- Average concurrent: 33 × (8 minutes ÷ 1440 minutes) = 0.18 users
- Peak factor (6-8 PM): 4x = 0.72 users
- Burst factor (traffic spikes): 3x = **2.2 peak concurrent users**
- **Load Testing VUs**: **5 VUs** (conservative buffer)

#### **5k MAU Scenario**  
- Daily active: 5,000 ÷ 30 = 167 DAU
- Average concurrent: 167 × (8 ÷ 1440) = 0.93 users
- Peak factor: 4x = 3.7 users
- Burst factor: 3x = **11 peak concurrent users**
- **Load Testing VUs**: **25 VUs** (Read: 18, Write: 7)

#### **10k MAU Scenario**
- Daily active: 10,000 ÷ 30 = 333 DAU  
- Average concurrent: 333 × (8 ÷ 1440) = 1.85 users
- Peak factor: 4x = 7.4 users
- Burst factor: 3x = **22 peak concurrent users**
- **Load Testing VUs**: **50 VUs** (Read: 35, Write: 15)

---

## **💰 Cost Modeling Inputs**

### **Monthly Resource Consumption (10k MAU)**

#### **Database Operations**
- **Read Operations**: 10,000 × 221 = **2.21M reads/month**
- **Write Operations**: 10,000 × 45 = **450k writes/month**
- **Data Transfer**: ~50MB per MAU = **500GB egress/month**

#### **Edge Function Usage**
- **Invocations**: 10,000 × 0.28 = **2,800 calls/month**
- **Execution Time**: 200ms average × 2,800 = **9.3 minutes/month**
- **CPU Seconds**: 2,800 × 0.2 = **560 CPU seconds/month**

#### **Authentication & Storage**
- **Active Users**: 10,000 MAU
- **Database Storage**: ~100MB base + 10MB per 1k recipes = **1GB storage**
- **File Storage**: Profile images, recipe photos = **5GB storage**

### **Supabase Service Mapping**
- **Database**: Compute time + read/write operations
- **Auth**: Monthly active users
- **Edge Functions**: Invocations + CPU time
- **Storage**: Database + file storage
- **Bandwidth**: Data egress

---

## **🧪 Load Testing Configuration**

### **k6 Test Scenarios**

#### **Realistic Load Test (10k MAU)**
- **Total VUs**: 50 (peak concurrent modeling)
- **Read VUs**: 35 (70% read traffic)
- **Write VUs**: 15 (30% write traffic)
- **Test Duration**: 10 minutes sustained
- **Ramp Period**: 2 minutes up, 2 minutes down

#### **VU Behavior Patterns**
```javascript
// Read VU Pattern (Recipe browsing)
- Recipe listing: 3 requests/minute
- Recipe detail: 2 requests/minute  
- Creator profile: 1 request/minute
- Search query: 1 request/minute

// Write VU Pattern (User interactions)  
- Recipe like: 1 request/minute
- Collection add: 0.5 requests/minute
- Recipe creation: 0.1 requests/minute
- Follow creator: 0.3 requests/minute
```

### **Data Variety for RLS Testing**
- **User Pool**: 100 different JWT tokens
- **Creator Pool**: 20 different creator profiles
- **Recipe Pool**: 50 different recipes for viewing
- **Geographic Distribution**: 3 time zones for realistic spread

---

## **⚠️ Modeling Assumptions & Risks**

### **Key Assumptions**
1. **User Engagement**: 12 sessions/month represents engaged user base
2. **Peak Factors**: 4x concentration during prime hours  
3. **Burst Handling**: 3x traffic spikes for viral content
4. **Geographic Distribution**: US-focused traffic patterns
5. **Feature Adoption**: 80% nutrition enrichment usage

### **Usage Variance Scenarios**
- **Conservative (-30%)**: Lower engagement, longer session gaps
- **Baseline (100%)**: Documented assumptions above
- **Growth (+50%)**: Higher engagement, viral content effects
- **Peak (+100%)**: Holiday cooking season, influencer campaigns

### **Cost Sensitivity Factors**
- **Supabase Pricing Changes**: 20% volatility buffer included
- **Usage Pattern Evolution**: Creator/consumer ratio may shift
- **Feature Expansion**: Additional features will increase operations
- **Geographic Expansion**: Multi-region deployment costs

---

## **✅ Validation Metrics**

### **Cost Model Validation**
- **1k MAU**: Should remain on Free tier (<$10/month acceptable)
- **5k MAU**: Target <$25/month (acceptable: <$40/month)
- **10k MAU**: Target ≤$75/month (acceptable: ≤$100/month, failure: >$150/month)

### **Load Testing Validation**
- **Concurrent Performance**: 50 VUs sustained with <1% error rate
- **Resource Utilization**: Database connections <90% during peak
- **Real-world Simulation**: RLS policies tested with user diversity

### **Assumption Testing**
- **Session Duration**: Measure actual user behavior during PoC
- **Operation Ratios**: Validate read/write distribution in testing
- **Peak Factors**: Confirm concurrency patterns match modeling

---

**Review Status**: ✅ **APPROVED**  
**Stakeholder Sign-off**: Required before cost modeling  
**Usage Tracking**: Monitor actual patterns during testing for model refinement 