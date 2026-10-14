<!-- HU-STATUS TEMPLATE - do NOT remove the <!-- ... --> markers or the table headers.
     Your weekly grade is read AUTOMATICALLY from this file:
       10-week/hu-status/README.md  (inside YOUR fork). English. -->

# Weekly Status - Week 10

<!-- CONFIG-START - must match your profile repo (username/username) CONFIG -->
- FULL_NAME: Alejandro Ortiz Vargas
- GITHUB_USER: alejandro538
- TEAM: Elkin Stiven Contreras Rojas, Alejandro Ortiz Vargas
- SPRINT_GOAL: Record the data and event decisions (ADR-010 to ADR-014), realign 06-data with them, build the first real service at the data layer (catalog-db, PostgreSQL instance in infra, catalog-api) and fix the build rules (design system and test levels per branch).
<!-- CONFIG-END -->

## 1. User stories worked this week
| HU ID | Title | Status (todo/doing/done) | Evidence (PR or commit URL) |
|---|---|---|---|
| HU-PLAT-004 | Extract catalog-service (build catalog-db + catalog-api) | doing | catalog-db#3, catalog-db#4, catalog-api#1, catalog-api#2, infra#3 |
| HU-CAT-004 | Mark a product out of stock / back in stock | doing | market-agri-docs#26 |
| HU-TXN-001 | Pay for a product on the platform | doing | market-agri-docs#25, market-agri-docs#31 |
| HU-PLAT-008 | Web shell with remote portals | doing | market-agri-docs#28, market-agri-docs#32 |

## 2. My individual contribution
- Data and event ADRs in `market-agri-docs`:
  - **ADR-010 Data isolation** (PR #15): one instance per engine, one schema per domain, `<x>_app` login user with `search_path` fixed to its schema, `<x>_reader` / `<x>_writer` roles with privileges only on their schema, no foreign keys and no reads across domains.
  - **ADR-011 Migrations** (PR #15): Liquibase in every `-db` with Annex A layout (`01_ddl` ... `04_tcl` + `05_rollbacks`), every changeset with its rollback, one control table per domain, runner `<x>-db-migrate` launched from `infra`, never on API start-up.
  - **ADR-012 Money**, **ADR-013 Transversal state** (own workflow / worker schemas), **ADR-014 Event delivery** (PR #19): transactional outbox, relay with publisher confirms, idempotent consumers (`processed_event`), bounded retry with full jitter and DLQ.
- Governance: git conventions v2 - version scheme v2.x.x, review and merge rules (PR #20); a branch may not carry changes of another sub-task (PR #27).
- `06-data` realigned with the ADRs (PRs #22, #23, #24, #25): migration strategy rewritten for Liquibase in each `-db`, modeling conventions aligned with Annex A, catalog modelled as implemented, transactions / workflow / worker models with the outbox and the idempotency table.
- Domain alignment: product status derived from quantity and logical deletion aligned (PR #26); checkout routed through the workflow saga (PR #31); interface sub-tasks HU-PLAT-008 to 010 added (PR #32).
- Build rules: design system validated in the monolith recorded in `12-ux-ui` (PR #28) and test levels required on each branch in `11-quality` (PR #29), plus their review follow-ups (PR #30).
- `market-agri-catalog-db` (branches `chore/` and `feat/HU-PLAT-004-...`): catalog schema with rollback, Liquibase master changelog, `catalog_reader` / `catalog_writer` roles (writer without DELETE, logical deletion), tables `product`, `stock_reservation` and `idempotency_key` with CHECK constraints, foreign keys and indexes, data dictionary,
