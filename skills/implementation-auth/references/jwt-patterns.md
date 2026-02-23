# JWT Patterns

JWT creation, validation, and refresh token strategies.

## JWT Structure

```
header.payload.signature
```

**Header**
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

**Payload (Claims)**
```json
{
  "sub": "1234567890",        // Subject (user ID)
  "name": "John Doe",
  "email": "john@example.com",
  "role": "admin",
  "iat": 1516239022,          // Issued at
  "exp": 1516242622           // Expiration
}
```

**Signature**
```
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  secret
)
```

## Creating JWTs

### Python (PyJWT)

```python
from datetime import datetime, timedelta
from jose import jwt

SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

def create_access_token(user_id: int, role: str) -> str:
    payload = {
        "sub": str(user_id),
        "role": role,
        "iat": datetime.utcnow(),
        "exp": datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    return token

def create_refresh_token(user_id: int) -> str:
    payload = {
        "sub": str(user_id),
        "type": "refresh",
        "iat": datetime.utcnow(),
        "exp": datetime.utcnow() + timedelta(days=7)
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    return token
```

### Node.js (jsonwebtoken)

```typescript
import jwt from 'jsonwebtoken';

const SECRET_KEY = process.env.JWT_SECRET!;

export function createAccessToken(userId: string, role: string): string {
  return jwt.sign(
    { sub: userId, role },
    SECRET_KEY,
    { expiresIn: '30m', algorithm: 'HS256' }
  );
}

export function createRefreshToken(userId: string): string {
  return jwt.sign(
    { sub: userId, type: 'refresh' },
    SECRET_KEY,
    { expiresIn: '7d', algorithm: 'HS256' }
  );
}
```

### Java (jjwt)

```java
import io.jsonwebtoken.*;
import java.util.Date;

public String createAccessToken(Long userId, String role) {
    Date now = new Date();
    Date expiry = new Date(now.getTime() + 1800000); // 30 minutes

    return Jwts.builder()
        .setSubject(userId.toString())
        .claim("role", role)
        .setIssuedAt(now)
        .setExpiration(expiry)
        .signWith(SignatureAlgorithm.HS256, SECRET_KEY)
        .compact();
}
```

## Validating JWTs

### Python

```python
from jose import JWTError, jwt
from fastapi import HTTPException, status

def verify_token(token: str) -> dict:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])

        # Check expiration (automatic)
        # Check custom claims
        if payload.get("type") == "refresh":
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Refresh token cannot be used for access"
            )

        return payload

    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token has expired"
        )
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )
```

### Node.js

```typescript
import jwt from 'jsonwebtoken';

interface TokenPayload {
  sub: string;
  role: string;
  iat: number;
  exp: number;
}

export function verifyToken(token: string): TokenPayload {
  try {
    const payload = jwt.verify(token, SECRET_KEY) as TokenPayload;
    return payload;
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      throw new Error('Token has expired');
    }
    throw new Error('Invalid token');
  }
}
```

### Java

```java
public Claims verifyToken(String token) {
    try {
        return Jwts.parser()
            .setSigningKey(SECRET_KEY)
            .parseClaimsJws(token)
            .getBody();
    } catch (ExpiredJwtException e) {
        throw new UnauthorizedException("Token has expired");
    } catch (JwtException e) {
        throw new UnauthorizedException("Invalid token");
    }
}
```

## Middleware/Filters

### FastAPI

```python
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
    token = credentials.credentials
    payload = verify_token(token)
    user_id = payload.get("sub")

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found"
        )

    return user

# Use in route
@router.get("/protected")
async def protected_route(current_user: User = Depends(get_current_user)):
    return {"message": f"Hello {current_user.email}"}
```

### Express.js

```typescript
import { Request, Response, NextFunction } from 'express';

export function authMiddleware(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'No token provided' });
  }

  const token = authHeader.substring(7);

  try {
    const payload = verifyToken(token);
    req.user = { id: payload.sub, role: payload.role };
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}

// Use in route
app.get('/protected', authMiddleware, (req, res) => {
  res.json({ message: `Hello user ${req.user.id}` });
});
```

### Spring Boot

```java
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtService jwtService;

    @Autowired
    private UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(
        HttpServletRequest request,
        HttpServletResponse response,
        FilterChain filterChain
    ) throws ServletException, IOException {

        String authHeader = request.getHeader("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);
        String username = jwtService.extractUsername(token);

        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);

            if (jwtService.validateToken(token, userDetails)) {
                UsernamePasswordAuthenticationToken authToken =
                    new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities()
                    );
                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }
        }

        filterChain.doFilter(request, response);
    }
}
```

## Refresh Token Strategy

### Storing Refresh Tokens

```python
# models/refresh_token.py
class RefreshToken(Base):
    __tablename__ = "refresh_tokens"

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    token = Column(String, unique=True, nullable=False)
    expires_at = Column(DateTime, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

# service/auth_service.py
def create_refresh_token_record(user_id: int, db: Session) -> str:
    token = create_refresh_token(user_id)

    refresh_token = RefreshToken(
        user_id=user_id,
        token=token,
        expires_at=datetime.utcnow() + timedelta(days=7)
    )
    db.add(refresh_token)
    db.commit()

    return token

def rotate_refresh_token(old_token: str, db: Session) -> dict:
    # Find and delete old token
    token_record = db.query(RefreshToken).filter(
        RefreshToken.token == old_token
    ).first()

    if not token_record or token_record.expires_at < datetime.utcnow():
        raise HTTPException(status_code=401, detail="Invalid refresh token")

    user_id = token_record.user_id
    db.delete(token_record)
    db.commit()

    # Create new tokens
    access_token = create_access_token(user_id)
    refresh_token = create_refresh_token_record(user_id, db)

    return {
        "access_token": access_token,
        "refresh_token": refresh_token
    }
```

## Token Blacklisting

```python
# For logout or token revocation
class TokenBlacklist(Base):
    __tablename__ = "token_blacklist"

    id = Column(Integer, primary_key=True)
    token = Column(String, unique=True, nullable=False)
    expires_at = Column(DateTime, nullable=False)

def blacklist_token(token: str, db: Session):
    payload = verify_token(token)
    expires_at = datetime.fromtimestamp(payload['exp'])

    blacklisted = TokenBlacklist(token=token, expires_at=expires_at)
    db.add(blacklisted)
    db.commit()

def is_token_blacklisted(token: str, db: Session) -> bool:
    return db.query(TokenBlacklist).filter(
        TokenBlacklist.token == token
    ).first() is not None
```

## Signing Algorithms

### Symmetric (HMAC)

- HS256 (HMAC with SHA-256)
- Single secret key
- Fast
- Good for internal services

### Asymmetric (RSA/ECDSA)

- RS256 (RSA with SHA-256)
- Public/private key pair
- Public key can verify, only private key can sign
- Good for distributed systems

```python
# Generate RSA keys
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization

# Generate private key
private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)

# Get public key
public_key = private_key.public_key()

# Sign with private key
token = jwt.encode(payload, private_key, algorithm="RS256")

# Verify with public key
payload = jwt.decode(token, public_key, algorithms=["RS256"])
```

## Best Practices

1. Use strong secret keys (256+ bits)
2. Set short access token expiration (15-30 min)
3. Use refresh tokens for long sessions
4. Rotate refresh tokens on use
5. Store refresh tokens securely in database
6. Implement token blacklisting for logout
7. Use RS256 for multi-service architectures
8. Include minimal claims in payload
9. Never store sensitive data in JWT
10. Always verify signature and expiration
