# Architecture Decision Record (ADR) Template

Template for documenting architecture decisions.

## ADR Format

```markdown
# ADR-XXX: [Short Title of Decision]

**Date**: YYYY-MM-DD
**Status**: [Proposed | Accepted | Deprecated | Superseded by ADR-YYY]
**Deciders**: [List of people involved in decision]
**Technical Story**: [Link to ticket/issue if applicable]

## Context

[Describe the context and background that led to this decision.]

What is the issue or situation we're addressing?
What forces are at play?
What constraints exist?
What are we trying to achieve?

## Decision

[State the decision clearly and concisely.]

We will [decision statement].

## Rationale

[Explain why this decision was made.]

Why is this the best option?
What alternatives were considered?
What factors influenced the decision?

## Consequences

### Positive
- [Benefit 1]
- [Benefit 2]
- [Benefit 3]

### Negative
- [Drawback 1]
- [Drawback 2]
- [Drawback 3]

### Neutral
- [Neutral impact 1]
- [Neutral impact 2]

## Alternatives Considered

### Alternative 1: [Name]
**Description**: [What it is]
**Pros**: [Benefits]
**Cons**: [Drawbacks]
**Why not chosen**: [Reason for rejection]

### Alternative 2: [Name]
**Description**: [What it is]
**Pros**: [Benefits]
**Cons**: [Drawbacks]
**Why not chosen**: [Reason for rejection]

## Notes

[Any additional context, references, or future considerations]
```

## Example ADR

```markdown
# ADR-001: Use PostgreSQL as Primary Database

**Date**: 2026-02-22
**Status**: Accepted
**Deciders**: Architecture Team, Lead Developer, CTO
**Technical Story**: REQ-D-001, REQ-NF-010

## Context

We need to select a primary database for the customer portal application. The system needs to:
- Store structured user, project, and task data
- Support complex queries and relationships
- Handle up to 100,000 users initially
- Scale to millions of records over time
- Provide ACID guarantees for critical operations
- Support full-text search
- Enable efficient analytics queries

Our team has experience with both SQL and NoSQL databases. The application requirements are primarily relational with well-defined schemas. We need to balance developer productivity, operational simplicity, and future scalability.

## Decision

We will use PostgreSQL 15+ as the primary database for all application data.

## Rationale

PostgreSQL provides the best balance of features, performance, and operational simplicity for our use case:

1. **Strong relational model**: Our data is inherently relational (users own projects, projects contain tasks, etc.)
2. **ACID compliance**: Critical for financial and user data integrity
3. **Rich feature set**: JSONB for flexibility, full-text search, advanced indexing, window functions
4. **Proven scalability**: Handles millions of rows with proper indexing and tuning
5. **Team expertise**: Development team has strong PostgreSQL experience
6. **Ecosystem**: Excellent tooling (pgAdmin, monitoring, ORMs)
7. **Cost**: Open-source with commercial support available if needed
8. **Cloud support**: Available as managed service on AWS, GCP, Azure

## Consequences

### Positive
- ACID guarantees ensure data consistency
- Rich query capabilities support complex analytics
- JSONB columns provide schema flexibility when needed
- Mature ecosystem with excellent tooling
- Team can be productive immediately
- Single database simplifies operations and reduces latency
- Built-in full-text search reduces need for separate search service
- Strong community support and documentation

### Negative
- Vertical scaling limits (though can be mitigated with read replicas)
- Requires careful query optimization at scale
- Schema migrations require planning for zero-downtime
- Not ideal for unstructured or highly variable data (though JSONB helps)
- Sharding is complex if we outgrow single-instance

### Neutral
- Need to establish backup and recovery procedures
- Will use managed service (RDS/Cloud SQL) vs self-hosted
- Connection pooling (pgBouncer) needed at scale
- Need monitoring and performance tuning strategy

## Alternatives Considered

### Alternative 1: MongoDB
**Description**: Document-oriented NoSQL database with flexible schema
**Pros**:
- Flexible schema good for rapid iteration
- Horizontal scaling built-in
- Strong for unstructured data

**Cons**:
- Eventual consistency model complicates critical operations
- Less mature transaction support
- Team less experienced with MongoDB
- Our data is inherently relational, not document-oriented
- Would require additional complexity for relationships

**Why not chosen**: Our data model is relational, not document-based. ACID guarantees are critical.

### Alternative 2: MySQL
**Description**: Popular open-source relational database
**Pros**:
- Similar to PostgreSQL in many ways
- Wide adoption and support
- Good performance

**Cons**:
- Less feature-rich than PostgreSQL
- Weaker JSON support
- Team prefers PostgreSQL syntax
- Historically less strict on data integrity

**Why not chosen**: PostgreSQL offers more advanced features (JSONB, full-text search, window functions) that we anticipate needing.

### Alternative 3: DynamoDB
**Description**: AWS managed NoSQL database
**Pros**:
- Fully managed, serverless
- Excellent scalability
- Pay-per-use pricing

**Cons**:
- Vendor lock-in to AWS
- Complex query patterns
- No ACID across partitions
- Team unfamiliar with DynamoDB design patterns
- Difficult to model relational data

**Why not chosen**: Vendor lock-in, complexity of modeling relational data, team expertise.

## Notes

- We will use PostgreSQL 15 or later for improved performance
- Will start with single instance and add read replicas as needed
- Use managed service (AWS RDS or similar) for operational simplicity
- Schema migrations managed via Alembic (Python) or Flyway (Java)
- Monitor query performance from day one
- Consider partitioning for large tables (users, events) when needed
- Future consideration: If we need specialized search, add Elasticsearch separately
```

## Tips for Writing Good ADRs

1. **Write when the decision is made** - Not before, not after
2. **Be concise** - ADRs should be readable in 5-10 minutes
3. **Explain the "why"** - Context and rationale matter more than the decision itself
4. **Be honest about consequences** - Include negative impacts
5. **Consider alternatives** - Show you evaluated options
6. **Use present tense** - "We will use X" not "We should use X"
7. **Status is important** - Update status when decisions change
8. **Link to requirements** - Connect decisions to business needs
9. **Make it searchable** - Use descriptive titles and tags

## Common ADR Topics

- Technology selection (database, framework, language)
- Architectural patterns (microservices, event-driven, etc.)
- API design (REST vs GraphQL, versioning strategy)
- Authentication/authorization approach
- Data storage and caching strategy
- Deployment and infrastructure
- Testing strategy
- Error handling and logging
- Third-party service selection
- Build and deployment pipeline
