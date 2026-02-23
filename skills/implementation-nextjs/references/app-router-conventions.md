# App Router Conventions

File-based routing conventions for Next.js App Router.

## Special Files

| File | Purpose | Required |
|------|---------|----------|
| `layout.tsx` | Shared UI for segment and children | Root only |
| `page.tsx` | Unique UI, makes route publicly accessible | Yes |
| `loading.tsx` | Loading UI for segment and children | No |
| `error.tsx` | Error UI for segment and children | No |
| `not-found.tsx` | Not found UI | No |
| `template.tsx` | Re-rendered layout (unlike layout) | No |
| `route.ts` | API endpoint | No |

## File Naming

### Dynamic Routes

```
app/
├── users/
│   └── [id]/
│       └── page.tsx     # /users/123
```

```typescript
export default function UserPage({
  params,
}: {
  params: { id: string };
}) {
  return <div>User {params.id}</div>;
}
```

### Catch-All Routes

```
app/
├── docs/
│   └── [...slug]/
│       └── page.tsx     # /docs/a, /docs/a/b, /docs/a/b/c
```

```typescript
export default function DocsPage({
  params,
}: {
  params: { slug: string[] };
}) {
  return <div>Docs: {params.slug.join('/')}</div>;
}
```

### Optional Catch-All

```
app/
├── shop/
│   └── [[...slug]]/
│       └── page.tsx     # /shop, /shop/a, /shop/a/b
```

### Route Groups

Organize without affecting URL:

```
app/
├── (marketing)/
│   ├── layout.tsx       # Marketing layout
│   ├── page.tsx         # /
│   └── about/
│       └── page.tsx     # /about
├── (dashboard)/
│   ├── layout.tsx       # Dashboard layout
│   └── users/
│       └── page.tsx     # /users
```

### Private Folders

Prefix with underscore to exclude from routing:

```
app/
├── _components/
│   └── Button.tsx
├── _utils/
│   └── helpers.ts
└── page.tsx
```

## Parallel Routes

Multiple pages in same layout:

```
app/
├── @analytics/
│   └── page.tsx
├── @notifications/
│   └── page.tsx
└── layout.tsx
```

```typescript
// layout.tsx
export default function Layout({
  children,
  analytics,
  notifications,
}: {
  children: React.ReactNode;
  analytics: React.ReactNode;
  notifications: React.ReactNode;
}) {
  return (
    <>
      {children}
      {analytics}
      {notifications}
    </>
  );
}
```

## Intercepting Routes

### Conventions

- `(.)` - Match same level
- `(..)` - Match one level above
- `(..)(..)` - Match two levels above
- `(...)` - Match from root

### Example: Photo Modal

```
app/
├── photos/
│   ├── page.tsx         # /photos
│   └── [id]/
│       └── page.tsx     # /photos/123
└── @modal/
    └── (.)photos/
        └── [id]/
            └── page.tsx # Modal when navigating from /photos
```

## Metadata

### Static Metadata

```typescript
// app/page.tsx
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Home',
  description: 'Welcome to our site',
};

export default function HomePage() {
  return <h1>Home</h1>;
}
```

### Dynamic Metadata

```typescript
// app/users/[id]/page.tsx
export async function generateMetadata({
  params,
}: {
  params: { id: string };
}): Promise<Metadata> {
  const user = await getUserById(params.id);

  return {
    title: `${user.name} - User Profile`,
    description: user.bio,
  };
}
```

### Metadata Template

```typescript
// app/layout.tsx
export const metadata: Metadata = {
  title: {
    template: '%s | My App',
    default: 'My App',
  },
};

// app/users/page.tsx
export const metadata: Metadata = {
  title: 'Users', // Becomes "Users | My App"
};
```

## Static Site Generation

### generateStaticParams

```typescript
// app/users/[id]/page.tsx
export async function generateStaticParams() {
  const users = await getUsers();

  return users.map((user) => ({
    id: user.id,
  }));
}

export default function UserPage({
  params,
}: {
  params: { id: string };
}) {
  return <div>User {params.id}</div>;
}
```

### Dynamic Segments

```typescript
// Static by default
export const dynamic = 'auto';

// Always dynamically rendered
export const dynamic = 'force-dynamic';

// Always statically rendered
export const dynamic = 'force-static';

// Throw error if dynamic
export const dynamic = 'error';
```

## Route Segment Config

```typescript
// app/users/page.tsx
export const revalidate = 3600; // Revalidate every hour

export const fetchCache = 'auto';
// Options: 'auto' | 'default-cache' | 'only-cache' | 'force-cache' | 'force-no-store' | 'default-no-store' | 'only-no-store'

export const runtime = 'nodejs';
// Options: 'nodejs' | 'edge'

export const preferredRegion = 'auto';
// Options: 'auto' | 'global' | 'home' | ['us-east-1', 'us-west-2']
```

## Loading UI Patterns

### Instant Loading

```typescript
// app/users/loading.tsx
export default function Loading() {
  return <UsersSkeleton />;
}
```

### Streaming with Suspense

```typescript
// app/dashboard/page.tsx
import { Suspense } from 'react';

export default function Dashboard() {
  return (
    <div>
      <Suspense fallback={<Skeleton />}>
        <SlowComponent />
      </Suspense>
      <FastComponent />
    </div>
  );
}
```

## Error Handling

### Error Boundary

```typescript
// app/users/error.tsx
'use client';

import { useEffect } from 'react';

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error(error);
  }, [error]);

  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={reset}>Try again</button>
    </div>
  );
}
```

### Global Error

```typescript
// app/global-error.tsx
'use client';

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <html>
      <body>
        <h2>Something went wrong!</h2>
        <button onClick={reset}>Try again</button>
      </body>
    </html>
  );
}
```

## Not Found

```typescript
// app/users/[id]/not-found.tsx
export default function NotFound() {
  return (
    <div>
      <h2>User Not Found</h2>
      <p>Could not find the requested user.</p>
    </div>
  );
}

// app/users/[id]/page.tsx
import { notFound } from 'next/navigation';

export default async function UserPage({
  params,
}: {
  params: { id: string };
}) {
  const user = await getUserById(params.id);

  if (!user) {
    notFound();
  }

  return <UserDetail user={user} />;
}
```

## Best Practices

1. Use `layout.tsx` for shared UI
2. Implement `loading.tsx` for better UX
3. Add `error.tsx` for error handling
4. Use route groups for organization
5. Generate metadata for SEO
6. Use `generateStaticParams` for static pages
7. Implement not-found pages
8. Use parallel routes for complex layouts
9. Intercept routes for modals
10. Configure segment options appropriately
