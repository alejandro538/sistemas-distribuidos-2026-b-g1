<!-- CONFIG-START - must match your profile repo (username/username) CONFIG -->
- FULL_NAME: Alejandro Ortiz Vargas
- GITHUB_USER: alejandro538
- TEAM: Elkin Stiven Contreras Rojas - Alejandro Ortiz Vargas
- DOCS_REPO: https://github.com/code-corhuila/market-agri-docs
- TRUST_BOUNDARY: Stripe test-mode webhook -> api-gateway -> transactions-service
- BOUNDARY_ISSUE: https://github.com/code-corhuila/market-agri-docs/issues/84
- REFLECTION_DOC: TODO - add your Google Docs reflection URL
<!-- CONFIG-END -->

# Week 13 Threat Modeling Workshop

Individual workshop artifacts for threat modeling and the security backlog of Market Agri.

## Checkpoints

- CP0: claim the selected trust boundary in the team docs repository issue tracker.
- CP1: [Attack surface map](./01-attack-surface.md).
- CP2: STRIDE model in a separate branch and pull request in the team docs repository.
- CP3: three security issues in the team project board, linked to the STRIDE pull request.
- CP4: security workflow and negative authorization test.
- CP5: peer review and weekly status update.

## Selected trust boundary

The selected boundary is the third-party Stripe test-mode payment webhook entering through
`api-gateway` and reaching `transactions-service`. Confirm that no other team member has claimed
this same boundary, then replace `BOUNDARY_ISSUE` above with the issue URL.

## Project references

- `05-architecture/security-threat-model.md`
- `05-architecture/overview.md`
- `07-api/api-contract.md` (E-43)
- `09-microservices/services/04-transactions-service/README.md`
- `00-governance/security-rules.md`
