# OAuth Patterns

OAuth2 flows, PKCE, and token management.

## OAuth2 Flows

### Authorization Code Flow (Web Apps)

Most secure for server-side apps.

```
1. Client redirects user to authorization server
   https://auth.example.com/authorize?
     response_type=code&
     client_id=CLIENT_ID&
     redirect_uri=https://app.example.com/callback&
     scope=openid profile email

2. User authenticates and grants permission

3. Authorization server redirects back with code
   https://app.example.com/callback?code=AUTH_CODE

4. Client exchanges code for tokens
   POST https://auth.example.com/token
   {
     grant_type: "authorization_code",
     code: "AUTH_CODE",
     client_id: "CLIENT_ID",
     client_secret: "CLIENT_SECRET",
     redirect_uri: "https://app.example.com/callback"
   }

5. Server returns tokens
   {
     access_token: "...",
     refresh_token: "...",
     id_token: "...",
     expires_in: 3600
   }
```

### PKCE (Proof Key for Code Exchange)

For mobile and SPA apps (no client secret).

```typescript
// 1. Generate code verifier and challenge
import crypto from 'crypto';

function generateCodeVerifier(): string {
  return crypto.randomBytes(32).toString('base64url');
}

function generateCodeChallenge(verifier: string): string {
  return crypto
    .createHash('sha256')
    .update(verifier)
    .digest('base64url');
}

const codeVerifier = generateCodeVerifier();
const codeChallenge = generateCodeChallenge(codeVerifier);

// 2. Authorization request (with challenge)
const authUrl = `https://auth.example.com/authorize?` +
  `response_type=code&` +
  `client_id=${CLIENT_ID}&` +
  `redirect_uri=${REDIRECT_URI}&` +
  `code_challenge=${codeChallenge}&` +
  `code_challenge_method=S256`;

// 3. Token request (with verifier)
const tokenResponse = await fetch('https://auth.example.com/token', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    grant_type: 'authorization_code',
    code: authCode,
    client_id: CLIENT_ID,
    redirect_uri: REDIRECT_URI,
    code_verifier: codeVerifier,  // Proves we initiated the flow
  }),
});
```

### Implicit Flow (Deprecated)

Don't use. Access token exposed in URL.

### Client Credentials Flow

For service-to-service authentication.

```python
import requests

response = requests.post('https://auth.example.com/token', data={
    'grant_type': 'client_credentials',
    'client_id': CLIENT_ID,
    'client_secret': CLIENT_SECRET,
    'scope': 'api.read api.write'
})

access_token = response.json()['access_token']

# Use token for API calls
api_response = requests.get(
    'https://api.example.com/data',
    headers={'Authorization': f'Bearer {access_token}'}
)
```

## Token Types

### Access Token

- Short-lived (minutes to hours)
- Used for API authentication
- JWT or opaque string

### Refresh Token

- Long-lived (days to weeks)
- Used to get new access tokens
- Should be securely stored
- Can be revoked

### ID Token (OpenID Connect)

- Contains user information
- Always a JWT
- Used for authentication (not authorization)

```typescript
// Decode ID token (JWT)
import jwt_decode from 'jwt-decode';

interface IDToken {
  sub: string;        // User ID
  email: string;
  name: string;
  picture: string;
  iat: number;        // Issued at
  exp: number;        // Expiration
}

const idToken = jwt_decode<IDToken>(token);
console.log(idToken.email);
```

## Token Storage

### Frontend

**Best: httpOnly Cookie**
- Set by backend
- Not accessible to JavaScript
- CSRF protection needed

```typescript
// Backend sets cookie
res.cookie('access_token', token, {
  httpOnly: true,
  secure: true,      // HTTPS only
  sameSite: 'strict',
  maxAge: 3600000,   // 1 hour
});

// Frontend sends automatically
fetch('/api/data', {
  credentials: 'include',  // Include cookies
});
```

**Alternative: localStorage (with XSS risk)**
```typescript
localStorage.setItem('access_token', token);

// Add to requests
const token = localStorage.getItem('access_token');
fetch('/api/data', {
  headers: {
    'Authorization': `Bearer ${token}`,
  },
});
```

**Mobile: Secure Storage**
- iOS: Keychain
- Android: Keystore
- React Native: react-native-keychain

## Refresh Token Rotation

```typescript
// authService.ts
let accessToken = '';
let refreshToken = '';

async function refreshAccessToken() {
  const response = await fetch('/api/auth/refresh', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ refresh_token: refreshToken }),
  });

  const data = await response.json();
  accessToken = data.access_token;
  refreshToken = data.refresh_token;  // New refresh token (rotation)

  return accessToken;
}

// Axios interceptor
axios.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      try {
        const newToken = await refreshAccessToken();
        originalRequest.headers.Authorization = `Bearer ${newToken}`;
        return axios(originalRequest);
      } catch (refreshError) {
        // Refresh failed, logout user
        logout();
        return Promise.reject(refreshError);
      }
    }

    return Promise.reject(error);
  }
);
```

## Social Login Integration

### Google

```typescript
// Next.js with NextAuth
import GoogleProvider from 'next-auth/providers/google';

export default NextAuth({
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    }),
  ],
});
```

### GitHub

```typescript
import GitHubProvider from 'next-auth/providers/github';

GitHubProvider({
  clientId: process.env.GITHUB_ID!,
  clientSecret: process.env.GITHUB_SECRET!,
})
```

### Custom Provider

```typescript
providers: [
  {
    id: 'custom',
    name: 'Custom OAuth',
    type: 'oauth',
    authorization: {
      url: 'https://auth.example.com/authorize',
      params: { scope: 'openid email profile' },
    },
    token: 'https://auth.example.com/token',
    userinfo: 'https://auth.example.com/userinfo',
    profile(profile) {
      return {
        id: profile.sub,
        email: profile.email,
        name: profile.name,
      };
    },
  },
]
```

## Scopes

Limit what access token can do:

```
openid           - OpenID Connect
profile          - User profile info
email            - Email address
read:users       - Read user data
write:users      - Create/update users
admin:all        - Admin access
```

```typescript
// Request specific scopes
const authUrl = `https://auth.example.com/authorize?` +
  `scope=openid profile email read:users`;

// Check scopes in token
const token = jwt_decode<{ scope: string }>(accessToken);
const scopes = token.scope.split(' ');

if (scopes.includes('admin:all')) {
  // User has admin access
}
```

## Best Practices

1. Use Authorization Code Flow with PKCE
2. Always use HTTPS
3. Validate redirect URIs
4. Rotate refresh tokens
5. Set short access token expiration
6. Store tokens securely
7. Implement token revocation
8. Use state parameter to prevent CSRF
9. Validate JWT signatures
10. Use nonce for replay protection
