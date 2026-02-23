# Next.js Patterns

Next.js 14+ patterns and best practices for App Router.

## Server Component Patterns

### Streaming with Suspense

```typescript
// app/dashboard/page.tsx
import { Suspense } from 'react';
import { UserStats } from './UserStats';
import { RevenueChart } from './RevenueChart';

export default function DashboardPage() {
  return (
    <div>
      <h1>Dashboard</h1>
      <Suspense fallback={<div>Loading stats...</div>}>
        <UserStats />
      </Suspense>
      <Suspense fallback={<div>Loading chart...</div>}>
        <RevenueChart />
      </Suspense>
    </div>
  );
}
```

### Parallel Routes

```typescript
// app/dashboard/layout.tsx
export default function DashboardLayout({
  children,
  analytics,
  notifications,
}: {
  children: React.ReactNode;
  analytics: React.ReactNode;
  notifications: React.ReactNode;
}) {
  return (
    <div>
      <div>{children}</div>
      <div>{analytics}</div>
      <div>{notifications}</div>
    </div>
  );
}

// app/dashboard/@analytics/page.tsx
export default async function Analytics() {
  const data = await fetchAnalytics();
  return <AnalyticsChart data={data} />;
}

// app/dashboard/@notifications/page.tsx
export default async function Notifications() {
  const notifications = await fetchNotifications();
  return <NotificationList items={notifications} />;
}
```

### Intercepting Routes (Modals)

```typescript
// app/photos/[id]/page.tsx
export default async function PhotoPage({
  params,
}: {
  params: { id: string };
}) {
  const photo = await getPhoto(params.id);
  return <PhotoDetail photo={photo} />;
}

// app/@modal/(.)photos/[id]/page.tsx
// Opens in modal when navigating from same page
export default async function PhotoModal({
  params,
}: {
  params: { id: string };
}) {
  const photo = await getPhoto(params.id);
  return (
    <Modal>
      <PhotoDetail photo={photo} />
    </Modal>
  );
}
```

## Data Fetching Patterns

### Revalidation Strategies

```typescript
// Revalidate every 60 seconds
const res = await fetch('https://api.example.com/data', {
  next: { revalidate: 60 }
});

// Never cache
const res = await fetch('https://api.example.com/data', {
  cache: 'no-store'
});

// Cache forever (until revalidated)
const res = await fetch('https://api.example.com/data', {
  cache: 'force-cache'
});
```

### On-Demand Revalidation

```typescript
// app/actions/revalidate.ts
'use server';

import { revalidatePath, revalidateTag } from 'next/cache';

export async function revalidateUser(userId: string) {
  revalidatePath(`/users/${userId}`);
  revalidateTag('users');
}

// In data fetch
const res = await fetch('https://api.example.com/users', {
  next: { tags: ['users'] }
});
```

### Request Memoization

```typescript
// Multiple calls to same function are deduplicated automatically
async function getUser(id: string) {
  const res = await fetch(`https://api.example.com/users/${id}`);
  return res.json();
}

export default async function Page() {
  // Only one request made
  const user1 = await getUser('123');
  const user2 = await getUser('123');

  return <div>{user1.name}</div>;
}
```

## Server Actions Patterns

### Form with useFormState

```typescript
// app/actions/userActions.ts
'use server';

import { z } from 'zod';

const schema = z.object({
  email: z.string().email(),
  firstName: z.string().min(1),
});

export async function createUser(prevState: any, formData: FormData) {
  const validatedFields = schema.safeParse({
    email: formData.get('email'),
    firstName: formData.get('firstName'),
  });

  if (!validatedFields.success) {
    return {
      errors: validatedFields.error.flatten().fieldErrors,
    };
  }

  const user = await userService.createUser(validatedFields.data);

  return { success: true, user };
}
```

```typescript
// app/components/UserForm.tsx
'use client';

import { useFormState } from 'react-dom';
import { createUser } from '@/app/actions/userActions';

export function UserForm() {
  const [state, formAction] = useFormState(createUser, null);

  return (
    <form action={formAction}>
      <input name="email" type="email" />
      {state?.errors?.email && <p>{state.errors.email}</p>}

      <input name="firstName" type="text" />
      {state?.errors?.firstName && <p>{state.errors.firstName}</p>}

      <button type="submit">Create User</button>
    </form>
  );
}
```

### Optimistic Updates

```typescript
'use client';

import { useOptimistic } from 'react';
import { deleteUser } from '@/app/actions/userActions';

export function UserList({ users }: { users: User[] }) {
  const [optimisticUsers, addOptimisticUser] = useOptimistic(
    users,
    (state, deletedId: string) => state.filter(u => u.id !== deletedId)
  );

  async function handleDelete(id: string) {
    addOptimisticUser(id);
    await deleteUser(id);
  }

  return (
    <ul>
      {optimisticUsers.map(user => (
        <li key={user.id}>
          {user.name}
          <button onClick={() => handleDelete(user.id)}>Delete</button>
        </li>
      ))}
    </ul>
  );
}
```

## Image Optimization

```typescript
import Image from 'next/image';

export function UserAvatar({ user }: { user: User }) {
  return (
    <Image
      src={user.avatarUrl}
      alt={user.name}
      width={100}
      height={100}
      priority // Load immediately for above-fold images
    />
  );
}

// Background image
<div className="relative h-64">
  <Image
    src="/hero.jpg"
    alt="Hero"
    fill
    style={{ objectFit: 'cover' }}
  />
</div>
```

## Font Optimization

```typescript
// app/layout.tsx
import { Inter, Roboto_Mono } from 'next/font/google';

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-inter',
});

const robotoMono = Roboto_Mono({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-roboto-mono',
});

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={`${inter.variable} ${robotoMono.variable}`}>
      <body>{children}</body>
    </html>
  );
}
```

## Route Handlers (API Routes)

### Middleware Pattern

```typescript
// app/api/middleware.ts
import { NextRequest, NextResponse } from 'next/server';

export function withAuth(handler: Function) {
  return async (request: NextRequest, context: any) => {
    const token = request.headers.get('authorization');

    if (!token) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    return handler(request, context);
  };
}

// app/api/users/route.ts
import { withAuth } from '../middleware';

async function getUsers(request: NextRequest) {
  const users = await userService.getUsers();
  return NextResponse.json(users);
}

export const GET = withAuth(getUsers);
```

### Streaming Response

```typescript
// app/api/stream/route.ts
export async function GET() {
  const encoder = new TextEncoder();

  const stream = new ReadableStream({
    async start(controller) {
      for (let i = 0; i < 10; i++) {
        controller.enqueue(encoder.encode(`data: ${i}\n\n`));
        await new Promise(resolve => setTimeout(resolve, 1000));
      }
      controller.close();
    },
  });

  return new Response(stream, {
    headers: {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
    },
  });
}
```

## Best Practices

1. Use Server Components by default
2. Add 'use client' only when needed
3. Fetch data in Server Components
4. Use Server Actions for mutations
5. Implement loading and error states
6. Use Suspense for streaming
7. Optimize images with next/image
8. Use next/font for fonts
9. Implement middleware for auth
10. Revalidate data appropriately
