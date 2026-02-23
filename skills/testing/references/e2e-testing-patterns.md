# End-to-End Testing Patterns

E2E tests validate complete user journeys through the application.

## Playwright Patterns

### Page Object Model
```typescript
// pages/LoginPage.ts
export class LoginPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.page.fill('[data-testid="email"]', email);
    await this.page.fill('[data-testid="password"]', password);
    await this.page.click('[data-testid="login-button"]');
  }

  async getErrorMessage() {
    return this.page.textContent('[data-testid="error-message"]');
  }
}

// tests/login.e2e.test.ts
test('should login successfully', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.login('user@example.com', 'password123');

  await expect(page).toHaveURL('/dashboard');
});
```

### Testing User Journeys
```typescript
test('complete purchase flow', async ({ page }) => {
  // Navigate to product
  await page.goto('/products/1');
  await page.click('[data-testid="add-to-cart"]');

  // View cart
  await page.click('[data-testid="cart-icon"]');
  await expect(page.locator('[data-testid="cart-item"]')).toHaveCount(1);

  // Checkout
  await page.click('[data-testid="checkout-button"]');
  await page.fill('[data-testid="card-number"]', '4242424242424242');
  await page.fill('[data-testid="expiry"]', '12/25');
  await page.fill('[data-testid="cvc"]', '123');

  // Complete order
  await page.click('[data-testid="place-order"]');
  await expect(page.locator('[data-testid="order-confirmation"]')).toBeVisible();
});
```

## Cypress Patterns

### Custom Commands
```typescript
// cypress/support/commands.ts
Cypress.Commands.add('login', (email: string, password: string) => {
  cy.visit('/login');
  cy.get('[data-cy=email]').type(email);
  cy.get('[data-cy=password]').type(password);
  cy.get('[data-cy=login-button]').click();
});

// cypress/e2e/dashboard.cy.ts
describe('Dashboard', () => {
  beforeEach(() => {
    cy.login('user@example.com', 'password123');
  });

  it('should display user stats', () => {
    cy.get('[data-cy=stats-widget]').should('be.visible');
    cy.get('[data-cy=order-count]').should('contain', '5');
  });
});
```

### Network Stubbing
```typescript
it('should handle API errors gracefully', () => {
  cy.intercept('GET', '/api/orders', {
    statusCode: 500,
    body: { error: 'Internal Server Error' }
  });

  cy.visit('/orders');
  cy.get('[data-cy=error-message]').should('contain', 'Failed to load orders');
});
```

## Wait Strategies

```typescript
// Wait for element
await page.waitForSelector('[data-testid="results"]');

// Wait for navigation
await page.waitForNavigation();

// Wait for network idle
await page.waitForLoadState('networkidle');

// Custom wait condition
await page.waitForFunction(() => {
  return document.querySelectorAll('.item').length > 5;
});
```

## Accessibility Testing

```typescript
import { injectAxe, checkA11y } from 'axe-playwright';

test('should have no accessibility violations', async ({ page }) => {
  await page.goto('/');
  await injectAxe(page);
  await checkA11y(page);
});
```

## Visual Regression Testing

```typescript
test('homepage visual test', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveScreenshot('homepage.png');
});
```
