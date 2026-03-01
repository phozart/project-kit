# Change Management

## When Developers Need to Deviate from Contracts

During implementation, developers may discover that a contract (TYPE-CONTRACTS or API-CONTRACTS) needs modification. They cannot modify contracts directly.

## Process

1. **Developer creates** `docs/changes/CHANGE-XXX.md` documenting:
   - What contract needs to change
   - Why the current contract doesn't work
   - Proposed change
   - Impact on other components

2. **Sprint coordinator reviews** the change request and routes to solution-architect

3. **Architect evaluates** the change:
   - Is it necessary or is there a way to work within existing contracts?
   - What other components are affected?
   - Does it require an ADR?

4. **If approved:** Architect updates all contract files. Sprint coordinator flags affected task briefs to implementation-planner for update. TASK-QUEUE.md is updated to reflect the change.

5. **If rejected:** Architect explains why and suggests alternative approach. Developer proceeds within existing contracts.

## Change Log Format

```markdown
# CHANGE-XXX: [Title]

## Requested By
TASK-XXX: [task title]

## Current Contract
[Quote the current contract entry]

## Proposed Change
[What should change and why]

## Impact
- Affected components: [list]
- Affected tasks: [list]
- Breaking change: yes/no

## Status
[Pending / Approved / Rejected]

## Resolution
[Architect's decision and rationale]
```

## Rules

1. Developers NEVER modify contracts directly
2. All contract changes go through the solution-architect
3. Change requests are logged even if rejected (audit trail)
4. Breaking changes require notification to all affected agents
5. The sprint coordinator tracks change impact on the task queue
