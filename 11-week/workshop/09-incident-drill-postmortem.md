# CP9 - Incident Drill and Blameless Postmortem

## Exercise status

This is a tabletop exercise plan and a postmortem template. The scenario and numbers below are simulated; no production incident or completed drill is claimed. Run the discussion with the team, then fill the exercise notes from what participants actually do and decide. Do not make changes in a live environment during the tabletop.

## Scenario for the facilitator

A hypothetical deployment is followed by slow database responses on the payment-confirmation path. Valid webhook requests begin timing out or returning server errors. Some buyers see a pending payment, and the fast-burn alerts from CP7 fire. The team must investigate using the CP8 runbook, protect payment idempotency, communicate impact, and decide on a safe mitigation.

### Simulated alert data

For the exercise only, give participants these counts for each of the relevant 5-minute and 1-hour windows:

- Availability: 80 of 1,000 eligible valid requests fail or time out. Bad-event ratio = 8%; allowed ratio = 0.5%; burn rate = 16x, above the CP7 fast-burn threshold of 13.44x.
- Latency: 150 of 1,000 eligible valid confirmation attempts take longer than 2 seconds or fail technically. Bad-event ratio = 15%; allowed ratio = 1%; burn rate = 15x, above the 13.44x threshold.
- These are invented exercise values, not observed project metrics. The actual instrumentation gaps in CP6 would need to be fixed before calculating these ratios in a deployment.

## Drill flow

1. **T+0 - Alert arrives.** Participants identify the SLO, severity, incident lead, and note taker. Ask what user impact is known and what is still unknown.
2. **T+5 - First triage.** Use the CP8 steps to check route-level errors, latency, recent releases, and safe logs/traces. Ask participants to distinguish evidence from assumptions.
3. **T+10 - New information.** The facilitator says database connection wait time rose shortly after the hypothetical deployment. Participants decide what evidence would confirm or disprove the link.
4. **T+15 - Safety check.** Ask how the team would mitigate if the release is the likely cause. The expected discussion is to consult the approved rollback owner/procedure, preserve webhook signature checks, and avoid direct ledger edits or non-idempotent replay.
5. **T+20 - Recovery inject.** The facilitator reports that a rollback in the simulated environment lowers latency. Participants decide how to verify new confirmations, duplicate delivery behavior, ledger consistency, delayed work, and alert recovery.
6. **T+30 - Close the exercise.** Record what was clear, what was missing, decisions that took time, and follow-up actions with role owners and due dates agreed by participants.

## Exercise notes to complete after the drill

- Date/time and participants: `[fill in]`
- Who acted as incident lead and note taker: `[fill in]`
- What responders checked first and why: `[fill in]`
- What information or access was missing: `[fill in]`
- What mitigation was chosen in the simulation and why: `[fill in]`
- Did participants protect idempotency and payment data? Evidence: `[fill in]`
- What should be changed in the runbook, alerts, or instrumentation: `[fill in]`

## Blameless postmortem template

### Summary

`Tabletop exercise only. Scenario: hypothetical database latency after a deployment. Actual customer impact: none; no production event was simulated.`

### Timeline

| Relative time | Exercise event or decision | Evidence / open question |
| --- | --- | --- |
| T+0 | `[fill in after exercise]` | `[fill in]` |
| T+5 | `[fill in after exercise]` | `[fill in]` |
| T+10 | `[fill in after exercise]` | `[fill in]` |
| T+15 | `[fill in after exercise]` | `[fill in]` |
| T+20 | `[fill in after exercise]` | `[fill in]` |

### Learning and follow-up

Describe how system design, observability, or procedures shaped the response. Focus on conditions and process, not blame. Add only actions agreed during the exercise; give each an owner role and due date.

| Action | Reason / expected improvement | Owner role | Due date | Status |
| --- | --- | --- | --- | --- |
| `[complete after exercise]` | `[complete]` | `[role]` | `[date]` | Open |

## References

- `06-slos-error-budget.md` - SLO definitions and measurement gaps
- `07-burn-rate-alerts.md` - simulated thresholds used in this scenario
- `08-runbook.md` - proposed incident response procedure
