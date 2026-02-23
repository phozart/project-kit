---
name: implementation-react
description: React implementation patterns with strict separation of concerns
---

# React Implementation Skill

React implementation skill enforcing clean architecture with components/hooks/services layers.

## When to Use

- React frontend implementation tasks
- "Build React components"
- "Implement the React UI"
- Phase 7 implementation when React is the chosen framework

## MANDATORY RULES

These rules are non-negotiable. Violations are blocking defects:

1. **No Inline Styles**: All styling uses CSS modules or design tokens
2. **No API Calls from Components**: API calls only in services layer
3. **No Business Logic in Components**: Components only handle presentation
4. **All Styling Uses Design Tokens**: Colors, spacing, typography from tokens

## Architecture Layers

```
src/
├── components/       # Presentation components only
├── hooks/           # Custom hooks (composition, state)
├── services/        # API calls, external integrations
├── stores/          # Global state (Zustand/Redux)
├── utils/           # Pure functions, helpers
└── types/           # TYPE-CONTRACTS
```

### Layer Responsibilities

**Components Layer**
- Render UI based on props
- Handle user interactions
- Delegate to hooks for logic
- NO API calls
- NO business logic
- NO inline styles

**Hooks Layer**
- Compose React hooks
- Manage component state
- Call services for data
- Transform data for UI
- Handle side effects

**Services Layer**
- API calls using fetch/axios
- WebSocket connections
- Local storage access
- Third-party integrations
- Error handling

## File Placement Rules

| File Type | Location | Example |
|-----------|----------|---------|
| Shared UI components | `src/components/ui/` | Button, Input, Modal |
| Feature components | `src/components/features/` | UserProfile, OrderList |
| Layout components | `src/components/layout/` | Header, Sidebar, Layout |
| Custom hooks | `src/hooks/` | useAuth, useUsers |
| API services | `src/services/api/` | userService, orderService |
| State stores | `src/stores/` | authStore, userStore |
| Type contracts | `src/types/` | User.ts, Order.ts |
| Utilities | `src/utils/` | formatDate, validateEmail |
| Design tokens | `src/styles/tokens/` | colors.ts, spacing.ts |

## Implementation Process

### 1. Directory Structure

```bash
src/
├── components/
│   ├── ui/              # Shared UI components
│   ├── features/        # Feature-specific components
│   └── layout/          # Layout components
├── hooks/
│   ├── useAuth.ts
│   └── useUsers.ts
├── services/
│   └── api/
│       ├── client.ts    # Axios/fetch config
│       ├── userService.ts
│       └── orderService.ts
├── stores/
│   ├── authStore.ts
│   └── userStore.ts
├── styles/
│   └── tokens/
│       ├── colors.ts
│       ├── spacing.ts
│       └── typography.ts
├── types/               # Import from TYPE-CONTRACTS
│   ├── User.ts
│   └── Order.ts
└── utils/
    ├── formatters.ts
    └── validators.ts
```

### 2. Design Tokens

Define all design values as tokens:

```typescript
// src/styles/tokens/colors.ts
export const colors = {
  primary: {
    main: '#0066cc',
    light: '#3385d6',
    dark: '#004c99',
  },
  text: {
    primary: '#1a1a1a',
    secondary: '#666666',
  },
  background: {
    default: '#ffffff',
    paper: '#f5f5f5',
  },
} as const;

// src/styles/tokens/spacing.ts
export const spacing = {
  xs: '0.25rem',
  sm: '0.5rem',
  md: '1rem',
  lg: '1.5rem',
  xl: '2rem',
} as const;
```

### 3. Shared UI Components

Build reusable components using design tokens:

```typescript
// src/components/ui/Button/Button.tsx
import styles from './Button.module.css';
import { ButtonHTMLAttributes } from 'react';

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary';
  size?: 'sm' | 'md' | 'lg';
}

export function Button({
  variant = 'primary',
  size = 'md',
  children,
  ...props
}: ButtonProps) {
  return (
    <button
      className={`${styles.button} ${styles[variant]} ${styles[size]}`}
      {...props}
    >
      {children}
    </button>
  );
}
```

```css
/* src/components/ui/Button/Button.module.css */
.button {
  border: none;
  border-radius: var(--radius-md);
  font-weight: 600;
  cursor: pointer;
}

.primary {
  background-color: var(--color-primary-main);
  color: white;
}

.md {
  padding: var(--spacing-sm) var(--spacing-md);
  font-size: var(--font-size-md);
}
```

### 4. API Services

All API calls in services layer:

```typescript
// src/services/api/userService.ts
import { UserDTO, CreateUserRequest } from '@/types/User';
import { apiClient } from './client';

export const userService = {
  async getUsers() {
    const response = await apiClient.get<UserDTO[]>('/users');
    return response.data;
  },

  async getUserById(id: string) {
    const response = await apiClient.get<UserDTO>(`/users/${id}`);
    return response.data;
  },

  async createUser(data: CreateUserRequest) {
    const response = await apiClient.post<UserDTO>('/users', data);
    return response.data;
  },

  async deleteUser(id: string) {
    await apiClient.delete(`/users/${id}`);
  },
};
```

### 5. Custom Hooks

Hooks compose services and manage state:

```typescript
// src/hooks/useUsers.ts
import { useState, useEffect } from 'react';
import { userService } from '@/services/api/userService';
import { UserDTO } from '@/types/User';

export function useUsers() {
  const [users, setUsers] = useState<UserDTO[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    loadUsers();
  }, []);

  async function loadUsers() {
    try {
      setLoading(true);
      const data = await userService.getUsers();
      setUsers(data);
    } catch (err) {
      setError(err as Error);
    } finally {
      setLoading(false);
    }
  }

  async function deleteUser(id: string) {
    await userService.deleteUser(id);
    await loadUsers();
  }

  return { users, loading, error, deleteUser, refetch: loadUsers };
}
```

### 6. Feature Pages

Pages use hooks and components:

```typescript
// src/components/features/UserList/UserList.tsx
import { useUsers } from '@/hooks/useUsers';
import { Button } from '@/components/ui/Button';
import styles from './UserList.module.css';

export function UserList() {
  const { users, loading, error, deleteUser } = useUsers();

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <div className={styles.container}>
      <h1>Users</h1>
      <ul className={styles.list}>
        {users.map(user => (
          <li key={user.id} className={styles.item}>
            <span>{user.firstName} {user.lastName}</span>
            <Button
              variant="secondary"
              size="sm"
              onClick={() => deleteUser(user.id)}
            >
              Delete
            </Button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

### 7. Routing

Use React Router for navigation:

```typescript
// src/App.tsx
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { Layout } from '@/components/layout/Layout';
import { UserList } from '@/components/features/UserList';
import { UserDetail } from '@/components/features/UserDetail';

export function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<UserList />} />
          <Route path="users/:id" element={<UserDetail />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
```

### 8. Testing

Test each layer independently:

```typescript
// src/components/ui/Button/Button.test.tsx
import { render, screen } from '@testing-library/react';
import { Button } from './Button';

test('renders button with text', () => {
  render(<Button>Click me</Button>);
  expect(screen.getByText('Click me')).toBeInTheDocument();
});
```

## Quality Gates

Implementation must satisfy:
- No inline styles
- No API calls in components
- No business logic in components
- All design tokens used
- All TYPE-CONTRACTS imported and used
- Components under 200 lines
- Hooks unit tested
- Services mocked in tests

## Anti-Patterns to Avoid

- **Fetch in Components**: Move to services
- **Inline Styles**: Use CSS modules or styled-components
- **Prop Drilling**: Use context or state management
- **Giant Components**: Split into smaller components
- **useEffect Abuse**: Consider if effect is needed
- **Missing Error Handling**: Always handle errors

## References

- [React Patterns](references/react-patterns.md) - Component patterns and hooks
- [Component Architecture](references/component-architecture.md) - Component composition
- [State Management](references/state-management.md) - Zustand, Redux, Context
- [Testing React](references/testing-react.md) - Testing Library and strategies

## Integration

Used by:
- **frontend-developer agent**: Primary consumer during Phase 7
- **api-design skill**: Imports TYPE-CONTRACTS from this skill
- **testing skill**: Tests components using patterns from this skill
