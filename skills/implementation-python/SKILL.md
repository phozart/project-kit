---
name: implementation-python
description: Python backend implementation with FastAPI, Django, and async patterns
---

# Python Implementation Skill

Python implementation skill covering FastAPI, Django, and async patterns with clean architecture.

## When to Use

- Python backend implementation tasks
- "Build the Python API"
- "Implement Python backend"
- Phase 7 implementation when Python is the chosen language

## Architecture

Clean architecture with three layers:

```
src/
├── api/              # Routers (FastAPI) or Views (Django)
├── services/         # Business logic
├── repositories/     # Data access
├── models/           # Database models
├── schemas/          # Pydantic schemas (TYPE-CONTRACTS)
└── core/             # Config, dependencies
```

### Layer Responsibilities

**API Layer (Routers/Views)**
- HTTP request/response handling
- Input validation
- Authentication/authorization
- Delegate to services

**Service Layer**
- Business logic
- Transaction management
- Orchestrate repositories
- Error handling

**Repository Layer**
- Database queries
- Data access only
- No business logic

## Type Hints Everywhere

MANDATORY: All functions must have type hints.

```python
from typing import Optional, List
from models import User
from schemas import UserCreate, UserResponse

def get_user(user_id: int) -> Optional[User]:
    return db.query(User).filter(User.id == user_id).first()

def get_users(skip: int = 0, limit: int = 100) -> List[User]:
    return db.query(User).offset(skip).limit(limit).all()

def create_user(user_data: UserCreate) -> User:
    user = User(**user_data.dict())
    db.add(user)
    db.commit()
    db.refresh(user)
    return user
```

## FastAPI Implementation

### Project Structure

```
src/
├── api/
│   └── v1/
│       ├── __init__.py
│       ├── users.py
│       └── auth.py
├── services/
│   ├── __init__.py
│   ├── user_service.py
│   └── auth_service.py
├── repositories/
│   ├── __init__.py
│   └── user_repository.py
├── models/
│   ├── __init__.py
│   └── user.py
├── schemas/
│   ├── __init__.py
│   └── user.py
├── core/
│   ├── config.py
│   ├── deps.py
│   └── security.py
└── main.py
```

### Pydantic Schemas (TYPE-CONTRACTS)

```python
# src/schemas/user.py
from pydantic import BaseModel, EmailStr, Field
from datetime import datetime
from typing import Optional

class UserBase(BaseModel):
    email: EmailStr
    first_name: str = Field(..., min_length=1, max_length=100)
    last_name: str = Field(..., min_length=1, max_length=100)

class UserCreate(UserBase):
    password: str = Field(..., min_length=8)

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None

class UserInDB(UserBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class UserResponse(UserInDB):
    pass
```

### Database Models

```python
# src/models/user.py
from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.sql import func
from database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    hashed_password = Column(String, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
```

### Repository Layer

```python
# src/repositories/user_repository.py
from typing import Optional, List
from sqlalchemy.orm import Session
from models.user import User
from schemas.user import UserCreate

class UserRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, user_id: int) -> Optional[User]:
        return self.db.query(User).filter(User.id == user_id).first()

    def get_by_email(self, email: str) -> Optional[User]:
        return self.db.query(User).filter(User.email == email).first()

    def get_all(self, skip: int = 0, limit: int = 100) -> List[User]:
        return self.db.query(User).offset(skip).limit(limit).all()

    def create(self, user_data: UserCreate, hashed_password: str) -> User:
        user = User(
            email=user_data.email,
            first_name=user_data.first_name,
            last_name=user_data.last_name,
            hashed_password=hashed_password,
        )
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        return user

    def delete(self, user_id: int) -> bool:
        user = self.get_by_id(user_id)
        if user:
            self.db.delete(user)
            self.db.commit()
            return True
        return False
```

### Service Layer

```python
# src/services/user_service.py
from typing import Optional, List
from sqlalchemy.orm import Session
from repositories.user_repository import UserRepository
from schemas.user import UserCreate, UserUpdate, UserResponse
from core.security import get_password_hash
from fastapi import HTTPException, status

class UserService:
    def __init__(self, db: Session):
        self.repository = UserRepository(db)

    def get_user(self, user_id: int) -> UserResponse:
        user = self.repository.get_by_id(user_id)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        return UserResponse.from_orm(user)

    def get_users(self, skip: int = 0, limit: int = 100) -> List[UserResponse]:
        users = self.repository.get_all(skip=skip, limit=limit)
        return [UserResponse.from_orm(user) for user in users]

    def create_user(self, user_data: UserCreate) -> UserResponse:
        # Check if user exists
        existing_user = self.repository.get_by_email(user_data.email)
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )

        # Hash password
        hashed_password = get_password_hash(user_data.password)

        # Create user
        user = self.repository.create(user_data, hashed_password)
        return UserResponse.from_orm(user)

    def delete_user(self, user_id: int) -> None:
        if not self.repository.delete(user_id):
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
```

### API Router

```python
# src/api/v1/users.py
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from core.deps import get_db
from services.user_service import UserService
from schemas.user import UserCreate, UserResponse

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/", response_model=List[UserResponse])
def get_users(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    service = UserService(db)
    return service.get_users(skip=skip, limit=limit)

@router.get("/{user_id}", response_model=UserResponse)
def get_user(user_id: int, db: Session = Depends(get_db)):
    service = UserService(db)
    return service.get_user(user_id)

@router.post("/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def create_user(user_data: UserCreate, db: Session = Depends(get_db)):
    service = UserService(db)
    return service.create_user(user_data)

@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user(user_id: int, db: Session = Depends(get_db)):
    service = UserService(db)
    service.delete_user(user_id)
```

### Main Application

```python
# src/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api.v1 import users, auth
from core.config import settings

app = FastAPI(title=settings.PROJECT_NAME, version="1.0.0")

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(users.router, prefix="/api/v1")
app.include_router(auth.router, prefix="/api/v1")

@app.get("/health")
def health_check():
    return {"status": "healthy"}
```

## Django Implementation

### Project Structure

```
src/
├── apps/
│   └── users/
│       ├── models.py
│       ├── views.py
│       ├── serializers.py
│       ├── services.py
│       ├── repositories.py
│       └── urls.py
├── core/
│   ├── settings.py
│   └── urls.py
└── manage.py
```

### Serializers (TYPE-CONTRACTS)

```python
# apps/users/serializers.py
from rest_framework import serializers
from .models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'first_name', 'last_name', 'created_at']
        read_only_fields = ['id', 'created_at']

class CreateUserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = User
        fields = ['email', 'first_name', 'last_name', 'password']

    def create(self, validated_data):
        return User.objects.create_user(**validated_data)
```

### Views

```python
# apps/users/views.py
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import User
from .serializers import UserSerializer, CreateUserSerializer
from .services import UserService

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    def get_serializer_class(self):
        if self.action == 'create':
            return CreateUserSerializer
        return UserSerializer

    def create(self, request):
        service = UserService()
        user = service.create_user(request.data)
        serializer = self.get_serializer(user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
```

## Async Patterns

```python
# Async route handler
@router.get("/users/{user_id}")
async def get_user(user_id: int, db: AsyncSession = Depends(get_async_db)):
    service = UserService(db)
    return await service.get_user_async(user_id)

# Async service
class UserService:
    async def get_user_async(self, user_id: int) -> UserResponse:
        user = await self.repository.get_by_id_async(user_id)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        return UserResponse.from_orm(user)

# Async repository
class UserRepository:
    async def get_by_id_async(self, user_id: int) -> Optional[User]:
        result = await self.db.execute(
            select(User).where(User.id == user_id)
        )
        return result.scalar_one_or_none()
```

## Quality Gates

Implementation must satisfy:
- Type hints on all functions
- Clean architecture (routers → services → repositories)
- Pydantic models for validation
- No business logic in routers/views
- Constructor injection for dependencies
- All TYPE-CONTRACTS imported from schemas
- Proper error handling with HTTP exceptions
- Database sessions managed properly

## Anti-Patterns to Avoid

- Business logic in routers/views
- Direct database access from routers
- Missing type hints
- Mutable default arguments
- Circular imports
- God classes

## References

- [Python Patterns](references/python-patterns.md) - Python project patterns
- [FastAPI Conventions](references/fastapi-conventions.md) - FastAPI patterns
- [Django Conventions](references/django-conventions.md) - Django patterns
- [Async Patterns](references/async-patterns.md) - Async/await patterns

## Integration

Used by:
- **backend-developer agent**: Primary consumer during Phase 7
- **api-design skill**: Imports TYPE-CONTRACTS from schemas
- **implementation-database skill**: Uses repository patterns
