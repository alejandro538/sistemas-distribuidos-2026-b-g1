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
| HU-TXN-001 | Secure the Stripe payment webhook and checkout flow | doing | [CP2 STRIDE PR #85](https://github.com/code-corhuila/market-agri-docs/pull/85); [CP3 issues #93](https://github.com/code-corhuila/market-agri-docs/issues/93), [#94](https://github.com/code-corhuila/market-agri-docs/issues/94), [#95](https://github.com/code-corhuila/market-agri-docs/issues/95); [CP4 PR #15](https://github.com/code-corhuila/sistemas-distribuidos-2026-b-g1/pull/15) |

## 2. My individual contribution
- CP0: Claimed the Stripe test-mode webhook -> `api-gateway` -> `transactions-service` trust boundary in [issue #84](https://github.com/code-corhuila/market-agri-docs/issues/84) and recorded the workshop setup in [`13-week/workshop/README.md`](../workshop/README.md).
- CP1: Created the [attack-surface map](../workshop/01-attack-surface.md), including system boundaries, assets, and entry points.
- CP2: Submitted the STRIDE analysis for the webhook boundary in [PR #85](https://github.com/code-corhuila/market-agri-docs/pull/85).
- CP3: Opened three security backlog issues: [#93](https://github.com/code-corhuila/market-agri-docs/issues/93), [#94](https://github.com/code-corhuila/market-agri-docs/issues/94), and [#95](https://github.com/code-corhuila/market-agri-docs/issues/95).
- CP4: Added Gitleaks, Maven/npm dependency audits, and a negative authorization regression test in [course PR #15](https://github.com/code-corhuila/sistemas-distribuidos-2026-b-g1/pull/15). The test passed locally; the GitHub PR has not produced job results.
- CP5: Peer review of a classmate's STRIDE pull request is not recorded yet. The HU status was updated, but that does not replace the required review comment.
- CP6: Refined the STRIDE PR #85 description to reflect the completed six-threat analysis. No reviewer comments were visible in the screenshots checked.
- CP7: Checked issue stories, STRIDE categories, risks, acceptance criteria, and labels. Issues #93 and #94 have `security` and `P0`; issue #95 has `security` and `P1`. Adding all three issues to the team Project remains to be confirmed.
- CP8: Re-ran the negative authorization test successfully (1 test, 0 failures) and parsed the workflow YAML, which contains the three expected jobs.
- CP9: The personal implementation plan in the reflection document and final closure of this HU status are still pending; they must be completed by the student.

## 3. Blockers and risks
- GitHub Actions has not produced job results for PR #15. Its check screen showed zero checks and "Workflow runs completed with no jobs". No Actions run URL is available.
- The GitHub issue Project picker returned "No projects were found" for issues #93, #94, and #95. The team Project name or access is needed before adding them.
- CP5 peer-review evidence, the team's GitHub Project association for the three issues, and the student-written CP9 implementation plan remain unverified or pending.

## 4. Plan for next week
- Confirm the team Project and GitHub Actions status with the course team, complete and record the peer review if still accepted, and finish the student-written CP9 implementation plan if the instructor permits late completion.

## 5. Compliance self-check
- [x] Conventional Commits - `type(scope): summary`
- [x] Security branches and pull requests were used for the STRIDE analysis and CP4 workflow.
- [x] Testable acceptance criteria are recorded in the three security issues.
- [x] Tests added/updated (unit / integration): CP4 negative authorization test passed locally and was rerun for CP8.
- [x] DDD / hexagonal boundaries respected: no production domain code was changed for this workshop test.
- [x] No secrets; the test uses a non-production, test-only JWT secret.

## 6. Evidence links
- [CP0 boundary issue #84](https://github.com/code-corhuila/market-agri-docs/issues/84)
- [CP1 attack-surface map](../workshop/01-attack-surface.md)
- [CP2 STRIDE PR #85](https://github.com/code-corhuila/market-agri-docs/pull/85)
- [CP3 issue #93](https://github.com/code-corhuila/market-agri-docs/issues/93)
- [CP3 issue #94](https://github.com/code-corhuila/market-agri-docs/issues/94)
- [CP3 issue #95](https://github.com/code-corhuila/market-agri-docs/issues/95)
- [CP4 course PR #15](https://github.com/code-corhuila/sistemas-distribuidos-2026-b-g1/pull/15)
- [CP8 verification commit](https://github.com/alejandro538/sistemas-distribuidos-2026-b-g1/commit/7f4917c)
- [Reflection document](https://docs.google.com/document/d/1DFyU1cRLSM8GBEeO7Rh6ucPJMlnz_e7DBJ1rSIq-xXk/edit?hl=es&tab=t.0)
