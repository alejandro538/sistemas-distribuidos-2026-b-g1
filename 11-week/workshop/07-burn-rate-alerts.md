# CP7 - Burn-Rate Alerts

## Scope and status

These alert specifications use the 28-day, request-based SLOs proposed in `06-slos-error-budget.md`. They are design examples, not deployed alert rules: the private application repository and a metrics backend are unavailable, and CP6 identified missing denominator and failure measurements.

## Burn-rate calculation

`burn rate = observed bad-event ratio / allowed bad-event ratio`

The allowed bad-event ratio is `1 minus the SLO target`: 0.5% for the 99.5% availability SLO and 1% for the 99% latency SLO. A burn rate of 1 consumes the budget at its expected pace; a higher value consumes it faster.

For a 28-day window (672 hours), the proposed thresholds are derived from the fraction of budget to spend:

- **Fast burn:** spend 2% of the budget in one hour: `0.02 × 672 / 1 = 13.44×`.
- **Slow burn:** spend 5% of the budget in six hours: `0.05 × 672 / 6 = 5.6×`.

## Alert specifications

| Alert | SLO | Condition (both windows must exceed threshold) | Severity | Intended response |
| --- | --- | --- | --- | --- |
| `CheckoutConfirmationFastBurn` | Availability | Burn rate > `13.44×` over 1 hour **and** 5 minutes | Page / urgent investigation | Check valid webhook 5xx/timeouts, gateway and application health, and payment-provider status. Mitigate the active cause and preserve evidence. |
| `CheckoutConfirmationSlowBurn` | Availability | Burn rate > `5.6×` over 6 hours **and** 30 minutes | Ticket / prompt investigation | Review the trend, recent releases, and dependency failures; assign investigation before more budget is consumed. |
| `ConfirmationLatencyFastBurn` | Latency | Burn rate > `13.44×` over 1 hour **and** 5 minutes | Page / urgent investigation | Check confirmation latency and failures by dependency; identify whether the application, database, or payment provider is delaying valid requests. |
| `ConfirmationLatencySlowBurn` | Latency | Burn rate > `5.6×` over 6 hours **and** 30 minutes | Ticket / prompt investigation | Review latency distribution and deployment changes; plan a corrective action and track it to completion. |

Each rule must calculate bad events and eligible events for the same route, SLI, and time window. For latency, a technical failure is bad, as is a completed attempt over 2 seconds. For availability, a 5xx or timeout on an eligible valid webhook is bad; expected duplicate handling is good. Do not use identifiers as alert labels.

## Before enabling alerts

- Add instrumentation that counts every eligible attempt and captures technical failures, as required by CP6. The current reference counter records only selected outcomes and cannot produce a trustworthy burn rate by itself.
- Configure a timer histogram with a 2-second bucket and expose request totals by the webhook route and status.
- Add a minimum-event-volume guard after observing real traffic, so a few requests do not trigger unstable ratios. The threshold must come from measured traffic, not an invented value.
- Validate both long and short windows against sample data, confirm alert routing and ownership, and link the final response steps to the CP8 runbook before activation.

## References

- `06-slos-error-budget.md` - targets, eligible events, and error-budget definitions
- `04-metric-catalog.md` - proposed metric names and cardinality rules
