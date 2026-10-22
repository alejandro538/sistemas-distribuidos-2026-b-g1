# CP3 - Metric Catalog

This catalog describes the reference instrumentation in [`03-instrumentation`](03-instrumentation/README.md). The metric code is not connected to the private application repository, so these are proposed metrics, not measurements from a running deployment.

| Metric | Type | Unit | Labels | Source | Purpose |
| --- | --- | --- | --- | --- | --- |
| `market_agri.transaction.confirmations` | Counter | confirmations | `outcome`: `confirmed`, `already_confirmed`, `session_not_found` | `TransactionService.confirm` outcome, recorded by `TransactionConfirmationMetrics` | Count confirmation attempts by bounded outcome; use the `confirmed` series to track successful confirmations. |
| `market_agri.transaction.confirmation.duration` | Timer | seconds | `outcome`: `confirmed`, `already_confirmed`, `session_not_found` | Elapsed time around `TransactionService.confirm`, recorded by `TransactionConfirmationMetrics` | Track confirmation processing latency and compare it with a future latency objective. |

## Label and collection rules

- The `outcome` label has exactly three values from an enum. Do not add exception messages or dynamically generated values.
- Never use transaction, conversation, buyer, producer, trace, or correlation IDs as metric labels. They create a separate time series per value and can expose identifiers.
- Keep sensitive data and business identifiers in appropriately protected logs or traces, following `02-log-contract.md`.
- The timer is recorded once for each handled confirmation outcome. A Prometheus registry exports timer count, sum, and histogram/maximum series according to its configuration; the exact exported series depend on the registry settings.
- No dashboard, scrape target, alert, or production SLI is claimed by this catalog. Those require a deployed metrics backend and agreed service objectives.

## Interpretation

The `confirmed` counter is the numerator for successful confirmations. The sum of all three outcome counters represents the confirmation calls observed by this instrumentation. A ratio can be calculated over a time window after deployment, but this example does not define an alert threshold or an SLO. The timer supports latency analysis; a percentile objective must be agreed and configured separately.
