# Session Management

One task = one Claude Code session during BUILD. One stage = one session for review cycles. Context resets between tasks ensure each task gets the model's full attention with only relevant context.

## Session Break Format

### Before Each Task (BUILD)

```
════════════════════════════════════════════
SESSION BREAK
────────────────────────────────────────────
Next: TASK-XXX: [title]
Context needed: docs/sprints/tasks/TASK-XXX.md
Context to discard: All conversation from previous task
════════════════════════════════════════════

→ Start a new Claude Code session for this task.
→ In the new session, provide only:
  1. The task brief (docs/sprints/tasks/TASK-XXX.md)
  2. The implementation-thinking skill reference
  3. The relevant technology skill (e.g., nextjs, react, python)

→ Do NOT carry over conversation from previous tasks.
→ The codebase already contains previous tasks' output on disk.
```

### Between BUILD and TEST

```
════════════════════════════════════════════
SESSION BREAK
────────────────────────────────────────────
Next: TEST stage for WP-X
Context needed: docs/sprints/WP-XXX-brief.md, test commands
Context to discard: BUILD conversation history
════════════════════════════════════════════

→ Start a new Claude Code session for TEST stage.
→ Provide: work package brief + test execution command
→ Do NOT carry over BUILD conversation history.
```

### Between TEST and CODE REVIEW

```
════════════════════════════════════════════
SESSION BREAK
────────────────────────────────────────────
Next: CODE REVIEW for WP-X
Context needed: Changed files list, implementation notes, review checklist
Context to discard: TEST output (unless failures to reference)
════════════════════════════════════════════

→ Start a new Claude Code session for CODE REVIEW.
→ Provide: changed files list, implementation notes, review checklist
→ Do NOT carry over TEST output unless there were failures to reference.
```

### Between CODE REVIEW and QA REVIEW

```
════════════════════════════════════════════
SESSION BREAK
────────────────────────────────────────────
Next: QA REVIEW for WP-X
Context needed: WP brief with acceptance criteria, task briefs with edge cases
Context to discard: Code review findings (resolved)
════════════════════════════════════════════

→ Start a new Claude Code session for QA REVIEW.
→ Provide: WP brief with acceptance criteria, task briefs with edge cases, QA checklist
→ Do NOT carry over code review findings (they're resolved).
```

## Resuming After Interruption

If a session is interrupted mid-task:
1. The task brief (fresh read)
2. A brief description of what was already done

The model reads the brief fresh and examines the codebase to see what exists. This is better than continuing a stale session.

## Debugging Across Sessions

If a bug found in TEST traces back to a previous task:
1. Start a new session with the original task brief
2. Include the work package log entry showing what TEST found
3. Include the specific error message

Scoped to the bug, not the full work package context.
