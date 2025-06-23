# Mock API Strategy (Stage 0)

Document the design and implementation of the `dio_mock_interceptor` used to simulate network requests with configurable latency.

## Objectives
- Provide deterministic responses for Recipe List, Recipe Detail, Like/Unlike endpoints.
- Inject variable latency (80-150 ms) to match success metrics assumptions.
- Emit error scenarios (HTTP 5xx, network timeout) for resilience testing.

## Key Decisions
| Decision | Rationale |
|----------|-----------|
| Response source | Inline fixtures vs. JSON files in assets/ | [TODO] |
| Latency injection | `Future.delayed(Duration(milliseconds: randomRange))` | Keeps test simple while realistic |
| Error rate | 5 % configurable failure rate | Exposes rollback paths |

## Implementation Steps
1. Add `dio_mock_interceptor` dependency.
2. Register interceptor in `main.dart` during development mode.
3. Configure per-endpoint handlers returning mock payloads.
4. Provide helper to toggle latency/failure during tests.

## Validation Plan
- Unit test ensuring mock returns expected JSON + status code.
- Measure actual injected latency distribution.

---
*Template generated: 2025-06-13* 