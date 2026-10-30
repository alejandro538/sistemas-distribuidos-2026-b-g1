# CP4 - Security CI

The GitHub Actions workflow runs on pull requests and has three gates: Gitleaks, dependency audits for the Maven backend and npm frontend, and a negative authorization regression test.

GitHub only discovers workflows in `.github/workflows/`. The operational workflow is [`.github/workflows/w13-security.yml`](../../../.github/workflows/w13-security.yml); [`security.yml`](./security.yml) is the workshop copy.

## Workflow run evidence

- Actions run URL: TODO - add the URL after a run completes.

## Project scope

The test is kept in this course fork and overlaid into an isolated temporary copy of the available Market Agri MVP backend. No files in `market-agri-docs` are changed or committed.
