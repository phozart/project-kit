# Architecture Style Patterns

Decision tree and patterns for each architecture style. Use this reference after reading Decision 8 (Architecture Style) from PLATFORM-FOUNDATION.md.

---

## Selection Flowchart

```
Start: What is the project's Architecture Style? (Decision 8)
  |
  +-- Traditional Monolith
  |     \-- How should code be organized?
  |           +-- Small team, simple domain --> Folder-by-layer (controller/service/repo)
  |           +-- Growing team, complex domain --> Folder-by-feature
  |           +-- Need clear request flow --> MVC / Layered Architecture
  |
  +-- Modular Monolith
  |     \-- How should modules be defined?
  |           +-- Clear domain boundaries exist --> Bounded contexts (DDD)
  |           +-- Feature-group alignment --> Feature-group modules
  |           \-- How do modules communicate?
  |                 +-- Commands (synchronous) --> Module API / service facade
  |                 +-- Reactions (asynchronous) --> Internal event bus
  |                 +-- Both --> Hybrid (sync for queries, async for side effects)
  |
  +-- Microservices
  |     \-- How should services be scoped?
  |           +-- One service per bounded context
  |           +-- Shared nothing between services
  |           \-- How do services communicate?
  |                 +-- Sync: REST / gRPC through API gateway
  |                 +-- Async: Message broker (events)
  |                 +-- Observability: Distributed tracing + circuit breakers
  |
  +-- Serverless-First
        \-- How should functions be composed?
              +-- Request-driven --> API Gateway + Lambda / Cloud Functions
              +-- Event-driven --> Event sources + function triggers
              +-- Orchestration --> State machines (Step Functions / Durable Functions)
              +-- Long-running --> Queue + worker pattern
```

---

## Traditional Monolith

### Layered Architecture
- **Presentation layer** -- controllers, routes, view models
- **Business logic layer** -- services, use cases, domain rules
- **Data access layer** -- repositories, ORM models, queries
- **Cross-cutting** -- middleware, logging, auth, error handling

### MVC Pattern
- Model: domain entities and data access
- View: templates or API serializers
- Controller: request handling, input validation, orchestration

### Code Organization

**Folder-by-layer** (simpler, suits small codebases):
```
src/
  controllers/
  services/
  repositories/
  models/
```

**Folder-by-feature** (preferred for growing codebases):
```
src/
  users/
    user.controller
    user.service
    user.repository
    user.model
  orders/
    order.controller
    order.service
    order.repository
    order.model
```

---

## Modular Monolith

A single deployable with strict internal module boundaries. Each module behaves like a mini-application.

### Module Boundary Rules
- Module boundaries align with **bounded contexts** from domain analysis
- Each module owns its **domain logic**, **data schema**, and **internal API**
- No module directly accesses another module's database tables or internal classes
- Cross-module data access goes through the module's public API (service facade)

### Internal APIs (Service Facades)
- Each module exposes a defined interface (e.g., `OrderModule.getOrderById()`)
- Consumers depend on the interface, not the implementation
- Enables future extraction to a separate service if needed

### Domain Event Bus
- Modules publish events when state changes occur (e.g., `OrderPlaced`, `UserRegistered`)
- Other modules subscribe to events they care about
- Events are internal (in-process) -- not distributed messaging
- Keeps modules decoupled for reactive behavior (notifications, projections, side effects)

### Data Isolation
- **Schema-per-module**: each module owns a database schema (preferred)
- **Table-prefix-per-module**: each module prefixes its tables (simpler alternative)
- **Shared read models**: allowed through read-only views or CQRS projections, never direct table access

### References
- See `modular-monolith-patterns.md` for detailed implementation patterns
- See `domain-driven-design.md` for bounded context identification

---

## Microservices

### Service Boundaries
- One service per bounded context
- Each service owns its data store (database-per-service)
- Services communicate through well-defined APIs -- never shared databases

### API Gateway
- Single entry point for external clients
- Routes requests to appropriate services
- Handles cross-cutting concerns: auth, rate limiting, request logging

### Service Mesh
- Handles service-to-service communication
- Provides: load balancing, retries, circuit breaking, mTLS
- Examples: Istio, Linkerd, Consul Connect

### Inter-Service Communication
- **Synchronous**: REST or gRPC for request/response patterns
- **Asynchronous**: Message broker (RabbitMQ, Kafka, SQS) for event-driven patterns
- **Saga pattern**: for distributed transactions across services

### Distributed Tracing
- Correlation IDs propagated across all service calls
- Trace collection (OpenTelemetry, Jaeger, Zipkin)
- Circuit breakers to prevent cascade failures (Hystrix pattern)

---

## Serverless-First

### Event-Driven Architecture
- Functions triggered by events (HTTP, queue messages, file uploads, schedules)
- Each function does one thing and returns
- Stateless execution -- state lives in external stores

### Function Composition
- **Sequential**: function A calls function B (avoid deep chains)
- **Fan-out/fan-in**: one event triggers multiple functions in parallel
- **Orchestrated**: state machine coordinates multi-step workflows

### State Machines
- AWS Step Functions, Azure Durable Functions, GCP Workflows
- Define workflow as states and transitions
- Handle retries, error paths, parallel branches, timeouts
- Preferred over chaining functions directly

### Cold Start Mitigation
- Keep functions small and focused
- Use provisioned concurrency for latency-sensitive paths
- Choose lightweight runtimes (Node.js, Python over Java/C#)

### Data Patterns
- DynamoDB / Cosmos DB for low-latency key-value access
- S3 / Blob Storage for large objects
- Event sourcing for audit trails and replay capability
