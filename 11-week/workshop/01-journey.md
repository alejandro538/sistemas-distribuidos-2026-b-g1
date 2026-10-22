# CP1 - Critical Journey and Trace Map

## Journey: Buyer platform checkout (HU-TXN-001)

A buyer starts an on-platform purchase from an agreed conversation. The checkout workflow reads the conversation, reserves the product, creates a Stripe Checkout session, and waits for the signed payment webhook. After payment confirmation, the transaction service writes the ledger and outbox event; the worker notifies the buyer and producer, and the workflow completes the saga.

This map follows the **documented target microservice architecture** in the team documentation. The ZIP also contains an earlier modular-monolith MVP; its in-process calls are not represented here as deployed HTTP microservices.

The team architecture currently specifies `X-Correlation-Id` on internal HTTP calls and `metadata.correlationId` in domain-event envelopes. This map adds W3C `traceparent` as the distributed trace context. The Stripe webhook starts a new trace because it is a separate inbound request. `transactionId` links that payment-confirmation trace to the checkout; each trace keeps its own `correlationId`. The webhook trace context is carried through the outbox event to its RabbitMQ consumers.

## Hop table

| Step | Caller | Receiver | Protocol | Operation | Sync/Async | Data touched |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `market-agri-front` | `api-gateway` | HTTPS / REST | `POST /api/v1/workflow/checkouts` (E-40) | Sync | None |
| 2 | `api-gateway` | `workflow` | HTTP / REST | Forward E-40 checkout request | Sync | `workflow.saga_instance`, `workflow.saga_step` |
| 3 | `workflow` | `chat-service` | HTTP / REST | `GET /internal/v1/chat/conversations/{id}` (I-05) | Sync | MongoDB `chat.conversations` (read) |
| 4 | `workflow` | `catalog-service` | HTTP / REST | `POST /internal/v1/catalog/products/{id}/reservations` (I-03) | Sync | `catalog.product` (read), `catalog.stock_reservation` (write) |
| 5 | `workflow` | `transactions-service` | HTTP / REST | `POST /internal/v1/transactions` (I-06) | Sync | `transactions.payment_transaction`, `transactions.idempotency_key` |
| 6 | `transactions-service` | Stripe Checkout | HTTPS / REST | Create Checkout session | Sync | None |
| 7 | Stripe | `api-gateway` -> `transactions-service` | HTTPS / REST | `POST /api/v1/transactions/webhooks/payment-gateway` (E-43) | Async callback; new request and trace | `transactions.payment_transaction`, `transactions.ledger_entry`, `transactions.outbox_event` |
| 8 | Transactions outbox relay | RabbitMQ | AMQP | Publish `TransactionConfirmed` to `transactions.transaction-confirmed` | Async | `transactions.outbox_event`, event queue |
| 9 | RabbitMQ | `worker` | AMQP | Consume `TransactionConfirmed`; send notifications to buyer and producer | Async | `worker.processed_event` |
| 10 | RabbitMQ | `workflow` | AMQP | Consume `TransactionConfirmed`; complete checkout saga | Async | `workflow.processed_event`, `workflow.saga_instance` |

## Sequence diagram

```mermaid
sequenceDiagram
    actor Buyer
    participant Front as market-agri-front
    participant GW as api-gateway
    participant WF as workflow
    participant Chat as chat-service
    participant Cat as catalog-service
    participant Tx as transactions-service
    participant Stripe
    participant Outbox as transactions outbox relay
    participant MQ as RabbitMQ
    participant Worker as worker

    Buyer->>Front: Start checkout
    Front->>GW: E-40 request (gateway starts Trace A and X-Correlation-Id)
    GW->>WF: Forward E-40 (propagate Trace A context)
    WF->>Chat: I-05 GET conversation (propagate Trace A context)
    Chat-->>WF: Conversation response (same request trace)
    WF->>Cat: I-03 POST reservation (propagate Trace A context)
    Cat-->>WF: Reservation response (same request trace)
    WF->>Tx: I-06 POST transaction (propagate Trace A context)
    Tx->>Stripe: Create Checkout session (client span in Trace A)
    Stripe-->>Tx: Session ID and URL (Trace A continues locally)
    Tx-->>WF: Pending transaction and checkout URL (Trace A)
    WF-->>GW: E-40 response (Trace A)
    GW-->>Front: Checkout URL (Trace A)
    Front-->>Buyer: Redirect to Stripe Checkout

    Stripe-)GW: E-43 signed webhook (new inbound Trace B)
    GW-)Tx: Forward webhook (propagate Trace B and new X-Correlation-Id)
    Tx->>Tx: Verify signature; confirm payment; write ledger and outbox (Trace B)
    Tx-)Outbox: Relay committed event with saved Trace B context
    Outbox-)MQ: Publish TransactionConfirmed (Trace B traceparent and correlationId)
    MQ-)Worker: Consume event (continue Trace B)
    Worker->>Worker: Notify buyer and producer (Trace B)
    MQ-)WF: Consume event (continue Trace B)
    WF->>WF: Complete saga (Trace B)
```

## Span tree

**Trace A - checkout request** (`trace_id` begins at the gateway and is propagated through synchronous HTTP calls):

- `POST /api/v1/workflow/checkouts` - `api-gateway` (root/server span)
  - `POST /api/v1/workflow/checkouts` - `workflow` (server span)
    - `checkout.saga.start` - `workflow` (internal span; persist saga instance and step)
      - `GET /internal/v1/chat/conversations/{id}` - workflow client span -> chat server span
      - `POST /internal/v1/catalog/products/{id}/reservations` - workflow client span -> catalog server span
        - `catalog.stock_reservation` - catalog database span
      - `POST /internal/v1/transactions` - workflow client span -> transactions server span
        - `stripe.checkout.session.create` - transactions client span

**Trace B - Stripe payment webhook** (a new `trace_id`; linked to Trace A by `transactionId`):

- `POST /api/v1/transactions/webhooks/payment-gateway` - `api-gateway` (root/server span)
  - `payment.webhook.verify_and_confirm` - `transactions-service` (verify signature; update transaction; write ledger and outbox)
    - `transactions.outbox.publish TransactionConfirmed` - outbox producer span; inject `traceparent` into AMQP headers **(async boundary)**
      - `TransactionConfirmed consume` - `worker` consumer span (**same `trace_id` as producer**)
        - `notification.send buyer` - `worker`
        - `notification.send producer` - `worker`
      - `TransactionConfirmed consume` - `workflow` consumer span (**same `trace_id` as producer**)
        - `checkout.saga.complete` - `workflow`

## References

- `04-requirements/user-stories.md` - HU-TXN-001
- `07-api/api-contract.md` - E-40, I-03, I-05, I-06, E-43, and the event contract in section 6
- `02-domain/domain-events.md` - `TransactionConfirmed`
- `05-architecture/cross-cutting.md` - request correlation and event metadata
- `09-microservices/service-catalog.md` - target service topology
