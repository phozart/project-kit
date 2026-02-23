# Data Quality Testing

Data quality tests validate data pipelines, transformations, and integrity.

## Schema Validation

### Using Great Expectations (Python)
```python
import great_expectations as ge

def test_customer_schema():
    df = ge.read_csv('customers.csv')

    # Column existence
    assert df.expect_column_to_exist('customer_id').success
    assert df.expect_column_to_exist('email').success

    # Data types
    assert df.expect_column_values_to_be_of_type('customer_id', 'int64').success
    assert df.expect_column_values_to_be_of_type('email', 'object').success
```

### Spark Schema Testing
```python
from pyspark.sql.types import StructType, StructField, IntegerType, StringType

def test_orders_schema():
    expected_schema = StructType([
        StructField("order_id", IntegerType(), False),
        StructField("customer_id", IntegerType(), False),
        StructField("total", DecimalType(10, 2), False),
        StructField("status", StringType(), False)
    ])

    df = spark.read.parquet("orders.parquet")
    assert df.schema == expected_schema
```

## Completeness Checks

### Null Value Testing
```python
def test_no_null_customer_ids():
    df = spark.read.table("customers")
    null_count = df.filter(col("customer_id").isNull()).count()
    assert null_count == 0, f"Found {null_count} null customer IDs"

def test_email_completeness():
    df = spark.read.table("customers")
    total = df.count()
    with_email = df.filter(col("email").isNotNull()).count()
    completeness = with_email / total
    assert completeness >= 0.95, f"Email completeness {completeness} below 95%"
```

## Data Integrity Testing

### Referential Integrity
```python
def test_order_customer_relationship():
    orders = spark.read.table("orders")
    customers = spark.read.table("customers")

    orphaned = orders.join(
        customers,
        orders.customer_id == customers.customer_id,
        "left_anti"
    )

    assert orphaned.count() == 0, "Found orders without valid customer"
```

### Uniqueness Constraints
```python
def test_customer_id_uniqueness():
    df = spark.read.table("customers")
    total_count = df.count()
    distinct_count = df.select("customer_id").distinct().count()
    assert total_count == distinct_count, "Duplicate customer IDs found"
```

## Transformation Testing

### Test Data Transformation Logic
```python
def test_revenue_calculation():
    input_data = [
        (1, 100.0, 2, 10.0),  # order_id, price, quantity, discount
        (2, 50.0, 1, 0.0)
    ]
    df = spark.createDataFrame(input_data, ["order_id", "price", "quantity", "discount"])

    result = calculate_revenue(df)

    expected = [(1, 190.0), (2, 50.0)]
    assert result.collect() == expected
```

## Row Count Validation

```python
def test_etl_row_counts():
    source_count = spark.read.table("raw.orders").count()
    target_count = spark.read.table("curated.orders").count()

    # Allow for some filtering but not excessive loss
    assert target_count >= source_count * 0.95, \
        f"Target count {target_count} too low compared to source {source_count}"
```

## Data Range Validation

```python
def test_order_total_range():
    df = spark.read.table("orders")

    # Check for negative totals
    negative_count = df.filter(col("total") < 0).count()
    assert negative_count == 0, "Found negative order totals"

    # Check for unrealistic values
    too_high = df.filter(col("total") > 1000000).count()
    assert too_high == 0, "Found unrealistically high order totals"
```
