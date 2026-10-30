<!-- HU-STATUS TEMPLATE - do NOT remove the <!-- ... --> markers or the table headers.
     Your weekly grade is read AUTOMATICALLY from this file:
       13-week/hu-status/README.md  (inside YOUR fork). English. -->

# Weekly Status - Week 13

<!-- CONFIG-START - must match your profile repo (username/username) CONFIG -->
- FULL_NAME: Alejandro Ortiz Vargas
- GITHUB_USER: alejandro538
- TEAM: Elkin Stiven Contreras Rojas - Alejandro Ortiz Vargas
- SPRINT_GOAL: Assess the Stripe test-mode payment webhook trust boundary, document STRIDE risks, create a security backlog, and add automated security gates for the Market Agri MVP.
<!-- CONFIG-END -->

## 1. User stories worked this week
| HU ID | Title | Status (todo/doing/done) | Evidence (PR or commit URL) |
|---|---|---|---|
| HU-TXN-001 | Secure the Stripe payment webhook and checkout flow | doing | [CP2 STRIDE PR #85](https://github.com/code-corhuila/market-agri-docs/pull/85); [CP3 issue #93](https://github.com/code-corhuila/market-agri-docs/issues/93), [#94](https://github.com/code-corhuila/market-agri-docs/issues/94), [#95](https://github.com/code-corhuila/market-agri-docs/issues/95); [CP4 PR #15](https://github.com/code-corhuila/sistemas-distribuidos-2026-b-g1/pull/15) |

## 2. My individual contribution
- CP0: Claimed the Stripe test-mode webhook → `api-gateway` → `transactions-service` trust boundary in [issue #84](https://github.com/code-corhuila/market-agri-docs/issues/84) and recorded the workshop setup in [`13-week/workshop/README.md`](../workshop/README.md).
- CP1: Created the [attack-surface map](../workshop/01-attack-surface.md), including system boundaries, assets, and entry points.
- CP2: Submitted the STRIDE analysis for the webhook boundary in [PR #85](https://github.com/code-corhuila/market-agri-docs/pull/85).
- CP3: Opened three security backlog issues ([#93](https://github.com/code-corhuila/market-agri-docs/issues/93), [#94](https://github.com/code-corhuila/market-agri-docs/issues/94), [#95](https://github.com/code-corhuila/market-agri-docs/issues/95)).
- CP4: Added Gitleaks, Maven/npm dependency audits, and a negative authorization regression test in [course PR #15](https://github.com/code-corhuila/sistemas-distribuidos-2026-b-g1/pull/15). The test passed locally (1 test, 0 failures); the GitHub PR currently reports zero checks/no jobs.

## 3. Blockers and risks
- GitHub Actions has not produced job results for PR #15 yet. The PR check screen shows zero checks and “Workflow runs completed with no jobs”; maintainer confirmation or approval may be needed. No Actions run URL is available yet.

## 4. Plan for next week
- Complete the peer review and submit the delivery 1 links in Moodle. Resolve the pending Actions run with a maintainer, then continue CP6–CP9 according to the take-home guide.

## 5. Compliance self-check
- [ ] Conventional Commits - `type(scope): summary`
- [ ] Per-environment HU branch + PR to that environment (hu-xxx-dev -> develop, ...)
- [ ] Testable acceptance criteria
- [x] Tests added/updated (unit / integration): CP4 negative authorization test passed locally.
- [ ] DDD / hexagonal boundaries respected (domain has no I/O)
- [x] No secrets; config via environment variables: the test uses a non-production test-only JWT secret.

## 6. Evidence links
- [CP0 boundary issue #84](https://github.com/code-corhuila/market-agri-docs/issues/84)
- [CP1 attack-surface map](../workshop/01-attack-surface.md)
- [CP2 STRIDE PR #85](https://github.com/code-corhuila/market-agri-docs/pull/85)
- [CP3 issue #93](https://github.com/code-corhuila/market-agri-docs/issues/93)
- [CP3 issue #94](https://github.com/code-corhuila/market-agri-docs/issues/94)
- [CP3 issue #95](https://github.com/code-corhuila/market-agri-docs/issues/95)
- [CP4 course PR #15](https://github.com/code-corhuila/sistemas-distribuidos-2026-b-g1/pull/15)
- [Reflection document](https://docs.google.com/document/d/1DFyU1cRLSM8GBEeO7Rh6ucPJMlnz_e7DBJ1rSIq-xXk/edit?hl=es&tab=t.0)
