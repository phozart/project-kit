# Unit Testing Patterns

Unit tests validate individual components or functions in isolation.

## Arrange-Act-Assert Pattern

```typescript
test('should calculate total price with discount', () => {
  // Arrange
  const cart = new ShoppingCart();
  cart.addItem({ id: 1, price: 100 });
  const discount = 0.1;

  // Act
  const total = cart.calculateTotal(discount);

  // Assert
  expect(total).toBe(90);
});
```

## Mocking Dependencies

### Mocking External Services
```typescript
// Mock HTTP client
const mockHttp = {
  get: jest.fn().mockResolvedValue({ data: { id: 1, name: 'Test' } })
};

test('should fetch user data', async () => {
  const service = new UserService(mockHttp);
  const user = await service.getUser(1);

  expect(mockHttp.get).toHaveBeenCalledWith('/users/1');
  expect(user.name).toBe('Test');
});
```

### Mocking Time
```typescript
beforeEach(() => {
  jest.useFakeTimers();
  jest.setSystemTime(new Date('2024-01-01'));
});

afterEach(() => {
  jest.useRealTimers();
});
```

## Parameterized Tests

```typescript
test.each([
  { input: 0, expected: 0 },
  { input: 1, expected: 1 },
  { input: 5, expected: 120 },
])('factorial($input) should return $expected', ({ input, expected }) => {
  expect(factorial(input)).toBe(expected);
});
```

## Testing Error Conditions

```typescript
test('should throw error for negative input', () => {
  expect(() => factorial(-1)).toThrow('Input must be non-negative');
});

test('should handle null input gracefully', () => {
  const result = processData(null);
  expect(result).toBeNull();
});
```

## Testing Async Code

```typescript
test('should resolve with data', async () => {
  const data = await fetchData();
  expect(data).toHaveProperty('id');
});

test('should reject with error', async () => {
  await expect(fetchData()).rejects.toThrow('Network error');
});
```

## Test Doubles

- **Stub**: Returns predefined values
- **Mock**: Records calls and validates interactions
- **Spy**: Wraps real object, tracks calls
- **Fake**: Simplified working implementation
