---
name: architecture-maintenance
description: Maintain architecture as a living document during implementation
---

# Architecture Maintenance Skill

Architecture maintenance skill for keeping architecture documentation current during implementation. Invoked when implementation reveals the need for architecture updates.

## Overview

Architecture is not a one-time Phase 5 activity. This skill keeps architecture documentation living and accurate as implementation progresses and new insights emerge.

## When to Use

Use this skill when:
- Sprint coordinator identifies architecture gap during implementation
- Developer agent encounters architecture limitation
- New architecture decision needed
- Existing ADR needs updating
- System design document needs correction
- API contract needs modification

**Trigger phrases:**
- "Update architecture docs"
- "Architecture doesn't support this feature"
- "Need architecture decision for X"
- "API contract needs updating"

## Architecture Maintenance Process

### Step 1: Assess Change Request

**Read Change Request:**
Review the blocker or request from sprint coordinator or developer agent.

**Questions to Answer:**
- What is the architectural gap or issue?
- What feature or implementation is blocked?
- Is this a clarification or a significant change?
- What is the impact scope (single feature vs. system-wide)?

### Step 2: Review Current Architecture

**Read Relevant Documents:**
- `docs/SYSTEM-DESIGN/SYSTEM-ARCHITECTURE.md`
- `docs/SYSTEM-DESIGN/adr/` (relevant ADRs)
- `docs/contracts/` (relevant API contracts)

**Understand Context:**
- What was the original reasoning?
- What constraints were considered?
- What alternatives were rejected?

### Step 3: Evaluate Options

**Consider Solutions:**
1. Clarification only (no architecture change)
2. Minor adjustment (update documentation)
3. Architecture enhancement (new ADR)
4. Significant change (requires review and approval)

**Evaluate Impact:**
- What components are affected?
- What work is already complete that needs updating?
- What dependencies exist?
- What risks are introduced?

### Step 4: Make Decision

**For Clarifications:**
- Update relevant documentation
- Notify requesting agent
- No ADR needed

**For Minor Adjustments:**
- Update system architecture document
- Update affected API contracts
- Create lightweight ADR if warranted
- Notify affected agents

**For Significant Changes:**
- Create new ADR with full context
- Update system architecture document
- Update affected API contracts
- Update implementation plan if needed
- Notify all affected agents
- Route to tech lead/architect for approval if needed

### Step 5: Update Documentation

**System Architecture:**
Update `docs/SYSTEM-DESIGN/SYSTEM-ARCHITECTURE.md` with changes to:
- Component descriptions
- Architecture diagrams
- Technology choices
- Integration patterns

**Architecture Decision Record:**
Create or update ADR in `docs/SYSTEM-DESIGN/adr/ADR-NNN-title.md`:
- Document the decision
- Explain context and options
- Record consequences
- Link to related ADRs

**API Contracts:**
Update contracts in `docs/contracts/` if API changes needed:
- Maintain backward compatibility if possible
- Version API if breaking change
- Document migration path

**Implementation Impact:**
Document in change request response:
- What needs to be updated
- Which agents are affected
- What timeline impact exists

### Step 6: Notify Affected Agents

**Notification Should Include:**
- What changed and why
- What implementation needs updating
- Updated documentation links
- Migration steps if needed
- Timeline impact

**Notify:**
- Sprint coordinator (always)
- Developer agents working on affected features
- QA agent if testing impacted

## Common Architecture Updates

### Adding Technology or Library

**Example:** Need to add WebSocket support for real-time updates

**Process:**
1. Evaluate options (WebSocket vs. Server-Sent Events vs. polling)
2. Create ADR documenting decision
3. Update system architecture with new component
4. Document integration pattern
5. Update affected API contracts

### Modifying Data Model

**Example:** Need to add new table or modify schema

**Process:**
1. Assess impact on existing data
2. Design migration strategy
3. Update data model documentation
4. Update affected API contracts
5. Document migration steps
6. Notify data and backend agents

### Changing Integration Pattern

**Example:** Switch from REST to GraphQL for specific API

**Process:**
1. Document reasoning in ADR
2. Update system architecture
3. Create new API contracts
4. Plan migration path
5. Update implementation plan
6. Notify frontend and backend agents

### Addressing Performance Issues

**Example:** Current approach won't scale, need caching layer

**Process:**
1. Document performance issue and target
2. Evaluate caching options
3. Create ADR for caching strategy
4. Update system architecture with cache component
5. Document cache invalidation strategy
6. Notify backend agents

## ADR Template for Maintenance

```markdown
# ADR-NNN: [Title]

**Status:** Accepted
**Date:** [Date]
**Supersedes:** [Previous ADR if applicable]

## Context
[Why is this decision needed? What triggered it?]

Implementation of [feature] revealed [gap/issue/limitation]:
- [Specific problem]
- [Impact on implementation]
- [Constraints]

## Decision
[What is the decision?]

We will [decision statement].

## Options Considered

### Option 1: [Name]
**Description:** [...]
**Pros:**
- [...]
**Cons:**
- [...]

### Option 2: [Name]
[Similar structure]

## Consequences

**Positive:**
- [Benefits of this decision]

**Negative:**
- [Drawbacks or trade-offs]

**Impact on Implementation:**
- [What needs to change]
- [Which components affected]
- [Timeline impact]

## Migration Path
[If updating existing implementation]
1. [Step 1]
2. [Step 2]

## Related Decisions
- [Link to related ADRs]
```

## Architecture Maintenance Best Practices

### Keep It Living
- Architecture evolves with implementation
- Update documentation as soon as decision made
- Don't wait until "later" to document

### Maintain Traceability
- Link ADRs to features/requirements
- Reference ADRs in code comments for key decisions
- Track which ADRs are superseded

### Balance Speed and Quality
- Quick clarifications don't need full ADR
- Significant changes deserve thorough documentation
- Use judgment on what level of documentation needed

### Communicate Changes
- Proactively notify affected agents
- Don't let agents discover changes by accident
- Provide clear migration guidance

### Version Control
- All architecture docs in version control
- Tag architecture versions with releases
- Maintain changelog of significant changes
