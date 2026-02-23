# Requirements Traceability Matrix (RTM) Guide

Guide for creating and maintaining a Requirements Traceability Matrix.

## What is an RTM?

A Requirements Traceability Matrix (RTM) is a document that maps and traces requirements throughout the project lifecycle. It ensures every requirement is:
- Linked to business objectives (features)
- Implemented in design and code
- Verified through testing
- Tracked for completion

## Why RTM Matters

**For Humans**:
- Ensures nothing is missed
- Provides visibility into project completeness
- Enables impact analysis for changes
- Supports regulatory compliance
- Facilitates stakeholder communication

**For Agents**:
- Machine-parseable format enables automated tracking
- Agents can verify all requirements have tests
- Agents can identify orphaned requirements
- Agents can detect gaps in coverage
- Agents can validate implementation completeness

## RTM Structure

### Basic RTM Format

```markdown
| Feature ID | Requirement ID | Requirement Description | Priority | Status | Test Case ID | Test Status |
|------------|----------------|-------------------------|----------|--------|--------------|-------------|
| FEAT-001   | REQ-F-001      | User registration       | Must     | Draft  | TC-001       | Not Started |
| FEAT-001   | REQ-F-002      | Email verification      | Must     | Draft  | TC-002       | Not Started |
| FEAT-001   | REQ-S-001      | Password validation     | Must     | Draft  | TC-003       | Not Started |
```

### Extended RTM Format

For more complex projects, include additional columns:

```markdown
| Feature ID | User Story ID | Requirement ID | Requirement Type | Description | Priority | Owner | Status | Design Doc | Test Case ID | Test Status | Implementation Status |
|------------|---------------|----------------|------------------|-------------|----------|-------|--------|------------|--------------|-------------|-----------------------|
| FEAT-001   | US-001        | REQ-F-001      | Functional       | User reg    | Must     | Team A| Approved | ARCH-001  | TC-001       | Pass        | Complete              |
```

## Column Definitions

### Required Columns

**Feature ID**: Links to product design features (FEAT-XXX)
- Traces requirement back to business need

**Requirement ID**: Unique requirement identifier (REQ-F-XXX, REQ-D-XXX, etc.)
- Primary key for traceability

**Requirement Description**: Brief description of requirement
- Keep under 100 characters for table readability
- Link to full requirement document for details

**Priority**: MoSCoW priority
- Must Have
- Should Have
- Could Have
- Won't Have

**Status**: Current state of requirement
- Draft (initial writing)
- Review (under review)
- Approved (stakeholders approved)
- Implemented (code complete)
- Verified (tests passing)
- Accepted (stakeholder sign-off)

**Test Case ID**: Links to test case(s)
- May be one-to-many relationship
- Use TC-XXX format

**Test Status**: Current test state
- Not Started
- In Progress
- Pass
- Fail
- Blocked

### Optional Columns

**User Story ID**: Links to user story (US-XXX)

**Requirement Type**: Category of requirement
- Functional
- Data
- Non-Functional
- Security
- Operational

**Owner**: Team or person responsible

**Design Doc**: Links to architecture/design documents

**Implementation Status**: Code status
- Not Started
- In Progress
- Code Complete
- Code Review
- Merged

**Notes**: Additional context or blockers

## RTM Variants

### Feature-to-Requirement Mapping

Focus on ensuring all features have requirements:

```markdown
| Feature ID | Feature Description | Requirement IDs | Status |
|------------|---------------------|-----------------|--------|
| FEAT-001   | User Authentication | REQ-F-001, REQ-F-002, REQ-S-001, REQ-S-002 | Complete |
| FEAT-002   | Project Management  | REQ-F-010, REQ-F-011, REQ-D-001, REQ-D-002 | In Progress |
```

### Requirement-to-Test Mapping

Focus on test coverage:

```markdown
| Requirement ID | Test Case IDs | Test Coverage % | Pass/Fail Status |
|----------------|---------------|-----------------|------------------|
| REQ-F-001      | TC-001, TC-002, TC-003 | 100% | 2 Pass, 1 Fail |
| REQ-F-002      | TC-004 | 100% | Pass |
| REQ-NF-001     | TC-020, TC-021 | 50% | 1 Pass, 1 Not Run |
```

### Bi-directional Traceability

Full forward and backward tracing:

```markdown
**Forward Traceability** (Business Need → Implementation):
Business Objective → Feature → Requirement → Design → Code → Test

**Backward Traceability** (Implementation → Business Need):
Test → Code → Design → Requirement → Feature → Business Objective
```

## Maintaining the RTM

### When to Update

**During Requirements Phase**:
- Add rows for each new requirement
- Link to source features
- Set initial priority and status

**During Design Phase**:
- Link to design documents
- Update status to "Approved"

**During Development**:
- Add test case IDs
- Update implementation status
- Flag blockers or issues

**During Testing**:
- Update test status
- Update requirement status to "Verified" when tests pass

**During Changes**:
- Trace impact of requirement changes
- Update all affected rows
- Document change history

### RTM Quality Checks

**Completeness**:
- [ ] Every feature has at least one requirement
- [ ] Every "Must Have" requirement has test case(s)
- [ ] No orphaned requirements (without feature source)
- [ ] No orphaned tests (without requirement)

**Consistency**:
- [ ] Status values are from approved list
- [ ] IDs follow naming conventions
- [ ] Priorities align between features and requirements
- [ ] Test status matches requirement status

**Accuracy**:
- [ ] Links point to existing documents
- [ ] Status reflects current state
- [ ] Descriptions match actual requirements
- [ ] Owners are correct and current

## Example RTM

```markdown
# Requirements Traceability Matrix

**Project**: Customer Portal
**Version**: 1.0
**Date**: 2026-02-22

## Summary
- Total Features: 15
- Total Requirements: 47
- Total Test Cases: 89
- Coverage: 95%

## Traceability Matrix

| Feature ID | Requirement ID | Requirement Description | Type | Priority | Owner | Status | Test Case ID | Test Status |
|------------|----------------|-------------------------|------|----------|-------|--------|--------------|-------------|
| FEAT-001   | REQ-F-001      | User can sign up with email | Functional | Must | Team-Auth | Verified | TC-001, TC-002 | Pass |
| FEAT-001   | REQ-F-002      | System sends verification email | Functional | Must | Team-Auth | Verified | TC-003 | Pass |
| FEAT-001   | REQ-S-001      | Password meets complexity rules | Security | Must | Team-Auth | Verified | TC-004, TC-005 | Pass |
| FEAT-001   | REQ-S-002      | Passwords encrypted with bcrypt | Security | Must | Team-Auth | Verified | TC-006 | Pass |
| FEAT-001   | REQ-D-001      | Store user profile data | Data | Must | Team-Auth | Implemented | TC-007 | In Progress |
| FEAT-002   | REQ-F-010      | User can create project | Functional | Must | Team-Projects | Approved | TC-020 | Not Started |
| FEAT-002   | REQ-F-011      | User can edit project | Functional | Must | Team-Projects | Approved | TC-021 | Not Started |
| FEAT-002   | REQ-D-010      | Store project data | Data | Must | Team-Projects | Approved | TC-022 | Not Started |
| FEAT-002   | REQ-NF-001     | Project load time < 500ms | Non-Func | Should | Team-Projects | Draft | TC-050 | Not Started |

## Gap Analysis

**Requirements without tests**:
- None

**Features without requirements**:
- None

**Failed tests**:
- None

**Blocked items**:
- None
```

## Tips for Agent-Parseable RTMs

1. **Use consistent markdown tables** - Standard pipe-delimited format
2. **No merged cells** - Keep table structure simple
3. **Consistent ID formats** - Use prefixes (FEAT-, REQ-, TC-)
4. **Standard status values** - Use predefined set of statuses
5. **One table per file** - Makes parsing easier
6. **Include metadata header** - Project name, version, date
7. **Use links** - Make IDs clickable to documents where possible

## Benefits of Good RTM

1. **Prevents scope creep** - Every requirement traced to business need
2. **Ensures test coverage** - Every requirement has tests
3. **Enables impact analysis** - Quickly see what's affected by changes
4. **Supports audits** - Demonstrates completeness and compliance
5. **Facilitates automation** - Agents can parse and validate
6. **Improves communication** - Single source of truth for project status
