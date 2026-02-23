# Code Review Checklist

Comprehensive checklist for code quality and standards compliance.

## Contract Compliance

- [ ] All API endpoints match contract specifications in `docs/contracts/`
- [ ] Request/response schemas validated
- [ ] Error responses follow contract format
- [ ] Contract versioning implemented correctly
- [ ] Breaking changes documented

## Code Quality

### Readability
- [ ] Code is self-documenting with clear names
- [ ] Complex logic has explanatory comments
- [ ] Functions are small and focused (< 50 lines)
- [ ] Consistent code formatting
- [ ] No commented-out code

### Design Patterns
- [ ] Appropriate design patterns applied
- [ ] Separation of concerns maintained
- [ ] Dependency injection used where appropriate
- [ ] Factory pattern for complex object creation
- [ ] Strategy pattern for variable algorithms

### SOLID Principles
- [ ] Single Responsibility: Each class has one reason to change
- [ ] Open/Closed: Open for extension, closed for modification
- [ ] Liskov Substitution: Subtypes can replace base types
- [ ] Interface Segregation: No client forced to depend on unused methods
- [ ] Dependency Inversion: Depend on abstractions, not concretions

## Error Handling

- [ ] All exceptions caught and handled appropriately
- [ ] Custom exception types for domain errors
- [ ] Error messages are clear and actionable
- [ ] Stack traces logged for debugging
- [ ] No swallowed exceptions
- [ ] Graceful degradation for non-critical errors

## Logging and Observability

- [ ] Appropriate log levels (DEBUG, INFO, WARN, ERROR)
- [ ] Structured logging with context
- [ ] No sensitive data in logs (passwords, tokens, PII)
- [ ] Key operations logged (start, success, failure)
- [ ] Performance metrics logged
- [ ] Correlation IDs for request tracing

## Test Coverage

- [ ] Unit tests for all business logic (80%+ coverage)
- [ ] Integration tests for API endpoints
- [ ] E2E tests for critical user journeys
- [ ] Edge cases tested
- [ ] Error conditions tested
- [ ] Tests are independent and repeatable

## Performance

- [ ] No N+1 query problems
- [ ] Database queries use indexes
- [ ] Caching applied where appropriate
- [ ] Lazy loading for expensive operations
- [ ] Pagination for large datasets
- [ ] Resource cleanup (connections, files)

## Security

- [ ] Input validation on all user input
- [ ] Output encoding to prevent XSS
- [ ] Parameterized queries (no SQL injection)
- [ ] Authentication checked on protected endpoints
- [ ] Authorization verified before operations
- [ ] Secrets not hardcoded

## Documentation

- [ ] Public APIs documented
- [ ] Complex algorithms explained
- [ ] Architecture decisions recorded (ADRs)
- [ ] README up to date
- [ ] Configuration options documented

## Dependencies

- [ ] No unnecessary dependencies
- [ ] Dependencies up to date (security patches)
- [ ] License compatibility verified
- [ ] Dependency versions pinned
