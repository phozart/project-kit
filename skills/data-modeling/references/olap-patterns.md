# OLAP Patterns

Online Analytical Processing patterns for data warehouses and analytics.

## When to Use OLAP

- Read-heavy workloads (aggregations, reports, dashboards)
- Historical data analysis
- Business intelligence queries
- Complex joins across many tables
- Infrequent writes (batch loads)

## Star Schema

Denormalized structure optimized for queries.

```
        Fact Table
       /    |    \
      /     |     \
   Dim1   Dim2   Dim3
```

### Example: Sales Analysis

```sql
-- Fact Table (normalized measures)
CREATE TABLE fact_sales (
  sale_id BIGINT PRIMARY KEY,
  date_key INT REFERENCES dim_date(date_key),
  product_key INT REFERENCES dim_product(product_key),
  customer_key INT REFERENCES dim_customer(customer_key),
  store_key INT REFERENCES dim_store(store_key),
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  discount_amount DECIMAL(10,2) DEFAULT 0
);

-- Dimension Tables (denormalized)
CREATE TABLE dim_date (
  date_key INT PRIMARY KEY,
  full_date DATE NOT NULL,
  day_of_week VARCHAR(10),
  month_name VARCHAR(10),
  quarter INT,
  year INT
);

CREATE TABLE dim_product (
  product_key INT PRIMARY KEY,
  product_id VARCHAR(50),
  product_name VARCHAR(255),
  category VARCHAR(100),
  subcategory VARCHAR(100),
  brand VARCHAR(100)
);
```

## Snowflake Schema

Normalized dimensions (space-efficient but more joins).

```
     Fact Table
       /    \
      /      \
   Dim1    Dim2
    |        |
  SubDim1  SubDim2
```

Use when:
- Storage is expensive
- Dimension tables are very large
- Dimension updates are common

## Fact Table Types

### 1. Transaction Fact
- One row per business event
- Highly granular
- Example: fact_sales (one row per sale)

### 2. Periodic Snapshot
- One row per time period
- Aggregated metrics
- Example: daily_inventory_snapshot

### 3. Accumulating Snapshot
- Tracks progress through a process
- Updated as milestones reached
- Example: order_fulfillment (order_date, ship_date, delivery_date)

## Dimension Patterns

### Slowly Changing Dimensions (SCD)

**Type 1: Overwrite**
- Update existing row
- No history preserved

**Type 2: Add New Row**
- Create new row with version/date
- Full history preserved
- Most common for analytics

```sql
CREATE TABLE dim_customer (
  customer_key INT PRIMARY KEY,
  customer_id VARCHAR(50),
  customer_name VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(50),
  effective_date DATE,
  expiration_date DATE,
  is_current BOOLEAN DEFAULT TRUE
);
```

**Type 3: Add New Column**
- Track previous value in separate column
- Limited history

## Indexing for OLAP

- Bitmap indexes for low-cardinality columns
- Columnstore indexes for analytical queries
- Partition fact tables by date
- Pre-aggregate common queries (materialized views)

## Performance Optimization

1. Partition large fact tables (by month/year)
2. Use columnar storage formats
3. Pre-calculate aggregations
4. Denormalize dimensions to reduce joins
5. Compress historical data
