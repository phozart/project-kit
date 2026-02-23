---
name: implementation-auth
description: Authentication and authorization implementation patterns for OAuth2, JWT, and RBAC
---

# Authentication Implementation Skill

Authentication and authorization implementation covering OAuth2, JWT, session-based, and API keys.

## When to Use

- Implementing authentication systems
- "Set up authentication"
- "Implement user login"
- Phase 7 implementation when auth is required

## Authentication Strategies

Choose based on `project.config.yaml` auth settings:

### OAuth2 / OpenID Connect
- Third-party login (Google, GitHub, etc.)
- Enterprise SSO
- Delegated authentication

### JWT (JSON Web Tokens)
- Stateless authentication
- Microservices
- Mobile apps

### Session-Based
- Traditional web apps
- Server-side session storage
- CSRF protection needed

### API Keys
- Service-to-service
- Programmatic access
- Rate limiting

## OAuth2 Patterns

### Authorization Code Flow (Web Apps)

```typescript
// Frontend (Next.js with NextAuth)
// pages/api/auth/[...nextauth].ts
import NextAuth from 'next-auth';
import GoogleProvider from 'next-auth/providers/google';

export default NextAuth({
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    }),
  ],
  callbacks: {
    async jwt({ token, account }) {
      if (account) {
        token.accessToken = account.access_token;
      }
      return token;
    },
    async session({ session, token }) {
      session.accessToken = token.accessToken;
      return session;
    },
  },
});
```

### PKCE Flow (Mobile/SPA)

```typescript
// React Native / SPA
import { useAuth0 } from '@auth0/auth0-react';

function LoginButton() {
  const { loginWithRedirect } = useAuth0();

  return (
    <button onClick={() => loginWithRedirect()}>
      Log In
    </button>
  );
}

function Profile() {
  const { user, isAuthenticated } = useAuth0();

  if (!isAuthenticated) {
    return <div>Not logged in</div>;
  }

  return (
    <div>
      <h2>{user.name}</h2>
      <p>{user.email}</p>
    </div>
  );
}
```

## JWT Implementation

### Backend (Python/FastAPI)

```python
# core/security.py
from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext

SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def create_access_token(data: dict) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def verify_token(token: str) -> dict:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except JWTError:
        return None

# api/v1/auth.py
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

router = APIRouter(prefix="/auth", tags=["auth"])
security = HTTPBearer()

@router.post("/login")
def login(credentials: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == credentials.email).first()

    if not user or not verify_password(credentials.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password"
        )

    access_token = create_access_token({"sub": str(user.id)})
    return {"access_token": access_token, "token_type": "bearer"}

def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
    token = credentials.credentials
    payload = verify_token(token)

    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )

    user_id = payload.get("sub")
    user = db.query(User).filter(User.id == user_id).first()

    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found"
        )

    return user

@router.get("/me")
def get_me(current_user: User = Depends(get_current_user)):
    return current_user
```

### Backend (Java/Spring Boot)

```java
// config/SecurityConfig.java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/auth/**").permitAll()
                .anyRequest().authenticated()
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            .addFilterBefore(jwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}

// security/JwtService.java
@Service
public class JwtService {

    @Value("${jwt.secret}")
    private String secret;

    @Value("${jwt.expiration}")
    private long expiration;

    public String generateToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        return Jwts.builder()
            .setClaims(claims)
            .setSubject(userDetails.getUsername())
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + expiration))
            .signWith(SignatureAlgorithm.HS256, secret)
            .compact();
    }

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public boolean validateToken(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return username.equals(userDetails.getUsername()) && !isTokenExpired(token);
    }

    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }
}
```

### Frontend (React)

```typescript
// hooks/useAuth.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface AuthState {
  token: string | null;
  user: User | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
}

export const useAuth = create<AuthState>()(
  persist(
    (set) => ({
      token: null,
      user: null,

      login: async (email, password) => {
        const response = await fetch('/api/v1/auth/login', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email, password }),
        });

        if (!response.ok) {
          throw new Error('Login failed');
        }

        const { access_token } = await response.json();

        // Fetch user details
        const userResponse = await fetch('/api/v1/auth/me', {
          headers: { 'Authorization': `Bearer ${access_token}` },
        });
        const user = await userResponse.json();

        set({ token: access_token, user });
      },

      logout: () => {
        set({ token: null, user: null });
      },
    }),
    { name: 'auth-storage' }
  )
);

// services/api/client.ts
import axios from 'axios';
import { useAuth } from '@/hooks/useAuth';

const apiClient = axios.create({
  baseURL: '/api/v1',
});

// Add token to requests
apiClient.interceptors.request.use((config) => {
  const token = useAuth.getState().token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle 401 responses
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      useAuth.getState().logout();
    }
    return Promise.reject(error);
  }
);

export default apiClient;
```

## Role-Based Access Control (RBAC)

### Backend (Python)

```python
# models/user.py
from enum import Enum

class Role(str, Enum):
    ADMIN = "admin"
    USER = "user"
    GUEST = "guest"

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True)
    role = Column(Enum(Role), default=Role.USER)

# core/permissions.py
from fastapi import Depends, HTTPException, status

def require_role(required_role: Role):
    def role_checker(current_user: User = Depends(get_current_user)):
        if current_user.role != required_role:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions"
            )
        return current_user
    return role_checker

# Router
@router.delete("/users/{user_id}")
def delete_user(
    user_id: int,
    current_user: User = Depends(require_role(Role.ADMIN))
):
    # Only admins can delete users
    pass
```

### Backend (Java)

```java
// model/User.java
public enum Role {
    ADMIN, USER, GUEST
}

@Entity
public class User {
    @Enumerated(EnumType.STRING)
    private Role role;
}

// config/SecurityConfig.java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests(auth -> auth
        .requestMatchers("/api/v1/admin/**").hasRole("ADMIN")
        .requestMatchers("/api/v1/users/**").hasAnyRole("ADMIN", "USER")
        .anyRequest().authenticated()
    );
    return http.build();
}

// controller/UserController.java
@PreAuthorize("hasRole('ADMIN')")
@DeleteMapping("/{id}")
public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
    userService.deleteUser(id);
    return ResponseEntity.noContent().build();
}
```

## Refresh Tokens

```python
# Create access + refresh tokens
def create_tokens(user_id: int):
    access_token = create_access_token({"sub": str(user_id)})
    refresh_token = create_refresh_token({"sub": str(user_id)})
    return {"access_token": access_token, "refresh_token": refresh_token}

def create_refresh_token(data: dict) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(days=7)
    to_encode.update({"exp": expire, "type": "refresh"})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

# Refresh endpoint
@router.post("/refresh")
def refresh_token(refresh_token: str):
    payload = verify_token(refresh_token)

    if not payload or payload.get("type") != "refresh":
        raise HTTPException(status_code=401, detail="Invalid refresh token")

    user_id = payload.get("sub")
    new_access_token = create_access_token({"sub": user_id})

    return {"access_token": new_access_token}
```

## Quality Gates

Implementation must satisfy:
- Passwords hashed (bcrypt, argon2)
- JWTs signed and verified
- Tokens stored securely (httpOnly cookies or secure storage)
- HTTPS only in production
- CSRF protection for session-based auth
- Rate limiting on login endpoints
- Password requirements enforced
- Account lockout after failed attempts
- Refresh tokens for long-lived sessions

## References

- [OAuth Patterns](references/oauth-patterns.md) - OAuth2 flows
- [JWT Patterns](references/jwt-patterns.md) - JWT implementation
- [RBAC Patterns](references/rbac-patterns.md) - Role-based access control

## Integration

Used by:
- **backend-developer agent**: Implements auth during Phase 7
- **frontend-developer agent**: Integrates auth in UI
- **implementation-nextjs skill**: Middleware patterns
