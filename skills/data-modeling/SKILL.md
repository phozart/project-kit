---
name: data-modeling
description: Data modeling patterns for OLTP, OLAP, and lakehouse architectures
---

# Data Modeling Skill

Expert guidance for designing data models across relational (OLTP), analytical (OLAP), and modern lakehouse architectures.

## When to Use

- Phase 5: Data architecture design during "design the data model" tasks
- When defining entity relationships and database schemas
- When choosing between normalized vs denormalized structures
- When designing star/snowflake schemas for analytics
- When implementing Delta Lake or Iceberg table structures
- When generating type contracts for data access layers

## Core Principles

1. **Start with Entities**: Identify business entities and their attributes before choosing a pattern
2. **Match Pattern to Workload**: OLTP for transactions, OLAP for analytics, lakehouse for both
3. **Contract-Driven**: All data models must be expressed as TYPE-CONTRACTS
4. **Migration-Safe**: Every schema change must have a migration path

## Data Modeling Process

### 1. Entity Identification

```
Read requirements → Extract nouns → Group related concepts → Define attributes
```

Questions to answer:
- What are the core business entities?
- What attributes describe each entity?
- What are the unique identifiers?
- What are the relationships between entities?

### 2. Relationship Mapping

Types of relationships:
- **One-to-One**: User ↔ UserProfile
- **One-to-Many**: Customer → Orders
- **Many-to-Many**: Students ↔ Courses (requires junction table)

Document cardinality and optionality:
- Required (NOT NULL) vs Optional (NULL)
- Cascade delete behavior
- Foreign key constraints

### 3. Pattern Selection

Choose based on workload:

**OLTP (Transactional)**
- Normalized (3NF) for data integrity
- Frequent writes, point reads
- Strong consistency requirements
- See: references/oltp-patterns.md

**OLAP (Analytical)**
- Denormalized for query performance
- Bulk loads, aggregation queries
- Star or snowflake schemas
- See: references/olap-patterns.md

**Lakehouse (Hybrid)**
- Bronze/Silver/Gold layers
- Schema evolution support
- Both transactional and analytical
- See: references/lakehouse-patterns.md

### 4. Schema Generation

Generate schemas in target format:
- SQL DDL for relational databases
- Parquet/Delta schemas for lakehouses
- MongoDB schemas for document stores

Include:
- Primary keys and indexes
- Foreign key constraints
- Check constraints
- Default values
- Triggers (if needed)

### 5. Type Contract Generation

Create TYPE-CONTRACTS for data access:

```typescript
// TYPE-CONTRACTS/entities/User.ts
export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateUserInput {
  email: string;
  firstName: string;
  lastName: string;
}
```

Implementation code MUST use these contracts. Deviation is a blocking defect.

## Architecture Decisions

Document these decisions:

1. **Normalization Level**: 1NF, 2NF, 3NF, or denormalized?
2. **Partitioning Strategy**: How is data distributed?
3. **Indexing Strategy**: What indexes are needed for performance?
4. **Migration Approach**: How will schema changes be managed?
5. **Data Retention**: Archive/deletion policies

## Quality Gates

Data model must satisfy:
- All entities have primary keys
- Relationships are clearly defined with cardinality
- Indexes support all query patterns
- TYPE-CONTRACTS generated for all entities
- Migration scripts created for schema changes
- No orphaned records possible
- Performance tested with realistic data volumes

## Anti-Patterns to Avoid

- **EAV (Entity-Attribute-Value)**: Avoid unless truly needed
- **Polymorphic Associations**: Use separate foreign keys instead
- **God Tables**: Split large tables with many columns
- **No Constraints**: Always use foreign keys and constraints
- **Premature Denormalization**: Start normalized, denormalize based on metrics

## Deliverables

1. **Entity-Relationship Diagram**: Visual representation
2. **Schema Files**: DDL or schema definitions
3. **TYPE-CONTRACTS**: Interface definitions for all entities
4. **Migration Scripts**: Initial schema + migration strategy
5. **Data Dictionary**: Documentation of all fields

## References

- [OLTP Patterns](references/oltp-patterns.md) - Normalized relational patterns
- [OLAP Patterns](references/olap-patterns.md) - Star/snowflake schemas
- [Lakehouse Patterns](references/lakehouse-patterns.md) - Delta Lake and medallion architecture
- [Migration Guide](references/migration-guide.md) - Database migration strategies

## Integration

Used by:
- **data-architect agent**: Primary consumer during Phase 5
- **implementation-database skill**: Uses schemas for implementation
- **api-design skill**: Reads entity models to design endpoints

Produces:
- TYPE-CONTRACTS for repository/DAO layers
- Schema definitions for database creation
- Migration scripts for schema evolution
