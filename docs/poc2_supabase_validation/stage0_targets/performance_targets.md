# PoC #2 Performance Targets
## 🎯 **Quantitative Performance Targets for Supabase Validation**

**Document Purpose**: Define specific, realistic performance targets for PoC #2 Supabase validation, accounting for PostgREST transport overhead and production conditions.

**Last Updated**: 2025-01-15T23:45:00Z  
**Version**: 1.0  
**Status**: ✅ **APPROVED FOR TESTING**

---

## **📊 Primary Performance Targets**

### **🔍 Read Query Performance (Recipe Listing with RLS)**
- **Target (p95)**: < **150ms** end-to-end latency
- **Acceptable**: < **195ms** (30% buffer)
- **Failure Threshold**: ≥ **195ms**

**Query Profile**:
```sql
-- Representative read query: Recipe listing with RLS
SELECT r.id, r.title, r.description, r.status, r.likes_count,
       c.display_name as creator_name, c.avatar_url as creator_avatar
FROM active_recipes r
JOIN active_creators c ON r.creator_id = c.id  
WHERE r.status = 'published'
ORDER BY r.created_at DESC
LIMIT 20 OFFSET 0;
```

**Overhead Assumptions**:
- PostgREST processing: 40-60ms baseline
- HTTPS/TLS handshake: 20-40ms
- RLS policy evaluation: 15-25ms
- Network round-trip: 10-30ms
- **Total Baseline**: 85-155ms before query execution

### **✏️ Write Flow Performance (User Signup + Recipe Creation)**
- **Target (p95)**: < **250ms** end-to-end transaction
- **Acceptable**: < **325ms** (30% buffer)  
- **Failure Threshold**: ≥ **325ms**

**Write Flow Profile**:
```sql
-- Multi-step write: User signup + Creator profile + Recipe creation
BEGIN;
INSERT INTO users (email, display_name) VALUES (...);
INSERT INTO creators (user_id, display_name, bio) VALUES (...);
INSERT INTO recipes (creator_id, title, description, steps, nutrition) VALUES (...);
COMMIT;
```

**Write Overhead Assumptions**:
- PostgREST transaction handling: 50-80ms
- RLS policy evaluation (3 tables): 30-50ms
- Trigger execution (counters): 20-40ms
- JSONB validation & indexing: 15-25ms
- **Total Baseline**: 115-195ms before database execution

### **⚡ Edge Function Performance (Nutrition Enrichment)**

#### **Warm Execution**
- **Target (p95)**: < **200ms** warm function execution
- **Acceptable**: < **260ms** (30% buffer)
- **Failure Threshold**: ≥ **260ms**

#### **Cold Start**
- **Target (p95)**: < **800ms** cold start execution  
- **Acceptable**: < **1040ms** (30% buffer)
- **Failure Threshold**: ≥ **1040ms**

**Function Profile**:
```typescript
// nutritionEnrich Edge Function workflow
1. JWT validation: 5-15ms
2. Input parsing & validation: 10-20ms  
3. Nutrition API calls (simulated): 100-150ms
4. Data processing: 20-40ms
5. Response formatting: 5-15ms
// Total business logic: 140-240ms + Deno overhead
```

**Edge Function Assumptions**:
- Deno runtime overhead: 30-50ms (warm), 400-600ms (cold)
- Supabase Edge network: 20-40ms
- Function memory allocation: 128MB baseline

---

## **🎯 Secondary Performance Metrics**

### **⚖️ RLS Performance Impact**
- **RLS Overhead Target**: < **30%** performance impact vs service_role
- **Measurement**: (RLS_latency - service_role_latency) / service_role_latency × 100%
- **Failure Threshold**: ≥ **30%** overhead

### **📈 Throughput & Concurrency**
- **Read Throughput**: > **100 RPS** sustained (20 VUs × 5 RPM)
- **Write Throughput**: > **50 RPS** sustained (10 VUs × 5 RPM)  
- **Error Rate**: < **1%** under target load
- **Failure Threshold**: ≥ **1%** error rate

### **💾 Resource Efficiency**
- **Memory Utilization**: < **80%** database memory under load
- **Connection Pool**: < **90%** max connections during testing
- **Query Plan Stability**: No plan changes under concurrency

---

## **🏗️ Performance Testing Methodology**

### **Load Testing Approach**
- **Tool**: k6 for HTTP-based load testing
- **Test Duration**: 5-minute sustained load + 2-minute ramp
- **VU Distribution**: 70% read operations, 30% write operations
- **Data Variance**: 10 different recipes, 100 different users for RLS diversity

### **Measurement Strategy**
- **Latency Collection**: p50, p95, p99, max percentiles
- **Error Tracking**: HTTP 4xx/5xx rates, database connection errors
- **Resource Monitoring**: Supabase Dashboard metrics during testing
- **Baseline Comparison**: Single-user performance vs concurrent load

### **Test Environment**
- **Network**: US-West-2 region testing (matching production intent)
- **Database Tier**: Pro tier (if required for 100k+ records)
- **Client Location**: Same AWS region to minimize network variability

---

## **⚠️ Risk Factors & Contingencies**

### **Identified Performance Risks**
1. **PostgREST Overhead**: May consume 40-60% of latency budget
2. **RLS Policy Complexity**: Multi-table joins could exceed 30% overhead
3. **JSONB Performance**: Recipe steps/nutrition queries may be slower than expected
4. **Edge Function Cold Starts**: Unpredictable Deno initialization timing

### **Escalation Triggers**
- **Baseline Reality Check**: If single-user queries exceed 50% of targets → stakeholder decision required
- **RLS Overhead**: If RLS impact ≥30% → evaluate policy optimization vs acceptance
- **Infrastructure Limits**: If Free tier insufficient → Pro tier upgrade required
- **Fundamental Performance Gap**: If 2+ targets missed by ≥50% → alternative evaluation

### **Optimization Strategies (If Needed)**
1. **Query Optimization**: Index tuning, query plan analysis
2. **RLS Policy Refinement**: Simplify policy logic where possible
3. **Connection Pooling**: PgBouncer configuration optimization  
4. **Edge Function Optimization**: Memory allocation, code optimization
5. **Caching Strategy**: PostgREST cache headers for read-heavy workloads

---

## **✅ Success Criteria Summary**

### **Pass Conditions (All Required)**
- Read Query p95 < 150ms (acceptable: <195ms)
- Write Flow p95 < 250ms (acceptable: <325ms)  
- Edge Warm p95 < 200ms (acceptable: <260ms)
- Edge Cold p95 < 800ms (acceptable: <1040ms)
- RLS overhead < 30%
- Error rate < 1% under target load

### **Evidence Required**
- k6 test results with full latency distributions
- Supabase Dashboard metrics during testing periods
- Database query performance logs (if available)
- RLS vs service_role performance comparison
- Resource utilization trends during concurrent load

---

**Review Status**: ✅ **APPROVED**  
**Stakeholder Sign-off**: Required before Stage 1 commencement  
**Target Validation**: Baseline reality check in Stage 0b 