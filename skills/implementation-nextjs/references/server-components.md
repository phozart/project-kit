# Server Components

Understanding Server Components vs Client Components in Next.js.

## Server Components (Default)

Components that render on the server.

### Benefits

1. **Smaller Bundle Size**: No JavaScript sent to client
2. **Direct Backend Access**: Query database, read files
3. **Security**: Keep secrets on server
4. **Better Performance**: Server-side rendering
5. **Automatic Code Splitting**: No manual imports

### What You Can Do

```typescript
// Direct database access
import { db } from '@/lib/db';

export default async function UsersPage() {
  const users = await db.user.findMany();
  return <UserList users={users} />;
}

// Read files
import fs from 'fs/promises';

export default async function AboutPage() {
  const content = await fs.readFile('about.md', 'utf-8');
  return <Markdown content={content} />;
}

// Use secrets safely
export default async function DataPage() {
  const data = await fetch('https://api.example.com/data', {
    headers: {
      'Authorization': `Bearer ${process.env.API_SECRET}`,
    },
  });
  return <DataView data={await data.json()} />;
}
```

### What You Cannot Do

- Use React hooks (useState, useEffect, etc.)
- Use browser APIs (localStorage, window)
- Add event listeners (onClick, onChange)
- Use Context API providers
- Use React class components

## Client Components

Components that run in the browser.

### When to Use

Add `'use client'` when you need:
- Interactivity (event listeners)
- State management (useState, useReducer)
- Effects (useEffect, useLayoutEffect)
- Browser APIs (localStorage, geolocation)
- Custom hooks that use above features
- React class components

### Example

```typescript
'use client';

import { useState } from 'react';

export function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>
        Increment
      </button>
    </div>
  );
}
```

## Composition Patterns

### Server Component with Client Children

```typescript
// app/users/page.tsx (Server Component)
import { UserFilters } from './UserFilters'; // Client Component

export default async function UsersPage() {
  const users = await getUsers();

  return (
    <div>
      <h1>Users</h1>
      <UserFilters /> {/* Client Component */}
      <UserList users={users} />
    </div>
  );
}
```

### Passing Server Components to Client Components

Pass as `children` prop:

```typescript
// ClientComponent.tsx
'use client';

export function ClientComponent({
  children,
}: {
  children: React.ReactNode;
}) {
  return <div>{children}</div>;
}

// page.tsx (Server Component)
export default async function Page() {
  const data = await fetchData();

  return (
    <ClientComponent>
      <ServerComponent data={data} />
    </ClientComponent>
  );
}
```

### Client Component with Server Props

```typescript
// ServerComponent.tsx (Server Component)
export async function UserStats() {
  const stats = await getStats();
  return <StatsDisplay stats={stats} />;
}

// StatsDisplay.tsx (Client Component)
'use client';

export function StatsDisplay({ stats }: { stats: Stats }) {
  const [expanded, setExpanded] = useState(false);

  return (
    <div onClick={() => setExpanded(!expanded)}>
      {expanded && <div>{stats.details}</div>}
    </div>
  );
}
```

## Data Fetching

### Server Components

```typescript
// Async Server Component
export default async function UsersPage() {
  // Direct fetch
  const users = await getUsers();

  // Parallel fetching
  const [users, posts] = await Promise.all([
    getUsers(),
    getPosts(),
  ]);

  return <div>{/* ... */}</div>;
}
```

### Client Components

```typescript
'use client';

import { useEffect, useState } from 'react';

export function UserList() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    fetch('/api/users')
      .then(res => res.json())
      .then(setUsers);
  }, []);

  return <ul>{/* ... */}</ul>;
}

// Or with SWR
import useSWR from 'swr';

export function UserList() {
  const { data: users } = useSWR('/api/users', fetcher);
  return <ul>{/* ... */}</ul>;
}
```

## Context with Server Components

### Pattern: Client Provider with Server Children

```typescript
// providers/ThemeProvider.tsx
'use client';

import { createContext, useContext, useState } from 'react';

const ThemeContext = createContext<{
  theme: string;
  setTheme: (theme: string) => void;
} | null>(null);

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState('light');

  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) throw new Error('useTheme must be within ThemeProvider');
  return context;
}
```

```typescript
// app/layout.tsx (Server Component)
import { ThemeProvider } from '@/providers/ThemeProvider';

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html>
      <body>
        <ThemeProvider>
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
```

## Performance Optimization

### Minimize Client Components

```typescript
// ❌ Entire component is client
'use client';

export default function Page() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <ServerSideData />  {/* Now runs on client! */}
      <button onClick={() => setCount(count + 1)}>
        {count}
      </button>
    </div>
  );
}

// ✅ Extract interactive part
export default function Page() {
  return (
    <div>
      <ServerSideData />  {/* Runs on server */}
      <Counter />  {/* Only this is client */}
    </div>
  );
}

function Counter() {
  'use client';
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
}
```

### Move Client Components Down the Tree

```typescript
// ❌ Top-level client component
'use client';

export default function Page() {
  return (
    <div>
      <Header />
      <Content />
      <InteractiveButton />
    </div>
  );
}

// ✅ Server component with client leaf
export default function Page() {
  return (
    <div>
      <Header />  {/* Server */}
      <Content />  {/* Server */}
      <InteractiveButton />  {/* Client */}
    </div>
  );
}
```

## Importing Third-Party Libraries

### Server-Only Libraries

```typescript
import 'server-only';

// This module can only be imported by Server Components
export async function getData() {
  // Database queries, file system access, etc.
}
```

### Client-Only Libraries

```typescript
import 'client-only';

// This module can only be imported by Client Components
export function useLocalStorage() {
  // Browser API usage
}
```

## Best Practices

1. Use Server Components by default
2. Add 'use client' only when necessary
3. Move Client Components to leaf nodes
4. Pass Server Components as children to Client Components
5. Fetch data in Server Components when possible
6. Use Server Actions for mutations
7. Keep client bundle small
8. Mark server-only code with 'server-only'
9. Mark client-only code with 'client-only'
10. Avoid large Client Component trees
