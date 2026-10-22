# CP8 - Runbook: Payment Confirmation SLO Burn

## Scope and status

Use this proposed runbook when a CP7 availability or latency alert fires for the valid payment-confirmation webhook, or when confirmed payments remain pending. It follows the documented target microservice architecture. The application repository, dashboards, deployment commands, and on-call contacts are private or unavailable, so this is a procedure outline that the team must adapt before production use. The ZIP's MVP is a modular monolith and may not have the target services or broker.

## Impact to check

- Buyers may see a payment as pending after completing checkout.
- Producers may not receive a confirmation or follow-up notification on time.
- Retried webhook events may increase, so idempotent handling must be preserved.

## First response

1. Acknowledge the alert and record its start time, SLO, burn rate, and affected window.
2. Check the confirmation dashboard for eligible request volume, 5xx/timeouts, latency, and the `confirmed`, `already_confirmed`, and `session_not_found` outcomes. Confirm that enough events exist for the ratio to be meaningful.
3. Determine whether the issue is still active. Compare the current window with the paired short window from the alert; note recent releases and dependency changes.
4. Use approved logs and traces to follow an affected request by `trace_id`/`correlation_id`. Do not paste credentials, payment payloads, buyer details, or raw chat text into the incident channel.

## Diagnose the failing boundary

1. **Webhook ingress:** check gateway availability, route-level status codes, request duration, and recent deployment health.
2. **Signature verification:** check safe error codes and provider delivery status in the approved Stripe console. Never bypass signature verification or share the signing secret.
3. **Transaction processing:** check transaction-service health, database connectivity/latency, and whether confirmation writes complete. Avoid direct database edits.
4. **Asynchronous completion (target architecture only):** if the transaction is confirmed but downstream work is delayed, inspect the outbox relay, RabbitMQ backlog, and consumer health. In the monolithic MVP, verify the actual event-delivery path before applying these steps.
5. Compare the failing dependency and time range with the CP1 trace map. Record evidence and a likely cause before changing traffic or service state.

## Mitigate safely

- If a release correlates with the incident, use the team's approved rollback procedure and release owner; do not invent a deployment command.
- If a dependency is degraded, follow its approved fallback or escalation process. Keep the webhook response and retry behavior consistent with the provider's documented contract.
- Replay or retry only through an approved, idempotent mechanism. Do not create a second payment, mark a transaction confirmed manually, alter ledger rows, or disable idempotency/signature checks.
- If the cause is unclear or a mitigation could duplicate a charge, escalate to the transaction-service owner and payment-provider contact before acting.

## Recovery and handoff

1. Confirm a new valid webhook completes successfully and a duplicate delivery remains idempotent.
2. Verify transaction state, ledger consistency, and any delayed event/notification processing through approved read-only views.
3. Confirm the relevant alert windows recover and the SLO is no longer burning rapidly; keep monitoring for a recurrence.
4. Record start/end time, customer impact, affected component, mitigation, and remaining risks. Preserve a timeline for the CP9 blameless postmortem.

## Incident update template

`Status: investigating / mitigating / monitoring | Start time: UTC | Affected journey: payment confirmation | User impact: known / being assessed | Current evidence: safe metrics and error codes | Action owner: role/name | Next update: time`

## References

- `01-journey.md` - checkout and payment-confirmation trace map
- `02-log-contract.md` - safe structured-log fields and prohibited data
- `06-slos-error-budget.md` - SLO definitions and eligibility
- `07-burn-rate-alerts.md` - alert conditions and intended severity
