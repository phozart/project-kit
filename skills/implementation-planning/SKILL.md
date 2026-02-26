---
name: implementation-planning
description: Task decomposition patterns for breaking design artifacts into developer-ready task briefs
---

# Implementation Planning Skill

Reference material for the implementation-planner agent on task decomposition patterns, context scoping, and dependency mapping.

## When to Use

- Phase 7 implementation entry in the orchestrator workflow
- User says "plan implementation" or "decompose into tasks"
- Before any coding begins, after design phases are complete
- When reviewing or restructuring an existing task queue

## Vertical Slice Decomposition

The core principle: every task should touch all layers of the stack needed to deliver one testable behavior. A user should be able to see and verify the result of a single task without waiting for other tasks to complete.

### How to Identify Slices

Start from the user-visible behavior, not from the architecture:
1. Read a feature's acceptance criteria
2. For each criterion, trace backward: what UI does the user see? What API does the UI call? What data does the API read/write? What schema supports that data?
3. That trace is one vertical slice. If it's small enough (< 6 hours), it's one task. If not, split by sub-behavior within the feature.

### Splitting Large Features

A feature like "Dispatch Management" is not a task. Split by user action:
- Task: Create a new dispatch (form + API + schema)
- Task: List dispatches with pagination (table + API + query)
- Task: Filter dispatches by date and country (filter UI + API query params)
- Task: View dispatch detail (detail page + API + related data joins)
- Task: Export dispatches to CSV (export button + API + file generation)

Each is independently testable. Each delivers visible value.

### Foundation Task Patterns

Foundation tasks are the exception to vertical slicing. They're horizontal by nature because they set up infrastructure. Keep them minimal:

- **Scaffold**: Framework init, folder structure, linting, formatting, CI pipeline. Nothing custom yet.
- **Auth**: The full auth flow because everything depends on it. This is the one foundation task that should be vertical (includes UI).
- **Database**: Schema setup, migration tooling, seed data script. No feature schemas yet — those come with feature tasks.
- **Design system**: Token installation, layout component, typography setup. Not full component library — components get built within feature tasks.
- **Layout shell**: Navigation, routing structure, 404 page, loading skeleton. The frame that features plug into.

## Context Scoping Rules

For each task brief, include:
- From Platform Foundation: only the decisions that affect THIS task (usually 2-4 out of 10+)
- From Architecture: only the component(s) and contract(s) this task touches
- From UX/UI: only the wireframe(s) for the screen(s) this task builds
- From Product Design: only the acceptance criteria this task satisfies

Rule of thumb: if a developer reads the task brief and says "why is this here?", it shouldn't be there.

## Dependency Mapping

Three types of dependencies:
1. **Hard block**: Task B cannot start until Task A is complete (e.g., auth must exist before protected routes)
2. **Interface contract**: Task B needs to know the API shape from Task A but can be built in parallel using the contract as a mock (e.g., frontend and backend for the same feature)
3. **No dependency**: Tasks that touch different features with no shared state

Maximize type 2 and 3. Minimize type 1. The more tasks that can run in parallel (or in any order), the more flexible the execution.

## Task Size Calibration

| Size | Time | Characteristics | Examples |
|------|------|----------------|----------|
| Small | 1-2 hours | Single component, single API endpoint, single schema change | Add a filter dropdown, create a seed script, implement a loading skeleton |
| Medium | 2-4 hours | One vertical slice through 2-3 layers | Login flow, dispatch list with pagination, dashboard widget |
| Large | 4-6 hours | One complex feature slice with multiple interactions | Full CRUD for an entity, complex form with validation and error handling |
| Too Large | > 6 hours | Split required | Anything touching more than one major feature area |

For Claude Code sessions specifically: target Medium tasks. Claude Code performs best when it can hold the full task context and complete it in one conversation without losing thread.

## Task Brief Template

Each brief in `docs/sprints/tasks/TASK-XXX.md` follows this structure:

```markdown
# TASK-XXX: [Title]

## What to Build
[2-3 sentences]

## Acceptance Criteria
- [Criterion 1 — from Product Design, scoped to this task]
- [Criterion 2]
- [Criterion 3]

## Technical Constraints
- [Constraint 1 — from Platform Foundation/Architecture, only if relevant]
- [Constraint 2]

## UI Reference
[Specific wireframe/screen reference, or "No UI" for backend-only tasks]

## Interaction Pattern Hint
[Suggested primary pattern: CRUD / Search & Filter / Monitor & Alert / Workflow & Queue / Analysis & Exploration / Configuration & Setup / Import & Transform]
[Brief explanation of why this pattern, not just the label]
Example: "Primary pattern: Monitor & Alert. The operator watches for delayed dispatches, not searches for them. Default view should show exceptions, not all records."
This is a HINT, not a mandate. The developer may identify a different or combined pattern after reading the implementation-thinking skill. But the hint prevents the developer from defaulting to CRUD without thinking.

## Dependencies
- [TASK-XXX required before this starts]
- [Or: No dependencies]

## What Done Looks Like
- [Testable outcome 1]
- [Testable outcome 2]
- [Test cases to write]

## Files Likely Touched
- [path] — [new/modify]

## Estimated Scope
[Small / Medium / Large]
```

## Research Reference

The task sizing and context scoping approach is informed by findings from "Evaluating AGENTS.md" (Gloaguen et al., ETH Zurich, Feb 2026):

- Agents with more context use more reasoning tokens (+14-22%) without improving success rates
- Agents with context files take more steps to find relevant files, not fewer
- Instructions in context files are followed almost universally, but following more instructions doesn't improve outcomes
- The strongest predictor of task success is task scope and clarity, not context comprehensiveness

This means: a shorter, more focused task brief outperforms a comprehensive one. When in doubt, remove context from the brief rather than adding it.

## References

- [Vertical Slice Patterns](./references/vertical-slice-patterns.md)
