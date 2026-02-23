---
name: implementation-database
description: Database implementation covering migrations, queries, and connection management
---

# Database Implementation Skill

Database implementation skill covering migrations, efficient queries, and connection pooling.

## When to Use

- Database implementation tasks
- "Create migrations"
- "Optimize queries"
- "Set up database"
- Phase 7 implementation when database work is needed

## Migration Tools

### Python (Alembic)

```python
# alembic/versions/001_create_users_table.py
from alembic import op
import sqlalchemy as sa

def upgrade():
    op.create_table(
        'users',
        sa.Column('id', sa.Integer(), primary_key=True),
        sa.Column('email', sa.String(255), unique=True, nullable=False)
    )

def downgrade():
    op.drop_table('users')
```

## References

- [Query Patterns](references/query-patterns.md) - Efficient queries
- [Migration Patterns](references/migration-patterns.md) - Migration strategies
- [Connection Pooling](references/connection-pooling.md) - Pool configuration
