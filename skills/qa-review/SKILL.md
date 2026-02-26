---
name: qa-review
description: Quality validation at work package level (incremental) and system level (Phase 8). Connects to implementation thinking, performance contracts, and product failure modes.
---

# QA Review

## Two Levels of QA

### Level 1: Work Package QA (During Implementation)

Runs after every work package's BUILD stage. Scope: only the work package's changed code and features.

This is embedded in the work package lifecycle (see sprint-coordinator). The QA skill provides the criteria and methods for this level.

### Level 2: System QA (Phase 8)

Runs after ALL work packages are complete. Scope: the entire integrated system.

Phase 8 is NOT re-testing features (that happened at Level 1). Phase 8 validates:
- Cross-work-package integration (features built in WP-1 still work after WP-4 was added)
- System-level performance under realistic load
- Security across the full attack surface
- End-to-end user journeys that span multiple work packages
- Regression: nothing built later broke something built earlier

## Level 1: Work Package QA

### Automated Test Stage (TEST)

Run after all tasks in a work package complete. Automated, no human judgment.

Checklist:
- [ ] All unit tests pass (written during BUILD alongside code)
- [ ] All integration tests pass
- [ ] Linting: zero errors
- [ ] Type checking: zero errors
- [ ] Contract compliance: implementations match TYPE-CONTRACTS and API-CONTRACTS
- [ ] Performance contract tests pass (from implementation notes)

If any automated check fails -> identify which task(s) caused the failure -> return to BUILD -> fix -> re-run TEST.

### Code Review Stage (CODE REVIEW)

Review the code produced in this work package only. Read-only review, no code changes.

Checklist:
- [ ] Implementation notes exist for each task (5 questions answered)
- [ ] Code matches the interaction pattern identified in implementation notes
- [ ] Performance contract decisions actually implemented (indexes created, caching configured, not deferred)
- [ ] No scope creep (code only does what the task brief specifies)
- [ ] Security basics: input validation, auth checks, no exposed secrets
- [ ] Error handling: errors are caught, logged, and surfaced to the user appropriately
- [ ] No hardcoded values that should be configurable
- [ ] Code is readable without the implementation notes (someone new could understand it)

Severity classification:
- **Critical**: security vulnerability, data loss risk, auth bypass -> blocks, return to BUILD
- **High**: missing validation, unhandled error that crashes, contract deviation -> blocks, return to BUILD
- **Medium**: missing index (performance risk), hardcoded value, missing test -> logged, fix in this WP or defer to Polish WP
- **Low**: naming convention, comment quality, minor refactor opportunity -> logged, defer to Polish WP

### QA Review Stage (QA REVIEW)

Functional testing against acceptance criteria. Human-assisted, not purely automated.

Process:
1. Read the work package brief's acceptance criteria
2. For each criterion: verify it works as specified
3. Read the edge cases for each task in the package
4. For each edge case: verify the behavior is correct
5. Test the interaction BETWEEN tasks in the package (do they work together?)
6. Test failure scenarios: what happens when things go wrong?

```markdown
## WP-1 QA Review: Dispatch Management

### Acceptance Criteria Verification
| Criterion | Result | Notes |
|-----------|--------|-------|
| Create dispatch with all fields | PASS | |
| List dispatches with pagination | PASS | |
| View dispatch detail | PASS | |
| Edit dispatch | PASS | |
| Delete dispatch (soft delete, Draft only) | PASS | |

### Edge Case Verification
| Edge Case | Result | Notes |
|-----------|--------|-------|
| Empty item count defaults to 0 | PASS | |
| 10,000+ records loads in <2s | PASS | 1.3s measured |
| Delete dispatch with items shows warning | FAIL | Warning text missing item count |
| Edit closed dispatch shows "closed" message | PASS | |
| Concurrent edit: last-write-wins with warning | NOT TESTED | Need two browser sessions |

### Cross-Task Integration
| Interaction | Result | Notes |
|-------------|--------|-------|
| Create -> appears in list | PASS | |
| Edit from detail -> list reflects change | PASS | |
| Delete from list -> detail returns 404 | PASS | |

### Failure Scenarios
| Scenario | Expected | Actual | Result |
|----------|----------|--------|--------|
| Create with server down | Error message | 500 error page | FAIL |
| Edit after session expires | Redirect to login | Silent failure | FAIL |
```

Defects from QA REVIEW return to BUILD with specific information: what was tested, what the expected behavior was, what actually happened.

### Human Verify Stage (HUMAN VERIFY)

The user (not the QA agent) tests the work package. The work package brief includes a specific verify prompt.

This is NOT a checklist. It's a real person using the feature and reporting what they experience. The QA skill supports this by providing the verify prompt and a simple feedback template:

```markdown
## Human Verification: WP-1

### Verify Prompt
Open the app. Create three dispatches with different data. Go to the list — are they there?
Open one — is the detail correct? Edit it — does the change persist?
Try to break it. Tell me what happened.

### Feedback
[User writes freeform feedback here]

### Triage
| Feedback Item | Type | Action |
|---------------|------|--------|
| [from user feedback] | Bug / Enhancement / Cosmetic / Design Gap | [task fix / defer / escalate to product design] |
```

## Level 2: System QA (Phase 8)

Phase 8 runs after all work packages have passed their individual QA cycles.

### What Phase 8 Tests That Level 1 Doesn't

**Cross-Work-Package Integration**

Each work package was tested in isolation. Phase 8 tests that they work together:
- Features from WP-1 still function after WP-2, WP-3, WP-4 were added
- Shared state (auth, navigation, filters) works consistently across all features
- Data created in one feature appears correctly in another
- Navigation between features built in different work packages is seamless

Test method: Run every user journey end-to-end. A user journey typically spans features from multiple work packages.

**System Performance Under Realistic Load**

Work package performance tests used isolated benchmarks. Phase 8 tests under realistic conditions:
- Multiple features active simultaneously
- Realistic number of concurrent users
- Realistic data volumes across all entities
- Background jobs running alongside user traffic

Test method: Load testing with realistic user scenarios, not synthetic benchmarks.

**Security Across Full Attack Surface**

Work package security checks were scoped. Phase 8 tests the complete attack surface:
- OWASP Top 10 validation across all endpoints
- Dependency vulnerability scan (full dependency tree)
- Auth/authz testing across all features (privilege escalation attempts)
- Session management across feature boundaries
- Input validation on every user-facing input in the system

Test method: Combination of automated scanning (OWASP ZAP, dependency audit) and manual testing of auth boundaries.

**Regression**

The most important Phase 8 activity. Did building WP-4 break something from WP-1?

Test method: Re-run all work package TEST suites (automated tests from every WP). If any fail, a regression was introduced. Identify which WP introduced it, fix, and re-run.

### Phase 8 Process

```
1. REGRESSION RUN
   - Execute all automated tests from all work packages
   - If any fail -> identify regression -> fix -> re-run
   - All green -> proceed

2. INTEGRATION JOURNEYS
   - Execute end-to-end user journeys that span multiple work packages
   - Document any journey that doesn't complete correctly
   - Fix -> re-test journey

3. SYSTEM PERFORMANCE
   - Load test with realistic concurrent usage
   - Compare against performance contracts from implementation notes
   - Flag any endpoint or feature that exceeds its performance budget under load
   - Fix or document with mitigation plan

4. SECURITY SCAN
   - Run automated security scanning (OWASP ZAP, dependency audit)
   - Manual auth boundary testing
   - Document findings by severity
   - Critical/High -> fix before release
   - Medium -> fix or accept with documented risk
   - Low -> document, defer

5. SYSTEM QA SIGN-OFF
   - All regression tests pass
   - All integration journeys complete
   - Performance under load meets contracts
   - No critical/high security findings open
   - Release candidate approved or blocked with specific blockers
```

### Phase 8 Output

```
docs/qa/
  REGRESSION-RESULTS.md          -- All-WP test suite results
  INTEGRATION-JOURNEYS.md        -- End-to-end journey test results
  PERFORMANCE-REPORT.md          -- Load test results vs. performance contracts
  SECURITY-REPORT.md             -- Scan results + manual findings
  SYSTEM-QA-SIGN-OFF.md          -- Approved / Blocked with reasons
```

### Phase 8 Is Fast If Work Packages Were Thorough

The point of embedded QA in work packages is that Phase 8 should find very little. If work package QA was done well:
- Regression tests are already written and passing
- Features are already individually verified
- Performance contracts are already validated per-feature
- Security basics are already reviewed per-work-package

Phase 8 catches only what falls between the cracks: integration issues, cumulative performance degradation, and security gaps that only appear when the full system is assembled.

If Phase 8 finds major issues, the problem isn't Phase 8. It's that work package QA was too shallow. The fix is improving Level 1, not making Phase 8 more comprehensive.

## When to Use

Use this skill when:
- During work package TEST, CODE REVIEW, or QA REVIEW stages (Level 1)
- Entering Phase 8 system QA (Level 2)
- User asks to "run QA review" or "check quality"
- Before release preparation

## References

Detailed checklists and criteria:
- `references/code-review-checklist.md` — Contract compliance, quality, error handling, test coverage
- `references/security-checklist.md` — OWASP Top 10, input validation, auth, encryption, secrets
- `references/performance-checklist.md` — Load testing, profiling, caching, bundle size
