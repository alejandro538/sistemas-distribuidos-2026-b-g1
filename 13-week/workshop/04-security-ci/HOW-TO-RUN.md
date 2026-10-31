# CP4 - How to run

## Prerequisites

- Java 21 or newer, PowerShell, and Maven (or a Maven wrapper).
- A local clone of `market-agri-docs` containing the MVP backend path below.

## Run the negative authorization regression test

From the course-fork root, run:

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -File .\13-week\workshop\04-security-ci\Prepare-AuthzTestCopy.ps1 -BackendPath "C:\clone\market-agri-docs\12-ux-ui\MVP\marketplace-agricultural-huila-monolith\backend" -MavenCommandPath "C:\path\to\mvn.cmd"
```

The helper copies the backend into a temporary directory, overlays the maintained test from this workshop, and adds `spring-boot-starter-webmvc-test` to that temporary copy's test dependencies. It leaves the original `market-agri-docs` checkout unchanged. The Maven test invocation uses a cache in the system temporary directory:

```text
mvn -B -Dmaven.repo.local="<temporary-directory>/market-agri-cp4-m2/repository" -Dtest=BuyerCannotListProducerProductsTest test
```

If Maven is installed and on `PATH`, omit `-MavenCommandPath`. Otherwise, pass the path to an available Maven launcher with that parameter.

The test signs a valid BUYER JWT with the application's `JwtEncoder`, sends it through the real `SecurityConfig` filter chain to `GET /api/catalog/products/mine`, expects HTTP 403, and verifies that `ProductService` is not called.

## Observed result

Observed local result: **PASS** (exit code 0). Maven reported `Tests run: 1, Failures: 0, Errors: 0, Skipped: 0` and `BUILD SUCCESS`. The test sent a valid BUYER JWT through the application's MVC and Spring Security configuration, received HTTP 403 for the producer-only endpoint, and verified no `ProductService` interaction. It ran against a disposable copy; the source backend was not modified.

## CP8 verification (2026-10-30)

- Re-ran the negative authorization test using the command above. Observed result: **PASS**, `Tests run: 1, Failures: 0, Errors: 0, Skipped: 0`; Maven reported `BUILD SUCCESS` (exit code 0).
- Parsed `.github/workflows/w13-security.yml` with SnakeYAML 2.6. YAML syntax was accepted, and the parser found the three expected jobs: `secret-scan`, `dependency-audit`, and `authorization-regression`.
- GitHub PR #15 still displayed zero checks and “Workflow runs completed with no jobs” at the time of this verification. This local YAML parse and test do not claim that GitHub Actions ran.
