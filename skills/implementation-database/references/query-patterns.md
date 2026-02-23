# Query Patterns

Efficient queries, N+1 prevention, and indexing strategies.

## N+1 Query Problem

The most common performance issue.

### Problem

```python
# Bad: Triggers N+1 queries
users = db.query(User).all()  # 1 query

for user in users:  # N queries (one per user!)
    print(user.orders)
```

### Solutions

**Eager Loading (join)**
```python
# SQLAlchemy
from sqlalchemy.orm import joinedload

users = db.query(User).options(joinedload(User.orders)).all()
```

**Subquery Loading**
```python
from sqlalchemy.orm import subqueryload

users = db.query(User).options(subqueryload(User.orders)).all()
```

**Prisma**
```typescript
const users = await prisma.user.findMany({
  include: {
    orders: true,
  },
});
```

**Spring Data JPA**
```java
@EntityGraph(attributePaths = {"orders"})
List<User> findAll();
```

## Indexing Strategies

```sql
-- Single column
CREATE INDEX idx_email ON users(email);

-- Composite (order matters)
CREATE INDEX idx_name ON users(last_name, first_name);

-- Partial
CREATE INDEX idx_active ON users(email) WHERE active = true;
```

## Pagination

```python
def get_users(skip: int = 0, limit: int = 20):
    return db.query(User).offset(skip).limit(limit).all()
```

## Best Practices

1. Use eager loading for related data
2. Index foreign keys
3. Paginate large result sets
4. Select only needed columns
5. Use prepared statements
