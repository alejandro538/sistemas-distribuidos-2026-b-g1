# CP6 - SLOs and Error Budget

## Scope and status

These are proposed objectives for the buyer checkout and payment-confirmation journey in `01-journey.md`. The application repository is private and unavailable, and the instrumentation in `03-instrumentation` is a reference example only. The targets below are therefore design proposals, not measured production performance or commitments approved by the team.

Use a rolling 28-day window and request-based event counting. Exclude invalid requests rejected before business processing (for example, a webhook with an invalid signature). Count valid requests that fail technically as bad events. Revisit the targets after collecting a representative baseline and agreeing them with the team.

## Proposed objectives

| SLO | Service user outcome | SLI definition | Target | Window | Data needed |
| --- | --- | --- | --- | --- | --- |
| Checkout confirmation availability | A valid payment confirmation is handled without a server-side failure. | Good events / eligible valid webhook requests. A good event is a completed handling response without a 5xx or timeout; an expected duplicate confirmation is good. | At least 99.5% good events | Rolling 28 days | HTTP request counts by route and status, plus valid webhook request counts. Spring Boot Actuator HTTP metrics or gateway metrics could supply this after configuration. |
| Confirmation processing latency | A valid payment confirmation is processed promptly. | Good events / eligible valid confirmation attempts. A good event completes within 2 seconds; a technical failure or slower completion is bad. | At least 99% good events | Rolling 28 days | A timer histogram for all valid attempts, including failed attempts, with a 2-second bucket and the request total as denominator. |

Business outcomes such as a duplicate webhook are not technical failures. Invalid signatures are excluded from these objectives and should be monitored separately as security signals. A missing transaction/session should be classified with the team before it is included or excluded; the proposed metric currently labels it `session_not_found`.

## Error budget calculation

For an event-based SLO:

`error budget = eligible events × (1 − SLO target)`

For every 10,000 eligible valid requests in a 28-day window:

| SLO | Allowed bad-event fraction | Example budget per 10,000 eligible events |
| --- | ---: | ---: |
| Availability at 99.5% | 0.5% | 50 failed or timed-out requests |
| Latency at 99% within 2 seconds | 1% | 100 requests slower than 2 seconds or failed technically |

These are request counts, not minutes of downtime. The actual budget depends on the number of eligible events observed during each window. No traffic volume or consumed budget is asserted here.

## Measurement gaps before activation

- The reference `TransactionConfirmationMetrics` records an outcome and duration only when called. It does not yet count every attempt before processing or record thrown technical failures. Without those observations, the denominator omits some bad events and the SLO can look better than reality.
- The Timer must publish a histogram with a bucket at 2 seconds, and the application must record failures as bad events. The private application POM and runtime configuration were not changed.
- HTTP request metrics must be enabled and filtered to the valid webhook route. Do not use a global 2xx ratio that mixes unrelated endpoints or invalid-signature traffic into this SLO.
- Until these gaps are addressed and the team approves the targets, treat both SLOs and budgets as proposals only.

## References

- `01-journey.md` - buyer checkout and payment-confirmation traces
- `02-log-contract.md` - correlation, safe identifiers, and event fields
- `03-instrumentation/README.md` - limits of the reference metrics implementation
- `04-metric-catalog.md` - current proposed counter and timer
