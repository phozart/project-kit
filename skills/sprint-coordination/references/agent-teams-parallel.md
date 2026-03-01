# Agent Teams — Parallel Sprint Execution (Experimental)

> **Requires:** `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` environment variable

Agent Teams is an experimental Claude Code feature that allows multiple agents to work in parallel on independent tasks. This reference describes how to use it for sprint execution.

## When to Use Agent Teams

Use Agent Teams when:
- Work package has 3+ tasks with no inter-task dependencies
- Tasks touch different parts of the codebase (different modules, different features)
- Developer agents are configured with `isolation: worktree` (prevents file conflicts)

Do NOT use Agent Teams when:
- Tasks have sequential dependencies within the work package
- Tasks modify the same files or database schemas
- The project is small enough that sequential execution is fast enough
- The environment variable is not set

## How It Works

1. Sprint coordinator identifies parallelizable tasks within a work package
2. Groups tasks by independence (no shared file modifications)
3. Launches developer agents in parallel via Agent Teams
4. Each agent works in an isolated worktree
5. When all parallel tasks complete, coordinator merges results
6. Proceeds to TEST stage as normal

## Team Composition Patterns

### Pattern 1: Frontend + Backend Parallel
- Agent A: Frontend tasks (React/Next.js developer in worktree)
- Agent B: Backend tasks (Python/Java developer in worktree)
- Works when: frontend and backend touch different files, API contracts are defined

### Pattern 2: Module-Per-Agent
- Agent A: Module X tasks (developer in worktree)
- Agent B: Module Y tasks (developer in worktree)
- Works when: modular monolith with clear module boundaries

### Pattern 3: Feature-Per-Agent
- Agent A: Feature X (vertical slice in worktree)
- Agent B: Feature Y (vertical slice in worktree)
- Works when: features are independent with no shared state

## Merge Strategy

After parallel execution:
1. Each worktree contains the agent's changes
2. Merge worktrees sequentially (first completer merges first)
3. If merge conflicts occur:
   - Automated resolution for non-overlapping changes
   - Flag overlapping changes for coordinator review
   - This is why task independence matters — conflicts mean tasks weren't independent

## Limitations

- Agent Teams is experimental and may change
- Each parallel agent uses its own context window
- No inter-agent communication during execution
- Merge conflicts require manual resolution
- More parallel agents = more API token usage

## Enabling

Set the environment variable before starting Claude Code:
```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

Or in `.env`:
```
CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```
