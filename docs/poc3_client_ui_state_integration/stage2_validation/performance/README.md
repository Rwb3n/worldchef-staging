# Performance Traces (Stage 2)

Store Flutter DevTools CPU & rebuild traces here.

## Trace Guidelines
1. Name files with pattern `<feature>_<device>_<timestamp>.json` or `.trace`.
2. Record device model, OS version, build variant in commit message.
3. Capture at least:
   - Optimistic like flow (list → like → detail) on mid-range device.
   - Network mutation latency path.

## Analysis Checklist
- [ ] Identify frame build time spikes.
- [ ] Verify widget rebuild count (≤2 on like flow).
- [ ] Note garbage collection pauses.

---
*Template generated: 2025-06-13* 