# Stage Transitions

Every stage transition must be logged in `docs/sprints/WP-XXX-log.md`.

## Log Format

```markdown
## WP-1: [Work Package Name]

### BUILD
- [YYYY-MM-DD HH:MM] TASK-010 started
- [YYYY-MM-DD HH:MM] TASK-010 complete
- [YYYY-MM-DD HH:MM] TASK-011 started
- [YYYY-MM-DD HH:MM] TASK-011 complete
- [YYYY-MM-DD HH:MM] BUILD complete. All tasks done.

### TEST
- [YYYY-MM-DD HH:MM] Test run 1: 23 passed, 1 failed — [details]
- [YYYY-MM-DD HH:MM] TEST FAILED. Returning TASK-XXX to BUILD.
- [YYYY-MM-DD HH:MM] Fix applied, re-running TEST
- [YYYY-MM-DD HH:MM] Test run 2: 24 passed, 0 failed
- [YYYY-MM-DD HH:MM] TEST PASSED.

### CODE REVIEW
- [YYYY-MM-DD HH:MM] Code review started (N files changed)
- [YYYY-MM-DD HH:MM] CODE REVIEW PASSED.

### QA REVIEW
- [YYYY-MM-DD HH:MM] Functional QA started
- [YYYY-MM-DD HH:MM] All acceptance criteria verified
- [YYYY-MM-DD HH:MM] QA PASSED.

### HUMAN VERIFY
- [YYYY-MM-DD HH:MM] Presented to user with verify prompt
- [YYYY-MM-DD HH:MM] HUMAN VERIFY: APPROVED
- [YYYY-MM-DD HH:MM] WP-1 COMPLETE.
```

## Transition Rules

1. **BUILD → TEST:** Only when ALL tasks in the work package are marked complete with implementation notes verified.
2. **TEST → CODE REVIEW:** Only when all automated tests pass, no lint errors, no type errors.
3. **CODE REVIEW → QA REVIEW:** Only when no critical or high-severity review findings remain.
4. **QA REVIEW → HUMAN VERIFY:** Only when all acceptance criteria verified and no critical defects.
5. **HUMAN VERIFY → COMPLETE:** Only when user explicitly approves.

## Failure Loops

- TEST fails → identify broken task(s) → return to BUILD for those tasks only → re-run TEST
- CODE REVIEW fails → findings documented → return to BUILD for fixes → re-run CODE REVIEW
- QA REVIEW fails → defects logged → return to BUILD for fixes → re-run from TEST
- HUMAN VERIFY rejected → triage feedback → return to BUILD → re-run from TEST

## This Log Is the Source of Truth

The `/status` command reads these logs to report project progress. Keep them accurate and complete.
