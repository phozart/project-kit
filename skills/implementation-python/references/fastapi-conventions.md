# FastAPI Conventions

FastAPI patterns for routers, dependencies, middleware, and Pydantic models.

## Router Organization

### Versioned API

```python
# api/v1/users.py
from fastapi import APIRouter

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/")
def get_users():
    pass

@router.get("/{user_id}")
def get_user(user_id: int):
    pass

# main.py
from api.v1 import users

app = FastAPI()
app.include_router(users.router, prefix="/api/v1")
```

### Router with Dependencies

```python
from fastapi import APIRouter, Depends
from core.auth import get_current_user

router = APIRouter(
    prefix="/users",
    tags=["users"],
    dependencies=[Depends(get_current_user)]  # Applied to all routes
)

@router.get("/")
def get_users():
    # get_current_user already called
    pass
```

## Pydantic Models

### Base Model Patterns

```python
from pydantic import BaseModel, EmailStr, Field, validator
from datetime import datetime
from typing import Optional

class UserBase(BaseModel):
    email: EmailStr
    first_name: str = Field(..., min_length=1, max_length=100)
    last_name: str = Field(..., min_length=1, max_length=100)

class UserCreate(UserBase):
    password: str = Field(..., min_length=8, max_length=100)

    @validator('password')
    def validate_password(cls, v):
        if not any(char.isdigit() for char in v):
            raise ValueError('Password must contain at least one digit')
        if not any(char.isupper() for char in v):
            raise ValueError('Password must contain at least one uppercase letter')
        return v

class UserUpdate(BaseModel):
    first_name: Optional[str] = Field(None, min_length=1, max_length=100)
    last_name: Optional[str] = Field(None, min_length=1, max_length=100)

class UserInDB(UserBase):
    id: int
    hashed_password: str
    created_at: datetime
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True  # Formerly orm_mode

class UserResponse(BaseModel):
    id: int
    email: EmailStr
    first_name: str
    last_name: str
    created_at: datetime

    class Config:
        from_attributes = True
```

### Nested Models

```python
class Address(BaseModel):
    street: str
    city: str
    state: str
    zip_code: str

class UserWithAddress(UserResponse):
    address: Optional[Address] = None

class CreateUserWithAddress(UserCreate):
    address: Address
```

## Response Models

```python
from typing import List, Generic, TypeVar
from pydantic import BaseModel

T = TypeVar('T')

class PaginatedResponse(BaseModel, Generic[T]):
    data: List[T]
    total: int
    page: int
    page_size: int
    pages: int

# Usage
@router.get("/users", response_model=PaginatedResponse[UserResponse])
def get_users(page: int = 1, page_size: int = 20):
    users = service.get_users(page, page_size)
    total = service.count_users()
    return {
        "data": users,
        "total": total,
        "page": page,
        "page_size": page_size,
        "pages": (total + page_size - 1) // page_size
    }
```

## Dependency Injection

### Database Session

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
    return db.query(User).filter(User.id == user_id).first()
```

### Current User

```python
# core/auth.py
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

security = HTTPBearer()

def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
    token = credentials.credentials
    payload = decode_jwt(token)
    user_id = payload.get("sub")

    if not user_id:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found"
        )

    return user

# Router
@router.get("/me")
def get_me(current_user: User = Depends(get_current_user)):
    return current_user
```

### Reusable Dependencies

```python
from typing import Optional

def pagination(page: int = 1, page_size: int = 20):
    return {"skip": (page - 1) * page_size, "limit": page_size}

def filter_params(
    status: Optional[str] = None,
    created_after: Optional[datetime] = None
):
    return {"status": status, "created_after": created_after}

# Router
@router.get("/users")
def get_users(
    pagination: dict = Depends(pagination),
    filters: dict = Depends(filter_params),
    db: Session = Depends(get_db)
):
    return service.get_users(db, **pagination, **filters)
```

## Middleware

### CORS

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Custom Middleware

```python
from fastapi import Request
import time

@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    response.headers["X-Process-Time"] = str(process_time)
    return response
```

### Request Logging

```python
import logging

logger = logging.getLogger(__name__)

@app.middleware("http")
async def log_requests(request: Request, call_next):
    logger.info(f"{request.method} {request.url}")
    response = await call_next(request)
    logger.info(f"Status: {response.status_code}")
    return response
```

## Exception Handling

### Custom Exception Handler

```python
from fastapi import HTTPException, Request
from fastapi.responses import JSONResponse

class AppException(Exception):
    def __init__(self, detail: str):
        self.detail = detail

@app.exception_handler(AppException)
async def app_exception_handler(request: Request, exc: AppException):
    return JSONResponse(
        status_code=400,
        content={"error": {"message": exc.detail}}
    )

@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"error": {"message": exc.detail}}
    )
```

## Background Tasks

```python
from fastapi import BackgroundTasks

def send_email(email: str, message: str):
    # Send email logic
    print(f"Sending email to {email}: {message}")

@router.post("/users")
def create_user(
    user: UserCreate,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db)
):
    new_user = service.create_user(db, user)
    background_tasks.add_task(send_email, new_user.email, "Welcome!")
    return new_user
```

## File Uploads

```python
from fastapi import File, UploadFile
from typing import List

@router.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    contents = await file.read()
    # Process file
    return {"filename": file.filename, "size": len(contents)}

@router.post("/upload-multiple")
async def upload_files(files: List[UploadFile] = File(...)):
    return [{"filename": file.filename} for file in files]
```

## Testing

```python
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_get_users():
    response = client.get("/api/v1/users")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_create_user():
    user_data = {
        "email": "test@example.com",
        "first_name": "Test",
        "last_name": "User",
        "password": "Password123"
    }
    response = client.post("/api/v1/users", json=user_data)
    assert response.status_code == 201
    assert response.json()["email"] == user_data["email"]
```

## Best Practices

1. Use response_model for automatic serialization
2. Leverage dependency injection for reusability
3. Validate inputs with Pydantic models
4. Use background tasks for async operations
5. Implement proper error handling
6. Add middleware for cross-cutting concerns
7. Use routers to organize endpoints
8. Type hint everything
9. Use async when doing I/O operations
10. Write tests with TestClient
