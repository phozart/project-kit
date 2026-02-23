# Async Patterns

Asyncio patterns for concurrent execution and background tasks.

## Async/Await Basics

```python
import asyncio

async def fetch_user(user_id: int) -> User:
    """Async function - returns coroutine."""
    await asyncio.sleep(1)  # Simulating I/O
    return User(id=user_id, name="John")

# Run async function
user = await fetch_user(1)

# Run from sync code
user = asyncio.run(fetch_user(1))
```

## Concurrent Execution

### asyncio.gather

```python
async def fetch_users():
    # Run concurrently
    users = await asyncio.gather(
        fetch_user(1),
        fetch_user(2),
        fetch_user(3)
    )
    return users

# Returns: [User(1), User(2), User(3)]
```

### asyncio.create_task

```python
async def main():
    # Create tasks
    task1 = asyncio.create_task(fetch_user(1))
    task2 = asyncio.create_task(fetch_user(2))

    # Do other work
    print("Tasks running in background")

    # Wait for results
    user1 = await task1
    user2 = await task2
```

### TaskGroup (Python 3.11+)

```python
async def main():
    async with asyncio.TaskGroup() as tg:
        task1 = tg.create_task(fetch_user(1))
        task2 = tg.create_task(fetch_user(2))

    # All tasks completed here
    print("All tasks done")
```

## FastAPI Async

### Async Routes

```python
from fastapi import FastAPI
import httpx

app = FastAPI()

@app.get("/users/{user_id}")
async def get_user(user_id: int):
    # Async HTTP call
    async with httpx.AsyncClient() as client:
        response = await client.get(f"https://api.example.com/users/{user_id}")
        return response.json()
```

### Async Database

```python
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.ext.asyncio import async_sessionmaker

# Create async engine
engine = create_async_engine(
    "postgresql+asyncpg://user:pass@localhost/db",
    echo=True
)

# Create async session maker
async_session = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

# Dependency
async def get_db():
    async with async_session() as session:
        yield session

# Repository
class UserRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_by_id(self, user_id: int) -> Optional[User]:
        result = await self.db.execute(
            select(User).where(User.id == user_id)
        )
        return result.scalar_one_or_none()

    async def get_all(self) -> List[User]:
        result = await self.db.execute(select(User))
        return result.scalars().all()

    async def create(self, user: User) -> User:
        self.db.add(user)
        await self.db.commit()
        await self.db.refresh(user)
        return user

# Route
@app.get("/users/{user_id}")
async def get_user(user_id: int, db: AsyncSession = Depends(get_db)):
    repo = UserRepository(db)
    user = await repo.get_by_id(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
```

## Background Tasks

### FastAPI Background Tasks

```python
from fastapi import BackgroundTasks

def send_email(email: str, message: str):
    # Sync function runs in thread pool
    print(f"Sending email to {email}")
    time.sleep(2)  # Simulate sending
    print("Email sent")

async def async_send_email(email: str, message: str):
    # Async function
    print(f"Sending email to {email}")
    await asyncio.sleep(2)
    print("Email sent")

@app.post("/users")
async def create_user(
    user: UserCreate,
    background_tasks: BackgroundTasks
):
    # Add sync background task
    background_tasks.add_task(send_email, user.email, "Welcome!")

    # Or async task
    # background_tasks.add_task(async_send_email, user.email, "Welcome!")

    return {"message": "User created"}
```

### Celery (Production Background Tasks)

```python
from celery import Celery

app = Celery('tasks', broker='redis://localhost:6379/0')

@app.task
def send_email_task(email: str, message: str):
    # This runs in a separate worker
    print(f"Sending email to {email}")
    time.sleep(2)
    print("Email sent")

# Trigger from FastAPI
@router.post("/users")
def create_user(user: UserCreate):
    # Send task to Celery
    send_email_task.delay(user.email, "Welcome!")
    return {"message": "User created"}
```

## Async Context Managers

```python
class AsyncDatabase:
    async def __aenter__(self):
        self.connection = await create_connection()
        return self.connection

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        await self.connection.close()

# Usage
async def fetch_data():
    async with AsyncDatabase() as conn:
        result = await conn.execute("SELECT * FROM users")
        return result
```

## Async Generators

```python
async def fetch_users_stream():
    for user_id in range(1, 11):
        user = await fetch_user(user_id)
        yield user
        await asyncio.sleep(0.1)

# Consume
async def main():
    async for user in fetch_users_stream():
        print(user)

# Or collect all
users = [user async for user in fetch_users_stream()]
```

## Error Handling

### asyncio.gather with return_exceptions

```python
async def main():
    results = await asyncio.gather(
        fetch_user(1),
        fetch_user(999),  # This might fail
        fetch_user(3),
        return_exceptions=True
    )

    for i, result in enumerate(results):
        if isinstance(result, Exception):
            print(f"Task {i} failed: {result}")
        else:
            print(f"Task {i} succeeded: {result}")
```

### Try-Except in Async

```python
async def fetch_user_safe(user_id: int) -> Optional[User]:
    try:
        user = await fetch_user(user_id)
        return user
    except HTTPException as e:
        logger.error(f"Failed to fetch user {user_id}: {e}")
        return None
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        return None
```

## Timeouts

```python
import asyncio

async def fetch_with_timeout(user_id: int) -> User:
    try:
        user = await asyncio.wait_for(fetch_user(user_id), timeout=5.0)
        return user
    except asyncio.TimeoutError:
        raise HTTPException(status_code=504, detail="Request timeout")
```

## Async Locks

```python
lock = asyncio.Lock()

async def critical_section():
    async with lock:
        # Only one coroutine at a time
        await asyncio.sleep(1)
        print("Critical work done")

# Or manual
await lock.acquire()
try:
    await asyncio.sleep(1)
finally:
    lock.release()
```

## Semaphore (Rate Limiting)

```python
sem = asyncio.Semaphore(5)  # Max 5 concurrent

async def fetch_user_limited(user_id: int):
    async with sem:
        return await fetch_user(user_id)

# Only 5 concurrent fetches
users = await asyncio.gather(*[
    fetch_user_limited(i) for i in range(100)
])
```

## When to Use Async

### Use Async For:
- I/O-bound operations (HTTP, database, file I/O)
- Many concurrent operations
- WebSocket connections
- Streaming data

### Don't Use Async For:
- CPU-bound operations (use multiprocessing)
- Simple CRUD with minimal I/O
- When all dependencies are sync

### Example: Mixed Sync/Async

```python
import asyncio
from concurrent.futures import ThreadPoolExecutor

executor = ThreadPoolExecutor()

def cpu_intensive_task(data):
    # CPU-bound work (sync)
    result = complex_calculation(data)
    return result

async def process_data(data):
    # Run CPU-intensive task in thread pool
    loop = asyncio.get_event_loop()
    result = await loop.run_in_executor(executor, cpu_intensive_task, data)
    return result

@app.post("/process")
async def process_endpoint(data: DataInput):
    result = await process_data(data)
    return {"result": result}
```

## Best Practices

1. Use async for I/O-bound operations
2. Always await async functions
3. Use asyncio.gather for concurrent execution
4. Handle exceptions properly
5. Use timeouts to prevent hanging
6. Use semaphores for rate limiting
7. Don't block the event loop (no time.sleep in async)
8. Use async database drivers (asyncpg, motor)
9. Background tasks for fire-and-forget operations
10. Celery for production background jobs
