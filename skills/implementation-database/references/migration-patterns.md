# Migration Patterns

Database migration strategies and rollback patterns.

## Migration Naming

```
V001__create_users_table.sql
V002__add_email_index.sql
V003__add_orders_table.sql
```

## Safe Migrations

### Additive Changes (Safe)

```sql
-- Add column
ALTER TABLE users ADD COLUMN phone VARCHAR(20);

-- Add index
CREATE INDEX idx_phone ON users(phone);
```

### Destructive Changes (Risky)

Use two-phase approach:

```sql
-- Phase 1: Stop using old column
-- Deploy code that doesn't reference old_column

-- Phase 2: Drop after deployment
ALTER TABLE users DROP COLUMN old_column;
```

## Rollback Scripts

```sql
-- up.sql
ALTER TABLE users ADD COLUMN age INT;

-- down.sql
ALTER TABLE users DROP COLUMN age;
```

## Best Practices

1. Never edit existing migrations
2. Test rollback before deploying
3. Use transactions when possible
4. Backup before major changes
5. Split large data migrations
