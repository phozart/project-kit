# Modular Monolith Patterns

Patterns for designing, implementing, and evolving modular monolith architectures.

## What Is a Modular Monolith

**Description**: A single deployable application with strict internal module boundaries, combining monolithic deployment simplicity with service-oriented organizational clarity.

**How It Differs**:

| Aspect | Traditional Monolith | Modular Monolith | Microservices |
|--------|---------------------|-------------------|---------------|
| Deployment | Single unit | Single unit | Many units |
| Internal boundaries | None / weak | Strict, enforced | Network boundary |
| Data access | Any code reads any table | Module owns its data | Service owns its data |
| Communication | Anything goes | Module public API only | Network calls |
| Operational cost | Low | Low | High |

**Key Principle**: Deploy as one thing, develop as if modules could become separate services. The module boundary is discipline enforced in code, not by a network.

**Deployment Model**:
- Single artifact (JAR, binary, container image), one process at runtime
- Modules share the same memory space
- Scale vertically or by running multiple identical instances

**When to Choose**:
- Team of 3-20 developers
- Domain complexity warrants boundaries but not distributed systems overhead
- You want a migration path toward microservices without the operational cost upfront
- Deployment simplicity matters more than independent component scaling

## Module Boundary Definition

**Rule**: Align modules with bounded contexts from DDD. Each module represents a distinct business capability.

**What a Module Owns**: its domain models, its data (tables/schemas), its public API (the only way in), its internal implementation (hidden from others).

**Boundary Rules**:
1. No module reaches into another module's internals
2. All cross-module interaction goes through the public module API
3. No module directly queries another module's database tables
4. Shared kernel (truly shared types) is minimal and explicitly managed

**Good Boundaries** -- follow business capabilities:
```
modules/
  ordering/        # Order lifecycle, cart, checkout
  inventory/       # Stock levels, warehouse operations
  billing/         # Invoices, payments, refunds
  identity/        # Users, authentication, roles
  notifications/   # Email, SMS, push notifications
```

**Bad Boundaries** -- follow technical layers:
```
modules/
  controllers/     # All HTTP handlers mixed together
  services/        # All business logic mixed together
  repositories/    # All data access mixed together
```

**Module Structure** (per module):
```
modules/ordering/
  api/             # Public interfaces and DTOs exposed to other modules
  internal/        # Domain logic, repositories, helpers (private)
  events/          # Domain events this module publishes
  tests/           # Module-scoped tests
```

**Boundary Enforcement**:
- Language-level: package visibility (Java), internal packages (Go), barrel exports (TypeScript)
- Build-level: separate modules as build targets, configure dependency rules
- Architecture tests: ArchUnit (Java), Dependency Cruiser (JS/TS), or custom lint rules

## Internal Module API Contracts

**Principle**: Each module exposes a public interface (facade or port). Everything behind it is private.

**Contract Example -- TypeScript**:
```typescript
// modules/ordering/api/ordering.module.ts (PUBLIC)
export interface OrderingModule {
  createOrder(input: CreateOrderInput): Promise<OrderResult>;
  getOrder(orderId: string): Promise<OrderView | null>;
  cancelOrder(orderId: string, reason: string): Promise<void>;
}

export interface CreateOrderInput {
  customerId: string;
  items: Array<{ productId: string; quantity: number }>;
  shippingAddress: Address;
}
```

**Contract Example -- Java**:
```java
public interface OrderingModule {
    OrderResult createOrder(CreateOrderCommand command);
    Optional<OrderView> getOrder(String orderId);
    void cancelOrder(String orderId, String reason);
}
```

**Implementation Is Private**:
```
modules/ordering/
  api/OrderingModule.ts          # PUBLIC - other modules import this
  internal/OrderingModuleImpl.ts # PRIVATE - implements OrderingModule
  internal/OrderRepository.ts    # PRIVATE - data access
  internal/OrderValidator.ts     # PRIVATE - business rules
```

**Rules for Module APIs**:
- Return DTOs or value objects, never internal domain entities
- Keep the surface area small -- expose business operations, not CRUD
- Avoid leaking implementation details (no ORM entities, no internal IDs)

**Versioning Internal APIs**:
- For in-process modules, versioning is usually unnecessary -- refactor across modules in one commit
- If separate teams own modules, version the interface and deprecate before removal
- Use compiler errors as your migration tool: change the interface, fix all callers

## Data Isolation Strategies

### Schema-Per-Module (Recommended)

Each module owns a dedicated database schema within a shared database instance.

```sql
CREATE SCHEMA ordering;
CREATE TABLE ordering.orders (id UUID PRIMARY KEY, ...);
CREATE TABLE ordering.order_items (id UUID PRIMARY KEY, ...);

CREATE SCHEMA inventory;
CREATE TABLE inventory.stock_levels (product_id UUID PRIMARY KEY, ...);
```

**Pros**: Clear ownership at database level, enforceable with permissions, easy to extract later, per-module migrations.
**Cons**: Still one database instance (shared failure domain), temptation to cross-schema join.

### Table Prefix Convention

Prefix tables with module name in a shared schema: `ord_orders`, `inv_stock_levels`.

**Pros**: Works with any database. **Cons**: Convention-only discipline, weaker enforcement.

### Shared Database with Ownership Rules

Single schema, each table has a documented owner module.

**Pros**: Simplest to start. **Cons**: Hardest to enforce, drift is inevitable.

### Cross-Module Data Access Rules

1. **Never** query another module's tables directly
2. **Always** use the owning module's API to read or write data
3. For reporting spanning modules, use a dedicated read model that subscribes to events
4. Denormalize where necessary -- modules store local copies updated via events

### Migrations

Each module maintains its own migration files against its own schema. If migration order between modules matters, you have a coupling problem.

## Cross-Module Communication

### Synchronous: Direct Method Calls

```typescript
class OrderingModuleImpl implements OrderingModule {
  constructor(
    private inventory: InventoryModule,
    private billing: BillingModule
  ) {}

  async createOrder(input: CreateOrderInput): Promise<OrderResult> {
    const available = await this.inventory.checkAvailability(input.items);
    if (!available) throw new InsufficientStockError();

    const order = await this.orderRepo.save(new Order(input));
    await this.billing.createInvoice({ orderId: order.id, amount: order.totalAmount });
    return order.toResult();
  }
}
```

**When to Use**: Commands needing immediate confirmation, caller needs the result now.
**Pros**: Simple, type-safe, debuggable, transactional.
**Cons**: Runtime coupling between modules.

### Asynchronous: Internal Event Bus

```typescript
// Ordering module publishes
await this.eventBus.publish(new OrderPlacedEvent({
  orderId: order.id,
  customerId: input.customerId,
  items: input.items,
  occurredAt: new Date()
}));

// Inventory module subscribes
@OnEvent('OrderPlaced')
async handleOrderPlaced(event: OrderPlacedEvent): Promise<void> {
  await this.inventoryModule.reserveStock(event.items);
}

// Notifications module subscribes
@OnEvent('OrderPlaced')
async handleOrderPlaced(event: OrderPlacedEvent): Promise<void> {
  await this.notificationModule.sendOrderConfirmation(event.customerId, event.orderId);
}
```

**When to Use**: Side effects (notifications, analytics), publisher should not know about consumers, multiple modules react to the same event.
**Pros**: Loose coupling, extensible. **Cons**: Eventual consistency, harder to debug.

### Choosing Between Sync and Async

| Scenario | Sync | Async |
|----------|------|-------|
| Confirm stock for order | X | |
| Send confirmation email | | X |
| Check user permissions | X | |
| Update analytics | | X |
| Calculate shipping cost | X | |
| Notify warehouse team | | X |

**Rule of thumb**: If the caller needs the result to continue, use sync. If it is a side effect, use async.

### In-Process vs External Event Bus

- **In-process** (start here): Simple event emitter within the application. No infrastructure dependency. Events lost if process crashes.
- **External broker** (graduate to this): RabbitMQ, Kafka, or cloud equivalent. Adds durability, replay, extraction readiness. Add when you need guaranteed delivery.

## Module Testing Strategy

### Unit Tests (Within Module)

Test domain logic and calculations in isolation. Mock external module dependencies using the module API interfaces. Fast, no infrastructure needed.

### Integration Tests (Module API Level)

Test the module's public API with real infrastructure. Use actual implementation, mock only external modules. Verifies the API contract works end-to-end within the module.

```typescript
describe('OrderingModule', () => {
  it('creates an order and persists it', async () => {
    const inventoryMock = mock<InventoryModule>();
    when(inventoryMock.checkAvailability(anything())).thenResolve(true);

    const module = new OrderingModuleImpl(inventoryMock, billingMock, testDb);
    const result = await module.createOrder(validInput);

    expect(result.status).toBe('pending');
    expect(await module.getOrder(result.orderId)).not.toBeNull();
  });
});
```

### Cross-Module Integration Tests

Test critical paths spanning multiple modules with real implementations. Keep focused on integration points. Run less frequently (CI pipeline, not on every save).

### Test Isolation Principle

Each module must be testable without any other module's real implementation. If you cannot test a module in isolation, your boundaries are wrong. The module API interface is your test seam.

## Migration Path to Microservices

### When to Extract

- Module has independent scaling requirements
- Separate team owns it and wants independent deployment
- Different technology requirement (e.g., ML pipeline in Python, rest in TypeScript)
- Its failure should not bring down the rest of the system

### Extraction Steps

1. **Verify boundary integrity**: Module communicates only through public API and events
2. **Add network API**: Expose module API as HTTP/gRPC alongside in-process interface
3. **Externalize events**: Move domain events to Kafka/RabbitMQ
4. **Extract database**: Move module's schema to separate database instance
5. **Deploy separately**: Run as its own service
6. **Replace in-process calls**: Module API interface stays the same, implementation changes from direct call to network call
7. **Remove old code**: Delete module from monolith once service is stable

### When NOT to Extract

- No operational maturity for distributed systems
- No independent scaling needs
- High-frequency, latency-sensitive communication with other modules
- Team too small to own a separate service
- Extracting to follow a trend rather than solve a real problem

## Decision Matrix

| Factor | Traditional Monolith | Modular Monolith | Microservices |
|--------|---------------------|-------------------|---------------|
| **Team size** | 1-8 | 3-20 | 15+ |
| **Domain complexity** | Simple | Moderate-High | High |
| **Deployment frequency** | Weekly/Monthly | Daily/Weekly | Continuous |
| **Scaling needs** | Uniform | Uniform | Per-component |
| **Operational maturity** | Any | Any | High required |
| **Time to market** | Fastest | Fast | Slowest initially |
| **Cross-cutting changes** | Trivial | Easy | Hard |
| **Data consistency** | Strong (ACID) | Strong (ACID) | Eventual |
| **Infrastructure cost** | Lowest | Low | Highest |

**Choose Traditional Monolith**: Small team, simple domain, speed matters most.

**Choose Modular Monolith**: Growing team, complex domain, clean architecture without distributed overhead, possible future extraction.

**Choose Microservices**: Multiple teams need independent deployment, genuinely different scaling profiles, operational maturity to run distributed infrastructure.

## Anti-Patterns

### God Module

**Symptom**: One module depends on everything or everything depends on it. The "core" or "common" module grows without bounds.
**Fix**: Break it apart along business capability lines. If a module has too many responsibilities, it contains multiple bounded contexts.

### Circular Dependencies

**Symptom**: Module A depends on Module B, which depends on Module A.
**Fix**: Extract shared concern into a third module, or use events to break the cycle.

### Shared Mutable State

**Symptom**: Multiple modules write to the same table, shared cache, or global variable.
**Fix**: Assign clear ownership. One module owns the data. Others read through its API or subscribe to events.

### Database-Level Coupling

**Symptom**: Cross-module table joins, database triggers reacting to other modules' data, shared foreign keys across boundaries.
**Fix**: Remove cross-module joins. Replace with API calls or event-driven replication. Each module's database is private.

### Distributed Monolith

**Symptom**: Extracted to microservices but every change requires coordinated deployment. All the complexity, none of the benefits.
**Fix**: You split along wrong boundaries. Merge back into modular monolith, re-evaluate contexts, split again only when boundaries are clean.

### Premature Extraction

**Symptom**: Extracting to services before understanding the domain. Boundaries shift, requiring expensive cross-service refactoring.
**Fix**: Start as modular monolith. Refactoring boundaries in a monolith is cheap. Across a network is expensive. Extract only when boundaries have stabilized.
