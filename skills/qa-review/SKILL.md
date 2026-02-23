---
name: qa-review
description: System-level quality validation with parallel QA, security, and code reviews
---

# QA Review Skill

System-level quality validation skill for Phase 8. Coordinates three parallel reviews: QA Engineer (system testing), Security Reviewer (OWASP + vulnerabilities), and Code Reviewer (standards compliance).

## Overview

QA review validates the complete system before release. Unlike unit/integration testing during implementation, QA review focuses on system-level quality, security, and compliance.

**Three Parallel Reviews:**
1. **QA Engineer** — System testing, user journey validation, performance
2. **Security Reviewer** — OWASP Top 10, vulnerability scanning, security best practices
3. **Code Reviewer** — Contract compliance, code quality, error handling, test coverage

## When to Use

Use this skill when:
- Entering Phase 8 QA review
- User asks to "run QA review" or "check quality"
- Before release preparation
- Validating system-level quality
- After sprint completion

## QA Review Process

### Phase 8 Entry Criteria
- All Phase 7 sprint work completed
- Implementation complete (all features done)
- Unit and integration tests passing
- Requirements Traceability Matrix updated
- System deployed to QA environment

### Parallel Review Streams

**Stream 1: QA Engineer**
- Execute system test plan
- Validate user journeys end-to-end
- Verify requirements traceability
- Test cross-functional scenarios
- Validate data flows
- Performance and load testing

**Stream 2: Security Reviewer**
- OWASP Top 10 validation
- Dependency vulnerability scanning
- Authentication/authorization testing
- Input validation and sanitization
- Secrets management audit
- PII/sensitive data handling
- XSS, CSRF, SQL injection testing

**Stream 3: Code Reviewer**
- Contract compliance verification
- Code quality and standards
- Error handling patterns
- Test coverage analysis
- Documentation completeness
- Performance patterns

### Defect Management

**Defect Severity Levels:**
- **Critical** — System crash, data loss, security breach
- **High** — Major feature broken, severe security issue
- **Medium** — Feature partially broken, moderate security issue
- **Low** — Minor issue, cosmetic problem

**Routing:**
- Critical/High defects block release
- Route defects back to Sprint Coordinator for assignment
- Track in defect log: `docs/qa/DEFECTS.md`
- Retest after fix

### Phase 8 Exit Criteria
- All Critical/High defects resolved
- Medium defects documented (fix or defer decision)
- Security checklist 100% passed
- Code review checklist passed
- Performance benchmarks met
- Test coverage targets achieved
- RTM validated (all requirements tested)

## QA Engineer Review

### System Test Plan Execution

**Test Scope:**
- All user journeys from User Guide
- Cross-feature integration scenarios
- Error handling and edge cases
- Data validation and integrity
- System performance under load

**Test Environment:**
- Staging/QA environment matching production
- Realistic test data
- External service stubs/mocks if needed
- Performance monitoring enabled

**Test Documentation:**
- Test execution log: `docs/qa/test-execution.md`
- Defect reports: `docs/qa/DEFECTS.md`
- Performance results: `docs/qa/performance-results.md`

See: `references/performance-checklist.md`

### Requirements Validation

**Process:**
1. Review Requirements Traceability Matrix
2. For each requirement, verify:
   - Implementation exists
   - Tests exist and pass
   - Functionality matches specification
3. Update RTM with test results
4. Flag untested or failed requirements

### User Journey Validation

**Process:**
1. Review User Guide journeys
2. Execute each journey step-by-step
3. Validate expected outcomes
4. Test error scenarios
5. Document deviations

## Security Reviewer Review

### OWASP Top 10 Validation

**2023 OWASP Top 10:**
1. Broken Access Control
2. Cryptographic Failures
3. Injection
4. Insecure Design
5. Security Misconfiguration
6. Vulnerable and Outdated Components
7. Identification and Authentication Failures
8. Software and Data Integrity Failures
9. Security Logging and Monitoring Failures
10. Server-Side Request Forgery (SSRF)

See: `references/security-checklist.md`

### Vulnerability Scanning

**Tools:**
- Dependency scanning: `npm audit`, `pip-audit`, OWASP Dependency-Check
- SAST: SonarQube, Semgrep
- DAST: OWASP ZAP, Burp Suite
- Container scanning: Trivy, Snyk

**Process:**
1. Run automated scans
2. Review findings by severity
3. Validate true positives
4. Create defects for confirmed issues
5. Document false positives

### Security Testing

**Authentication:**
- Test login/logout flows
- Verify session management
- Test password policies
- Check MFA implementation

**Authorization:**
- Test role-based access control
- Verify permission enforcement
- Test privilege escalation attempts
- Check API authorization

**Input Validation:**
- Test SQL injection
- Test XSS attacks
- Test command injection
- Test path traversal
- Test file upload restrictions

See: `references/security-checklist.md`

## Code Reviewer Review

### Contract Compliance

**Process:**
1. Review API contracts in `docs/contracts/`
2. Test API endpoints against contracts
3. Validate request/response schemas
4. Check error response formats
5. Verify contract versioning

### Code Quality Review

**Review Focus:**
- Code readability and maintainability
- Design pattern adherence
- DRY principle compliance
- SOLID principle adherence
- Error handling patterns
- Logging and observability

See: `references/code-review-checklist.md`

### Test Coverage Analysis

**Coverage Targets:**
- Unit tests: 80%+ line coverage
- Integration tests: Critical paths covered
- E2E tests: Core user journeys covered

**Process:**
1. Run coverage reports
2. Identify uncovered code
3. Assess risk of uncovered areas
4. Create defects for missing critical tests

### Documentation Review

**Validation:**
- Code comments for complex logic
- API documentation completeness
- README accuracy
- Architecture Decision Records
- Deployment documentation

## QA Review Deliverables

**Required Outputs:**
1. `docs/qa/test-execution.md` — Test execution summary
2. `docs/qa/DEFECTS.md` — Defect log with severity
3. `docs/qa/security-report.md` — Security scan results
4. `docs/qa/code-review-summary.md` — Code review findings
5. `docs/qa/QA-SIGN-OFF.md` — QA approval or block decision

## References

Detailed checklists and criteria:
- `references/code-review-checklist.md` — Contract compliance, quality, error handling, test coverage
- `references/security-checklist.md` — OWASP Top 10, input validation, auth, encryption, secrets
- `references/performance-checklist.md` — Load testing, profiling, caching, bundle size
