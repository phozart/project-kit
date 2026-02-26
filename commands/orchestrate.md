When the user invokes this command, start or continue the orchestration workflow for the project.

## Steps
1. Read CLAUDE.md for orchestration context (behavioral framing + state summary)
2. Read project.config.yaml for full state and configuration
3. If neither exists, tell user to run /project-init first
4. **Check Ad-Hoc Work Log** — if CLAUDE.md contains logged ad-hoc work in `<!-- DYNAMIC:ADHOC -->`, present it to the user before proceeding. Ask: reconcile now, or continue orchestration as-is?
5. Invoke the project-lead agent to manage the workflow
6. Project-lead determines next phase and invokes appropriate agents

## Context Recovery

CLAUDE.md must be read **before** project.config.yaml because it provides:

- **Behavioral framing** — Reminds Claude this is an orchestrated project-kit workflow, not a freeform conversation. This is critical after context compression removes the original agent prompt.
- **State summary** — Current phase, next phase, last gate, and blockers in 4 lines. Enough to orient without parsing the full config.
- **Decision history** — Key decisions that shaped the project, so Claude doesn't re-ask or contradict them.
- **Phase history** — What's done, what's skipped, what's next.

project.config.yaml then provides the full data: techstack details, gate modes, requirement counts, sprint state, and all configuration the project-lead needs to execute.

## Phase Sequence

| Phase | Name | Key Agent |
|-------|------|-----------|
| 0 | Setup | — |
| 1 | Innovation (optional) | innovation-strategist |
| 2 | Product Design (includes requirements) | product-designer |
| 3 | Platform Foundation | platform-engineer |
| 4 | Architecture | solution-architect |
| 5 | UX/UI Design | ux-ui-designer |
| 6 | Marketing (optional, parallel with 4-5) | marketing-researcher |
| 7 | Implementation | sprint-coordinator |
| 8 | QA & Security | qa-engineer |
| 9 | Release | release-manager |
| 10 | Documentation | docs-writer |

## Usage
- `/orchestrate` - Resume from current phase (checks for ad-hoc drift first)
- `/orchestrate phase-name` - Jump to specific phase
- See also: `/sync` - Reconcile ad-hoc work without resuming full orchestration

## Implementation Phase Orchestration

When the orchestrator reaches the Implementation phase:

### Entry: Decomposition
1. Trigger implementation-planner agent
2. Planner produces task queue and groups into work packages
3. Present work package plan to user for approval (manual gate)
4. User approves, reorders, or requests changes

### Execution: Work Package Loop
For each work package in order:

1. **Announce**: "Starting WP-X: [name]. This package includes [N] tasks and delivers: [capability description]."

2. **BUILD**: Execute tasks via sprint-coordinator. Log each task start/complete.

3. **TEST**: "All tasks in WP-X are built. Running automated tests."
   - If pass: proceed
   - If fail: "TEST failed: [details]. Returning [task(s)] to BUILD." Fix and re-run.

4. **CODE REVIEW**: "Tests pass. Running code review on [N] changed files."
   - If pass: proceed
   - If critical/high findings: "Code review found [N] issues: [summary]. Returning to BUILD." Fix and re-review.
   - If medium/low only: log findings, proceed. "Code review passed. [N] medium findings logged for WP-N (polish)."

5. **QA REVIEW**: "Code review passed. Running functional QA against acceptance criteria."
   - If pass: proceed
   - If defects: "QA found [N] defects: [summary]. Returning to BUILD." Fix and re-test.

6. **HUMAN VERIFY**: "WP-X is ready for your review. Here's what you can now do: [verify prompt]. Please test and let me know if this is approved or if changes are needed."
   - If approved: "WP-X approved. Moving to WP-[X+1]."
   - If changes requested: triage feedback into task fixes, return to BUILD, re-run from TEST after fixes.

### Between Work Packages
After each WP is approved and before the next starts:
- Update `docs/sprints/TASK-QUEUE.md` with completion status
- Check if user feedback from HUMAN VERIFY impacts future work packages
- If it does, update affected task briefs before proceeding
- Present brief summary: "WP-X complete. Next up: WP-[X+1]: [name]. [N] tasks. Ready to proceed?"

### Completion
After all work packages are approved:
- Run full integration test suite across all packages
- Present final implementation summary
- Transition to QA & Security phase (Phase 8)

## Session Management During Orchestration

The orchestrator tracks session boundaries and reminds the user when to reset context.

### Automatic Session Break Points

Output a session break instruction at these points:
- Before each task in BUILD stage
- Between each stage of a work package (BUILD→TEST→CODE REVIEW→QA REVIEW)
- Between work packages
- Between phases
- When conversation exceeds 15 exchanges within a single task

### Session Break Format

Always use a consistent format so the user recognizes it:

```
════════════════════════════════════════════
🔄 SESSION BREAK
────────────────────────────────────────────
Next: [what comes next]
Context needed: [specific files/documents]
Context to discard: [what from current session is no longer needed]
════════════════════════════════════════════
```

### What Persists Across Sessions (Disk)

- All code files (the codebase)
- All docs/ artifacts (task briefs, implementation notes, work package logs)
- project.config.yaml (workflow state)
- docs/sprints/TASK-QUEUE.md (task completion status)
- docs/sprints/WP-XXX-log.md (work package stage history)
- CLAUDE.md (project-level context cheat sheet)

### What Resets Between Sessions (Context Window)

- Conversation history
- Debug output from previous tasks
- Error messages that were already resolved
- Reasoning about previous tasks' implementation decisions
- File contents that were read but aren't relevant to the next task

### Phase 8 Session Strategy

Phase 8 (QA & Security) justifies broader context but should still use focused sessions:

1. **Session 1: Regression** — Load test commands only. Run all tests. Analyze failures.
2. **Session 2: Integration journeys** — Load customer journey maps from product design. Execute journeys. Document results.
3. **Session 3: Performance testing** — Load performance contracts from implementation notes. Run load tests. Compare against contracts.
4. **Session 4: Security scan** — Load security checklist from qa-review skill. Run scans. Analyze results.

Four focused sessions instead of one enormous session for all of Phase 8.

$ARGUMENTS Optional phase name (setup|innovation|design|platform|architecture|ux|marketing|implementation|qa|release|documentation) to jump to specific phase
