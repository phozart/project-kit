---
name: implementation-thinking
description: Think before coding. Connect task purpose to implementation decisions. Read this BEFORE any technology-specific implementation skill.
---

# Implementation Thinking

Read this before writing any code. Every task.

## Why This Exists

Code recipe skills (React, Next.js, Python, Java, Database) tell you HOW to write code. This skill makes you think about WHAT you're actually building so the HOW serves the purpose.

A filter component for a real-time operator dashboard and a filter component for a monthly reporting page use the same React patterns. But they have fundamentally different performance budgets, state management needs, interaction patterns, and failure modes. If you don't think about that before coding, you build the wrong thing correctly.

## Process: 5 Questions Before Code (6 for Modular Monolith)

For every task, answer these five questions by reading the task brief. Write the answers as a comment block at the top of the primary file you create, or as a brief `TASK-XXX-notes.md` if the answers influence multiple files. These notes are for the code reviewer and for your future self.

### Question 1: What Is the User Actually Doing?

Not "what feature am I building." What is the human physically doing when they use this?

Read the task brief's acceptance criteria and the usage context from the product design. Then describe the moment of use in one sentence.

Examples of BAD answers (feature-level):
- "The user filters dispatches"
- "The user views a dashboard"
- "The user creates a record"

Examples of GOOD answers (moment-level):
- "An operator scanning three monitors spots a red indicator, clicks it, and needs to see all delayed dispatches for that route within 2 seconds so they can escalate before the SLA window closes"
- "A manager opens the app for 5 minutes between meetings to check if anything needs their attention, then closes it"
- "A customs officer processes a queue of declarations one by one, spending 30-90 seconds per item, and needs the next item to load instantly when they finish the current one"

The good answers contain:
- WHO (role, not persona)
- WHAT they're doing physically
- TIME pressure (or lack of it)
- WHAT happens if it goes wrong

This single sentence should change how you code. The operator scanning three monitors gets keyboard shortcuts and auto-refresh. The manager gets a summary view with exception highlighting. The customs officer gets prefetching of the next queue item.

### Question 2: What's the Performance Contract?

Every task has an implicit performance budget. Make it explicit before coding.

| Question | Answer | Code Implication |
|----------|--------|-----------------|
| How many records are we dealing with? | [from task brief edge cases] | Pagination strategy, index design, query approach |
| What's the acceptable response time? | [from "within seconds" / "real-time" / "batch is fine"] | Caching strategy, loading pattern, optimistic UI |
| Will this be called frequently or rarely? | [from usage context — continuous use vs. occasional] | Cache invalidation strategy, connection pooling |
| Does stale data matter? | [from failure mode — is outdated data dangerous or acceptable?] | Real-time vs polling vs on-demand refresh |
| What's the payload size? | [from data model — how much data per response?] | API response shaping, field selection, compression |

Write these down. They become your technical constraints alongside the Platform Foundation decisions. A 200ms response time target with 50,000 records means you need a database index BEFORE you write the query. Not after you discover it's slow.

### Question 3: What Interaction Pattern Am I Building?

Not all features are CRUD. The current skills treat everything as CRUD because the code examples are all CRUD. Before coding, identify which pattern this task actually is:

**CRUD (Create, Read, Update, Delete)**
When to use: entity management where the user's primary action is maintaining data.
Architecture: standard form -> API -> database pattern. The recipe book skills cover this well.
Signal: task brief mentions "create," "edit," "delete," "manage."

**Search & Filter**
When to use: user is looking for specific items in a large dataset.
Architecture: indexed queries, faceted search, result highlighting, saved searches.
NOT the same as CRUD list with filters bolted on. Search is a first-class interaction pattern.
Signal: task brief mentions "find," "filter," "search," large record counts.

**Monitor & Alert**
When to use: user watches for changes or anomalies over time.
Architecture: real-time data (WebSocket/SSE/polling), threshold-based visual indicators, notification system.
NOT a dashboard with auto-refresh. Monitoring means the system tells you when something changes, you don't have to look.
Signal: task brief mentions "monitor," "alert," "detect," "real-time," time-pressure in usage context.

**Workflow & Queue**
When to use: user processes items through states sequentially.
Architecture: state machine, queue management, next-item prefetching, bulk actions.
Signal: task brief mentions "process," "approve," "queue," "next," sequential operations.

**Analysis & Exploration**
When to use: user investigates data to find patterns or make decisions.
Architecture: drill-down navigation, comparative views, bookmarkable states, export.
Signal: task brief mentions "analyze," "compare," "investigate," "drill down."

**Configuration & Setup**
When to use: user defines rules, settings, or structures that affect system behavior.
Architecture: form wizards, validation-heavy, preview before commit, undo/history.
Signal: task brief mentions "configure," "set up," "define rules," "template."

**Import & Transform**
When to use: user brings data into the system from external sources.
Architecture: file upload, parsing, validation preview, error reporting, batch processing.
Signal: task brief mentions "import," "upload," "CSV," "integrate."

Most tasks fit one primary pattern. Some combine two (e.g., "search then process" is Search + Workflow). Identifying the pattern BEFORE coding prevents the default-to-CRUD problem.

### Question 4: What Does This Connect To?

Read the task brief's dependencies section. But also think about runtime connections, not just build-time dependencies:

- What data does this feature READ that another feature WRITES? (Data coupling)
- What events does this feature produce that others consume? (Event coupling)
- What shared UI state does this feature depend on? (State coupling — filters, navigation, selection)
- What shared infrastructure does this feature use? (Auth, caching, real-time connections)

Write down the connections. They reveal:
- Where you need to import shared types (from TYPE-CONTRACTS)
- Where you need to emit events (for features built in other work packages)
- Where you need to respect shared state (not reinventing filter state that already exists)
- Where a change in your code could break something in another work package

The task brief scopes your work. The connections scope your awareness.

### Question 5: What Would I Regret Not Doing?

After answering questions 1-4, ask: if I build this the obvious way using the recipe book patterns, what will go wrong in two weeks?

Common regrets:
- "I didn't add an index and now the filter is too slow with real data" -> add the index now
- "I didn't handle the empty state and it looks broken when there's no data" -> design the empty state as part of the task
- "I hardcoded the page size and now the operator wants 100 rows not 25" -> make it configurable
- "I didn't preserve filter state across navigation and the operator loses their view every time they click away" -> use URL params or session storage
- "I built it as a form but it should have been a command palette" -> the interaction pattern question should have caught this
- "I didn't add loading skeletons and the page looks broken during data fetch" -> loading states are part of the feature, not polish
- "I didn't think about what happens when the API is slow or fails" -> error and timeout handling in the service layer

This question is a 30-second gut check. It catches the things that recipe book skills don't mention because they're context-dependent.

### Question 6: Which Module Does This Belong To? (Modular Monolith Only)

If the project uses modular monolith architecture (`techstack.architecture.style: modular-monolith` in project.config.yaml), answer this question before coding:

- Which module owns this task's domain logic and data?
- Does this task need to call another module's API? If so, use the module's public interface — never import internal classes.
- Does this task produce domain events that other modules consume? If so, publish through the internal event bus.
- Does this task need data owned by another module? Access it through the owning module's API, never through direct database queries.

If the task brief doesn't specify the module, check the architecture documentation (SYSTEM-DESIGN.md) for module boundary definitions. If unclear, flag to the sprint coordinator as a blocker.

## Output: Implementation Notes

Before writing code, produce a brief note (inline comment block or separate file):

```
// IMPLEMENTATION NOTES: TASK-012 — Dispatch Filter
//
// USER MOMENT: Operator on 3 monitors during 8hr shift needs delayed
// dispatches for a specific route within 2 seconds to escalate before
// SLA window closes.
//
// PERFORMANCE CONTRACT:
// - 50,000+ records in dispatches table
// - Target response: <500ms for filtered query
// - Called continuously (operator refreshes or auto-polls every 30s)
// - Stale data is dangerous (missed delay = SLA breach)
// -> Need: composite index on (route, status, date), API response <200ms
//
// INTERACTION PATTERN: Monitor & Alert (primary) + Search & Filter (secondary)
// - Default view should show ONLY delayed dispatches, not all dispatches
// - Filter narrows within the alert set, not within all dispatches
// - Auto-refresh every 30s with visual diff (new delays highlighted)
// - Keyboard shortcut to cycle through delayed items
//
// CONNECTIONS:
// - Reads dispatch data written by TASK-010 (dispatch CRUD)
// - Filter state shared with TASK-013 (dispatch detail) — use URL params
// - Real-time updates from WebSocket established in WP-0 foundation
//
// MODULE (if modular monolith):
// - Belongs to: dispatch module
// - Calls: no cross-module calls needed
// - Publishes: DispatchDelayDetected event (consumed by notification module)
//
// REGRET CHECK:
// - Must add composite index in migration, not after
// - Must preserve filter state in URL (operator shares links with team)
// - Must handle WebSocket disconnect gracefully (show "stale data" warning)
// - Empty state: "No delayed dispatches" is a GOOD state, not an error
```

These notes take 5 minutes to write. They prevent hours of rework.

## How This Connects to Technology Skills

After writing implementation notes, THEN read the technology-specific skill (React, Next.js, Python, Java, Database). The technology skill tells you the code patterns. The implementation notes tell you WHICH patterns to apply and HOW to adapt them.

Example flow:
1. Read task brief -> understand what to build
2. Read implementation-thinking skill -> answer 5 questions (6 if modular monolith), write notes
3. Read implementation-react or implementation-nextjs skill -> choose code patterns that match the interaction pattern
4. Code -> with the notes as your guide, not just the recipe

The technology skill's CRUD examples become starting points, not templates. If your interaction pattern is "Monitor & Alert," you don't build a standard list page with filters. You build a real-time view with threshold indicators and auto-refresh. The React skill shows you how to structure components. The implementation notes tell you what kind of components to build.

## Integration with Existing Quality Gates

The work package QA REVIEW stage should check:
- Do implementation notes exist for each task?
- Do the notes reflect the task brief's usage context and acceptance criteria?
- Does the code match the interaction pattern identified in the notes?
- Were performance contract decisions actually implemented (indexes, caching, etc.)?

The CODE REVIEW stage should check:
- Are the implementation notes accurate to what was built?
- If the developer deviated from the notes, is the deviation documented and justified?
- Do the connections identified in the notes have proper imports/types/contracts?

## Interaction Pattern Reference Cards

For each interaction pattern, a quick reference of what the technology skill's default patterns DON'T cover:

### CRUD — What Recipe Books Miss
- Optimistic updates (update UI before server confirms) for responsive feel
- Conflict resolution when two users edit simultaneously
- Soft delete vs hard delete as a product decision, not a technical one
- Audit trail: who changed what when (if the product type is Operational or Compliance)

### Search & Filter — What Recipe Books Miss
- Debounced search input (don't query on every keystroke)
- URL-encoded filter state (shareable, bookmarkable, survives refresh)
- Faceted counts (show "Status: Delayed (42)" not just "Status: Delayed")
- Empty results: is it "no matches" or "too narrow filter"? Different UX.
- Saved searches / filter presets for power users

### Monitor & Alert — What Recipe Books Miss
- Polling interval tuning (too fast = server load, too slow = missed alerts)
- Visual diff between refreshes (what changed since last view)
- Alert fatigue: if everything is red, nothing is red. Severity matters.
- Acknowledge/snooze mechanism for alerts already seen
- Stale data indicators (when was this last refreshed? Is the connection alive?)
- Sound/notification for critical alerts when tab is in background

### Workflow & Queue — What Recipe Books Miss
- Prefetch next item while current item is being processed
- Bulk actions (approve all, reject selected)
- Queue position visibility ("12 of 47 processed")
- Lock mechanism (prevent two people processing the same item)
- Return-to-queue on timeout (if processor abandons an item)

### Analysis & Exploration — What Recipe Books Miss
- Bookmarkable state (every exploration state should be a URL)
- Compare mode (side-by-side views of different time periods or entities)
- Export current view (not just raw data, but the filtered/analyzed view)
- Breadcrumb trail showing drill-down path with ability to jump back to any level
- "How did I get here?" context preservation

### Configuration & Setup — What Recipe Books Miss
- Preview before commit (show what will change)
- Validation across fields (not just per-field: "if A is selected, B must be > 0")
- Undo/version history for configuration changes
- Impact analysis ("changing this setting affects 12 active dispatches")
- Template/copy functionality (duplicate an existing configuration as starting point)

### Import & Transform — What Recipe Books Miss
- Preview step before committing the import (show first 10 rows, flag problems)
- Partial success handling (47 of 50 rows imported, 3 failed — show details)
- Rollback mechanism (undo an entire import)
- Duplicate detection (this record already exists — skip, update, or flag?)
- Progress indicator for large imports (don't leave the user staring at a spinner)
