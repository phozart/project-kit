---
name: architecture
description: System architecture and technical design with binding contracts
---

# Architecture Skill

Defines the technical architecture and system design based on requirements and selected technology stack. Creates binding contracts that govern system behavior and integration.

## When to Use

- Phase 5 architecture in the orchestrator workflow
- User says "design the architecture" or "create system design"
- Need to define technical architecture
- Creating Architecture Decision Records (ADRs)
- Defining TYPE-CONTRACTS and API-CONTRACTS
- Planning infrastructure and deployment

## What This Skill Does

This skill produces comprehensive technical architecture including:

1. System architecture and component design
2. Architecture Decision Records (ADRs)
3. Infrastructure design and deployment strategy
4. Binding TYPE-CONTRACTS and API-CONTRACTS
5. Data architecture and schema design

## Process

### 1. Review Inputs

Read and analyze:
- `project.config.yaml` - Selected technology stack
- `docs/requirements/*.md` - All requirements (functional, data, non-functional, security, operational)
- `docs/features.md` - Product features for context

### 2. Design System Architecture

**Define System Components**:
- Frontend application(s)
- Backend service(s)
- Database(s)
- Cache layer(s)
- Message queue(s) (if applicable)
- External integrations
- CDN/static assets

**Define Component Interactions**:
- Request/response flows
- Data flows
- Authentication flows
- Authorization boundaries
- Error handling flows

**Create Architecture Diagrams**:
Use Mermaid or similar for:
- System context diagram (external actors and systems)
- Container diagram (high-level components)
- Component diagram (internal structure)
- Deployment diagram (infrastructure)
- Sequence diagrams (critical flows)

**Output**: `docs/architecture/system-design.md`

### 2.5. Apply Architecture Style

Read `docs/PLATFORM-FOUNDATION.md` Decision 8 (Architecture Style) to determine the project's architecture style.

**If Traditional Monolith:**
- Design a layered architecture (controller → service → repository)
- Organize by feature, not by technical layer
- Reference: `references/system-design-patterns.md`

**If Modular Monolith:**
- Define module boundaries aligned with bounded contexts
- Each module owns its domain logic, data schema, and internal API
- Cross-module communication through defined interfaces or internal event bus
- Reference: `references/modular-monolith-patterns.md`, `references/domain-driven-design.md`

**If Microservices:**
- Define service boundaries per bounded context
- Design API gateway, inter-service communication, and service discovery
- Plan distributed tracing and circuit breakers
- Reference: `references/architecture-style-patterns.md`

**If Serverless-First:**
- Design event-driven architecture with function composition
- Plan state management and orchestration
- Reference: `references/architecture-style-patterns.md`

### 3. Create Architecture Decision Records

For each significant architectural decision, create an ADR:

**ADR Format** (see ADR template in references):
- Status (Proposed / Accepted / Deprecated / Superseded)
- Context (what decision needs to be made)
- Decision (what was decided)
- Consequences (positive and negative impacts)

**Common ADR Topics**:
- Technology choices (framework, database, etc.)
- Architectural patterns (monolith vs microservices, MVC, etc.)
- Data storage strategy
- Authentication/authorization approach
- API design (REST vs GraphQL vs gRPC)
- Deployment strategy
- Error handling approach
- Logging and monitoring strategy

**Output**: `docs/decisions/ADR-XXX-*.md` (one file per decision)

### 4. Design Infrastructure

**Define Infrastructure Components**:
- Compute (VMs, containers, serverless)
- Storage (databases, object storage, file storage)
- Networking (VPC, load balancers, CDN)
- Security (firewalls, secrets management, encryption)
- Monitoring (metrics, logs, traces, alerts)
- CI/CD pipeline

**Define Environments**:
- Development
- Staging/QA
- Production
- DR/backup (if applicable)

**Define Scaling Strategy**:
- Horizontal vs vertical scaling
- Auto-scaling rules
- Load balancing approach
- Database replication/sharding

**Output**: `docs/architecture/infrastructure.md`

### 5. Create Binding Contracts

**CRITICAL: Contracts are binding and govern system behavior.**

#### TYPE-CONTRACTS

Define data structures and their validation rules. These contracts are the source of truth for data shape.

**Format**:
```typescript
// docs/contracts/TYPE-CONTRACTS.ts (or .json, .yaml depending on stack)

/**
 * User entity
 * SOURCE OF TRUTH for user data structure
 */
interface User {
  id: string;              // UUID v4
  email: string;           // RFC 5322 format, unique
  name: string;            // 1-100 characters
  avatar_url?: string;     // Optional, valid URL
  created_at: Date;        // ISO 8601 timestamp
  updated_at: Date;        // ISO 8601 timestamp
  status: UserStatus;      // Enum: active | suspended | deleted
}

enum UserStatus {
  ACTIVE = "active",
  SUSPENDED = "suspended",
  DELETED = "deleted"
}

/**
 * Project entity
 * SOURCE OF TRUTH for project data structure
 */
interface Project {
  id: string;              // UUID v4
  name: string;            // 3-100 characters, unique per owner
  description?: string;    // Max 500 characters
  owner_id: string;        // Foreign key to User.id
  status: ProjectStatus;   // Enum: active | archived | deleted
  created_at: Date;
  updated_at: Date;
}

enum ProjectStatus {
  ACTIVE = "active",
  ARCHIVED = "archived",
  DELETED = "deleted"
}
```

**Contract Rules**:
- All entities must have ID, created_at, updated_at
- Use enums for constrained values
- Document all validation rules
- Mark optional fields with `?`
- Include comments explaining constraints
- Version contracts if they change

#### API-CONTRACTS

Define API endpoints, request/response schemas, and behavior.

**Format** (OpenAPI/Swagger style):
```yaml
# docs/contracts/API-CONTRACTS.yaml

openapi: 3.0.0
info:
  title: Customer Portal API
  version: 1.0.0

paths:
  /api/v1/users:
    post:
      summary: Create new user (registration)
      operationId: createUser
      tags: [Users, Authentication]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [email, password, name]
              properties:
                email:
                  type: string
                  format: email
                  description: User email address (unique)
                password:
                  type: string
                  minLength: 8
                  description: Must include uppercase, lowercase, number
                name:
                  type: string
                  minLength: 1
                  maxLength: 100
      responses:
        201:
          description: User created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        400:
          description: Validation error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        409:
          description: Email already exists
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        name:
          type: string
        avatar_url:
          type: string
          format: uri
          nullable: true
        status:
          type: string
          enum: [active, suspended, deleted]
        created_at:
          type: string
          format: date-time
        updated_at:
          type: string
          format: date-time
```

**Contract Change Rules**:
1. Contract changes MUST go through architect
2. Never let developer agents modify contracts directly
3. Version API contracts (v1, v2, etc.)
4. Breaking changes require new version
5. Document migration path for breaking changes

### 6. Design Data Architecture

**Define Database Schema**:
- Tables/collections with columns/fields
- Primary keys and foreign keys
- Indexes for performance
- Constraints and validations

**Define Relationships**:
- One-to-many
- Many-to-many (with junction tables)
- One-to-one

**Define Data Migration Strategy**:
- Schema versioning approach
- Migration tool (Alembic, Flyway, Liquibase, etc.)
- Rollback strategy

**Output**: `docs/architecture/data-model.md`

### 7. Validation Checklist

Before completing architecture:

- [ ] System architecture covers all functional requirements
- [ ] Non-functional requirements have architectural solutions
- [ ] All significant decisions have ADRs
- [ ] Infrastructure design supports scaling requirements
- [ ] TYPE-CONTRACTS defined for all entities
- [ ] API-CONTRACTS defined for all endpoints
- [ ] Data model supports all data requirements
- [ ] Security requirements addressed in design
- [ ] Monitoring and observability planned
- [ ] DR/backup strategy defined
- [ ] All contracts are versioned

## Output Files

- `docs/architecture/system-design.md` - Overall system architecture
- `docs/architecture/infrastructure.md` - Infrastructure and deployment design
- `docs/architecture/data-model.md` - Database schema and data flows
- `docs/decisions/ADR-001-*.md` - Architecture Decision Records
- `docs/contracts/TYPE-CONTRACTS.*` - Data type contracts (binding)
- `docs/contracts/API-CONTRACTS.*` - API contracts (binding)

## References

- [ADR Template](./references/adr-template.md)
- [System Design Patterns](./references/system-design-patterns.md)
- [Data Flow Patterns](./references/data-flow-patterns.md)
- [Modular Monolith Patterns](./references/modular-monolith-patterns.md)
- [Domain-Driven Design](./references/domain-driven-design.md)
- [Architecture Style Patterns](./references/architecture-style-patterns.md)
