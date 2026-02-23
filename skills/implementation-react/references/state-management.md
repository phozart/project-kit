# State Management

State management patterns using Zustand, Redux, and Context API.

## When to Use Each

**Local State (useState)**
- Component-only state
- Form inputs
- Toggle states
- No sharing needed

**Context API**
- Theme, locale, user auth
- Prop drilling avoidance
- 2-5 components need access
- Infrequent updates

**Zustand**
- Global app state
- Multiple components access
- Simple API preferred
- Middleware needed

**Redux**
- Complex state logic
- Time-travel debugging needed
- Large team, strict patterns
- Extensive middleware ecosystem

## Zustand (Recommended)

### Basic Store

```typescript
// src/stores/userStore.ts
import { create } from 'zustand';
import { userService } from '@/services/api/userService';
import { User } from '@/types/User';

interface UserState {
  users: User[];
  loading: boolean;
  error: Error | null;
  fetchUsers: () => Promise<void>;
  addUser: (user: User) => void;
  removeUser: (id: string) => void;
}

export const useUserStore = create<UserState>((set) => ({
  users: [],
  loading: false,
  error: null,

  fetchUsers: async () => {
    set({ loading: true, error: null });
    try {
      const users = await userService.getUsers();
      set({ users, loading: false });
    } catch (error) {
      set({ error: error as Error, loading: false });
    }
  },

  addUser: (user) =>
    set((state) => ({ users: [...state.users, user] })),

  removeUser: (id) =>
    set((state) => ({ users: state.users.filter((u) => u.id !== id) })),
}));
```

### Using Store in Components

```typescript
function UserList() {
  const { users, loading, fetchUsers } = useUserStore();

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  if (loading) return <Spinner />;

  return (
    <ul>
      {users.map((user) => (
        <UserItem key={user.id} user={user} />
      ))}
    </ul>
  );
}
```

### Slices Pattern

Split large stores into slices:

```typescript
// src/stores/slices/userSlice.ts
export const createUserSlice = (set, get) => ({
  users: [],
  fetchUsers: async () => {
    const users = await userService.getUsers();
    set({ users });
  },
});

// src/stores/slices/authSlice.ts
export const createAuthSlice = (set, get) => ({
  user: null,
  token: null,
  login: async (credentials) => {
    const { user, token } = await authService.login(credentials);
    set({ user, token });
  },
});

// src/stores/appStore.ts
import { create } from 'zustand';
import { createUserSlice } from './slices/userSlice';
import { createAuthSlice } from './slices/authSlice';

export const useAppStore = create((set, get) => ({
  ...createUserSlice(set, get),
  ...createAuthSlice(set, get),
}));
```

### Middleware

```typescript
import { create } from 'zustand';
import { persist, devtools } from 'zustand/middleware';

interface AuthState {
  user: User | null;
  token: string | null;
  login: (user: User, token: string) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  devtools(
    persist(
      (set) => ({
        user: null,
        token: null,
        login: (user, token) => set({ user, token }),
        logout: () => set({ user: null, token: null }),
      }),
      { name: 'auth-storage' }
    )
  )
);
```

## Redux Toolkit

### Store Setup

```typescript
// src/stores/store.ts
import { configureStore } from '@reduxjs/toolkit';
import userReducer from './slices/userSlice';
import authReducer from './slices/authSlice';

export const store = configureStore({
  reducer: {
    users: userReducer,
    auth: authReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
```

### Slice

```typescript
// src/stores/slices/userSlice.ts
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { userService } from '@/services/api/userService';
import { User } from '@/types/User';

interface UserState {
  users: User[];
  loading: boolean;
  error: string | null;
}

export const fetchUsers = createAsyncThunk(
  'users/fetchUsers',
  async () => {
    const users = await userService.getUsers();
    return users;
  }
);

const userSlice = createSlice({
  name: 'users',
  initialState: {
    users: [],
    loading: false,
    error: null,
  } as UserState,
  reducers: {
    addUser: (state, action) => {
      state.users.push(action.payload);
    },
    removeUser: (state, action) => {
      state.users = state.users.filter((u) => u.id !== action.payload);
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchUsers.pending, (state) => {
        state.loading = true;
      })
      .addCase(fetchUsers.fulfilled, (state, action) => {
        state.loading = false;
        state.users = action.payload;
      })
      .addCase(fetchUsers.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch users';
      });
  },
});

export const { addUser, removeUser } = userSlice.actions;
export default userSlice.reducer;
```

### Hooks

```typescript
// src/stores/hooks.ts
import { TypedUseSelectorHook, useDispatch, useSelector } from 'react-redux';
import type { RootState, AppDispatch } from './store';

export const useAppDispatch = () => useDispatch<AppDispatch>();
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
```

### Using Redux in Components

```typescript
function UserList() {
  const dispatch = useAppDispatch();
  const { users, loading } = useAppSelector((state) => state.users);

  useEffect(() => {
    dispatch(fetchUsers());
  }, [dispatch]);

  if (loading) return <Spinner />;

  return (
    <ul>
      {users.map((user) => (
        <UserItem key={user.id} user={user} />
      ))}
    </ul>
  );
}
```

## Context API

### Create Context

```typescript
// src/contexts/ThemeContext.tsx
import { createContext, useContext, useState, ReactNode } from 'react';

interface ThemeContextValue {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextValue | null>(null);

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');

  const toggleTheme = () => {
    setTheme((t) => (t === 'light' ? 'dark' : 'light'));
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}
```

### Using Context

```typescript
function App() {
  return (
    <ThemeProvider>
      <HomePage />
    </ThemeProvider>
  );
}

function HomePage() {
  const { theme, toggleTheme } = useTheme();

  return (
    <div className={theme}>
      <button onClick={toggleTheme}>Toggle Theme</button>
    </div>
  );
}
```

## Performance Optimization

### Selectors with Zustand

```typescript
// Only re-render when users change, not loading or error
function UserList() {
  const users = useUserStore((state) => state.users);

  return (
    <ul>
      {users.map((user) => (
        <UserItem key={user.id} user={user} />
      ))}
    </ul>
  );
}
```

### Memoized Selectors with Redux

```typescript
import { createSelector } from '@reduxjs/toolkit';

const selectUsers = (state: RootState) => state.users.users;
const selectFilter = (state: RootState) => state.users.filter;

export const selectFilteredUsers = createSelector(
  [selectUsers, selectFilter],
  (users, filter) => users.filter((u) => u.status === filter)
);

// Component
function UserList() {
  const filteredUsers = useAppSelector(selectFilteredUsers);
  return <ul>{/* ... */}</ul>;
}
```

## Best Practices

1. **Use local state first**: Only lift to global when needed
2. **Normalize state**: Avoid nested objects, use IDs
3. **One source of truth**: Don't duplicate state
4. **Immutable updates**: Never mutate state directly
5. **Selective subscriptions**: Subscribe to minimal state
6. **Async in actions**: Keep reducers pure
7. **Type everything**: Use TypeScript for type safety
8. **DevTools**: Use Redux/Zustand devtools for debugging
