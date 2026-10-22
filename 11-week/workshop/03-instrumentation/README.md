# CP3 - Reference instrumentation example

This small Java example is based on the transaction confirmation flow in the modular-monolith MVP included in `market-agri-docs-main.zip`. It demonstrates Micrometer instrumentation and a unit test. It is a workshop artifact; it is **not integrated into or running in the private application repository**.

## What the example measures

- A counter for transaction confirmation outcomes.
- A timer for the time spent processing a confirmation.
- A fixed `outcome` tag with only `confirmed`, `already_confirmed`, or `session_not_found` values.

It deliberately does not attach `transaction_id`, `buyer_id`, `trace_id`, or other request-specific values as metric tags. Those values belong in logs or traces because they would create high metric cardinality.

## Dependencies needed when integrating

The MVP backend uses Spring Boot and JUnit 5. To compile this example in that backend, add `spring-boot-starter-actuator` to its `pom.xml`; its test starter supplies JUnit. The private application repository was not available, so its POM and `TransactionService` were not changed here.

When the source repository is available, create the metrics bean and call `record` from `TransactionService.confirm`: use `SESSION_NOT_FOUND` before returning for an unknown session, `ALREADY_CONFIRMED` when the domain object is already confirmed, and `CONFIRMED` after the confirmation work succeeds. Measure elapsed time with a monotonic clock such as `System.nanoTime()` and convert it to `Duration`. Keep each metric update within the existing confirmation transaction outcome.

The test uses `SimpleMeterRegistry` to verify the counter, timer, and rejection of a negative duration. It is a unit test for the instrumentation class, not an integration test of the private application.
