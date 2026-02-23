# React Patterns

Common React patterns for components, hooks, and performance optimization.

## Component Patterns

### Presentational vs Container

**Presentational (Dumb Components)**
```typescript
interface UserCardProps {
  user: User;
  onDelete: (id: string) => void;
}

export function UserCard({ user, onDelete }: UserCardProps) {
  return (
    <div>
      <h3>{user.firstName} {user.lastName}</h3>
      <button onClick={() => onDelete(user.id)}>Delete</button>
    </div>
  );
}
```

**Container (Smart Components)**
```typescript
export function UserCardContainer({ userId }: { userId: string }) {
  const { user, loading } = useUser(userId);
  const { deleteUser } = useUsers();

  if (loading) return <Spinner />;
  if (!user) return <NotFound />;

  return <UserCard user={user} onDelete={deleteUser} />;
}
```

### Compound Components

Share state between related components:

```typescript
interface TabsContextValue {
  activeTab: string;
  setActiveTab: (tab: string) => void;
}

const TabsContext = createContext<TabsContextValue | null>(null);

export function Tabs({ children }: { children: ReactNode }) {
  const [activeTab, setActiveTab] = useState('');
  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      {children}
    </TabsContext.Provider>
  );
}

Tabs.List = function TabsList({ children }: { children: ReactNode }) {
  return <div role="tablist">{children}</div>;
};

Tabs.Tab = function Tab({ name, children }: { name: string; children: ReactNode }) {
  const { activeTab, setActiveTab } = useContext(TabsContext)!;
  return (
    <button
      role="tab"
      aria-selected={activeTab === name}
      onClick={() => setActiveTab(name)}
    >
      {children}
    </button>
  );
};

// Usage
<Tabs>
  <Tabs.List>
    <Tabs.Tab name="profile">Profile</Tabs.Tab>
    <Tabs.Tab name="settings">Settings</Tabs.Tab>
  </Tabs.List>
</Tabs>
```

### Render Props

Share logic with render function:

```typescript
interface MouseTrackerProps {
  children: (position: { x: number; y: number }) => ReactNode;
}

function MouseTracker({ children }: MouseTrackerProps) {
  const [position, setPosition] = useState({ x: 0, y: 0 });

  useEffect(() => {
    function handleMouseMove(e: MouseEvent) {
      setPosition({ x: e.clientX, y: e.clientY });
    }
    window.addEventListener('mousemove', handleMouseMove);
    return () => window.removeEventListener('mousemove', handleMouseMove);
  }, []);

  return <>{children(position)}</>;
}

// Usage
<MouseTracker>
  {({ x, y }) => <div>Mouse at {x}, {y}</div>}
</MouseTracker>
```

## Hook Patterns

### Custom Hook Composition

```typescript
function useUserManagement(userId: string) {
  const { user, loading } = useUser(userId);
  const { updateUser } = useUsers();
  const { showToast } = useToast();

  async function handleUpdate(data: UpdateUserRequest) {
    try {
      await updateUser(userId, data);
      showToast('User updated successfully', 'success');
    } catch (error) {
      showToast('Failed to update user', 'error');
    }
  }

  return { user, loading, handleUpdate };
}
```

### useReducer for Complex State

```typescript
type State = {
  data: User[];
  loading: boolean;
  error: Error | null;
};

type Action =
  | { type: 'FETCH_START' }
  | { type: 'FETCH_SUCCESS'; payload: User[] }
  | { type: 'FETCH_ERROR'; error: Error };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'FETCH_START':
      return { ...state, loading: true, error: null };
    case 'FETCH_SUCCESS':
      return { data: action.payload, loading: false, error: null };
    case 'FETCH_ERROR':
      return { ...state, loading: false, error: action.error };
    default:
      return state;
  }
}

function useUsers() {
  const [state, dispatch] = useReducer(reducer, {
    data: [],
    loading: false,
    error: null,
  });

  async function fetchUsers() {
    dispatch({ type: 'FETCH_START' });
    try {
      const users = await userService.getUsers();
      dispatch({ type: 'FETCH_SUCCESS', payload: users });
    } catch (error) {
      dispatch({ type: 'FETCH_ERROR', error: error as Error });
    }
  }

  return { ...state, fetchUsers };
}
```

### useCallback and useMemo

```typescript
function UserList({ users }: { users: User[] }) {
  // Memoize expensive calculation
  const sortedUsers = useMemo(() => {
    return [...users].sort((a, b) =>
      a.lastName.localeCompare(b.lastName)
    );
  }, [users]);

  // Memoize callback to prevent re-renders
  const handleDelete = useCallback((id: string) => {
    userService.deleteUser(id);
  }, []);

  return (
    <ul>
      {sortedUsers.map(user => (
        <UserItem key={user.id} user={user} onDelete={handleDelete} />
      ))}
    </ul>
  );
}
```

## Performance Patterns

### React.memo

Prevent re-renders of expensive components:

```typescript
const ExpensiveComponent = React.memo(function ExpensiveComponent({
  data
}: {
  data: ComplexData
}) {
  // Expensive rendering logic
  return <div>...</div>;
});
```

### Lazy Loading

Load components on demand:

```typescript
import { lazy, Suspense } from 'react';

const UserDetail = lazy(() => import('./UserDetail'));

function App() {
  return (
    <Suspense fallback={<Spinner />}>
      <UserDetail userId="123" />
    </Suspense>
  );
}
```

### Virtual Lists

For long lists, use virtualization:

```typescript
import { useVirtualizer } from '@tanstack/react-virtual';

function VirtualUserList({ users }: { users: User[] }) {
  const parentRef = useRef<HTMLDivElement>(null);

  const virtualizer = useVirtualizer({
    count: users.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 50,
  });

  return (
    <div ref={parentRef} style={{ height: '400px', overflow: 'auto' }}>
      <div style={{ height: `${virtualizer.getTotalSize()}px` }}>
        {virtualizer.getVirtualItems().map(virtualRow => (
          <div
            key={virtualRow.index}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              width: '100%',
              height: `${virtualRow.size}px`,
              transform: `translateY(${virtualRow.start}px)`,
            }}
          >
            <UserCard user={users[virtualRow.index]} />
          </div>
        ))}
      </div>
    </div>
  );
}
```

## Error Handling

### Error Boundary

```typescript
class ErrorBoundary extends React.Component<
  { children: ReactNode },
  { hasError: boolean }
> {
  state = { hasError: false };

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Error caught:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return <div>Something went wrong.</div>;
    }
    return this.props.children;
  }
}
```

### Async Error Handling

```typescript
function useAsyncError() {
  const [, setError] = useState();

  return useCallback((error: Error) => {
    setError(() => {
      throw error;
    });
  }, []);
}

function MyComponent() {
  const throwError = useAsyncError();

  async function fetchData() {
    try {
      await userService.getUsers();
    } catch (error) {
      throwError(error as Error);
    }
  }
}
```

## Best Practices

1. Keep components small and focused
2. Extract logic into custom hooks
3. Use TypeScript for type safety
4. Memoize expensive calculations
5. Lazy load routes and heavy components
6. Use error boundaries for graceful failures
7. Avoid premature optimization
8. Profile before optimizing
