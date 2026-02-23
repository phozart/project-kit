# Data Engineering Stack Configurations

Common patterns and configurations for data engineering and analytics stacks.

## Databricks Stack

**Typical Setup**:
- Databricks workspace
- Delta Lake tables
- Unity Catalog (governance)
- Databricks SQL (analytics)
- MLflow (ML lifecycle)

**Commands**:
```yaml
build: databricks bundle deploy
test: pytest tests/ --databricks
lint: pylint src/ && black --check src/
dev: databricks bundle run <job-name> --no-wait
```

**Project Structure**:
```
src/
  notebooks/
    etl/
    analytics/
  jobs/
    bronze_ingestion.py
    silver_transformation.py
    gold_aggregation.py
  pipelines/
    dlt_pipeline.py
  utils/
    spark_helpers.py
tests/
databricks.yml
requirements.txt
```

**Typical databricks.yml**:
```yaml
bundle:
  name: project-name
resources:
  jobs:
    etl_job:
      name: ETL Pipeline
      tasks:
        - task_key: bronze
          python_wheel_task:
            package_name: project_name
            entry_point: bronze_ingestion
```

## Snowflake Stack

**Typical Setup**:
- Snowflake warehouse
- dbt for transformations
- Airflow/Prefect for orchestration
- Python connectors

**Commands**:
```yaml
build: dbt deps && dbt compile
test: dbt test
lint: sqlfluff lint models/
dev: dbt run --select <model>
```

**Project Structure**:
```
dbt_project/
  models/
    staging/
    intermediate/
    marts/
  tests/
  macros/
  dbt_project.yml
airflow/
  dags/
  plugins/
```

## BigQuery Stack

**Typical Setup**:
- BigQuery datasets
- Cloud Dataflow (Apache Beam)
- Cloud Composer (Airflow)
- dbt Cloud or dbt Core

**Commands**:
```yaml
build: dbt deps && dbt compile
test: dbt test && pytest tests/
lint: sqlfluff lint models/
dev: dbt run --target dev
```

**Project Structure**:
```
sql/
  ddl/
  dml/
dataflow/
  pipelines/
    beam_pipeline.py
dbt/
  models/
tests/
```

## Apache Airflow Stack

**Typical Dependencies**:
- apache-airflow
- apache-airflow-providers-* (various)
- sqlalchemy
- pandas

**Commands**:
```yaml
build: pip install -r requirements.txt
test: pytest tests/
lint: pylint dags/ && black --check dags/
dev: airflow standalone
```

**Project Structure**:
```
dags/
  data_pipeline_dag.py
  ml_training_dag.py
plugins/
  operators/
  sensors/
  hooks/
tests/
airflow.cfg
```

## dbt Stack

**Commands**:
```yaml
build: dbt deps && dbt compile
test: dbt test
lint: sqlfluff lint models/
dev: dbt run
```

**Project Structure**:
```
models/
  staging/
    stg_<source>__<entity>.sql
  intermediate/
    int_<entity>__<verb>.sql
  marts/
    <domain>/
      fct_<entity>.sql
      dim_<entity>.sql
tests/
  <custom_tests>.sql
macros/
  <custom_macros>.sql
seeds/
  <reference_data>.csv
dbt_project.yml
profiles.yml
```

**Typical dbt_project.yml**:
```yaml
name: project_name
version: '1.0.0'
config-version: 2

profile: project_name

model-paths: ["models"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]

models:
  project_name:
    staging:
      +materialized: view
    intermediate:
      +materialized: ephemeral
    marts:
      +materialized: table
```

## Common Data Engineering Tooling

**Orchestration**:
- Apache Airflow (traditional)
- Prefect (modern, Python-first)
- Dagster (asset-oriented)
- Databricks Workflows

**Transformation**:
- dbt (SQL-based)
- Apache Spark (large-scale)
- Pandas (in-memory)
- Polars (fast dataframes)

**Quality & Testing**:
- Great Expectations (data quality)
- dbt tests (built-in)
- sqlfluff (SQL linting)
- pytest (Python testing)

**Data Formats**:
- Parquet (columnar, efficient)
- Delta Lake (ACID on data lake)
- Iceberg (table format)
- Avro (row-based, schema evolution)
