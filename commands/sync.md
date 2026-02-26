When the user invokes this command, reconcile ad-hoc work done outside orchestration back into the project's orchestrated state.

## Problem This Solves

During development, users often interact with Claude directly without invoking `/orchestrate`. This produces useful work (code, decisions, files) that exists outside the orchestrated workflow. The `/sync` command bridges this gap by detecting what changed, updating project documentation, and aligning the orchestration state.

## Steps

1. Read CLAUDE.md — check the Ad-Hoc Work Log section between `<!-- DYNAMIC:ADHOC -->` markers
2. Read project.config.yaml for current phase and gate status
3. Scan for untracked changes:
   a. Check git status (if git is available) for files modified since last gate passage
   b. Compare existing docs against what the current phase expects
   c. Read the Ad-Hoc Work Log for explicitly logged items
4. Classify each change by which phase it belongs to:
   - New/modified files in docs/product/ → Phase 2 (Product Design)
   - New/modified files in docs/architecture/ or ADRs → Phase 4 (Architecture)
   - New/modified files in docs/design/ → Phase 5 (UX/UI)
   - New/modified source code in src/ → Phase 7 (Implementation)
   - New/modified test files → Phase 8 (QA)
   - Configuration or infrastructure changes → Phase 3 (Platform)
5. Present a drift report to the user:
   - What ad-hoc work was detected
   - Which phases it maps to
   - Which docs need updating
   - Whether any gates can now be partially or fully satisfied
6. Ask the user which items to reconcile
7. For approved items:
   a. Update relevant documentation to reflect the work done
   b. Update project.config.yaml if phase progress changed
   c. Update CLAUDE.md dynamic sections (STATE, DECISIONS, HISTORY)
   d. Clear reconciled items from the Ad-Hoc Work Log
   e. Log a decision entry: "<date>: Reconciled ad-hoc work — [summary]"
8. For items the user defers, leave them in the Ad-Hoc Work Log

## Drift Report Format

Present to user:

```
## Sync Report

**Current orchestrated phase:** Phase N — [Name]
**Ad-hoc work detected:** X items

| # | Change | Mapped Phase | Status | Action Needed |
|---|--------|-------------|--------|---------------|
| 1 | [description] | Phase M | Ahead of current | Update docs/[file] |
| 2 | [description] | Phase N | In current phase | Validate gate criteria |
| 3 | [description] | Phase N-1 | Behind current | Already covered |

**Recommendations:**
- [specific actions]

Reconcile all / Select items / Skip for now?
```

## Rules

1. NEVER auto-reconcile without user approval — always present the report first
2. If ad-hoc work contradicts a locked decision from PLATFORM-FOUNDATION.md, flag it as a conflict that needs resolution
3. If ad-hoc work has advanced past the current phase significantly, suggest whether the user wants to update the phase pointer or keep it where it is
4. After reconciliation, clear the ADHOC log of processed items
5. If no ad-hoc work is detected, say so and suggest `/orchestrate` to continue normally

## Ad-Hoc Log Maintenance

When updating the ADHOC section, use this format:
```
## Ad-Hoc Work Log
- <date>: [Phase N] Brief description of what was done
- <date>: [Phase M] Brief description of what was done
```

When clearing after reconciliation:
```
## Ad-Hoc Work Log
_No ad-hoc work recorded._
```

## Usage
- `/sync` - Detect and reconcile ad-hoc work

$ARGUMENTS No arguments required
