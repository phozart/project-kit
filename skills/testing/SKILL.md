---
name: testing
description: Testing patterns for unit, integration, e2e, and data quality testing
---

# Testing Skill

Testing patterns and practices for all testing levels in the project-kit workflow. Testing is embedded throughout implementation, not a separate phase.

## Overview

This skill provides testing patterns for:
- **Unit Testing** — Component/function-level tests with mocking
- **Integration Testing** — API, service, and database integration tests
- **End-to-End Testing** — Full user journey testing with Playwright/Cypress
- **Data Quality Testing** — Data validation, schema checks, completeness

## When to Use

Use this skill when:
- Writing tests alongside implementation code
- User asks to "add tests" or "write tests for X"
- During feature implementation (tests are part of development)
- Validating data pipelines and transformations
- Setting up test infrastructure

## Core Principles

### Test-Driven Development
- Write tests alongside code, not after
- Red-Green-Refactor cycle
- Tests document expected behavior
- Tests enable confident refactoring

### Test Pyramid
- Many unit tests (fast, isolated)
- Fewer integration tests (slower, broader)
- Few e2e tests (slowest, full system)

### Test Independence
- Each test runs in isolation
- No shared state between tests
- Tests can run in any order
- Cleanup after each test

### Meaningful Assertions
- Test behavior, not implementation
- Clear error messages
- One logical assertion per test
- Use descriptive test names

## Testing Levels

### Unit Testing
Tests individual components or functions in isolation.

**Characteristics:**
- Fast execution (milliseconds)
- No external dependencies (use mocks/stubs)
- High code coverage target (80%+)
- Test edge cases and error conditions

**Patterns:**
- Arrange-Act-Assert structure
- Mock external dependencies
- Test public interface, not internals
- Parameterized tests for multiple inputs

See: `references/unit-testing-patterns.md`

### Integration Testing
Tests interaction between components, services, or systems.

**Characteristics:**
- Moderate execution time (seconds)
- Real dependencies (databases, APIs)
- Test contracts and interfaces
- Validate data flow

**Patterns:**
- API endpoint testing
- Database transaction testing
- Service-to-service communication
- Message queue integration

See: `references/integration-testing-patterns.md`

### End-to-End Testing
Tests complete user journeys through the application.

**Characteristics:**
- Slow execution (seconds to minutes)
- Full system deployment
- Browser automation
- Critical path coverage

**Patterns:**
- User journey scenarios
- Happy path and error handling
- Cross-browser testing
- Accessibility testing

See: `references/e2e-testing-patterns.md`

### Data Quality Testing
Tests data pipelines, transformations, and quality.

**Characteristics:**
- Validates data integrity
- Schema compliance
- Completeness and accuracy
- Transformation correctness

**Patterns:**
- Schema validation
- Null/missing value checks
- Data type verification
- Row count validation
- Referential integrity

See: `references/data-quality-testing.md`

## Test Organization

### Directory Structure
```
backend/
  src/
    main/java/com/example/
    test/java/com/example/
      unit/
      integration/
frontend/
  src/
    components/
      Button/
        Button.tsx
        Button.test.tsx
    tests/
      integration/
      e2e/
data/
  tests/
    unit/
    integration/
    data_quality/
```

### Naming Conventions
- Unit tests: `ClassName.test.ts` or `ClassName.spec.ts`
- Integration tests: `FeatureName.integration.test.ts`
- E2E tests: `user-journey-name.e2e.test.ts`
- Test methods: `test_should_do_something_when_condition()`

## Test Data Management

### Fixtures and Factories
- Use factories for test data generation
- Fixtures for consistent test scenarios
- Avoid hardcoded test data
- Clear test data after tests

### Database Testing
- Use test database separate from dev
- Transaction rollback after each test
- Seed data for consistent state
- Clear state between tests

## Mocking and Stubbing

### When to Mock
- External APIs
- Database connections (unit tests)
- File system operations
- Time-dependent operations
- Random number generation

### When NOT to Mock
- Integration tests (use real dependencies)
- Simple data structures
- Pure functions
- Internal domain logic

## Test Coverage

### Coverage Targets
- Unit tests: 80%+ line coverage
- Integration tests: Critical paths covered
- E2E tests: Core user journeys covered
- Data quality: All transformations validated

### Coverage Tools
- Backend: JaCoCo (Java), Coverage.py (Python)
- Frontend: Jest coverage, Istanbul
- Report in CI/CD pipeline

## References

Detailed patterns and examples:
- `references/unit-testing-patterns.md` — Unit test patterns, mocking, assertions
- `references/integration-testing-patterns.md` — API testing, database testing, service integration
- `references/data-quality-testing.md` — Data validation, schema checks, completeness
- `references/e2e-testing-patterns.md` — Playwright/Cypress patterns, user journey testing
