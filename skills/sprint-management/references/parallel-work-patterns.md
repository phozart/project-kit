# Parallel Work Patterns

Patterns for managing parallel execution of development work across multiple agents.

## Independent Parallel Work

### Pattern: Feature-Level Parallelism
Assign complete features to different agents when features are independent.

**Example:**
```
Agent 1: Customer Management Feature
  - Backend API
  - Frontend UI
  - Tests

Agent 2: Order Management Feature
  - Backend API
  - Frontend UI
  - Tests

Agent 3: Reporting Feature
  - Data pipeline
  - Dashboard UI
  - Tests
```

**Benefits:**
- Minimal coordination needed
- Clear ownership
- Reduced conflicts

**When to Use:**
- Features are independent
- No shared components
- Agents are experienced with full stack

## Layer-Based Parallelism

### Pattern: Horizontal Slicing
Split work by architectural layer for the same feature.

**Example:**
```
Feature: Customer Management

Agent 1 (Backend): Customer API
  - Create customer endpoint
  - Update customer endpoint
  - List customers endpoint

Agent 2 (Frontend): Customer UI
  - Customer list view
  - Customer form
  - Customer details view

Agent 3 (Data): Customer Analytics
  - Customer data pipeline
  - Customer metrics
```

**Benefits:**
- Specialists work on their layer
- Parallel progress on same feature
- Clear interface boundaries (API contracts)

**Challenges:**
- Requires well-defined contracts
- Frontend may need mocked backend initially
- More coordination needed

**When to Use:**
- Strong API contracts defined
- Team has specialized roles
- Feature is large and complex

## Dependency Management

### Pattern: Sequential with Parallel Branches

**Example:**
```
Phase 1:
  Agent 1: Database schema + migrations

Phase 2 (after Phase 1):
  Agent 2: Backend API (depends on schema)
  Agent 3: Data pipeline (depends on schema)  [parallel]

Phase 3 (after Phase 2):
  Agent 4: Frontend UI (depends on API)
  Agent 5: Reporting (depends on data pipeline)  [parallel]
```

**Critical Path:**
```
Schema → API → Frontend
```

**Benefits:**
- Respects dependencies
- Maximizes parallelism where possible
- Clear critical path

**When to Use:**
- Features have dependencies
- Some work can proceed in parallel
- Critical path identified

## Mock-Driven Parallelism

### Pattern: Mock Dependencies
Use mocks to enable parallel work when dependencies not ready.

**Example:**
```
Agent 1: Backend API (real implementation)
  - Implement endpoints
  - Real database access

Agent 2: Frontend UI (using mocks)
  - Use mocked API responses
  - Implement UI logic
  - Replace mocks when real API ready

Agent 3: Tests (using mocks)
  - Write tests against mocked dependencies
  - Update when real implementations ready
```

**Mock API Example:**
```typescript
// Mock for parallel development
const mockCustomerAPI = {
  getCustomers: () => Promise.resolve([
    { id: 1, name: 'Customer 1' },
    { id: 2, name: 'Customer 2' }
  ]),
  createCustomer: (data) => Promise.resolve({ id: 3, ...data })
};
```

**Benefits:**
- Unblocks dependent work
- Tests dependencies in isolation
- Validates contract assumptions early

**Challenges:**
- Mocks must match real behavior
- Integration needed when real implementation ready
- Risk of mock drift

**When to Use:**
- Clear API contracts defined
- Dependent work would otherwise be blocked
- Timeline pressure

## Conflict Resolution

### File-Level Conflicts

**Prevention:**
1. Assign different files to different agents
2. Coordinate changes to shared files
3. Use small, frequent merges

**Resolution:**
1. Identify conflicting changes
2. Communicate between agents
3. Merge changes (preserve both if possible)
4. Test merged result

### Database Schema Conflicts

**Prevention:**
1. Assign different tables to different agents
2. Use migration tool with timestamps
3. Review migrations before merge

**Example:**
```
Agent 1 creates: V001__create_customers_table.sql
Agent 2 creates: V002__create_orders_table.sql

Merge: Apply in order based on version number
```

**Resolution:**
1. Rename migrations if version conflict
2. Update dependencies if schema conflict
3. Test migrations together

### API Contract Conflicts

**Prevention:**
1. Define contracts upfront
2. Version APIs when breaking changes needed
3. Coordinate changes to shared contracts

**Resolution:**
1. Review conflicting contract changes
2. Decide on unified contract
3. Update both implementations
4. Test integration

## Work Distribution Strategies

### Strategy 1: Balanced Load
Distribute work evenly across agents by effort.

**Example:**
```
Agent 1 (8 story points):
  - Feature A (5 points)
  - Feature B (3 points)

Agent 2 (8 story points):
  - Feature C (8 points)

Agent 3 (8 story points):
  - Feature D (4 points)
  - Feature E (4 points)
```

### Strategy 2: Skill-Based Assignment
Assign work based on agent expertise.

**Example:**
```
Backend Specialist Agent:
  - All backend API work
  - Database design

Frontend Specialist Agent:
  - All frontend UI work
  - Design system implementation

Data Specialist Agent:
  - Data pipelines
  - Analytics
```

### Strategy 3: Feature Team
Assign cross-functional team to complete feature.

**Example:**
```
Feature: E-commerce Checkout

Backend Agent: Checkout API
Frontend Agent: Checkout UI
QA Agent: Checkout tests
Data Agent: Checkout analytics
```

## Coordination Patterns

### Daily Sync
Brief daily coordination:
- What was completed
- What is planned
- Any blockers or conflicts

### Integration Points
Schedule regular integration:
- Merge branches
- Run full test suite
- Resolve conflicts
- Deploy to shared environment

### Shared Backlog
Maintain shared backlog:
- All agents can see full sprint
- Agents pick next task when ready
- Clear dependencies marked
