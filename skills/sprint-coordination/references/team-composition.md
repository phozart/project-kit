# Team Composition Patterns

How to compose agent teams for different work package types during parallel sprint execution.

## Assessing Parallelizability

Before forming teams, check each task pair in the work package:

| Check | Parallel OK? |
|-------|-------------|
| Different files modified | Yes |
| Same files modified | No — sequential |
| Different database tables | Yes |
| Same database tables/schema | No — sequential |
| Different API endpoints | Yes |
| Shared middleware changes | No — sequential |
| Different UI pages | Yes |
| Shared layout/navigation changes | No — sequential |

Rule of thumb: if `git diff` from two tasks would never conflict, they can run in parallel.

## Foundation Work Package (WP-0)

Usually **sequential** — foundation tasks depend on each other:
1. Scaffold -> 2. Auth -> 3. Database -> 4. Design system -> 5. Layout shell

Exception: Design system setup (4) can sometimes parallel with Database setup (3) if they touch completely different files.

## Feature Work Packages (WP-1+)

Best candidates for parallel execution:

**Two-Agent Team (most common):**
- Agent 1: Backend tasks (API endpoints, database, business logic)
- Agent 2: Frontend tasks (UI components, pages, client-side logic)
- Prerequisite: API contracts defined so frontend can build against contract

**Three-Agent Team (large packages):**
- Agent 1: Backend/API tasks
- Agent 2: Frontend page tasks
- Agent 3: Shared component tasks (design system components, utilities)

## Polish Work Package (WP-N)

Good candidate for parallel execution:
- Agent 1: Error handling and loading states
- Agent 2: Responsive adjustments
- Agent 3: Accessibility audit fixes

These typically touch different aspects of the same components but different properties.

## Team Size Guidelines

| Work Package Size | Recommended Team Size |
|-------------------|----------------------|
| 3-4 tasks | 2 agents max |
| 5-6 tasks | 2-3 agents |
| 7-8 tasks | 3-4 agents |

More agents does not mean faster. Coordination overhead and merge complexity increase with team size. Start with 2 agents and increase only if tasks are clearly independent.

## Sequential Fallback

If task independence cannot be confirmed, fall back to sequential execution. It is better to be slow and correct than fast and broken.
