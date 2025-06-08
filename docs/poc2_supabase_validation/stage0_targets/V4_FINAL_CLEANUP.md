# PoC #2 v4 Final Cleanup
## 🧹 **Structural & Substantive Issue Resolution**

**Document Purpose**: Systematic cleanup of v4 plan addressing structural noise, threshold mismatches, and substantive gaps to achieve truly decision-grade quality.

---

## **📋 Cleanup Assessment**

**v4 Backbone Status**: ✅ **STRONG FOUNDATION**  
**Structural Issues**: 🔴 **7 Categories Requiring Cleanup**  
**Cleanup Objective**: 🎯 **Decision-Grade JSON with Zero Contradictions**

---

## **🔍 Line-by-Line Issue Categories**

### **1. Remove Stale Duplicates** 🚨 **URGENT**

| **What Clashes** | **Correct v4 Value** | **Stale Fragment** | **Fix Required** |
|------------------|---------------------|-------------------|------------------|
| Read/Write VUs | 150 read / 60 write | 50 read / 20 write | Purge old references |
| Edge CPU load | 300ms simulated CPU | 50ms simulated CPU | Remove old descriptions |
| Plan versions | Top-level v: 4 | Embedded v: 2, v: 3 | Clean all version refs |

**Risk**: JSON tooling will break, automation picks wrong values, human confusion

### **2. Fix Backup/Restore Scope Drift** 🔴 **CRITICAL**

**Current Mismatch**:
- Stage 6 task: pg_dump → local Postgres only
- Success metric m004: Demands Supabase-native restore (PITR)

**Required Fix**: Add checklist item "Verify Point-in-Time Recovery via Supabase dashboard/PITR API"

### **3. Threshold Mismatches** ⚠️ **INCONSISTENT**

| **Item** | **Location A** | **Location B** | **Correct Value** |
|----------|----------------|----------------|-------------------|
| Baseline overhead gate | Stage 0b: >30% | Exit gates: >50% | **Standardize to 50%** |
| Cost failure gate | Stage 5: >$150/month | Exit gates: >$120/month | **Standardize to $120/month** |

### **4. Edge Function Workload Realism** 📈 **ENHANCEMENT**

**Current**: 60 VUs sustained load (same as DB writes)  
**Issue**: Edge functions see steeper spike patterns  
**Fix**: Add burst scenario (200 VUs × 60s) to test auto-scaling vs throttling

### **5. Region & Latency Risk** 🌍 **GEOGRAPHIC**

**Current**: Hard-coded us-west-2  
**Issue**: Team is London-centric, may underestimate EU latency/egress  
**Fix**: Note EU production deployment or run dual-region comparison

### **6. Effort vs Schedule** ⏱️ **REALISTIC**

**Current**: Stage 4 = 12h (k6 + analysis)  
**Issue**: Last PoC took 18h just for k6 scripts  
**Fix**: Pad to 20h or add contingency line item

### **7. Minor Polish** ✨ **QUALITY**

- Link Stage 1 CLI setup to Stage 6 restore (avoid duplication)
- Add auth endpoint rate-limit testing to Stage 5b
- Rename stage_exit_gates keys to semantic names

---

## **🔧 Systematic Cleanup Implementation**

### **Phase 1: Structural JSON Cleanup**

#### **A. Version Fragment Purge**
```json
// REMOVE: All embedded version conflicts
"v": 2,  // DELETE
"v": 3,  // DELETE
// KEEP: Only top-level "v": 4
```

#### **B. VU Reference Standardization**
```
FIND: "50 VUs", "20 VUs"
REPLACE: "150 VUs (MAU-derived)", "60 VUs (MAU-derived)"

FIND: "50ms CPU"
REPLACE: "300ms CPU + HTTP simulation"
```

#### **C. Threshold Harmonization**
```
Baseline Gate: 50% everywhere (remove 30% references)
Cost Gate: $120/month everywhere (remove $150 references)
```

### **Phase 2: Substantive Gap Fixes**

#### **A. Enhanced Stage 6 Backup/Restore**
```json
{
  "item_id": "supabase_native_restore",
  "description": "Verify Point-in-Time Recovery via Supabase dashboard/PITR API to new project",
  "status": "PENDING",
  "target_artifact_id": "poc2_pitr_validation"
}
```

#### **B. Edge Function Burst Testing**
```json
{
  "item_id": "edge_burst_test",
  "description": "Test 3c: Edge Function Burst Load - 200 VUs × 60s to test auto-scaling vs throttling under spike traffic",
  "status": "PENDING",
  "target_artifact_id": "poc2_edge_burst_benchmark"
}
```

#### **C. Region Consideration**
```json
{
  "item_id": "region_latency_assessment",
  "description": "Document latency implications for EU production deployment vs us-west-2 PoC environment",
  "status": "PENDING",
  "target_artifact_id": "poc2_region_analysis"
}
```

#### **D. Enhanced Security Testing**
```json
{
  "item_id": "auth_rate_limit_test",
  "description": "Test rate-limiting and brute-force protection on auth endpoints per ADR-WCF-005",
  "status": "PENDING",
  "target_artifact_id": "poc2_auth_security_validation"
}
```

### **Phase 3: Schedule & Effort Calibration**

#### **A. Realistic Stage 4 Effort**
```
Current: 12h (optimistic)
Revised: 20h (based on PoC #1 k6 complexity)
Rationale: Script stabilization + multi-scenario analysis
```

#### **B. Semantic Exit Gate Names**
```json
"stage_exit_gates": {
  "baseline_overhead_gate": "If baseline overhead >50% → escalate",
  "performance_threshold_gate": "If read p95 >2× target → escalate", 
  "cost_viability_gate": "If 10k MAU >$120/month → trigger alternative",
  "operational_readiness_gate": "If backup/restore fails → document risk"
}
```

---

## **📊 Cleaned v4 Specifications**

### **Standardized Load Testing**:
- **Read Queries**: 150 VUs (peak MAU-derived concurrency)
- **Write Operations**: 60 VUs (peak write concurrency)  
- **Edge Sustained**: 60 VUs (realistic steady-state)
- **Edge Burst**: 200 VUs × 60s (spike testing)

### **Consistent Thresholds**:
- **Baseline Overhead**: >50% escalation trigger
- **Cost Failure**: >$120/month alternative evaluation
- **Performance**: >2× target immediate escalation
- **Backup/Restore**: >4h operational risk documentation

### **Complete Testing Scope**:
- **Database**: Read/Write with RLS under peak load
- **Edge Functions**: Sustained + burst with 300ms CPU
- **Security**: OWASP + auth rate-limiting + GDPR
- **Operations**: pg_dump + Supabase-native PITR
- **Cost Model**: All fee structures including EU egress

### **Realistic Schedule**:
- **Total Effort**: 90h (adjusted for k6 complexity)
- **Calendar Days**: 21 days (proper spacing)
- **Critical Path**: Stage 0b → 4 → 5/5b → 6/6b → 7

---

## **✅ Cleanup Checklist**

### **Structural Fixes** 🧹
- [ ] Remove all version fragments except top-level v: 4
- [ ] Standardize all VU references to 150/60/60/200
- [ ] Replace all 50ms CPU with 300ms CPU + HTTP
- [ ] Harmonize thresholds (50% baseline, $120 cost)
- [ ] Clean duplicate task descriptions

### **Substantive Enhancements** 🔧
- [ ] Add Supabase-native PITR testing to Stage 6
- [ ] Add Edge function burst testing (200 VUs)
- [ ] Add region latency consideration
- [ ] Add auth rate-limit testing to Stage 5b
- [ ] Adjust Stage 4 effort to 20h realistic estimate

### **Polish & Integration** ✨
- [ ] Link Stage 1 CLI to Stage 6 restore
- [ ] Rename exit gates to semantic names
- [ ] Add EU production deployment notes
- [ ] Verify all artifact paths are consistent
- [ ] Cross-reference all dependencies

---

## **🎯 Post-Cleanup Quality Assurance**

### **JSON Integrity**:
✅ **No Version Conflicts**: Single v: 4 throughout  
✅ **No Value Contradictions**: Consistent VUs, thresholds, timings  
✅ **No Scope Gaps**: Complete backup/restore, security, burst testing  
✅ **No Magic Numbers**: Semantic gate names with clear triggers  

### **Decision-Grade Criteria**:
✅ **Traceable**: Latency → Cost → Ops → Compliance chain  
✅ **Realistic**: MAU-derived load, 300ms Edge, PITR testing  
✅ **Complete**: All fee structures, security, operational validation  
✅ **Executable**: Realistic effort with proper contingencies  

### **Automation-Ready**:
✅ **Scriptable JSON**: No parsing conflicts or ambiguities  
✅ **Clear Dependencies**: Unambiguous task sequencing  
✅ **Measurable Gates**: Objective abort criteria  
✅ **Artifact Traceability**: Complete registry mapping  

---

## **📈 Expected Post-Cleanup Outcomes**

### **Signal Quality**:
- **Zero Contradictions**: Clean JSON for automation
- **Complete Coverage**: All testing scenarios included
- **Realistic Baselines**: Proper load and effort estimates
- **Clear Decision Points**: Unambiguous success/failure criteria

### **Implementation Confidence**:
- **Execution Clarity**: No confusion about VUs, thresholds, scope
- **Resource Planning**: Realistic 90h effort with proper buffers
- **Risk Management**: Clear abort criteria prevent resource waste
- **Quality Assurance**: Complete testing prevents production surprises

---

## **✅ Verdict Alignment**

**Your Assessment**: *"Keep the v4 backbone, but clean the JSON before anyone tries to script against it"*

**Cleanup Response**: 🎯 **COMPREHENSIVE JSON CLEANUP PLANNED**

**Result**: **Genuinely decision-grade PoC plan with traceable criteria from latency → cost → ops → compliance**

---

**Cleanup Priority**: 🚨 **IMMEDIATE**  
**Implementation Impact**: 📈 **DECISION-CRITICAL**  
**JSON Quality**: 🧹 **AUTOMATION-READY** 