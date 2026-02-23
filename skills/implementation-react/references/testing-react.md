# Testing React

Testing strategies using React Testing Library, MSW, and jest-axe.

## Testing Philosophy

**Test behavior, not implementation**
- Test what users see and do
- Avoid testing internal state
- Query by accessible roles and labels
- Interact like users (click, type)

## Testing Library Setup

```bash
npm install --save-dev @testing-library/react @testing-library/jest-dom @testing-library/user-event
```

```typescript
// src/test/setup.ts
import '@testing-library/jest-dom';
```

## Component Testing

### Basic Component Test

```typescript
// Button.test.tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Button } from './Button';

describe('Button', () => {
  it('renders button with text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: 'Click me' })).toBeInTheDocument();
  });

  it('calls onClick when clicked', async () => {
    const user = userEvent.setup();
    const handleClick = jest.fn();

    render(<Button onClick={handleClick}>Click me</Button>);

    await user.click(screen.getByRole('button'));

    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('is disabled when disabled prop is true', () => {
    render(<Button disabled>Click me</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });
});
```

### Form Testing

```typescript
// UserForm.test.tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { UserForm } from './UserForm';

describe('UserForm', () => {
  it('submits form with user data', async () => {
    const user = userEvent.setup();
    const handleSubmit = jest.fn();

    render(<UserForm onSubmit={handleSubmit} />);

    // Fill in form
    await user.type(screen.getByLabelText('Email'), 'user@example.com');
    await user.type(screen.getByLabelText('First Name'), 'John');
    await user.type(screen.getByLabelText('Last Name'), 'Doe');

    // Submit
    await user.click(screen.getByRole('button', { name: 'Submit' }));

    expect(handleSubmit).toHaveBeenCalledWith({
      email: 'user@example.com',
      firstName: 'John',
      lastName: 'Doe',
    });
  });

  it('displays validation errors', async () => {
    const user = userEvent.setup();
    render(<UserForm onSubmit={jest.fn()} />);

    // Submit without filling form
    await user.click(screen.getByRole('button', { name: 'Submit' }));

    expect(screen.getByText('Email is required')).toBeInTheDocument();
  });
});
```

## Query Priority

Use queries in this order (most to least preferred):

1. **getByRole**: Most accessible
```typescript
screen.getByRole('button', { name: 'Submit' });
screen.getByRole('textbox', { name: 'Email' });
screen.getByRole('heading', { name: 'User Profile' });
```

2. **getByLabelText**: For form fields
```typescript
screen.getByLabelText('Email');
```

3. **getByPlaceholderText**: For inputs with placeholders
```typescript
screen.getByPlaceholderText('Enter email');
```

4. **getByText**: For non-interactive elements
```typescript
screen.getByText('Welcome!');
```

5. **getByTestId**: Last resort
```typescript
screen.getByTestId('custom-element');
```

## Async Testing

### Wait for Elements

```typescript
import { waitFor } from '@testing-library/react';

it('displays users after loading', async () => {
  render(<UserList />);

  // Wait for loading to finish
  await waitFor(() => {
    expect(screen.queryByText('Loading...')).not.toBeInTheDocument();
  });

  // Check users are displayed
  expect(screen.getByText('John Doe')).toBeInTheDocument();
});
```

### findBy Queries (Async)

```typescript
it('displays user after fetching', async () => {
  render(<UserDetail userId="123" />);

  // findBy waits automatically
  const userName = await screen.findByText('John Doe');
  expect(userName).toBeInTheDocument();
});
```

## Mocking API Calls

### Mock Service Worker (MSW)

```typescript
// src/test/mocks/handlers.ts
import { http, HttpResponse } from 'msw';

export const handlers = [
  http.get('/api/users', () => {
    return HttpResponse.json([
      { id: '1', firstName: 'John', lastName: 'Doe', email: 'john@example.com' },
      { id: '2', firstName: 'Jane', lastName: 'Smith', email: 'jane@example.com' },
    ]);
  }),

  http.post('/api/users', async ({ request }) => {
    const newUser = await request.json();
    return HttpResponse.json(
      { id: '3', ...newUser },
      { status: 201 }
    );
  }),

  http.delete('/api/users/:id', () => {
    return new HttpResponse(null, { status: 204 });
  }),
];
```

```typescript
// src/test/mocks/server.ts
import { setupServer } from 'msw/node';
import { handlers } from './handlers';

export const server = setupServer(...handlers);
```

```typescript
// src/test/setup.ts
import { server } from './mocks/server';

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

### Test with MSW

```typescript
import { server } from '@/test/mocks/server';
import { http, HttpResponse } from 'msw';

it('displays error when fetch fails', async () => {
  // Override handler for this test
  server.use(
    http.get('/api/users', () => {
      return new HttpResponse(null, { status: 500 });
    })
  );

  render(<UserList />);

  expect(await screen.findByText('Failed to load users')).toBeInTheDocument();
});
```

## Testing Hooks

```typescript
// useCounter.test.ts
import { renderHook, act } from '@testing-library/react';
import { useCounter } from './useCounter';

describe('useCounter', () => {
  it('increments counter', () => {
    const { result } = renderHook(() => useCounter());

    expect(result.current.count).toBe(0);

    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });

  it('accepts initial value', () => {
    const { result } = renderHook(() => useCounter(10));
    expect(result.current.count).toBe(10);
  });
});
```

## Accessibility Testing

```bash
npm install --save-dev jest-axe
```

```typescript
import { render } from '@testing-library/react';
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

it('has no accessibility violations', async () => {
  const { container } = render(<UserForm onSubmit={jest.fn()} />);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

## Testing Context

```typescript
function renderWithTheme(ui: ReactElement) {
  return render(
    <ThemeProvider>
      {ui}
    </ThemeProvider>
  );
}

it('renders with theme', () => {
  renderWithTheme(<Button>Click me</Button>);
  expect(screen.getByRole('button')).toHaveClass('light-theme');
});
```

## Testing Router

```typescript
import { MemoryRouter } from 'react-router-dom';

function renderWithRouter(ui: ReactElement, { route = '/' } = {}) {
  return render(
    <MemoryRouter initialEntries={[route]}>
      {ui}
    </MemoryRouter>
  );
}

it('navigates to user detail', async () => {
  const user = userEvent.setup();
  renderWithRouter(<UserList />, { route: '/users' });

  await user.click(screen.getByText('John Doe'));

  expect(screen.getByRole('heading', { name: 'John Doe' })).toBeInTheDocument();
});
```

## Snapshot Testing (Use Sparingly)

```typescript
it('matches snapshot', () => {
  const { container } = render(<Button>Click me</Button>);
  expect(container).toMatchSnapshot();
});
```

## Best Practices

1. Test user behavior, not implementation
2. Use accessible queries (getByRole, getByLabelText)
3. Mock network calls with MSW
4. Test error states and edge cases
5. Use waitFor for async updates
6. Test accessibility with jest-axe
7. Avoid testing implementation details
8. Keep tests simple and readable
9. Use descriptive test names
10. One assertion per test (when possible)
