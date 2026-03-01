# Progress Tracking

## Artifacts to Update

### TASK-QUEUE.md

Update task and work package status as execution progresses:
- Task status: Not Started → In Progress → Complete → Blocked
- Work package status: current stage (BUILD / TEST / CODE REVIEW / QA REVIEW / HUMAN VERIFY)
- Note any dependency changes discovered during execution

### WP-XXX-log.md

One log file per work package. Created when the work package starts. Contains:
- Every stage transition with timestamp
- Every task start/complete within BUILD
- Test results (pass/fail counts, specific failures)
- Review findings (severity, count, resolution)
- QA results (acceptance criteria pass/fail)
- Human verify outcome and any feedback

This log is the **source of truth** for project status. The `/status` command reads these logs.

### project.config.yaml

Update progress fields:
- `requirements.implemented` — increment as tasks complete
- `sprints.features_in_progress` — update active feature list
- `sprints.features_completed` — move completed features
- `sprints.current_work_package` — current WP identifier

## Work Package Transition

After a work package is approved:

1. Mark the work package COMPLETE in TASK-QUEUE.md and its log
2. Check if user feedback from HUMAN VERIFY impacts future work packages
3. If it does, flag to implementation-planner to update affected task briefs
4. Present summary: "WP-X complete. Next up: WP-[X+1]: [name]. [N] tasks. Ready to proceed?"
5. Move to the next work package

## All Work Packages Complete

When the last work package passes HUMAN VERIFY:

1. Write `docs/sprints/SPRINT-REPORT.md` with:
   - Total work packages completed
   - Total tasks executed
   - Deviations from plan (any CHANGE-XXX.md records)
   - Test coverage summary
2. Run full integration test suite across all packages
3. Signal ready for Phase 8 (QA & Security)
