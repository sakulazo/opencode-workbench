<!-- Example spec (Specification-Driven Development) — see the SDD skill for context.
     This validation records the conformance check for the spec in
     examples/rate-limiting/{requirements,design,tasks}.md. -->

# Validation — API rate limiting

## Traceability matrix

| Requirement / edge case | Acceptance criterion | Test / evidence | Result |
| --- | --- | --- | --- |
| FR-1 | Given a valid API key with remaining quota, when a request arrives, then the request is processed normally. | `test/rate-limiter.test.js` — refill after idle; `test/rate-limit.middleware.test.js` — request within quota reaches the route handler. | PASS |
| FR-1 | Given a valid API key whose quota is exhausted, when a request arrives, then the request is rejected with HTTP 429 and a `Retry-After` header. | `test/rate-limiter.test.js` — exhaustion returns `allowed: false` with `retryAfterSeconds`; `test/rate-limit.middleware.test.js` — exhausted quota returns 429 with `Retry-After`. | PASS |
| FR-2 | Given a processed request, when the response is returned, then it includes `X-RateLimit-Limit`, `X-RateLimit-Remaining` and `X-RateLimit-Reset`. | `test/rate-limit.middleware.test.js` — all three headers present on processed responses. | PASS |
| FR-2 | Given a rejected request with exhausted quota, when the 429 response is returned, then it includes the same three quota headers alongside `Retry-After`. | `test/rate-limit.middleware.test.js` — all three headers present on 429 responses. | PASS |
| FR-3 | Given a client that has not made requests for at least one full window, when it sends N concurrent requests where N equals the capacity, then all N are processed. | `test/rate-limiter.test.js` — burst up to capacity. | PASS |
| FR-3 | Given the same client, when it sends N+1 concurrent requests, then exactly 1 is rejected with 429. | `test/rate-limiter.test.js` — burst exceeding capacity. | PASS |
| FR-4 | Given the service starts with `RATE_LIMIT_LIMIT=100` and `RATE_LIMIT_WINDOW=60`, when a client sends 100 requests back-to-back, then none are rejected. | Manual run with `RATE_LIMIT_LIMIT=100` / `RATE_LIMIT_WINDOW=60` — burst of 100 back-to-back requests. | PASS |
| FR-4 | Given the same configuration, when the client sends 101 requests back-to-back, then the 101st is rejected with 429. | Manual run with `RATE_LIMIT_LIMIT=100` / `RATE_LIMIT_WINDOW=60` — burst of 101 back-to-back requests. | PASS |
| First request from a new key | Bucket is initialized full; the request is processed. | `test/rate-limiter.test.js` — first request from a new key. | PASS |
| Missing/expired key header → 401 | Request rejected with 401 before rate limiting (unchanged behavior). | `test/rate-limit.middleware.test.js` — missing or expired key still returns 401. | PASS |
| Continuous refill | Refill is continuous: a request right after a refill sees the updated quota, with no jumps or off-by-one errors at any timestamp. | `test/rate-limiter.test.js` — refill-timing test. | PASS |
| Restart loses state | Bucket state is lost; all clients start with a full bucket. | Documented in design.md; covered by the bucket initialization test. | PASS |
| Memory sweep | Idle entries are swept to bound memory usage. | `test/rate-limiter.test.js` — idle entries swept. | PASS |

## Conformance check

Result of running the SDD spec validation — tests/validate-spec.md (validation moment).

| Section (validate-spec.md) | PASS | FAIL | N/A |
| --- | --- | --- | --- |
| A. Structure of `requirements.md` | PASS |  |  |
| B. Content quality of `requirements.md` | PASS |  |  |
| C. Structure and content of `design.md` | PASS |  |  |
| D. Structure and content of `tasks.md` | PASS |  |  |
| E. Global traceability and coherence | PASS |  |  |

## Exceptions

None.

## Result

- **Approved**: yes
- **Signed off by**: Lucas Sanchez
- **Date**: 2026-08-07
