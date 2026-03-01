# Blocker Resolution Protocol

When a developer reports a blocker during BUILD, route to the appropriate upstream agent.

## Blocker Types and Routing

### Task Brief Incomplete (Missing Context)

**Symptom:** Developer says "I need to know X to proceed" and X is not in the task brief.

**Route to:** implementation-planner

**Action:**
1. Flag the specific missing information
2. Do NOT load upstream design docs as compensation
3. Wait for the planner to update the brief
4. Provide the updated brief to the developer

### Contract Issue (Missing Types, Unclear API)

**Symptom:** TYPE-CONTRACTS or API-CONTRACTS don't cover the types/endpoints this task needs, or the contracts are ambiguous.

**Route to:** solution-architect (via architecture-maintenance skill)

**Action:**
1. Document the specific contract gap
2. Wait for contract update
3. Notify affected tasks in the queue
4. Never guess — always route to architect

### Design Inconsistency

**Symptom:** The wireframe says X but the acceptance criteria say Y, or the design doesn't account for an edge case.

**Route to:** ux-ui-designer

**Action:**
1. Document the specific inconsistency
2. Wait for design clarification
3. Update affected task briefs through implementation-planner

### Technical Feasibility

**Symptom:** The approach specified in the task brief won't work due to a technical limitation (framework constraint, performance issue, dependency conflict).

**Route to:** solution-architect

**Action:**
1. Document the feasibility issue with evidence
2. Escalate to architect for decision
3. May require an ADR
4. May require architecture change

### Discovered Missing Task

**Symptom:** Implementation reveals work that isn't in the task queue (e.g., a shared utility needed by multiple tasks, or an integration step nobody planned for).

**Route to:** implementation-planner

**Action:**
1. Flag the discovered work
2. Planner creates a new task brief and inserts it in the queue
3. Coordinator does not improvise new tasks
4. Coordinator does not modify other task briefs

## Blocker Communication Format

```
BLOCKER IDENTIFIED

Work Package: WP-[X]: [name]
Task: TASK-XXX: [title]
Issue: [description]
Type: [Brief incomplete / Contract issue / Design inconsistency / Technical feasibility / Missing task]

Action:
- Routed to [implementation-planner / solution-architect / ux-ui-designer] for resolution
- Waiting for [specific update]

Blocked downstream tasks: [list if any]
```

## Escalation Rules

1. **Never guess** when contracts are ambiguous — route to architect
2. **Never compensate** when briefs are incomplete — route to planner
3. **Never modify** other task briefs autonomously — flag to planner
4. **Always document** blockers and their resolutions in WP-XXX-log.md
5. If a blocker affects multiple work packages, flag to project-lead
