When the user invokes this command, display a quick overview of the current project state.

## Steps
1. Read project.config.yaml
2. Display: current phase, gates passed, requirements stats, sprint progress
3. If in Implementation phase (7), read work package logs and show work package progress
4. List any blockers or pending items
5. Show which phases are complete vs remaining

## Phase Reference

| Phase | Name |
|-------|------|
| 0 | Setup |
| 1 | Innovation (optional) |
| 2 | Product Design (includes requirements) |
| 3 | Platform Foundation |
| 4 | Architecture |
| 5 | UX/UI Design |
| 6 | Marketing (optional) |
| 7 | Implementation |
| 8 | QA & Security |
| 9 | Release |
| 10 | Documentation |

## Implementation Phase Status Display

When in Phase 7, display work package progress instead of a flat task list.

### Project-Level View

```
Project: [name]
Phase: Implementation (7)
Progress: WP-1 of 5 complete

Work Packages:
  [check] WP-0: Foundation .............. COMPLETE (approved [date])
  [cycle] WP-1: Dispatch Management .... QA REVIEW (4/5 tasks built, 1 fix in progress)
  [blank] WP-2: Tracking Workflow ....... QUEUED (blocked by WP-1)
  [blank] WP-3: Reporting Dashboard ..... QUEUED
  [blank] WP-4: Polish & Hardening ...... QUEUED
```

### Work Package Detail (current)

```
WP-1: Dispatch Management
Stage: QA REVIEW (attempt 1)

Tasks:
  [check] TASK-010: Dispatch schema ............. DONE
  [check] TASK-011: Dispatch list ............... DONE
  [wrench] TASK-012: Create dispatch form ........ FIX (validation bug from QA)
  [check] TASK-013: Dispatch detail ............. DONE
  [check] TASK-014: Edit dispatch ............... DONE

Stage History:
  BUILD ........... passed (5 tasks)
  TEST ............ passed (24/24 tests, 2nd attempt)
  CODE REVIEW ..... passed (1 medium finding deferred)
  QA REVIEW ....... in progress
```

### Principles for Status Display

- Show the work package level first, always. Individual tasks are detail.
- Use clear stage indicators: which stage is the current WP in?
- Show history: how many attempts at each stage? This reveals problem areas.
- Show blockers: is the next WP waiting on the current one?
- Keep it to one screen. If the user wants detail, they can ask for a specific WP.
- Read `docs/sprints/WP-XXX-log.md` files for stage history data.

## Usage
- `/status` - Show project status overview

$ARGUMENTS No arguments required
