# Integration Testing Patterns

Integration tests validate interactions between components, services, and external systems.

## API Endpoint Testing

### REST API Tests
```typescript
describe('POST /api/orders', () => {
  test('should create order and return 201', async () => {
    const response = await request(app)
      .post('/api/orders')
      .send({ items: [{ id: 1, quantity: 2 }], customerId: 123 })
      .expect(201);

    expect(response.body).toHaveProperty('orderId');
    expect(response.body.status).toBe('pending');
  });

  test('should return 400 for invalid input', async () => {
    await request(app)
      .post('/api/orders')
      .send({ items: [] })
      .expect(400);
  });
});
```

### GraphQL Tests
```typescript
test('should query user with orders', async () => {
  const query = `
    query {
      user(id: "123") {
        name
        orders { id status }
      }
    }
  `;

  const response = await graphqlRequest(query);
  expect(response.data.user.orders).toHaveLength(2);
});
```

## Database Integration Testing

### Transaction Testing
```java
@Test
@Transactional
public void shouldSaveOrderWithItems() {
    Order order = new Order();
    order.addItem(new OrderItem("Product1", 2));

    Order saved = orderRepository.save(order);

    assertThat(saved.getId()).isNotNull();
    assertThat(saved.getItems()).hasSize(1);
}
```

### Repository Testing with Test Containers
```java
@Testcontainers
class OrderRepositoryTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:15");

    @Test
    void shouldFindOrdersByCustomer() {
        List<Order> orders = orderRepository.findByCustomerId(123L);
        assertThat(orders).isNotEmpty();
    }
}
```

## Service Integration Testing

### Testing Service-to-Service Communication
```typescript
describe('OrderService integration', () => {
  let inventoryService: InventoryService;
  let orderService: OrderService;

  beforeEach(() => {
    inventoryService = new InventoryService(realHttpClient);
    orderService = new OrderService(inventoryService);
  });

  test('should reserve inventory when creating order', async () => {
    const order = await orderService.createOrder({
      items: [{ productId: 1, quantity: 2 }]
    });

    const inventory = await inventoryService.getStock(1);
    expect(inventory.reserved).toBe(2);
  });
});
```

## Message Queue Integration

```typescript
test('should process message and update database', async (done) => {
  const message = { orderId: 123, status: 'shipped' };

  await messageQueue.publish('order.updated', message);

  setTimeout(async () => {
    const order = await orderRepository.findById(123);
    expect(order.status).toBe('shipped');
    done();
  }, 1000);
});
```

## Test Data Setup

```typescript
beforeEach(async () => {
  await database.migrate.latest();
  await database.seed.run();
});

afterEach(async () => {
  await database.migrate.rollback();
});
```
