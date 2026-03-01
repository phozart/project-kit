# Communication Protocol

Standardized messages for each lifecycle event during sprint execution.

## When Starting Work Package

```
Sprint Coordinator: Starting WP-[X]: [name]

This package includes [N] tasks and delivers:
[capability description]

Tasks:
1. TASK-XXX: [title]
2. TASK-YYY: [title]
...

Acceptance criteria (package level):
- [criterion 1]
- [criterion 2]

Beginning BUILD stage.
```

## When Task Complete (within BUILD)

```
Task Complete: TASK-XXX: [title]

Acceptance criteria:
- [criterion 1]: PASS
- [criterion 2]: PASS

WP-[X] BUILD progress: [completed]/[total] tasks
Next in package: TASK-YYY: [title]
```

## Stage Transitions

```
WP-[X] BUILD complete. All [N] tasks done.
Running TEST stage (automated tests, lint, type check, contract compliance)...
```

```
WP-[X] TEST PASSED. [N] tests green.
Running CODE REVIEW on [N] changed files...
```

```
WP-[X] CODE REVIEW PASSED. [N medium findings logged for polish]
Running QA REVIEW against acceptance criteria...
```

```
WP-[X] QA PASSED. All acceptance criteria verified.

HUMAN VERIFY — WP-[X]: [name]
Here's what you can now do:
[human verify prompt from work package brief]

Please test and let me know if this is approved or if changes are needed.
```

## When Stage Fails

```
WP-[X] [STAGE] FAILED

Issue: [description]
Affected task(s): TASK-XXX, TASK-YYY
Action: Returning to BUILD for fixes, will re-run from [stage].
```

## When Work Package Complete

```
WP-[X]: [name] — APPROVED

Stage history:
  BUILD ........... passed ([N] tasks)
  TEST ............ passed ([N] tests, [attempts] attempt(s))
  CODE REVIEW ..... passed ([findings summary])
  QA REVIEW ....... passed
  HUMAN VERIFY .... approved

Next: WP-[X+1]: [name] ([N] tasks)
Ready to proceed?
```

## When All Work Packages Complete

```
Implementation Complete

Work packages: [total] completed
[list each WP with name and approval date]

Total tasks executed: [count]
Deviations from plan: [list any CHANGE-XXX.md records]

Running full integration test suite across all packages...
Ready for QA & Security phase?
```
