---
name: implementation-nextjs
description: Next.js App Router implementation with Server Components and API routes
---

# Next.js Implementation Skill

Next.js implementation skill covering App Router, Server Components, and modern Next.js 14+ patterns.

## When to Use

- Next.js frontend implementation tasks
- "Build Next.js pages"
- "Implement Next.js app"
- Phase 7 implementation when Next.js is the chosen framework

## Core Concepts

Next.js 14+ uses the App Router with:
- **Server Components**: Default, render on server
- **Client Components**: Opt-in with 'use client'
- **File-Based Routing**: app/ directory structure
- **Server Actions**: Server-side mutations
- **Parallel Routes**: Multiple page sections
- **Intercepting Routes**: Modal overlays

## App Router Directory Structure

```
app/
├── layout.tsx           # Root layout (required)
├── page.tsx            # Home page
├── loading.tsx         # Loading UI
├── error.tsx           # Error UI
├── not-found.tsx       # 404 page
├── users/
│   ├── layout.tsx      # Users section layout
│   ├── page.tsx        # /users
│   ├── loading.tsx     # /users loading
│   ├── [id]/
│   │   ├── page.tsx    # /users/[id]
│   │   └── edit/
│   │       └── page.tsx # /users/[id]/edit
│   └── new/
│       └── page.tsx    # /users/new
└── api/
    └── users/
        └── route.ts    # API endpoint
```

## Server vs Client Components

### Server Components (Default)

Use for:
- Fetching data
- Accessing backend resources
- Keeping sensitive information secure
- Reducing client bundle size

```typescript
// app/users/page.tsx
// Server Component by default
import { userService } from '@/services/userService';

export default async function UsersPage() {
  const users = await userService.getUsers();

  return (
    <div>
      <h1>Users</h1>
      <ul>
        {users.map(user => (
          <li key={user.id}>{user.firstName} {user.lastName}</li>
        ))}
      </ul>
    </div>
  );
}
```

### Client Components

Use for:
- Interactivity (onClick, onChange)
- Browser APIs (localStorage, geolocation)
- React hooks (useState, useEffect)
- Event listeners

```typescript
// app/components/UserForm.tsx
'use client';

import { useState } from 'react';
import { createUser } from '@/app/actions/userActions';

export function UserForm() {
  const [email, setEmail] = useState('');

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    await createUser({ email });
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />
      <button type="submit">Create User</button>
    </form>
  );
}
```

## Data Fetching Patterns

### Server Component Fetch

```typescript
// app/users/[id]/page.tsx
async function getUserById(id: string) {
  const res = await fetch(`https://api.example.com/users/${id}`, {
    next: { revalidate: 3600 } // Cache for 1 hour
  });
  return res.json();
}

export default async function UserDetailPage({
  params,
}: {
  params: { id: string };
}) {
  const user = await getUserById(params.id);

  return (
    <div>
      <h1>{user.firstName} {user.lastName}</h1>
      <p>{user.email}</p>
    </div>
  );
}
```

### Parallel Data Fetching

```typescript
async function getUser(id: string) { /* ... */ }
async function getUserOrders(id: string) { /* ... */ }

export default async function UserDetailPage({
  params,
}: {
  params: { id: string };
}) {
  // Fetch in parallel
  const [user, orders] = await Promise.all([
    getUser(params.id),
    getUserOrders(params.id),
  ]);

  return (
    <div>
      <h1>{user.name}</h1>
      <OrderList orders={orders} />
    </div>
  );
}
```

### Client-Side Fetch (SWR)

```typescript
'use client';

import useSWR from 'swr';

const fetcher = (url: string) => fetch(url).then(r => r.json());

export function UserList() {
  const { data, error, isLoading } = useSWR('/api/users', fetcher);

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error loading users</div>;

  return (
    <ul>
      {data.map((user: User) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

## Server Actions

Server-side mutations with type safety:

```typescript
// app/actions/userActions.ts
'use server';

import { revalidatePath } from 'next/cache';
import { userService } from '@/services/userService';

export async function createUser(formData: FormData) {
  const email = formData.get('email') as string;
  const firstName = formData.get('firstName') as string;

  const user = await userService.createUser({ email, firstName });

  revalidatePath('/users');
  return user;
}

export async function deleteUser(userId: string) {
  await userService.deleteUser(userId);
  revalidatePath('/users');
}
```

```typescript
// app/components/UserForm.tsx
'use client';

import { createUser } from '@/app/actions/userActions';

export function UserForm() {
  return (
    <form action={createUser}>
      <input name="email" type="email" required />
      <input name="firstName" type="text" required />
      <button type="submit">Create User</button>
    </form>
  );
}
```

## Layouts and Templates

### Root Layout (Required)

```typescript
// app/layout.tsx
import { Inter } from 'next/font/google';
import './globals.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata = {
  title: 'My App',
  description: 'App description',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  );
}
```

### Nested Layout

```typescript
// app/users/layout.tsx
export default function UsersLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div>
      <nav>
        <a href="/users">All Users</a>
        <a href="/users/new">Create User</a>
      </nav>
      <main>{children}</main>
    </div>
  );
}
```

## Loading and Error States

### Loading UI

```typescript
// app/users/loading.tsx
export default function Loading() {
  return <div>Loading users...</div>;
}
```

### Error Handling

```typescript
// app/users/error.tsx
'use client';

export default function Error({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return (
    <div>
      <h2>Something went wrong!</h2>
      <p>{error.message}</p>
      <button onClick={reset}>Try again</button>
    </div>
  );
}
```

## API Routes

```typescript
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { userService } from '@/services/userService';

export async function GET(request: NextRequest) {
  const users = await userService.getUsers();
  return NextResponse.json(users);
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  const user = await userService.createUser(body);
  return NextResponse.json(user, { status: 201 });
}
```

```typescript
// app/api/users/[id]/route.ts
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const user = await userService.getUserById(params.id);
  return NextResponse.json(user);
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  await userService.deleteUser(params.id);
  return new NextResponse(null, { status: 204 });
}
```

## Middleware

```typescript
// middleware.ts
import { NextRequest, NextResponse } from 'next/server';

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token');

  if (!token && request.nextUrl.pathname.startsWith('/dashboard')) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: '/dashboard/:path*',
};
```

## Quality Gates

Implementation must satisfy:
- Proper use of Server vs Client Components
- No unnecessary 'use client' directives
- Data fetching in Server Components when possible
- Server Actions for mutations
- Loading and error states defined
- Metadata exported from pages
- API routes follow REST conventions
- Middleware for cross-cutting concerns

## References

- [Next.js Patterns](references/nextjs-patterns.md) - Next.js 14+ patterns
- [App Router Conventions](references/app-router-conventions.md) - File-based routing
- [Server Components](references/server-components.md) - Server vs Client

## Integration

Used by:
- **frontend-developer agent**: Primary consumer during Phase 7
- **api-design skill**: API routes follow conventions from api-design
- **implementation-auth skill**: Middleware patterns for authentication
