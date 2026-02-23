# Python Patterns

Python project structure, typing, and async patterns.

## Project Structure

### FastAPI Project

```
project/
├── src/
│   ├── api/
│   │   └── v1/
│   │       ├── __init__.py
│   │       ├── users.py
│   │       └── auth.py
│   ├── services/
│   │   ├── __init__.py
│   │   └── user_service.py
│   ├── repositories/
│   │   ├── __init__.py
│   │   └── user_repository.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── user.py
│   ├── schemas/
│   │   ├── __init__.py
│   │   └── user.py
│   ├── core/
│   │   ├── config.py
│   │   ├── deps.py
│   │   └── security.py
│   ├── database.py
│   └── main.py
├── tests/
├── alembic/
├── pyproject.toml
└── README.md
```

### Django Project

```
project/
├── apps/
│   ├── users/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── serializers.py
│   │   ├── services.py
│   │   └── urls.py
│   └── orders/
├── core/
│   ├── settings.py
│   └── urls.py
├── manage.py
└── requirements.txt
```

## Type Hints

### Basic Types

```python
from typing import Optional, List, Dict, Tuple, Union, Any

# Simple types
name: str = "John"
age: int = 30
price: float = 19.99
active: bool = True

# Collections
users: List[str] = ["Alice", "Bob"]
scores: Dict[str, int] = {"Alice": 100, "Bob": 95}
coords: Tuple[float, float] = (1.0, 2.0)

# Optional (can be None)
middle_name: Optional[str] = None

# Union (one of multiple types)
user_id: Union[int, str] = "user-123"

# Any (avoid when possible)
data: Any = {"key": "value"}
```

### Function Signatures

```python
from typing import List, Optional

def get_user(user_id: int) -> Optional[User]:
    """Get user by ID."""
    return db.query(User).filter(User.id == user_id).first()

def get_users(skip: int = 0, limit: int = 100) -> List[User]:
    """Get list of users with pagination."""
    return db.query(User).offset(skip).limit(limit).all()

async def create_user(user_data: UserCreate) -> User:
    """Create new user (async)."""
    user = User(**user_data.dict())
    await db.add(user)
    await db.commit()
    return user
```

### Generic Types

```python
from typing import TypeVar, Generic, List

T = TypeVar('T')

class Repository(Generic[T]):
    def __init__(self, model: type[T]):
        self.model = model

    def get_all(self) -> List[T]:
        return db.query(self.model).all()

    def get_by_id(self, id: int) -> Optional[T]:
        return db.query(self.model).filter(self.model.id == id).first()

# Usage
user_repo = Repository[User](User)
users = user_repo.get_all()
```

### Type Aliases

```python
from typing import Dict, List

# Type alias
UserId = int
UserDict = Dict[str, any]
UserList = List[User]

def get_user(user_id: UserId) -> UserDict:
    pass
```

## Error Handling

### Custom Exceptions

```python
# exceptions.py
class AppException(Exception):
    """Base exception for application."""
    pass

class NotFoundError(AppException):
    """Resource not found."""
    pass

class ValidationError(AppException):
    """Validation failed."""
    pass

class UnauthorizedError(AppException):
    """Unauthorized access."""
    pass
```

### Try-Except Patterns

```python
from fastapi import HTTPException, status

def get_user(user_id: int) -> User:
    try:
        user = repository.get_by_id(user_id)
        if not user:
            raise NotFoundError(f"User {user_id} not found")
        return user
    except NotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )
```

## Dependency Injection

### FastAPI Dependencies

```python
# core/deps.py
from sqlalchemy.orm import Session
from database import SessionLocal

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Router
@router.get("/users/{user_id}")
def get_user(user_id: int, db: Session = Depends(get_db)):
    service = UserService(db)
    return service.get_user(user_id)
```

### Class-Based Dependencies

```python
from fastapi import Depends

class UserService:
    def __init__(self, db: Session = Depends(get_db)):
        self.db = db
        self.repository = UserRepository(db)

    def get_user(self, user_id: int) -> User:
        return self.repository.get_by_id(user_id)

# Router
@router.get("/users/{user_id}")
def get_user(user_id: int, service: UserService = Depends()):
    return service.get_user(user_id)
```

## Environment Configuration

```python
# core/config.py
from pydantic_settings import BaseSettings
from typing import List

class Settings(BaseSettings):
    PROJECT_NAME: str = "My API"
    DATABASE_URL: str
    SECRET_KEY: str
    ALLOWED_ORIGINS: List[str] = ["http://localhost:3000"]
    DEBUG: bool = False

    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
```

```env
# .env
PROJECT_NAME=My API
DATABASE_URL=postgresql://user:pass@localhost/dbname
SECRET_KEY=supersecretkey
ALLOWED_ORIGINS=["http://localhost:3000","http://localhost:8000"]
DEBUG=True
```

## Logging

```python
import logging
from logging.handlers import RotatingFileHandler

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        RotatingFileHandler('app.log', maxBytes=10000000, backupCount=5),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

# Usage
logger.info("User created: %s", user.email)
logger.warning("Invalid login attempt: %s", email)
logger.error("Database error: %s", str(e))
```

## Data Classes

```python
from dataclasses import dataclass
from datetime import datetime

@dataclass
class User:
    id: int
    email: str
    first_name: str
    last_name: str
    created_at: datetime

    @property
    def full_name(self) -> str:
        return f"{self.first_name} {self.last_name}"

# Usage
user = User(
    id=1,
    email="john@example.com",
    first_name="John",
    last_name="Doe",
    created_at=datetime.now()
)
print(user.full_name)  # "John Doe"
```

## Context Managers

```python
from contextlib import contextmanager
from sqlalchemy.orm import Session

@contextmanager
def get_db_session():
    session = SessionLocal()
    try:
        yield session
        session.commit()
    except Exception:
        session.rollback()
        raise
    finally:
        session.close()

# Usage
with get_db_session() as db:
    user = db.query(User).first()
```

## Best Practices

1. **Type Hints**: Always use type hints
2. **F-Strings**: Use f-strings for formatting
3. **List Comprehensions**: Prefer over loops when readable
4. **Context Managers**: Use for resource management
5. **Generators**: Use for large datasets
6. **Dataclasses**: Use for simple data containers
7. **Enums**: Use for fixed sets of values
8. **Pathlib**: Use pathlib instead of os.path
9. **Avoid Mutable Defaults**: Never use mutable default arguments
10. **Error Handling**: Always handle exceptions appropriately
