# Stage 2 – Validation & Profiling

Assess performance, developer experience, and AI effectiveness.

## Validation Checklist
- [ ] Measure optimistic update latency (<50 ms target).
- [ ] Measure mutation round-trip p90 (<300 ms target with mock latency).
- [ ] Capture widget rebuild counts (≤2 on like flow).
- [ ] Record AI prompt → first-iteration success metrics.
- [ ] Run full unit/widget test suite in CI (≥98 % pass).
- [ ] Validate offline banner latency (<200 ms after connectivity loss).

## Expected Outputs
| Artifact | Path | Description |
|----------|------|-------------|
| Performance traces | `stage2_validation/performance/` | DevTools CPU & rebuild traces |
| AI metrics log | `stage2_validation/ai_metrics.md` | Prompt counts, iterations, success rates |
| Test run log | `stage2_validation/test_results.md` | CI test outputs & coverage summary |
| Validation summary | `stage2_validation/validation_summary.md` | Consolidated pass/fail with recommendations |

---
_Last updated: 2025-06-13_ 