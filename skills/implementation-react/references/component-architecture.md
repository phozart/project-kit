# Component Architecture

Component composition patterns and architectural principles.

## Component Hierarchy

```
App
├── Layout
│   ├── Header
│   │   ├── Logo
│   │   └── Navigation
│   ├── Sidebar
│   └── Footer
└── Pages
    └── UserList
        ├── UserFilters
        ├── UserTable
        │   ├── UserRow
        │   └── UserActions
        └── Pagination
```

## Atomic Design

### Atoms (Basic Building Blocks)

```typescript
// Button
export function Button({ children, ...props }: ButtonProps) {
  return <button {...props}>{children}</button>;
}

// Input
export function Input({ label, ...props }: InputProps) {
  return (
    <div>
      {label && <label>{label}</label>}
      <input {...props} />
    </div>
  );
}
```

### Molecules (Simple Component Groups)

```typescript
// SearchField
export function SearchField({ onSearch }: SearchFieldProps) {
  return (
    <div>
      <Input placeholder="Search..." />
      <Button onClick={onSearch}>Search</Button>
    </div>
  );
}

// FormField
export function FormField({ label, error, children }: FormFieldProps) {
  return (
    <div>
      <label>{label}</label>
      {children}
      {error && <span>{error}</span>}
    </div>
  );
}
```

### Organisms (Complex Components)

```typescript
// UserForm
export function UserForm({ onSubmit }: UserFormProps) {
  return (
    <form onSubmit={onSubmit}>
      <FormField label="Email">
        <Input type="email" name="email" />
      </FormField>
      <FormField label="Name">
        <Input type="text" name="name" />
      </FormField>
      <Button type="submit">Save</Button>
    </form>
  );
}
```

### Templates (Page Layouts)

```typescript
// DashboardLayout
export function DashboardLayout({ children }: LayoutProps) {
  return (
    <div className={styles.layout}>
      <Header />
      <Sidebar />
      <main className={styles.main}>{children}</main>
      <Footer />
    </div>
  );
}
```

### Pages (Complete Views)

```typescript
// UsersPage
export function UsersPage() {
  const { users } = useUsers();

  return (
    <DashboardLayout>
      <h1>Users</h1>
      <SearchField onSearch={handleSearch} />
      <UserTable users={users} />
      <Pagination />
    </DashboardLayout>
  );
}
```

## Props Patterns

### Props Spreading

```typescript
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary';
}

export function Button({ variant = 'primary', ...props }: ButtonProps) {
  return <button className={variant} {...props} />;
}
```

### Discriminated Union Props

```typescript
type ButtonProps =
  | { variant: 'link'; href: string }
  | { variant: 'button'; onClick: () => void };

export function Button(props: ButtonProps) {
  if (props.variant === 'link') {
    return <a href={props.href}>Link</a>;
  }
  return <button onClick={props.onClick}>Button</button>;
}
```

### Children Patterns

```typescript
// Children as function
interface RenderProps {
  value: number;
  increment: () => void;
}

function Counter({ children }: { children: (props: RenderProps) => ReactNode }) {
  const [value, setValue] = useState(0);
  return <>{children({ value, increment: () => setValue(v => v + 1) })}</>;
}

// Multiple children slots
interface CardProps {
  header: ReactNode;
  footer: ReactNode;
  children: ReactNode;
}

function Card({ header, footer, children }: CardProps) {
  return (
    <div>
      <div className="header">{header}</div>
      <div className="body">{children}</div>
      <div className="footer">{footer}</div>
    </div>
  );
}
```

## Composition Patterns

### Higher-Order Components (HOC)

```typescript
function withLoading<P extends object>(
  Component: React.ComponentType<P>
) {
  return function WithLoadingComponent(
    props: P & { loading: boolean }
  ) {
    const { loading, ...restProps } = props;
    if (loading) return <Spinner />;
    return <Component {...(restProps as P)} />;
  };
}

const UserListWithLoading = withLoading(UserList);
```

### Slots Pattern

```typescript
interface PageProps {
  header?: ReactNode;
  sidebar?: ReactNode;
  children: ReactNode;
}

export function Page({ header, sidebar, children }: PageProps) {
  return (
    <div className={styles.page}>
      {header && <header className={styles.header}>{header}</header>}
      <div className={styles.content}>
        {sidebar && <aside className={styles.sidebar}>{sidebar}</aside>}
        <main className={styles.main}>{children}</main>
      </div>
    </div>
  );
}

// Usage
<Page
  header={<h1>Dashboard</h1>}
  sidebar={<Navigation />}
>
  <UserList />
</Page>
```

### Provider Pattern

```typescript
interface ThemeContextValue {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextValue | null>(null);

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');

  const toggleTheme = () => {
    setTheme(t => t === 'light' ? 'dark' : 'light');
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) throw new Error('useTheme must be used within ThemeProvider');
  return context;
}
```

## Component Communication

### Parent to Child (Props)

```typescript
function Parent() {
  const [count, setCount] = useState(0);
  return <Child count={count} />;
}

function Child({ count }: { count: number }) {
  return <div>Count: {count}</div>;
}
```

### Child to Parent (Callbacks)

```typescript
function Parent() {
  const handleChildEvent = (data: string) => {
    console.log('Child event:', data);
  };
  return <Child onEvent={handleChildEvent} />;
}

function Child({ onEvent }: { onEvent: (data: string) => void }) {
  return <button onClick={() => onEvent('clicked')}>Click</button>;
}
```

### Sibling to Sibling (Lift State)

```typescript
function Parent() {
  const [sharedState, setSharedState] = useState('');

  return (
    <>
      <ChildA value={sharedState} onChange={setSharedState} />
      <ChildB value={sharedState} />
    </>
  );
}
```

### Global Communication (Context/Store)

```typescript
// Using Context
const UserContext = createContext<User | null>(null);

function App() {
  const [user, setUser] = useState<User | null>(null);
  return (
    <UserContext.Provider value={user}>
      <ChildComponent />
    </UserContext.Provider>
  );
}

function ChildComponent() {
  const user = useContext(UserContext);
  return <div>{user?.name}</div>;
}
```

## Best Practices

1. **Single Responsibility**: Each component does one thing
2. **Composition Over Inheritance**: Build complex UI from simple components
3. **Props Interface**: Always type your props
4. **Default Props**: Provide sensible defaults
5. **Keep Components Pure**: Same props = same output
6. **Lift State Up**: Share state at lowest common ancestor
7. **Avoid Prop Drilling**: Use context or state management
8. **Component Size**: Under 200 lines, split if larger
9. **File Organization**: One component per file
10. **Naming**: Clear, descriptive names (UserList, not List)
