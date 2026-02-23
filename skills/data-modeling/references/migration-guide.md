# Database Migration Guide

Strategies and tools for managing database schema changes safely.

## Migration Principles

1. **Version Control**: All migrations in source control
2. **Immutable**: Never edit existing migrations
3. **Idempotent**: Safe to run multiple times
4. **Rollback-Safe**: Every migration has a down/rollback path
5. **Tested**: Test in staging before production

## Migration Tools

### SQL-Based
- **Flyway**: Java-based, SQL + Java migrations
- **Liquibase**: XML/YAML/SQL, enterprise features
- **golang-migrate**: Simple, language-agnostic

### ORM-Based
- **Alembic**: Python (SQLAlchemy)
- **TypeORM**: TypeScript/JavaScript
- **Entity Framework**: .NET
- **Prisma**: TypeScript with schema DSL

## File Naming Convention

```
V{version}__{description}.sql
```

Examples:
- `V001__create_users_table.sql`
- `V002__add_email_index_to_users.sql`
- `V003__create_orders_table.sql`

## Migration Types

### 1. Additive Changes (Safe)

```sql
-- V001__add_phone_column.sql
ALTER TABLE users
ADD COLUMN phone VARCHAR(20);
```

Rollback:
```sql
ALTER TABLE users
DROP COLUMN phone;
```

### 2. Destructive Changes (Risky)

```sql
-- V002__remove_deprecated_column.sql
-- WARNING: Data loss!
ALTER TABLE users
DROP COLUMN old_field;
```

Better approach (two-phase):
```sql
-- V002__deprecate_old_field.sql (Phase 1)
-- Stop writing to old_field in application code first

-- V003__remove_old_field.sql (Phase 2, weeks later)
ALTER TABLE users
DROP COLUMN old_field;
```

### 3. Data Migrations

```sql
-- V004__migrate_status_values.sql
UPDATE orders
SET status = 'PENDING'
WHERE status = 'NEW';

UPDATE orders
SET status = 'COMPLETED'
WHERE status = 'DONE';
```

## Zero-Downtime Migrations

### Strategy 1: Expand-Contract

1. **Expand**: Add new column, keep old column
2. **Migrate**: Dual-write to both columns
3. **Contract**: Remove old column after all data migrated

```sql
-- Step 1: Add new column
ALTER TABLE users ADD COLUMN full_name VARCHAR(255);

-- Step 2: Backfill data
UPDATE users SET full_name = CONCAT(first_name, ' ', last_name);

-- Step 3: Make new column NOT NULL (after app updated)
ALTER TABLE users ALTER COLUMN full_name SET NOT NULL;

-- Step 4: Drop old columns (weeks later)
ALTER TABLE users DROP COLUMN first_name, DROP COLUMN last_name;
```

### Strategy 2: Shadow Tables

1. Create new table with desired schema
2. Dual-write to both tables
3. Backfill data
4. Switch application to new table
5. Drop old table

### Strategy 3: Rolling Deployments

1. Ensure schema change is backward compatible
2. Deploy new schema
3. Deploy new application code
4. Verify everything works
5. Clean up old structures

## Rollback Strategies

### Automatic Rollback
```sql
BEGIN TRANSACTION;

-- Migration code here
ALTER TABLE users ADD COLUMN age INT;

-- If error occurs, transaction rolls back automatically
COMMIT;
```

### Manual Rollback Scripts
```sql
-- up.sql
ALTER TABLE users ADD COLUMN age INT;

-- down.sql
ALTER TABLE users DROP COLUMN age;
```

### Rollback-Safe Patterns
- Add columns (can always drop)
- Add indexes (can always drop)
- Add tables (can always drop)

### Rollback-Risky Patterns
- Drop columns (data loss)
- Rename columns (breaks old code)
- Change column types (data corruption risk)

## Testing Migrations

```bash
# Test migration up
npm run migrate:up

# Run tests
npm test

# Test rollback
npm run migrate:down

# Test idempotency (run twice)
npm run migrate:up
npm run migrate:up  # Should be no-op
```

## Lakehouse Migrations

Delta Lake supports schema evolution:

```python
# Enable schema evolution
spark.conf.set("spark.databricks.delta.schema.autoMerge.enabled", "true")

# Write with new schema (adds columns automatically)
df.write.format("delta").mode("append").save("/path/to/table")

# Or explicit ALTER TABLE
spark.sql("ALTER TABLE my_table ADD COLUMN new_col STRING")
```

## Best Practices

1. Run migrations as part of deployment pipeline
2. Test rollback before production deployment
3. Take database backup before major migrations
4. Monitor migration duration in staging
5. Use transactions where possible
6. Avoid long-running migrations during peak hours
7. Split large data migrations into batches
8. Document breaking changes in migration comments
