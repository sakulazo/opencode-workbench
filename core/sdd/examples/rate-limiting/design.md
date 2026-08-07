<!-- Example spec (Specification-Driven Development) — see the SDD skill for context.
     This design spec implements examples/rate-limiting/requirements.md. -->

# Design — API rate limiting

## Context

The HTTP service currently forwards every authenticated request to its route handlers with no throttling. This design adds a rate-limiting middleware in the request pipeline, keyed by the `X-API-Key` header, implementing [requirements.md](requirements.md).

## Architecture overview

A middleware registered before the route handlers:

```text
Request ──▶ [auth check] ──▶ [rate limiter] ──▶ route handler
                                │  │
                              pass │ reject → 429 + Retry-After
```

The rate limiter is a pure module that tracks token buckets per API key. The middleware reads the API key, calls the limiter, and either continues the pipeline or short-circuits with a 429 response.

## Decisions

### Decision 1: Token bucket algorithm

- **Decision**: Use a token bucket (capacity = limit, refill rate = limit / window).
- **Rationale**: Allows bounded bursts (FR-3) while enforcing the sustained rate (FR-1). Cheap to compute with lazy refill from a timestamp.
- **Alternatives considered**: Fixed-window counter (rejected: causes boundary spikes and an off-by-one issue at window edges); sliding window log (rejected: memory grows with request count, more complex).

### Decision 2: In-memory store

- **Decision**: Keep buckets in a process-local `Map<string, Bucket>` with idle-entry sweeping.
- **Rationale**: Meets the O(1) and no-external-infrastructure constraints for a single instance. Sweeping bounds memory growth per the edge-case requirement.
- **Alternatives considered**: Redis (rejected: violates constraints and is unnecessary for a single instance).

### Decision 3: Standard quota headers

- **Decision**: Emit `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`.
- **Rationale**: Interoperable with common client libraries and required by FR-2. In a token bucket, `X-RateLimit-Reset` reports when the bucket refills to capacity.
- **Alternatives considered**: Proprietary header names (rejected: weaker ecosystem support).

## Data model

```text
Bucket {
  tokens: number        // current tokens, float
  lastRefillTs: number  // unix seconds of last refill
}
Key: API key string (from X-API-Key header)
Store: Map<string, Bucket>
Config: { limit: number, windowSeconds: number }
```

`resetAt` is not persisted: it is computed per check as the time the bucket refills to capacity (`now + (capacity - tokens) / refillRate`).

## Contracts

### Module: `rate-limiter`

- `createRateLimiter(config) → RateLimiter` — validates config (throws on invalid values), returns a limiter instance.
- `limiter.check(key) → Result` where:
  - `Result = { allowed: true, remaining, resetAt }` — consumes one token; `resetAt` is the computed time the bucket refills to capacity.
  - `Result = { allowed: false, retryAfterSeconds, resetAt }` — bucket empty; `resetAt` computed as above.

### Middleware behavior

The auth check runs before this middleware; requests with a missing or invalid key never reach it (401 handled there, unchanged existing behavior).

- Request with exhausted quota: **429**, headers `Retry-After: <seconds>` plus quota headers.
- Processed request: **200-level**, response headers `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`.

### Startup configuration

- `RATE_LIMIT_LIMIT` (int, default 100), `RATE_LIMIT_WINDOW` (int, default 60). Invalid values fail fast at startup (FR-4).

## Affected files / modules

- `src/rate-limiter.js` — new pure module (bucket logic).
- `src/middleware/rate-limit.js` — new middleware (wiring, headers, 429 response).
- `src/server.js` — register middleware; read configuration.
- `test/rate-limiter.test.js` — unit tests for bucket logic.
- `test/rate-limit.middleware.test.js` — integration tests for middleware behavior.

## Risks and mitigations

- Multi-instance deployment later → single-instance assumption is documented in requirements; in-memory decision is reversible to Redis without API change.
- Memory growth from many keys → idle-entry sweep bounded to window size.
- Off-by-one at any timestamp → lazy refill derives tokens from `lastRefillTs` (continuous model), covered by an explicit refill-timing test.
