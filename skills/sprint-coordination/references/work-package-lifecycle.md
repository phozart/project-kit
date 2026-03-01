# Work Package Lifecycle

Every work package passes through five stages in order. No stage can be skipped.

## BUILD Stage

Execute tasks in the work package sequentially, respecting task dependencies.

### Per-Task Flow

1. Read the task brief from `docs/sprints/tasks/TASK-XXX.md`
2. Determine the right developer agent from the task's technology and project.config.yaml techstack
3. Invoke the developer agent via Agent tool with ONLY the task brief content
4. When developer signals completion, verify "What Done Looks Like" criteria:
   - Do the specified files exist?
   - Does the code compile/build?
   - Do the tests pass?
5. Verify implementation notes exist (5 questions from implementation-thinking skill):
   - Implementation notes written (inline comment or TASK-XXX-notes.md)
   - Interaction pattern identified and code matches the pattern
   - Performance contract decisions implemented (not deferred)
   - Connections to other tasks documented
   - Regret check items addressed
6. If criteria met → mark task Complete in TASK-QUEUE.md, log in WP-XXX-log.md
7. If criteria not met → return to developer with specific failures
8. If completed task reveals issues with downstream tasks → flag for implementation-planner

Missing implementation notes = task not complete. Return to developer.

## TEST Stage (Automated)

After all BUILD tasks complete, run the full automated test suite scoped to this work package.

**What to test:**
- Unit tests written during BUILD
- Integration tests for cross-task interactions within the package
- Linting, type checking, formatting
- Contract compliance check (implementations match TYPE-CONTRACTS and API-CONTRACTS)

**Agent:** qa-engineer (scoped to this work package's changed files only)

**Pass criteria:** All tests green, no lint errors, no type errors, contracts matched.

**Fail action:** Identify which task(s) broke, return to BUILD for those tasks only, re-run TEST.

## CODE REVIEW Stage

Review the code produced in this work package for:
- Standards compliance (naming, patterns, folder structure)
- Security (no exposed secrets, proper input validation, auth checks)
- Architecture alignment (implementation matches architecture design)
- Implementation thinking validation (notes exist, pattern matches, performance contracts implemented)
- No scope creep (tasks only built what the brief specified)

**Agent:** code-reviewer (read-only, scoped to this work package's changed files)

**Pass criteria:** No critical or high-severity findings.

**Fail action:** Findings documented, return to BUILD for fixes, then re-review.

## QA REVIEW Stage

Functional testing against acceptance criteria:
- Walk through each task's "what done looks like" checklist
- Test edge cases documented in task briefs
- Test interaction between tasks within the package
- Verify empty states, loading states, error states

**Agent:** qa-engineer (functional testing mode)

**Pass criteria:** All acceptance criteria met, no critical defects.

**Fail action:** Defects logged with severity, return to BUILD for fixes, then re-test from TEST.

## HUMAN VERIFY Stage

The user looks at what was built. Not a checklist exercise. The moment where the user opens the app, tries the feature, and decides: does this match what I had in mind?

**Gate mode:** Always manual. Cannot be set to auto or skip.

**Pass criteria:** User explicitly approves.

**Fail action:** User provides feedback. Review whether feedback requires task modifications within this work package, or reveals a design gap. Return to BUILD with updated briefs, then re-run full cycle from TEST.

## Failure Handling

When a stage fails:
1. Log what failed and why in `docs/sprints/WP-XXX-log.md`
2. Identify which task(s) need rework
3. Return only those tasks to BUILD, not the entire package
4. After fixes, re-run from the stage that failed (not from the beginning)
5. If the same task fails the same stage twice, flag for human review before retrying
