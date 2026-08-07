<!-- Example spec (Spec-Driven Development) — see the SDD skill for context.
     This task breakdown implements examples/rate-limiting/{requirements,design}.md.
     Tasks are executed ONE AT A TIME, in order, verifying each acceptance criterion
     before moving to the next. -->

# Tasks — API rate limiting

## T1: Implement the rate limiter module

- **Scope**: Create `src/rate-limiter.js` with a pure `createRateLimiter(config)` that validates config and returns a `check(key)` function implementing a lazy-refill token bucket. Include idle-entry sweep.
- **Files**: `src/rate-limiter.js`, `test/rate-limiter.test.js`
- **Depends on**: —
- **Acceptance**: `npm test -- rate-limiter` passes. Tests cover: refill after idle, burst up to capacity (FR-3), exhaustion → `allowed: false` with `retryAfterSeconds` (FR-1), config validation failure (FR-4), idle entries swept.

## T2: Wire the middleware with 429 rejection

- **Scope**: Create `src/middleware/rate-limit.js` that reads `X-API-Key`, calls `check`, short-circuits with HTTP 429 + `Retry-After` when not allowed, and leaves 401 handling to the existing auth check.
- **Files**: `src/middleware/rate-limit.js`, `test/rate-limit.middleware.test.js`, `src/server.js`
- **Depends on**: T1
- **Acceptance**: Integration tests pass: request with exhausted quota returns 429 with `Retry-After` (FR-1); request within quota reaches the route handler; missing key still returns 401.

## T3: Emit quota response headers

- **Scope**: Add `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset` to every public endpoint response. Make limit and window configurable via `RATE_LIMIT_LIMIT` / `RATE_LIMIT_WINDOW`, failing fast on invalid values.
- **Files**: `src/middleware/rate-limit.js`, `src/server.js`, `test/rate-limit.middleware.test.js`
- **Depends on**: T2
- **Acceptance**: Tests verify all three headers on processed responses (FR-2) and that invalid startup config aborts the service (FR-4). Manual run with 100 req/min config accepts 100 and rejects the 101st.

## Traceability

| Requirement / edge case | Covered by |
| --- | --- |
| FR-1 | T1, T2 |
| FR-2 | T3 |
| FR-3 | T1 |
| FR-4 | T1, T3 |
| First request from new key | T1 |
| Missing key header → 401 | T2 |
| Window boundary | T1 |
| Restart loses state | T1 (documented in design) |
| Memory sweep | T1 |
