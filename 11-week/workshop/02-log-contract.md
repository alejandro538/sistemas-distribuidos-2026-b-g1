# CP2 - Structured Log Contract

## Scope

This contract covers the buyer checkout journey in `01-journey.md`. Each handled request and consumed event emits one-line JSON to standard output. The examples below are illustrative; they are not captured runtime output.

## Common fields

| Field | Type | Requirement | Example | Purpose |
| --- | --- | --- | --- | --- |
| `timestamp` | string | Required; ISO-8601 UTC with milliseconds | `2026-10-21T19:10:00.010Z` | Orders events across components. |
| `level` | string | Required: `ERROR`, `WARN`, `INFO`, or `DEBUG` | `WARN` | Supports severity filtering. |
| `service` | string | Required | `workflow` | Identifies the emitting component. |
| `version` | string | Required | `1.0.0` | Identifies the deployed build; use the actual release value. |
| `environment` | string | Required | `dev` | Separates development, QA, and production data. |
| `trace_id` | string | Required; 32 lowercase hexadecimal characters | `4bf92f3577b34da6a3ce929d0e0e4736` | Connects spans in the distributed trace. |
| `span_id` | string | Required; 16 lowercase hexadecimal characters | `00f067aa0ba902b7` | Identifies this operation within the trace. |
| `correlation_id` | string | Required | `c0a80101-0000-4000-8000-000000000001` | Follows the request using `X-Correlation-Id` and event metadata. |
| `event` | string | Required; stable, lowercase dotted name | `checkout.rejected` | Names the operation or outcome for queries. |
| `message` | string | Required; safe, concise description | `Checkout rejected by purchase-method rule` | Gives a human-readable summary without sensitive values. |
| `duration_ms` | integer | Required; non-negative | `45` | Measures the operation time in milliseconds. |

## Checkout domain fields

Include only fields relevant to the event. Do not put unbounded values such as raw URLs, user names, or message text in logs.

| Field | Type | Requirement | Example | Why it is useful |
| --- | --- | --- | --- | --- |
| `saga_id` | UUID string | Optional until the workflow creates a saga | `6c3a5d40-7260-4a11-9d2d-86bb5ab81234` | Connects the checkout to `workflow.saga_instance`. |
| `conversation_id` | UUID string | Optional when a conversation is involved | `290c0f60-5be1-4e26-a32c-b992cf47a001` | Identifies the source conversation without logging its contents. |
| `product_id` | UUID string | Optional when a product is involved | `4a6fb72e-a32d-481b-a6d7-7de1fb91f201` | Identifies the catalog item involved in a reservation. |
| `transaction_id` | UUID string | Optional after the workflow creates a transaction | `8d34b254-38a2-401f-8f5c-0b1d020823c1` | Links the payment, reservation, ledger, and event. |
| `saga_step` | string | Optional | `read_conversation` | Shows which checkout step is running or failed. |
| `purchase_method` | enum string | Optional | `OFF_PLATFORM` | Explains a business-rule outcome without exposing chat text. |
| `error_code` | string | Optional on a rejected or failed operation | `PURCHASE_METHOD_NOT_PLATFORM` | Groups stable domain failures for investigation. |
| `downstream_service` | string | Optional on dependency calls | `chat-service` | Identifies which dependency timed out. |
| `retry_attempt` | integer | Optional when a retry is made | `1` | Distinguishes a transient failure from a final failure. |
| `http_status` | integer | Optional on HTTP request completion | `409` | Shows the client-visible result. |

## Data that must not be logged

| Never log | Safe handling |
| --- | --- |
| Passwords, JWTs, service credentials, Stripe API keys, or `Stripe-Signature` | Omit entirely; do not partially mask or log request headers. |
| Card numbers, CVV, bank account details, checkout URLs, or raw payment payloads | Omit entirely; log a safe status, event type, and internal `transaction_id` if needed. |
| Buyer/producer names, email addresses, phone numbers, or identity documents | Omit; use an internal UUID and role only when necessary. |
| Raw chat messages or conversation text | Omit; use `conversation_id`, an event name, and a message count if needed. |
| Raw request/response bodies or unfiltered exception text | Log an allow-listed error code and safe summary; keep sensitive diagnostic detail out of application logs. |

## Seven example log lines

These examples describe one Trace A. They assume the checkout flow makes one bounded retry after a transient I-05 timeout; the retry succeeds, then the conversation's `OFF_PLATFORM` agreement causes the business-rule rejection. The retry is an example policy, not a claim that the current implementation already retries. All seven lines share the same `trace_id` and `correlation_id`; each span has its own `span_id`.

```json
{"timestamp":"2026-10-21T19:10:00.010Z","level":"INFO","service":"api-gateway","version":"1.0.0","environment":"dev","trace_id":"4bf92f3577b34da6a3ce929d0e0e4736","span_id":"00f067aa0ba902b7","correlation_id":"c0a80101-0000-4000-8000-000000000001","event":"http.request.received","message":"Checkout request received","duration_ms":0,"http_method":"POST","route":"/api/v1/workflow/checkouts"}
{"timestamp":"2026-10-21T19:10:00.020Z","level":"INFO","service":"workflow","version":"1.0.0","environment":"dev","trace_id":"4bf92f3577b34da6a3ce929d0e0e4736","span_id":"b7ad6b7169203331","correlation_id":"c0a80101-0000-4000-8000-000000000001","event":"checkout.started","message":"Checkout saga started","duration_ms":0,"saga_id":"6c3a5d40-7260-4a11-9d2d-86bb5ab81234","conversation_id":"290c0f60-5be1-4e26-a32c-b992cf47a001","saga_step":"read_conversation"}
{"timestamp":"2026-10-21T19:10:00.025Z","level":"INFO","service":"workflow","version":"1.0.0","environment":"dev","trace_id":"4bf92f3577b34da6a3ce929d0e0e4736","span_id":"a6d3c7e9f1b20485","correlation_id":"c0a80101-0000-4000-8000-000000000001","event":"dependency.request","message":"Reading checkout conversation","duration_ms":0,"saga_id":"6c3a5d40-7260-4a11-9d2d-86bb5ab81234","conversation_id":"290c0f60-5be1-4e26-a32c-b992cf47a001","saga_step":"read_conversation","downstream_service":"chat-service","retry_attempt":1}
{"timestamp":"2026-10-21T19:10:03.025Z","level":"WARN","service":"workflow","version":"1.0.0","environment":"dev","trace_id":"4bf92f3577b34da6a3ce929d0e0e4736","span_id":"a6d3c7e9f1b20485","correlation_id":"c0a80101-0000-4000-8000-000000000001","event":"dependency.timeout","message":"Chat conversation read timed out; retrying once","duration_ms":3000,"saga_id":"6c3a5d40-7260-4a11-9d2d-86bb5ab81234","conversation_id":"290c0f60-5be1-4e26-a32c-b992cf47a001","saga_step":"read_conversation","downstream_service":"chat-service","retry_attempt":1,"error_code":"CHAT_TIMEOUT_RETRY"}
{"timestamp":"2026-10-21T19:10:03.080Z","level":"INFO","service":"workflow","version":"1.0.0","environment":"dev","trace_id":"4bf92f3577b34da6a3ce929d0e0e4736","span_id":"be17dcaf9903472a","correlation_id":"c0a80101-0000-4000-8000-000000000001","event":"dependency.response","message":"Conversation loaded after retry","duration_ms":55,"saga_id":"6c3a5d40-7260-4a11-9d2d-86bb5ab81234","conversation_id":"290c0f60-5be1-4e26-a32c-b992cf47a001","saga_step":"read_conversation","downstream_service":"chat-service","retry_attempt":2,"purchase_method":"OFF_PLATFORM"}
{"timestamp":"2026-10-21T19:10:03.085Z","level":"INFO","service":"workflow","version":"1.0.0","environment":"dev","trace_id":"4bf92f3577b34da6a3ce929d0e0e4736","span_id":"b7ad6b7169203331","correlation_id":"c0a80101-0000-4000-8000-000000000001","event":"checkout.rejected","message":"Checkout rejected by purchase-method rule","duration_ms":3065,"saga_id":"6c3a5d40-7260-4a11-9d2d-86bb5ab81234","conversation_id":"290c0f60-5be1-4e26-a32c-b992cf47a001","saga_step":"validate_purchase_method","purchase_method":"OFF_PLATFORM","error_code":"PURCHASE_METHOD_NOT_PLATFORM","http_status":409}
{"timestamp":"2026-10-21T19:10:03.090Z","level":"INFO","service":"api-gateway","version":"1.0.0","environment":"dev","trace_id":"4bf92f3577b34da6a3ce929d0e0e4736","span_id":"00f067aa0ba902b7","correlation_id":"c0a80101-0000-4000-8000-000000000001","event":"http.request.completed","message":"Checkout request completed","duration_ms":3080,"http_method":"POST","route":"/api/v1/workflow/checkouts","http_status":409,"error_code":"PURCHASE_METHOD_NOT_PLATFORM"}
```

## Log level policy

| Level | Use in this project | Example |
| --- | --- | --- |
| `ERROR` | A technical failure prevents the operation from completing and needs investigation. | I-05 remains unavailable after the allowed retry, Stripe rejects session creation, or a database write fails. |
| `WARN` | A degraded or unusual condition is recoverable, or needs attention but does not stop the whole service. | A chat-service timeout is recovered by the bounded retry shown above. |
| `INFO` | Normal business milestones and expected client-visible outcomes. | Checkout started, payment confirmed, or checkout rejected with `PURCHASE_METHOD_NOT_PLATFORM`. |
| `DEBUG` | Development-only diagnostics with allow-listed fields and no sensitive payloads. | A saga step changes state or an event is routed to its consumer. |

## References

- `01-journey.md` - buyer checkout trace map
- `07-api/api-contract.md` - E-40 and I-05 errors, including `PURCHASE_METHOD_NOT_PLATFORM` and `CHAT_UNAVAILABLE`
- `05-architecture/cross-cutting.md` - structured JSON logs and `X-Correlation-Id` propagation
- `02-domain/domain-events.md` - event envelope `metadata.correlationId`
