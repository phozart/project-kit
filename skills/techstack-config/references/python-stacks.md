# Python Stack Configurations

Common patterns and configurations for Python-based stacks.

## FastAPI Stack

**Typical Dependencies**:
- fastapi
- uvicorn[standard]
- pydantic
- sqlalchemy (ORM)
- alembic (migrations)
- pytest
- httpx (testing)

**Commands**:
```yaml
build: pip install -r requirements.txt
test: pytest tests/ -v
lint: pylint src/ && black --check src/ && mypy src/
dev: uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Project Structure**:
```
src/
  main.py
  api/
    routes/
    dependencies.py
  models/
  schemas/
  services/
  core/
    config.py
    database.py
tests/
requirements.txt
requirements-dev.txt
```

## Django Stack

**Typical Dependencies**:
- django
- djangorestframework (for APIs)
- django-environ
- psycopg2-binary (PostgreSQL)
- pytest-django
- django-cors-headers

**Commands**:
```yaml
build: pip install -r requirements.txt && python manage.py migrate
test: pytest
lint: pylint src/ && black --check src/
dev: python manage.py runserver 0.0.0.0:8000
```

**Project Structure**:
```
src/
  manage.py
  config/
    settings.py
    urls.py
  apps/
    <app_name>/
      models.py
      views.py
      serializers.py
      urls.py
tests/
requirements.txt
```

## Flask Stack

**Typical Dependencies**:
- flask
- flask-sqlalchemy
- flask-migrate
- flask-cors
- marshmallow (serialization)
- pytest
- pytest-flask

**Commands**:
```yaml
build: pip install -r requirements.txt
test: pytest tests/
lint: pylint src/ && black --check src/
dev: flask run --host=0.0.0.0 --port=5000 --debug
```

**Project Structure**:
```
src/
  app/
    __init__.py
    routes/
    models/
    schemas/
    services/
  config.py
tests/
requirements.txt
```

## Common Python Tooling

**Linting & Formatting**:
- pylint or flake8
- black (formatter)
- isort (import sorting)
- mypy (type checking)

**Testing**:
- pytest (primary framework)
- pytest-cov (coverage)
- pytest-mock (mocking)
- httpx or requests-mock (API testing)

**Dev Dependencies**:
```
pytest
pytest-cov
pytest-mock
black
pylint
mypy
isort
```

**Typical requirements.txt structure**:
```
# Production dependencies
requirements.txt

# Development dependencies
requirements-dev.txt
```
