# Domain-Driven Design

Practical DDD patterns for solution architects working within project-kit. Use these patterns when domain complexity justifies them -- not every project needs DDD.

---

## Strategic DDD

Strategic DDD is about decomposing a system into well-bounded areas of responsibility before writing any code. Get this wrong and tactical patterns will not save you.

### Bounded Contexts

A bounded context is a boundary within which a specific domain model applies and a single ubiquitous language is spoken.

**How to identify bounded contexts from a Feature Inventory**:
- Group features that share the same core nouns (e.g., "Order", "LineItem", "Fulfillment" belong together)
- Look for language divergence -- when "Account" means something different to billing vs. identity, you have two contexts
- Each context owns its data and its rules; no shared mutable state across contexts
- One ubiquitous language per context -- if the team argues about what a term means, the context boundary is wrong

**Rules**:
- A bounded context should map to one team or one module; never split a context across teams
- Keep contexts coarse-grained early -- split later when you discover real tension, not imagined tension
- Every entity, value object, and service lives inside exactly one bounded context

### Context Mapping

Context mapping documents how bounded contexts relate to each other. Draw this map before designing APIs.

**Relationship Patterns**:

| Pattern | When to Use | Direction |
|---------|-------------|-----------|
| **Shared Kernel** | Two contexts co-own a small shared model (e.g., common types). Use sparingly -- it couples both sides. | Bidirectional |
| **Customer-Supplier** | Upstream context serves downstream context. Downstream can negotiate changes. | Upstream -> Downstream |
| **Conformist** | Downstream adopts upstream's model as-is. No negotiation power. Typical with third-party APIs. | Upstream -> Downstream |
| **Anti-Corruption Layer** | Downstream translates upstream's model into its own domain language. Protects domain purity. | Upstream -> Downstream |
| **Open Host Service** | Upstream provides a well-defined protocol (API) for many consumers. | Upstream -> Many Downstreams |
| **Published Language** | Shared interchange format (JSON schema, Protobuf, Avro). Often paired with Open Host Service. | Shared |

### Mapping to Deployment

- **Modular monolith**: One module per bounded context, internal APIs between modules, shared database with schema-per-context isolation
- **Microservices**: One service (or small cluster) per bounded context, API contracts between services, database per service
- **Hybrid**: Start monolith with module boundaries aligned to contexts; extract to services only when scaling or team autonomy demands it

---

## Tactical DDD

Tactical patterns define the building blocks inside a bounded context. These patterns enforce consistency, encapsulate business rules, and keep domain logic out of infrastructure code.

### Entities

Objects defined by identity, not by attribute values.

- Have a unique identifier (usually UUID) that persists across state changes
- Mutable -- state changes over a lifecycle
- Encapsulate business rules governing their own state transitions
- Equality based on identity, not field values
- Examples: `User`, `Order`, `Invoice`

### Value Objects

Objects defined entirely by their attributes. Two with the same fields are equal.

- Immutable -- create a new instance instead of modifying
- No identity -- equality is structural
- Self-validating -- reject invalid state at construction
- Replace primitive types to encode domain meaning
- Examples: `Money(amount, currency)`, `Address(street, city, zip, country)`, `DateRange(start, end)`

In TYPE-CONTRACTS, value objects appear as embedded types, not as separate entities with their own IDs.

### Aggregates

An aggregate is a cluster of entities and value objects with a consistency boundary. The aggregate root is the single entry point for all mutations.

**Rules**:
- External code references an aggregate only through its root entity
- One transaction per aggregate -- never modify two aggregates in the same transaction
- Keep aggregates small -- prefer one entity plus value objects over deep object graphs
- Reference other aggregates by ID, never by direct object reference
- Validate all invariants inside the aggregate before persisting

**Example**: `Order` aggregate root owns `LineItems[]` (child entities), `ShippingAddress` (value object), and references `CustomerId` and `ProductId` by ID only.

**Aggregate Design Checklist**:
- Can this aggregate be loaded and saved independently? If not, it is too big.
- Does the root enforce all invariants? If external code sets internal state directly, the boundary is broken.
- Are you joining aggregates in queries? Use a read model or projection instead.

### Domain Events

A domain event records something that happened in the domain. Events are facts -- immutable and named in past tense.

**Naming**: Always past tense, always domain language.
- `OrderPlaced`, `PaymentReceived`, `InventoryReserved`, `UserSuspended`

**Structure**:
```typescript
interface DomainEvent {
  eventId: string;        // Unique event identifier
  eventType: string;      // e.g., "OrderPlaced"
  aggregateId: string;    // ID of the aggregate that produced this event
  occurredAt: Date;       // When the event happened
  payload: object;        // Event-specific data
}
```

**Rule**: Publish events after state change within the aggregate, not before. The event is a record of what happened, not a request.

### Repositories

Abstract persistence -- accept and return aggregates, never raw database rows.

- One repository per aggregate root -- never for child entities
- Interface in the domain layer; implementation in infrastructure
- Methods: `findById`, `save`, `delete` -- keep it minimal
- No query language leaking into the domain (use read models for complex queries)

### Domain Services

Stateless operations spanning multiple aggregates that do not belong to any single one.

- Use when business logic spans two aggregates (e.g., transferring money between accounts)
- Use when coordinating with an external service as part of a domain operation
- If the logic belongs on an entity, put it there. Domain services are a last resort, not a dumping ground.

---

## Domain Event Patterns

### Event Naming and Structure

- Use domain language, not technical language: `OrderShipped` not `OrderTableUpdated`
- Past tense: the event already happened
- Include enough data for consumers to act without querying back: aggregate ID + relevant state
- Include a schema version if events cross service boundaries

**Recommended event envelope**:
```json
{
  "eventId": "evt_a1b2c3",
  "eventType": "OrderPlaced",
  "aggregateType": "Order",
  "aggregateId": "ord_x9y8z7",
  "occurredAt": "2026-01-15T10:30:00Z",
  "version": 1,
  "payload": { "customerId": "cust_m4n5o6", "totalAmount": 149.99, "lineItemCount": 3 }
}
```

### Publishing and Consuming

**Publishing**:
- Publish after state change, or collect events and dispatch after save
- Use the "outbox pattern" for reliability: write event to an outbox table in the same transaction, publish asynchronously
- Never publish events the aggregate did not produce

**Consuming**:
- Consumers must be idempotent -- use event ID for deduplication
- Do not assume ordering across different aggregate types
- Within a single aggregate, events are ordered by sequence number

### In-Process vs Distributed

- **In-process** (modular monolith): Use an in-memory event bus. Consumers run in the same process. Simpler, faster, no serialization overhead.
- **Distributed** (microservices): Use a message broker (Kafka, RabbitMQ, SQS). Events are serialized. Handle retries, dead letters, and ordering at the infrastructure level.
- Start in-process. Move to distributed only when you extract a bounded context into a separate service.

---

## Anti-Corruption Layer

### When to Use

- Integrating with a legacy system whose model does not match your domain
- Consuming a third-party API with a different language or structure
- Protecting your bounded context from upstream model changes
- Merging with an acquired system during migration

### How It Works

The ACL sits at the boundary of your bounded context: `External System --> [Adapter + Translator] --> Your Domain Model`

- **Adapter**: Handles the protocol (HTTP client, message consumer, file reader)
- **Translator**: Maps external data structures to your domain entities and value objects
- **Facade** (optional): Simplifies the external API surface for your domain

### Implementation

```typescript
// ACL Translator: external payment API -> your domain model
function toPayment(charge: StripeCharge): Payment {
  return {
    paymentId: charge.id,
    amount: Money.fromCents(charge.amount, charge.currency),
    status: mapStatus(charge.status),  // "succeeded" -> PaymentStatus.COMPLETED
    processedAt: new Date(charge.created * 1000),
  };
}
```

**Practical rules**: Keep the ACL thin -- translate and nothing more. Write thorough tests for translation; external models change without warning. Version adapters when the external API versions. If the external system is replaced, only the ACL changes.

---

## Practical Application

### Identifying Bounded Contexts from a Feature Inventory

1. List all features from `docs/features.md`
2. Group features by the core domain noun they operate on
3. Look for features that share validation rules, state machines, or business invariants -- these belong in the same context
4. Look for features where the same word means different things -- these belong in different contexts
5. Validate: can each context be developed, tested, and deployed by one team or module? If not, re-draw boundaries.

### Mapping DDD to project-kit TYPE-CONTRACTS

- **Aggregate roots** become top-level interfaces in TYPE-CONTRACTS with their own ID fields
- **Value objects** become embedded types (no separate ID) within aggregate interfaces
- **Enums** in the domain map directly to TypeScript enums or union types in contracts
- **Aggregate references by ID** appear as `string` foreign key fields, not nested objects
- **Domain events** get their own section in contracts if they cross bounded context boundaries

### How Aggregates Map to API Endpoints

- Each aggregate root typically maps to a REST resource: `/api/v1/orders`, `/api/v1/users`
- CRUD operations on the aggregate root map to standard HTTP methods
- Operations on child entities go through the root: `POST /api/v1/orders/{id}/line-items`
- Domain commands that do not fit CRUD become custom actions: `POST /api/v1/orders/{id}/cancel`
- Never expose internal aggregate structure directly -- use DTOs in API-CONTRACTS

### When NOT to Use DDD

DDD adds complexity. Skip it when:
- **Simple CRUD**: If the app is mostly forms over data with no business rules, use a simpler architecture
- **Data pipelines / ETL**: The domain is transformation logic, not entity lifecycle management
- **Small projects**: Under 5 features, DDD overhead is not justified
- **Reporting / analytics**: Read-heavy systems benefit from query-oriented patterns, not aggregate boundaries
- **Prototypes / MVPs**: Ship fast, refactor to DDD if the domain proves complex

### DDD and Modular Monolith

The modular monolith is the ideal starting architecture for DDD:
- One module per bounded context
- Each module owns its database schema (separate schema or table prefix)
- Modules communicate via in-process events or explicit internal APIs
- Module boundaries enforce encapsulation -- no reaching into another module's tables
- When a module needs to become a service, extract it along the bounded context boundary

This maps directly to project-kit's approach: define contracts first, implement modules behind those contracts, extract to services only when operationally required.
