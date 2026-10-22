
<!-- CONFIG-START - must match your profile repo (username/username) CONFIG -->
- FULL_NAME: Alejandro Ortiz Vargas 
- GITHUB_USER: alejandro538
- TEAM: Elkin Stiven Contreras Rojas - Alejandro Ortiz Vargas
- DOCS_REPO: https://github.com/code-corhuila/market-agri-docs
- REFLECTION_DOC: https://docs.google.com/document/d/12WIi0rOL9ajy6lNCB-Ujs8VRlhaLPw0FrL-yHOxs0PU/edit?usp=sharing 
- JOURNEY: Buyer checkout (HU-TXN-001) - front -> api-gateway -> workflow saga -> chat / catalog / transactions -> RabbitMQ -> worker
<!-- CONFIG-END -->

# Weekly Status - Week 11

- FULL_NAME: Alejandro Ortiz Vargas
- GITHUB_USER: alejandro538
- TEAM: Elkin Stiven Contreras Rojas - Alejandro Ortiz Vargas
- SPRINT_GOAL: Apply observability practices to the buyer checkout journey (HU-TXN-001) and document the Week 11 workshop evidence.

## 1. User stories worked this week

| HU ID | Title | Status (todo/doing/done) | Evidence (PR or commit URL) |
| --- | --- | --- | --- |
| HU-TXN-001 | Pay for a product on the platform - checkout observability | doing | [Workshop folder](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/tree/main/11-week/workshop), [CP1 commit](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/commit/e834e4b), [CP2 commit](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/commit/7477364) |

## 2. My individual contribution

- **CP1 - Critical journey and trace map:** documented the buyer checkout journey, its synchronous and asynchronous hops, and the trace trees for checkout and payment confirmation. The map follows the documented target microservice architecture and calls out that the ZIP contains an earlier modular-monolith MVP. [File](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/blob/main/11-week/workshop/01-journey.md) · [Commit](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/commit/e834e4b)
- **CP2 - Structured log contract:** specified common and checkout fields, sensitive data to omit, severity guidance, and seven illustrative JSON log lines. They are examples, not captured runtime logs. [File](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/blob/main/11-week/workshop/02-log-contract.md) · [Commit](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/commit/7477364)
- **CP3 - Instrumentation example and test:** added a Java/Micrometer reference class for transaction confirmation counts and duration, plus a unit test using `SimpleMeterRegistry`. This sample is not integrated into the private application repository, and its test has not been run against that project. [Folder](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/tree/main/11-week/workshop/03-instrumentation) · [Commit](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/commit/01ac5a4)
- **CP4 - Metric catalog:** documented the proposed confirmation counter and timer, their bounded `outcome` labels, purposes, and measurement limitations. [File](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/blob/main/11-week/workshop/04-metric-catalog.md) · [Commit](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/commit/36bbf16)
- **CP6 - SLOs and error budget:** proposed 28-day event-based availability and latency objectives with example budgets. The values are proposals, not production measurements. [File](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/blob/main/11-week/workshop/06-slos-error-budget.md) · [Commit](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/commit/919d74c)
- **CP7 - Burn-rate alerts:** documented fast- and slow-burn conditions and what the proposed alerts should prompt. The alerts are not deployed because the metrics backend and complete measurements are unavailable. [File](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/blob/main/11-week/workshop/07-burn-rate-alerts.md) · [Commit](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/commit/30b7557)
- **CP8 - Runbook:** prepared investigation, mitigation, recovery, and communication steps for payment-confirmation SLO burn. The procedure needs adaptation to the private deployment. [File](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/blob/main/11-week/workshop/08-runbook.md) · [Commit](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/commit/fa69d19)
- **CP9 - Incident drill and postmortem:** committed a tabletop scenario and a blameless postmortem template. The exercise notes still need to be completed after the drill; CP9 is not yet complete. [File](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/blob/main/11-week/workshop/09-incident-drill-postmortem.md) · [Commit](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/commit/d009487)
- **CP10:** not completed yet.

## 3. Blockers and risks

- The application repository is private and I do not have access. The project ZIP contains a modular-monolith MVP, while CP1 maps the documented target microservice architecture; the reference instrumentation therefore has not been integrated into the running application.
- No production metrics backend or baseline is available. CP4, CP6, and CP7 describe proposed metrics and objectives, not measured service performance or active alerts.
- The CP9 tabletop notes and CP10 work remain to be completed.
- Some consecutive delivery-2 pushes were less than 15 minutes apart. The commit history has not been rewritten.

## 4. Plan for next week

`Complete this section in my own words, as required for the personal implementation plan.`

## 5. Compliance self-check

- Checkpoint artifacts and their commits are linked above; CP10 is still pending.
- The CP3 unit test was added but has not been run against the private application project.
- The proposed metrics avoid transaction, user, trace, and correlation IDs as metric labels.
- No secrets or payment payloads are included in the workshop examples.
- The personal implementation plan and reflection document are to be written by me.

## 6. Evidence links

- [My fork](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1)
- [Week 11 workshop folder](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/tree/main/11-week/workshop)
- [Reflection document](https://docs.google.com/document/d/12WIi0rOL9ajy6lNCB-Ujs8VRlhaLPw0FrL-yHOxs0PU/edit?usp=sharing)

