# OLTP Patterns

Online Transaction Processing patterns for normalized relational databases.

## When to Use OLTP

- High volume of INSERT, UPDATE, DELETE operations
- Strong consistency requirements (ACID)
- Complex relationships between entities
- Need for referential integrity
- Transactional workloads (orders, payments, inventory)

## Normalization Levels

### First Normal Form (1NF)
- Atomic values (no arrays or lists in columns)
- Each row is unique
- No repeating groups

### Second Normal Form (2NF)
- Meets 1NF
- No partial dependencies (all non-key attributes depend on entire primary key)

### Third Normal Form (3NF)
- Meets 2NF
- No transitive dependencies (non-key attributes don't depend on other non-key attributes)
- **Recommended for most OLTP systems**

## Common OLTP Patterns

### 1. Parent-Child Relationship

```sql
CREATE TABLE customers (
  id UUID PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
  id UUID PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  total_amount DECIMAL(10,2) NOT NULL,
  status VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

### 2. Junction Table (Many-to-Many)

```sql
CREATE TABLE products (
  id UUID PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE order_items (
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id),
  quantity INTEGER NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (order_id, product_id)
);
```

### 3. Audit Trail

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_by UUID,
  updated_by UUID
);
```

## Indexing Strategy

- **Primary Key**: Clustered index on ID
- **Foreign Keys**: Always index foreign key columns
- **Query Columns**: Index columns used in WHERE, JOIN, ORDER BY
- **Composite Indexes**: For multi-column queries
- **Avoid Over-Indexing**: Every index slows writes

## Constraints

Use constraints to enforce data integrity:
- **NOT NULL**: Require values
- **UNIQUE**: Prevent duplicates
- **CHECK**: Validate values
- **FOREIGN KEY**: Enforce relationships
- **DEFAULT**: Set default values

## Performance Tips

1. Use appropriate data types (INT vs BIGINT, VARCHAR vs TEXT)
2. Keep row size small for better cache utilization
3. Use connection pooling
4. Monitor slow queries and add indexes
5. Use transactions for multi-step operations
