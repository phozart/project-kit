---
name: sprint-coordination
description: Work package lifecycle execution, context isolation, and developer agent routing for Phase 7 implementation
---

# Sprint Coordination Skill

Execution knowledge for the sprint-coordinator agent. Covers work package lifecycle management, context isolation rules, developer agent routing, stage transitions, and progress tracking.

## When to Use

- Phase 7 implementation execution (after implementation-planner has produced the task queue)
- Sprint-coordinator agent is executing work packages
- Resolving blockers during implementation
- Tracking work package progress

## Work Package Lifecycle

Every work package passes through five stages in order. No stage can be skipped.

```
BUILD → TEST → CODE REVIEW → QA REVIEW → HUMAN VERIFY
```

**BUILD** — Execute tasks sequentially within the work package, respecting task dependencies. Each task follows the context isolation rule. Tasks are marked done individually.

**TEST** — After all BUILD tasks complete, run automated tests scoped to the work package: unit tests, integration tests, linting, type checking, contract compliance.

**CODE REVIEW** — Review the code for standards, security, architecture alignment, and scope compliance. Read-only review scoped to changed files.

**QA REVIEW** — Functional testing against acceptance criteria, edge cases, and interaction between tasks within the package.

**HUMAN VERIFY** — User tests the feature. Always manual. Cannot be set to auto or skip.

See: `references/work-package-lifecycle.md` for stage details, pass criteria, and failure handling.

## Context Isolation Rule

**Critical.** Developer agents receive ONLY:
- The task brief (`docs/sprints/tasks/TASK-XXX.md`)
- Access to the codebase

They do NOT receive upstream design documents, architecture docs, product strategy, or previous task conversations. If the developer needs information not in the brief, that's a brief quality issue — flag it to the implementation-planner.

Why: Research shows agents with more context use more reasoning tokens and solve tasks less effectively. A focused brief outperforms a comprehensive one.

See: `references/context-isolation.md` for the full isolation protocol.

## Session Management

One task = one Claude Code session during BUILD. One stage = one session for review cycles. Session breaks are explicit with instructions on what to load and what to discard.

See: `references/session-management.md` for session break formats and resumption patterns.

## Developer Agent Routing

Route tasks to developer agents based on the task's primary technology and the techstack in project.config.yaml:

| Task Type | Agent |
|-----------|-------|
| React/UI components | react-developer |
| Next.js pages, App Router | nextjs-developer |
| Python backend (FastAPI/Django/Flask) | python-developer |
| Java/Spring Boot | java-developer |
| API endpoint implementation | api-developer |
| Authentication/authorization | auth-developer |
| Database migrations, queries | database-developer |
| Mixed vertical slice | Route the primary layer first |

Developer agents run in isolated worktrees to prevent file conflicts during parallel execution.

## Blocker Resolution

Route blockers to the appropriate upstream agent:
- **Brief incomplete** → implementation-planner
- **Contract issue** → solution-architect (via architecture-maintenance skill)
- **Design inconsistency** → ux-ui-designer
- **Technical feasibility** → solution-architect
- **Missing task** → implementation-planner

See: `references/blocker-resolution-protocol.md` for escalation procedures.

## Progress Tracking

Update these artifacts during execution:
- `docs/sprints/TASK-QUEUE.md` — task and work package status
- `docs/sprints/WP-XXX-log.md` — stage transition log (source of truth for `/status`)
- `project.config.yaml` — progress counters

See: `references/progress-tracking.md` for tracking format and update rules.

## Stage Transitions

Every stage transition is logged with timestamp in `WP-XXX-log.md`. The log is the source of truth for project status.

See: `references/stage-transitions.md` for transition rules and logging format.

## Change Management

When developers need to deviate from contracts, route through the solution-architect.

See: `references/change-management.md` for the change management protocol.

## Communication Protocol

Standardized messages for each lifecycle event: work package start, task complete, stage transitions, failures, blockers, and work package completion.

See: `references/communication-protocol.md` for all message templates.

## Output Files

The sprint-coordinator creates or updates:
- `docs/sprints/TASK-QUEUE.md` — status tracking
- `docs/sprints/WP-XXX-log.md` — one per work package
- `docs/sprints/SPRINT-REPORT.md` — completion report
- `project.config.yaml` — progress fields

## References

- [Work Package Lifecycle](./references/work-package-lifecycle.md)
- [Stage Transitions](./references/stage-transitions.md)
- [Context Isolation](./references/context-isolation.md)
- [Session Management](./references/session-management.md)
- [Blocker Resolution Protocol](./references/blocker-resolution-protocol.md)
- [Progress Tracking](./references/progress-tracking.md)
- [Change Management](./references/change-management.md)
- [Communication Protocol](./references/communication-protocol.md)
