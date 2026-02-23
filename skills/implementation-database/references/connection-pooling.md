# Connection Pooling

Connection pool configuration and health checks.

## Python (SQLAlchemy)

```python
from sqlalchemy import create_engine

engine = create_engine(
    "postgresql://user:pass@localhost/db",
    pool_size=10,
    max_overflow=20,
    pool_timeout=30,
    pool_recycle=3600,
    pool_pre_ping=True
)
```

## Java (HikariCP)

```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 10
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
```

## Health Checks

```python
@router.get("/health/db")
def db_health(db: Session = Depends(get_db)):
    try:
        db.execute("SELECT 1")
        return {"status": "healthy"}
    except:
        return {"status": "unhealthy"}
```

## Best Practices

1. Configure appropriate pool size
2. Set connection timeouts
3. Recycle connections periodically
4. Monitor pool metrics
5. Implement health checks
