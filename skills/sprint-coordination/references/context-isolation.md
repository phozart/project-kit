# Context Isolation

## The Rule

Developer agents receive ONLY:
1. The task brief (`docs/sprints/tasks/TASK-XXX.md`)
2. Access to the codebase (files on disk)

They do NOT receive:
- Architecture documents (docs/architecture/*)
- Product design documents (docs/PRODUCT-STRATEGY.md, docs/FEATURE-INVENTORY.md)
- Platform Foundation document
- Previous task conversations
- Other task briefs
- Full design system documentation

## Why This Matters

Research (Gloaguen et al., ETH Zurich, Feb 2026) found that agents with more context:
- Use 14-22% more reasoning tokens without improving success rates
- Take more steps to find relevant files, not fewer
- Follow more instructions without better outcomes
- The strongest predictor of task success is task scope and clarity, not context comprehensiveness

A shorter, more focused task brief outperforms a comprehensive one. When in doubt, remove context from the developer's view rather than adding it.

## When Context Is Missing

If a developer agent reports that the task brief doesn't contain enough information to proceed:

1. **Do NOT compensate by loading upstream documents** — this defeats the purpose
2. Flag the issue to the implementation-planner as a brief quality issue
3. The planner updates the brief with the specific missing information
4. The developer receives the updated brief (still just the brief)
5. Resume the task

## What the Developer CAN Access

- The task brief (provided explicitly)
- The codebase on disk (previous tasks' output already exists as code)
- TYPE-CONTRACTS and API-CONTRACTS (referenced by path in the task brief's technical constraints)
- Technology skill reference (implementation-react, implementation-nextjs, etc.)
- Implementation-thinking skill reference

## Enforcement

The sprint-coordinator enforces isolation by:
1. Invoking developer agents with only the task brief content
2. Never injecting upstream documents into the agent invocation
3. Monitoring for developers requesting "more context" and routing to planner instead
4. Verifying at task completion that implementation notes reference the brief, not upstream docs
