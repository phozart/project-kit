---
name: testing
description: Write tests that prove the product works for real users. Connects acceptance criteria, performance contracts, and failure modes to concrete test cases. Not a pattern library — a thinking framework for what to test and why.
---

# Testing

## What Tests Are For

Tests don't exist to reach coverage numbers. They exist to answer one question: **"Can we prove this works the way the user needs it to?"**

Every test should trace back to one of:
- An acceptance criterion from the task brief
- An edge case from the product design
- A performance contract from implementation thinking
- A failure mode identified in product framing
- A connection between features that could break

If a test doesn't trace to any of these, ask why it exists. It might still be valid (guarding against regression), but it should be the exception, not the default.

## Test Planning: Before Writing Tests

Before writing any test code, read the task brief and implementation notes. Then answer:

### 1. What Must Be True?

Pull directly from the task brief's acceptance criteria. Each criterion becomes at least one test.

```
Task brief says: "User can create a dispatch with origin, destination, date, and item count"
-> Test: create dispatch with valid data -> dispatch exists in database with correct fields
-> Test: create dispatch with missing required field -> validation error returned
-> Test: create dispatch with future date -> allowed
-> Test: create dispatch with past date -> warning but allowed (from edge cases)
```

### 2. What Must Not Break?

Pull from the task brief's edge cases and "out of scope" statements.

```
Task brief says: "Empty item count defaults to 0. 10,000+ records must load in <2s."
-> Test: create dispatch without item count -> item count is 0, not null
-> Test: list dispatches with 10,000 records -> response time < 2 seconds
-> Test: create dispatch while unauthenticated -> 401, not 500
```

### 3. What Could Go Wrong for the User?

Pull from the product design's failure modes and the implementation notes' regret check.

```
Implementation notes say: "Operator misses delayed dispatch because filter was too slow"
-> Test: filter query with 50,000 records and composite index -> response < 500ms
-> Test: filter query WITHOUT the index -> verify it would be slow (this validates the index matters)
-> Test: WebSocket disconnects -> UI shows "stale data" warning within 5 seconds
-> Test: filter state persists in URL -> copy URL, open in new tab, same filter applied
```

### 4. What Connects to Other Features?

Pull from implementation notes' connections section.

```
Implementation notes say: "Filter state shared with dispatch detail via URL params"
-> Test: apply filter -> click dispatch -> back button -> filter still applied
-> Test: filter URL params match between list and detail views
```

### Test Plan Output

Before writing test code, produce a brief test plan as a comment block or `TASK-XXX-tests.md`:

```
// TEST PLAN: TASK-012 — Dispatch Filter
//
// FROM ACCEPTANCE CRITERIA:
// - [ ] Filter by date range returns only dispatches within range
// - [ ] Filter by destination country returns correct results
// - [ ] Filter by status "delayed" shows only delayed dispatches
// - [ ] Combined filters (date + country + status) work together
// - [ ] Clear filters returns to default view
//
// FROM EDGE CASES:
// - [ ] Filter with no results shows "No matching dispatches" message
// - [ ] Filter with 50,000+ records responds in < 500ms
// - [ ] Filter with date range spanning DST change handles correctly
//
// FROM FAILURE MODES:
// - [ ] Default view shows delayed dispatches without requiring filter action
// - [ ] Auto-refresh updates results without losing filter state
// - [ ] Stale data warning appears when WebSocket disconnects
//
// FROM CONNECTIONS:
// - [ ] Filter state encoded in URL params (shareable)
// - [ ] Filter state preserved when navigating to detail and back
// - [ ] Filter state compatible with dispatch detail view URL structure
//
// PERFORMANCE:
// - [ ] Filter query with composite index: < 500ms on 50,000 records
// - [ ] Auto-refresh cycle: < 200ms incremental update
```

This plan takes 5 minutes. It prevents writing 20 tests that all test the happy path and missing the edge case that causes the real production bug.

## Testing by Interaction Pattern

The implementation thinking skill identifies the interaction pattern for each task. Different patterns need different testing strategies. The test pyramid still applies, but WHAT you test at each level changes.

### Testing CRUD Features

Unit tests:
- Validation rules (each field constraint)
- Business logic in service layer (uniqueness checks, cascading deletes)
- Data transformation (entity <-> DTO mapping)

Integration tests:
- Full create -> read -> update -> delete cycle through API
- Concurrent edit handling (if applicable)
- Cascade behavior (delete parent -> what happens to children?)
- Pagination with real data volumes

Skip: E2E for simple CRUD unless it's the first feature built (then E2E validates the full stack works).

### Testing Search & Filter Features

Unit tests:
- Query builder logic (filter combination produces correct WHERE clause)
- URL param encoding/decoding for filter state
- Debounce behavior on search input
- Faceted count calculation

Integration tests:
- Filter queries against real database with realistic data volumes
- Performance: response time with 10x expected data volume
- Index validation: query plan uses expected indexes
- Empty result handling vs. too-narrow filter detection

E2E tests:
- Filter state survives page refresh (URL-encoded)
- Filter state shareable (copy URL -> new browser -> same results)
- Combined filter interaction (add filter A, add filter B, remove filter A)
- Saved search/preset creation and recall

Performance tests (REQUIRED for search features):
- Response time at expected data volume
- Response time at 10x expected data volume
- Concurrent filter requests under load

### Testing Monitor & Alert Features

Unit tests:
- Threshold calculation (when does a value become "alert"?)
- Alert severity classification logic
- Visual diff calculation (what changed between refreshes?)
- Stale data detection logic

Integration tests:
- Real-time data flow (WebSocket/SSE/polling delivers updates)
- Alert triggers under realistic conditions
- Acknowledge/snooze persistence
- Reconnection after disconnect

E2E tests:
- Alert appears within acceptable latency of triggering event
- Alert visual treatment matches severity (critical vs. warning vs. info)
- Alert acknowledgment persists across refresh
- Stale data warning appears on connection loss
- Alert sound/notification fires when tab is in background (if applicable)

Performance tests (CRITICAL for monitoring features):
- Polling/refresh cycle time under load
- WebSocket message throughput
- UI rendering time with many simultaneous alerts
- Memory usage over extended sessions (8-hour operator shift)

Resilience tests (UNIQUE to monitoring):
- Server restart -> client reconnects and recovers state
- Network interruption -> stale data warning -> auto-reconnect
- Data gap during outage -> gap is visible, not silently missing

### Testing Workflow & Queue Features

Unit tests:
- State machine transitions (valid and invalid)
- Queue ordering logic
- Lock acquisition and release
- Timeout calculation

Integration tests:
- Concurrent processing (two users claim same item)
- Lock expiry and return-to-queue
- Bulk action across multiple items
- State transition across services

E2E tests:
- Complete workflow: pick item -> process -> complete -> next item appears
- Queue position updates in real-time
- Return to queue on abandonment/timeout
- Bulk action confirmation and undo

Performance tests:
- Queue processing throughput (items per minute)
- Prefetch effectiveness (next item loads before current completes)
- Lock contention under concurrent access

### Testing Analysis & Exploration Features

Unit tests:
- Aggregation calculations
- Comparison logic
- Drill-down path generation
- Export data formatting

Integration tests:
- Aggregation queries against real data
- Drill-down produces correct scoped data
- Cross-referencing between datasets
- Export matches displayed view

E2E tests:
- Exploration state bookmarkable (URL reflects current view)
- Breadcrumb trail allows jump to any prior level
- Compare mode shows correct side-by-side data
- Export produces file matching current filtered/aggregated view

### Testing Configuration & Setup Features

Unit tests:
- Cross-field validation rules
- Impact analysis calculation
- Preview generation

Integration tests:
- Configuration save and load cycle
- Impact analysis reflects real data relationships
- Version history creates correct diffs

E2E tests:
- Preview before commit shows accurate representation
- Undo reverts to previous state correctly
- Template/copy produces independent copy

### Testing Import & Transform Features

Unit tests:
- Parser handles well-formed and malformed input
- Transformation rules produce correct output
- Duplicate detection logic
- Partial success handling

Integration tests:
- Import with realistic file sizes
- Rollback after failed import
- Duplicate handling (skip, update, flag)

E2E tests:
- Preview step shows accurate representation of first N rows
- Error rows are identifiable and actionable
- Progress indicator updates during large import
- Completed import data is queryable immediately

Performance tests:
- Import time for expected file sizes
- Memory usage during large file processing
- Database write throughput during bulk insert

## Coverage Philosophy

80% line coverage is a vanity metric. A codebase can have 95% coverage and still break in production if all the tests cover the happy path.

### What Actually Matters

| Metric | Target | Why |
|--------|--------|-----|
| Acceptance criteria coverage | 100% | Every acceptance criterion has a test. No exceptions. |
| Edge case coverage | 100% | Every documented edge case has a test. |
| Failure mode coverage | 100% of critical | Every critical failure mode from product design has a test proving it's handled. |
| Performance contract coverage | 100% | Every performance target from implementation notes has a benchmark test. |
| Line coverage | 70%+ | Secondary metric. Useful for finding dead code, not for proving quality. |
| Branch coverage | 60%+ | Secondary metric. More useful than line coverage for logic validation. |

### What to Test vs. What Not to Test

Test:
- Every path a user can take (from acceptance criteria)
- Every boundary condition (from edge cases)
- Every failure the user would experience (from failure modes)
- Every performance commitment (from implementation notes)
- Every connection between features (from implementation notes)

Don't test:
- Framework internals (React rendering, Next.js routing)
- Third-party library behavior
- Trivial getters/setters
- Styling (unless visual regression testing is set up)
- Mock behavior (you're testing your mock, not your code)

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

## References

Detailed patterns and examples:
- `references/unit-testing-patterns.md` — Unit test patterns, mocking, assertions
- `references/integration-testing-patterns.md` — API testing, database testing, service integration
- `references/data-quality-testing.md` — Data validation, schema checks, completeness
- `references/e2e-testing-patterns.md` — Playwright/Cypress patterns, user journey testing
