<!-- Example spec (Specification-Driven Development) — see the SDD skill for context.
     This is a complete, minimal requirements spec for a concrete feature. -->

# Requirements — API rate limiting

## Purpose

Protect the public HTTP API from abuse by limiting the number of requests a client can make within a time window, keyed by the client's API key. Without this limit, a single client can degrade service for everyone.

## Scope

Add a rate-limiting middleware to the existing HTTP service. The middleware sits in the request pipeline before the route handlers and applies only to public endpoints that require an API key.

## Goals

- Reject requests that exceed a configurable limit with HTTP 429.
- Inform clients of their remaining quota via standard headers.
- Cost less than 1ms of overhead per request on average.

## Non-goals

- Distributed/cross-instance rate limiting (tracked as future work).
- Authentication or API key issuance (already exists).
- Per-user or per-endpoint quotas beyond the single global default.
- Per-client whitelisting or higher-tier quotas.

## Assumptions

- The service runs as a single instance for the foreseeable future.
- The API key is always present and valid on the requests that reach the rate limiter: the auth check runs before it and rejects missing or expired keys with 401.
- The rate-limit state may be lost on restart without contractual impact.

## Functional requirements

### FR-1: Enforce a per-key rate limit

Each request to a public endpoint is checked against the quota for its API key. Requests exceeding the quota are rejected.

**Acceptance criteria:**

- Given a valid API key with remaining quota, when a request arrives, then the request is processed normally.
- Given a valid API key whose quota is exhausted, when a request arrives, then the request is rejected with HTTP 429 and a `Retry-After` header.

### FR-2: Report quota in response headers

Every response that passes through the rate limiter (processed or rejected with 429) includes the client's current quota state.

**Acceptance criteria:**

- Given a processed request, when the response is returned, then it includes `X-RateLimit-Limit`, `X-RateLimit-Remaining` and `X-RateLimit-Reset`.
- Given a rejected request with exhausted quota, when the 429 response is returned, then it includes the same three quota headers alongside `Retry-After`.

### FR-3: Allow a bounded burst

A client that has not made requests for at least one full window may send a burst of requests up to the configured limit, even if the sustained rate is exceeded during that burst.

**Acceptance criteria:**

- Given a client that has not made requests for at least one full window, when it sends N concurrent requests where N equals the configured limit, then all N are processed.
- Given the same client, when it sends N+1 concurrent requests, then exactly 1 is rejected with 429.

### FR-4: Configurable limits

The limit (requests per window) and the window (seconds) are configurable at service startup.

**Acceptance criteria:**

- Given the service starts with `RATE_LIMIT_LIMIT=100` and `RATE_LIMIT_WINDOW=60`, when a client sends 100 requests back-to-back, then none are rejected.
- Given the same configuration, when the client sends 101 requests back-to-back, then the 101st is rejected with 429.

## Edge cases and error scenarios

- First request from a new key: bucket is initialized full; the request is processed.
- Expired key or missing key header: request is rejected with 401 before rate limiting (unchanged existing behavior).
- Quota recovery is continuous: a request immediately after a quota recovery observes the updated remaining quota, with no jumps or off-by-one errors at any timestamp.
- Restart of the service: bucket state is lost; all clients start with a full bucket.
- Memory growth from many keys: entries idle for more than the window are swept to bound memory usage.

## Constraints

- In-memory storage only; no external infrastructure (Redis, DB) may be introduced.
- The rate-limit check must complete in O(1) per request on average.
- Limit and window must be positive integers; invalid configuration must fail fast at startup.
