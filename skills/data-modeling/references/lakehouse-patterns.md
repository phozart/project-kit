# Lakehouse Patterns

Modern data lakehouse patterns using Delta Lake, Iceberg, and medallion architecture.

## When to Use Lakehouse

- Need both transactional and analytical capabilities
- Large-scale data processing (PB scale)
- Schema evolution requirements
- Time travel and audit needs
- Streaming and batch workloads
- Cost-effective storage with cloud object stores

## Medallion Architecture

Three-tier data refinement pattern.

### Bronze Layer (Raw)
- Ingested data as-is
- Minimal transformations
- Schema-on-read
- Append-only

```sql
-- Bronze: Raw events
CREATE TABLE bronze.events (
  event_id STRING,
  event_type STRING,
  payload STRING,  -- JSON blob
  ingested_at TIMESTAMP
) USING DELTA
PARTITIONED BY (DATE(ingested_at));
```

### Silver Layer (Cleaned)
- Validated and cleaned
- Standardized formats
- Deduplication
- Type-safe schemas

```sql
-- Silver: Parsed and validated
CREATE TABLE silver.user_events (
  user_id STRING NOT NULL,
  event_type STRING NOT NULL,
  event_timestamp TIMESTAMP NOT NULL,
  properties MAP<STRING, STRING>,
  processed_at TIMESTAMP
) USING DELTA
PARTITIONED BY (DATE(event_timestamp));
```

### Gold Layer (Business)
- Aggregated metrics
- Business logic applied
- Optimized for consumption
- Denormalized views

```sql
-- Gold: Daily user metrics
CREATE TABLE gold.daily_user_metrics (
  user_id STRING,
  date DATE,
  event_count BIGINT,
  session_count BIGINT,
  total_revenue DECIMAL(10,2)
) USING DELTA
PARTITIONED BY (date);
```

## Delta Lake Features

### ACID Transactions

```sql
-- Atomic updates
UPDATE silver.user_events
SET properties['status'] = 'processed'
WHERE user_id = '12345';

-- Deletes are safe
DELETE FROM silver.user_events
WHERE event_timestamp < current_date() - INTERVAL 90 DAYS;
```

### Time Travel

```sql
-- Query historical data
SELECT * FROM silver.user_events VERSION AS OF 42;
SELECT * FROM silver.user_events TIMESTAMP AS OF '2024-01-01';

-- Restore previous version
RESTORE TABLE silver.user_events TO VERSION AS OF 42;
```

### Schema Evolution

```sql
-- Add new column
ALTER TABLE silver.user_events
ADD COLUMN device_type STRING;

-- Schema enforcement prevents bad writes
SET spark.databricks.delta.schema.autoMerge.enabled = false;
```

### Merge (Upsert)

```sql
MERGE INTO silver.users AS target
USING staging.users AS source
ON target.user_id = source.user_id
WHEN MATCHED THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *;
```

## Partitioning Strategy

### Date Partitioning (Most Common)

```sql
PARTITIONED BY (date_partition DATE)
```

Benefits:
- Easy to query specific date ranges
- Simple to drop old partitions
- Works well with time-series data

### Multi-Column Partitioning

```sql
PARTITIONED BY (region STRING, date DATE)
```

Use when:
- Common to filter by region + date
- Data naturally segmented by region

## Optimization Commands

```sql
-- Compact small files
OPTIMIZE silver.user_events;

-- Z-ordering for multi-column queries
OPTIMIZE silver.user_events
ZORDER BY (user_id, event_type);

-- Vacuum old files (after retention period)
VACUUM silver.user_events RETAIN 168 HOURS;
```

## Streaming Integration

```python
# Structured streaming with Delta
(spark.readStream
  .format("delta")
  .table("bronze.events")
  .writeStream
  .format("delta")
  .outputMode("append")
  .option("checkpointLocation", "/checkpoints/silver_events")
  .table("silver.user_events"))
```

## Best Practices

1. Always use partitioning for large tables
2. Run OPTIMIZE regularly on frequently written tables
3. Use Z-ordering for columns used together in WHERE
4. Set appropriate VACUUM retention (balance storage cost vs time travel)
5. Use MERGE for upserts instead of DELETE + INSERT
6. Monitor file sizes (target 100MB-1GB per file)
