---
name: sprint-management
description: Sprint coordination for parallel implementation work in Phase 7
---

# Sprint Management Skill

Sprint coordination skill for managing parallel implementation work during Phase 7. The sprint coordinator orchestrates multiple developer agents, manages dependencies, handles blockers, and tracks progress.

## Overview

This skill provides sprint management knowledge for:
- **Sprint Planning** — Breaking features into tasks and assigning to developers
- **Parallel Execution** — Managing multiple developer agents working concurrently
- **Dependency Management** — Tracking and resolving dependencies between work streams
- **Blocker Resolution** — Identifying blockers and routing to appropriate upstream agents
- **Progress Tracking** — Monitoring sprint progress and updating RTM

## When to Use

Use this skill when:
- Entering Phase 7 implementation
- User asks to "manage sprints" or "coordinate work"
- Organizing parallel development work
- Tracking implementation progress
- Resolving blockers and dependencies

## Sprint Coordinator Role

The sprint coordinator is responsible for:
1. Reading requirements, architecture, and design system
2. Creating sprint boards with feature assignments
3. Routing features to developer agents
4. Managing parallel execution
5. Tracking progress and updating RTM
6. Handling blockers and escalations
7. Coordinating with QA when sprint complete

## Sprint Planning Process

### Phase 7 Entry Criteria
- Phase 6 design system complete
- Requirements documented in `docs/REQUIREMENTS/`
- Architecture documented in `docs/SYSTEM-DESIGN/`
- Design system documented in `docs/DESIGN-SYSTEM/`
- API contracts defined in `docs/contracts/`

### Sprint Creation

**Step 1: Read Inputs**
1. Review requirements to understand features
2. Review architecture to understand technical approach
3. Review design system to understand UI components
4. Review API contracts to understand interfaces

**Step 2: Identify Features**
1. List all features from requirements
2. Group related features
3. Identify dependencies between features
4. Prioritize features (critical path first)

**Step 3: Create Sprint Board**
Create `docs/sprints/SPRINT-N.md` with structure:

```markdown
# Sprint N

**Start:** [Date]
**Goal:** [Sprint goal]

## Features
1. Feature A (Backend: Agent 1, Frontend: Agent 2)
2. Feature B (Backend: Agent 1, Frontend: Agent 3)
3. Feature C (Data: Agent 4)

## Assignments
- **Backend Agent 1:** Feature A backend, Feature B backend
- **Frontend Agent 2:** Feature A frontend
- **Frontend Agent 3:** Feature B frontend
- **Data Agent 4:** Feature C data pipeline

## Dependencies
- Feature B depends on Feature A API
- Feature C requires Feature A database schema

## Status
- [ ] Feature A backend
- [ ] Feature A frontend
- [ ] Feature B backend
- [ ] Feature B frontend
- [ ] Feature C data pipeline
```

**Step 4: Route to Agents**
Create work items for each agent referencing:
- Feature requirements
- API contracts
- Design system components
- Dependencies

## Parallel Execution Management

### Parallel Work Patterns

**Independent Features:**
Features with no dependencies can be developed in parallel by different agents.

```
Agent 1: Feature A (Backend + Frontend)
Agent 2: Feature B (Backend + Frontend)  [parallel]
Agent 3: Feature C (Data pipeline)       [parallel]
```

**Dependent Features:**
Features with dependencies require coordination.

```
Agent 1: Feature A API (complete first)
         ↓
Agent 2: Feature B (depends on Feature A API)
```

**Layered Parallelism:**
Split work by layer for same feature.

```
Agent 1: Feature A backend   [parallel]
Agent 2: Feature A frontend  [parallel]
Agent 3: Feature A tests     [parallel with mock API]
```

See: `references/parallel-work-patterns.md`

### Dependency Tracking

**Types of Dependencies:**
1. **API Dependencies** — Frontend depends on backend API
2. **Database Dependencies** — Features depend on schema
3. **Component Dependencies** — UI depends on design system components
4. **Data Dependencies** — Features depend on data availability

**Managing Dependencies:**
1. Identify dependencies during sprint planning
2. Schedule dependent work after dependencies complete
3. Use mocks/stubs to enable parallel work
4. Track dependency status in sprint board
5. Alert agents when dependencies ready

### Conflict Prevention

**Code Conflicts:**
- Assign different files/modules to different agents
- Coordinate changes to shared files
- Use feature branches
- Merge frequently

**Database Conflicts:**
- Assign different tables to different agents
- Coordinate schema changes
- Use database migration tools
- Review migrations before merge

## Progress Tracking

### Sprint Board Updates
Update `docs/sprints/SPRINT-N.md` daily:
- Mark completed tasks
- Add new tasks discovered
- Update blocker list
- Record progress notes

### Requirements Traceability Matrix
Update `docs/REQUIREMENTS/RTM.md` as features complete:
- Link requirements to implementations
- Mark requirements as implemented
- Link to test coverage

### Daily Standup Information
Track for each agent:
- What was completed yesterday
- What is planned today
- Any blockers

## Blocker Resolution

### Identifying Blockers

**Common Blocker Types:**
1. **Technical Blockers** — Missing dependencies, unclear requirements
2. **Architecture Blockers** — Architecture doesn't support feature
3. **Design Blockers** — Missing design specifications
4. **External Blockers** — Third-party API issues, access issues

See: `references/blocker-resolution.md`

### Escalation Process

**Architecture Issues:**
- Route to architecture maintenance skill
- Request architecture update
- Block dependent work until resolved

**Design Issues:**
- Route back to design agent
- Request design clarification/update
- Use placeholder in meantime

**Requirements Issues:**
- Route back to requirements agent
- Request requirement clarification
- Document assumptions

**Technical Issues:**
- Research and document solution options
- Escalate to technical lead if needed
- Update architecture decisions if needed

### Blocker Log
Maintain `docs/sprints/BLOCKERS.md`:

```markdown
# Blockers

## Active Blockers

### Blocker 1: API Contract Unclear
- **Reporter:** Frontend Agent 2
- **Feature:** Feature A
- **Status:** Escalated to Backend Agent 1
- **Created:** [Date]
- **Description:** Order API response format not clear in contract

## Resolved Blockers
[Archived blockers]
```

## Sprint Completion

### Sprint Exit Criteria
- All planned features implemented
- Unit and integration tests passing
- Code reviewed and merged
- RTM updated
- Documentation updated
- No active critical blockers

### Sprint Retrospective
Document in `docs/sprints/SPRINT-N-RETRO.md`:
- What went well
- What could improve
- Action items for next sprint

### Handoff to QA
When sprint complete:
1. Update sprint board with final status
2. Notify QA agent
3. Provide sprint summary
4. List features ready for testing

## Multi-Sprint Management

### Sprint Cadence
- 1-2 week sprints typical
- Review and plan next sprint before current ends
- Carry over incomplete work to next sprint

### Velocity Tracking
Track team velocity:
- Features completed per sprint
- Blockers encountered per sprint
- Average time per feature type
- Use to improve future estimates

## References

Detailed patterns and examples:
- `references/parallel-work-patterns.md` — Parallel execution, dependency management, conflict resolution
- `references/blocker-resolution.md` — Blocker types, escalation, routing to upstream agents
