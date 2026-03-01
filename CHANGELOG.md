# Changelog

All notable changes to the project-kit plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-03-01

### Added — W1: Agent Plumbing
- **Agent() tool** on project-lead and sprint-coordinator: orchestrators can now spawn specialist agents directly via the Agent tool instead of the removed Task tool. Includes agent routing allowlists.
- **isolation: worktree** on all 7 developer agents (react-developer, nextjs-developer, python-developer, java-developer, api-developer, auth-developer, database-developer). Each developer agent works in an isolated git worktree to prevent file conflicts during parallel execution.
- **maxTurns** on all 26 agents. Values calibrated by role: project-lead (200), sprint-coordinator (150), product-designer (100), developers (50), reviewers (30), documentation (40).
- **sprint-coordination skill** with SKILL.md and 8 reference files: work-package-lifecycle.md, stage-transitions.md, context-isolation.md, session-management.md, blocker-resolution-protocol.md, progress-tracking.md, change-management.md, communication-protocol.md. Extracted from the 533-line sprint-coordinator agent body, which is now ~120 lines focused on routing decisions.

### Added — W2: Modular Architecture
- **Decision 8: Architecture Style** in Platform Foundation — new diagnostic question covering traditional monolith, modular monolith, microservices, and serverless-first. Platform engineer now locks 8 decisions (up from 7).
- **modular-monolith-patterns.md** reference (~350 lines): module boundary definition, internal API contracts, data isolation strategies (schema-per-module), cross-module communication (sync + event bus), module testing strategy, migration path to microservices, decision matrix, anti-patterns.
- **domain-driven-design.md** reference (~250 lines): strategic DDD (bounded contexts, context mapping), tactical DDD (entities, value objects, aggregates, domain events, repositories), domain event patterns, anti-corruption layers, practical application to project-kit.
- **architecture-style-patterns.md** reference: decision tree for choosing patterns per architecture style with flowchart.
- Solution architect updated: new Step 2.5 (Apply Architecture Style from Platform Foundation) with conditional guidance for each style.
- Architecture skill updated: new step 2.5 and three new references.
- **Module Boundary Rule** added to all 7 developer agents: enforces module boundaries when architecture style is modular-monolith.
- **Question 6** added to implementation-thinking skill: "Which module does this belong to?" for modular monolith projects. Implementation notes example updated with MODULE section.
- Implementation planner updated: groups tasks by module boundary for modular monolith projects.
- Gate 4 (Architecture) criteria updated: checks architecture style alignment and module boundary definitions.
- project.config.template.yaml: new `architecture` block (style, module_boundaries, inter_module_communication).

### Added — W3: Agent Teams (Experimental)
- **Agent Teams parallel execution** support in sprint-coordinator: experimental mode for running independent tasks in parallel. Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` environment variable.
- **agent-teams-parallel.md** reference: when to use teams, how parallel execution works, team composition patterns (frontend+backend, module-per-agent, feature-per-agent), merge strategy, limitations.
- **team-composition.md** reference: parallelizability assessment, team patterns by work package type, team size guidelines, sequential fallback.
- Phase 7 description in project-lead updated with dual-mode execution (sequential default, Agent Teams optional).

### Changed
- Sprint-coordinator agent refactored from 533 lines to ~120 lines. All process detail moved to sprint-coordination skill reference files.
- "Task tool" references replaced with "Agent tool" across all agents and skills (project-lead, sprint-coordinator, docs-writer, product-designer).
- Platform Foundation references updated from "7 decisions" to "8 decisions" throughout (platform-engineer, platform-foundation skill, project-lead).
- Agent count unchanged at 26. Skill count: 23 → 24 (added sprint-coordination).

### Design Rationale
**W1 (Agent Plumbing):** The Task tool was removed from Claude Code; Agent() is the replacement. Adding maxTurns prevents runaway sessions. Worktree isolation enables safe parallel developer execution — each agent gets its own copy of the repository, eliminating file conflicts. Refactoring sprint-coordinator into a skill with references follows the same progressive disclosure pattern as other skills.

**W2 (Modular Architecture):** Project Kit defaulted to unstructured monolith architecture. Many production systems benefit from enforced module boundaries — they provide microservices-like separation (owned data, internal APIs, domain events) without operational overhead. Adding modular monolith and DDD as first-class architectural options with guidance at every level (platform decision → architecture design → implementation planning → developer constraints → code review) ensures the pattern is consistently applied, not just named in an ADR.

**W3 (Agent Teams):** Sequential task execution is safe but slow for large work packages with independent tasks. Agent Teams experimental support provides a parallel execution path for projects that need it, gated behind an environment variable to keep the default behavior unchanged. The worktree isolation from W1 is a prerequisite — without it, parallel agents would cause file conflicts.

## [1.2.6] - 2026-02-26

### Added
- Guardian Behavior section in CLAUDE.md template: ambient phase-awareness, drift flagging, ad-hoc work tracking, and locked decision enforcement — active on ALL interactions, not just when `/orchestrate` is invoked
- New `/sync` command: reconciles ad-hoc work done outside orchestration back into the project's orchestrated state with drift report, phase classification, and user-approved reconciliation
- Ad-Hoc Work Log (`DYNAMIC:ADHOC` section) in CLAUDE.md for tracking out-of-orchestration work between sync points
- Drift detection on `/orchestrate` resume: checks ADHOC log before proceeding, asks whether to reconcile or continue as-is
- Three missing skills registered in marketplace.json: `implementation-planning`, `implementation-thinking`, `platform-foundation` (20 → 23 registered skills)

### Changed
- Project-lead agent On Invocation expanded from 5 to 7 steps: new steps 3-4 read ADHOC section and present drift report before proceeding
- Project-lead CLAUDE.md Maintenance now covers 4 dynamic sections (STATE, DECISIONS, HISTORY, ADHOC) instead of 3
- CLAUDE.md size budget increased from 150 to 180 lines to accommodate Guardian Behavior (~20 static lines) and ADHOC log
- Orchestrate command Steps expanded from 5 to 6: new step 4 checks Ad-Hoc Work Log before invoking project-lead
- README rewritten with GitHub installation instructions, "What Problems It Solves" section, and "Known Limitations" section

### Design Rationale
Users inevitably drift into freeform chat during active projects. They fix bugs, tweak components, make architecture decisions — all outside the orchestrated workflow. Without tracking, this work is invisible to the orchestrator: gates can't account for it, documents don't reflect it, and resuming `/orchestrate` proceeds as if nothing happened. Guardian Behavior makes CLAUDE.md an active behavioral constraint (not just a passive signpost) and the ADHOC log captures drift as it happens. The `/sync` command provides explicit reconciliation, and `/orchestrate` checks for drift before resuming. Together, these four mechanisms close the gap between structured orchestration and the reality of how people actually work with Claude Code.

## [1.2.5] - 2026-02-26

### Added
- Context management strategy: session boundary rules enforcing one task = one Claude Code session during BUILD, one stage = one session for review cycles
- Session break format in sprint coordinator: standardized break instructions before each task and between each work package stage (BUILD→TEST→CODE REVIEW→QA REVIEW)
- Session management section in orchestrate command: automatic session break points, consistent break format, what persists (disk) vs. what resets (context window)
- Context management settings in project.config.template.yaml: `context_management` block with session boundary enforcement, max exchanges per session, and scoped context loading per session type (task, test, review, QA)
- CLAUDE.md template: minimal project-level context file (under 50 lines) — stack, conventions, current state pointers, key commands. Explicit guidance on what should NOT be in this file
- Phase 8 session strategy: four focused sessions (regression, integration journeys, performance, security) instead of one monolithic QA session
- Resumption and debugging patterns: guidance for resuming interrupted tasks and debugging across session boundaries

### Changed
- Sprint coordinator agent expanded with Context Management section after existing Context Isolation Rule: session break instructions per stage with specific context-to-load and context-to-discard guidance
- Orchestrate command expanded with Session Management During Orchestration section: break point timing, format, persistence rules, and Phase 8 session decomposition

### Design Rationale
The AGENTS.md paper (Gloaguen et al., ETH Zurich, Feb 2026) found that agents with more context use more reasoning tokens (+14-22%), take more steps, and solve tasks LESS effectively. By task 3 or 4 in a session, the model is swimming in irrelevant context from earlier tasks. Session boundaries are the mechanism that enforces relevance — every artifact in project-kit is already self-contained by design (task briefs, work package briefs, implementation notes), so each session can load exactly one artifact and have everything it needs. This update makes that session discipline explicit in the sprint coordinator and orchestrator rather than leaving it implicit.

## [1.2.4] - 2026-02-26

### Changed
- Testing skill rewritten: test planning from acceptance criteria replaces generic test pyramid as starting point; tests trace to acceptance criteria, edge cases, performance contracts, and failure modes; interaction pattern-aware testing strategies for all 7 patterns (CRUD, Search & Filter, Monitor & Alert, Workflow & Queue, Analysis & Exploration, Configuration & Setup, Import & Transform); outcome-based coverage targets (100% acceptance criteria, 100% edge cases, 100% performance contracts) replace 80% line coverage as primary metric
- QA review skill restructured into two-level QA: Level 1 (work package QA during implementation with TEST, CODE REVIEW, QA REVIEW, HUMAN VERIFY stages) and Level 2 (Phase 8 system QA for cross-work-package integration, regression, system performance, and security). Phase 8 is no longer "test everything for the first time" but "validate the whole system now that all work packages have individually passed"
- QA engineer agent updated with dual role: Level 1 (activated during work package TEST and QA REVIEW stages, scoped to current WP) and Level 2 (activated in Phase 8, scoped to full system). Reads implementation notes and adapts testing approach by interaction pattern
- Security reviewer agent updated with dual scope: Level 1 (work package CODE REVIEW, scoped to changed files) and Level 2 (Phase 8, full system OWASP scan and auth boundary testing)
- Code reviewer agent updated with implementation thinking awareness: primary checks now validate implementation notes existence, interaction pattern match, performance contract implementation, feature connections, and regret check items. Severity levels aligned with work package lifecycle (Critical/High block WP, Medium/Low defer to Polish WP)

### Design Rationale
QA was structurally disconnected from the rest of the workflow. The testing skill provided generic patterns (test pyramid, arrange-act-assert, 80% coverage) without connecting to acceptance criteria, edge cases, performance contracts, or failure modes from upstream phases. The qa-review skill described a monolithic Phase 8 review that ran after all implementation was done, but work packages now embed QA into every increment. The fix: testing starts from "what could go wrong for the user?" not "what's the test pyramid?", and QA operates at two levels — incremental validation during implementation (Level 1) and system integration validation after all work packages complete (Level 2). If Level 1 is done well, Phase 8 should find very little.

## [1.2.3] - 2026-02-26

### Added
- New implementation-thinking skill: 5-question decision framework (User Moment, Performance Contract, Interaction Pattern, Connections, Regret Check) that developers execute BEFORE reading technology-specific skills
- 7 interaction pattern reference cards (CRUD, Search & Filter, Monitor & Alert, Workflow & Queue, Analysis & Exploration, Configuration & Setup, Import & Transform) documenting what recipe-book skills miss for each pattern
- Implementation notes format: inline comment block or TASK-XXX-notes.md capturing thinking decisions for code reviewers
- Interaction Pattern Hint field in task brief template: implementation planner suggests a pattern per task to prevent default-to-CRUD

### Changed
- All 7 developer agents (react-developer, nextjs-developer, python-developer, java-developer, api-developer, auth-developer, database-developer) now execute "Before Writing Code" step before their technology-specific process
- Sprint coordinator BUILD stage now verifies implementation notes exist before marking a task complete (step 5 in task-level flow)
- Implementation-planning skill task brief template expanded with Interaction Pattern Hint section

### Design Rationale
Developer skills are code recipe books — they tell agents HOW to write code but never ask WHAT they're building or WHY that matters for code decisions. The result: every feature gets the same Controller/Service/Repository treatment regardless of whether it's a real-time monitoring dashboard, a data export pipeline, or a search interface. Implementation Thinking sits above technology skills and forces a thinking step between reading the task brief and writing code. The 5-question framework produces implementation notes that guide pattern selection and prevent the default-to-CRUD problem. Skill count: 22 -> 23.

## [1.2.2] - 2026-02-26

### Added
- Product Type Classifier as required first step in product-design skill: 8 product types (Consumer/PLG SaaS, Enterprise SaaS, Developer Tool, Operational Platform, Internal Tool, Compliance Tool, Data Product Analytical, Data Product Operational) with methodology adaptation per type
- Operational Value Framework for non-PLG products: operational metrics, operational NSM, role-based user types (not personas), value demonstration milestones (First Catch, Time Saved, Pattern Recognition, Trust Threshold)
- Usage Context Assessment (required): physical context (device, environment), temporal context (frequency, session length, time pressure), cognitive context (expertise, task complexity, error consequence) with context-to-feature rules
- Hierarchical Feature Inventory format: CAP-XXX (Capabilities) → FG-XXX (Feature Groups) → F-XXX (Features) replacing flat FEAT-XXX list. Maps directly to work package decomposition
- Cross-Domain Product Framing: 4 lenses (Physical Space, Time Horizon, Information Density, Failure Mode) to challenge default product patterns. Minimum 2 of 4 required before locking inventory
- Platform Foundation Input Package: structured signals (platform shape, user model, data, scale) fed from Product Design to Platform Foundation phase
- Scope definition at feature group level (Now / Next / Later) replacing flat MVP/post-MVP split
- Product Framing and Platform Foundation sections in FEATURE-INVENTORY.template.md
- Completeness Check table format in feature inventory template

### Changed
- Product-designer agent rewritten: process expanded from 3 phases to Step 0 (classification) + Step 1 (usage context) + 3 phases with new steps for framing, platform package, and scope at FG level
- Product-design skill restructured: Product Type Classifier and Usage Context Assessment inserted before Phase 1, Feature Design phase now produces hierarchical inventory
- FEATURE-INVENTORY.template.md converted from flat category format to hierarchical CAP → FG → F format with traceability cross-reference, product framing, and platform foundation input package sections
- Validation Checklist replaced with Package Completeness Check (10 items including classification, usage context, framing, platform package)
- Handoff section expanded from single BA handoff to four downstream phase handoffs (Platform Foundation, Architecture, UX/UI Design, Implementation Planner)
- Agent communication protocol updated: new post-classification checkpoint, feature inventory now reports capabilities/groups/features with framing insights, scope gate shows Now/Next/Later at FG level
- Agent quality criteria expanded: product type classified, usage context assessed, hierarchy used, framing applied, platform package prepared

### Design Rationale
The product-design skill was optimized for consumer SaaS and PLG products. Operational platforms, internal tools, enterprise systems, and data products have fundamentally different user models (assigned vs. chosen), success metrics (operational effectiveness vs. growth), and interaction patterns (continuous monitoring vs. task completion). The Product Type Classifier adapts methodology per product type. Usage Context Assessment captures physical, temporal, and cognitive constraints that shape features before they're designed. Hierarchical Feature Inventory (CAP → FG → F) maps directly to work package decomposition, making the handoff to implementation planning seamless. Cross-Domain Product Framing (from the same cross-domain thinking principle as the innovation skill update) prevents every product from defaulting to "a dashboard with CRUD and filters."

## [1.2.1] - 2026-02-26

### Added
- Cross-domain innovation requirement in innovation-strategist agent: six domain transfer lenses (physical world systems, biological systems, historical precedent, adjacent industry transfer, inversion, material constraints)
- Cross-Domain Perspectives table template for documenting structural insights from each lens
- Solution Options Matrix with Source column to force transparency about where each idea came from (business framework vs cross-domain transfer)
- Business-framework expansion techniques table (10x Thinking, Adjacent Problems, Different Users, Platform Thinking, Constraint Removal) as baseline before cross-domain step
- Solution Space Explored section in Validated Concept Package with cross-domain field tracking
- Communication protocol for solution space exploration phase

### Changed
- Innovation-strategist agent process expanded from 5 steps to 6: new Step 3 (Solution Space Exploration) inserted between Design Thinking Workshop and Feasibility Assessment
- Validated Concept Package now requires cross-domain option counts and selected cross-domain insight
- Quality criteria updated: cross-domain perspectives with structural mechanisms now required for validation
- Constraints updated: cross-domain exploration cannot be skipped, must score in Solution Options Matrix

### Design Rationale
Standard business-framework expansion (10x, Adjacent, etc.) keeps ideation within the same domain. Cross-domain perspectives force structurally different solutions by importing mechanisms from physical systems, biology, history, and unrelated industries. This mirrors the phozart-ui skill's approach of importing constraints from outside the design domain to break default AI patterns. Supported by AGENTS.md paper findings (Gloaguen et al., ETH Zurich, Feb 2026): cross-domain constraints force novel solution paths the model wouldn't find by expanding within its default domain.

## [1.2.0] - 2026-02-26

### Added
- Work package system: tasks grouped into 3-8 task packages that deliver visible, testable capabilities
- Five-stage work package lifecycle: BUILD → TEST → CODE REVIEW → QA REVIEW → HUMAN VERIFY (no stage can be skipped)
- Work package log template (`templates/docs/sprints/WP-TEMPLATE-log.md`) for stage transition logging
- Human verify prompt per work package: specific test scenarios instead of open-ended approval
- Stage transition logging in `docs/sprints/WP-XXX-log.md` (source of truth for `/status`)
- Standard work package sequence: WP-0 Foundation → WP-1 Core Entity → WP-2 Core Workflow → WP-3+ Features → WP-N Polish
- Work package progress display in `/status` command with stage indicators and attempt history

### Changed
- Implementation planner (Step 6): now groups tasks into work packages with package-level acceptance criteria
- Sprint coordinator: rewritten from flat task execution to work package lifecycle management with stage transitions and failure handling
- Orchestrate command: implementation phase now follows work package loop with stage announcements between packages
- Status command: shows work package progress (project-level and detail views) during implementation phase
- Gate 7b (Implementation Complete): now requires all work packages approved through full lifecycle, not just tasks complete
- HUMAN VERIFY gate on every work package is always manual — cannot be set to auto or skip

### Design Rationale
Individual tasks are the right unit for a developer session but too small for a review cycle. Reviewing everything at end of implementation is too late — problems compound. Work packages sit between tasks and full implementation: each delivers a testable increment that a human can use, break, approve, or send back before the next package starts.

## [1.1.0] - 2026-02-25

### Added
- New platform-engineer agent: locks foundational technical decisions (platform type, user model, auth, framework, data, deployment, NFRs) via structured diagnostic questionnaire with user
- New platform-foundation skill with tradeoff references for platform decisions
- New implementation-planner agent: decomposes design artifacts into bounded, developer-ready task briefs with scoped context (vertical slices, not horizontal layers)
- New implementation-planning skill with vertical slice decomposition patterns, context scoping rules, dependency mapping, and task size calibration
- Phase 3: Platform Foundation — new phase between Product Design and Architecture
- Gate 3: Platform Foundation — always manual, requires human confirmation of every decision
- Gate 7a: Implementation Entry — task decomposition must be approved before coding begins (always manual)
- Gate 7b: Implementation Complete — all tasks done, tests pass, contracts followed
- Task brief system: individual task files in docs/sprints/tasks/TASK-XXX.md with scoped context per task
- Context isolation rule: developer agents receive ONLY the task brief, not upstream design documents
- phozart-ui design skill integration support in ux-ui-designer agent and ux-ui-design skill
- External Design System Skills reference in ux-ui-design skill

### Changed
- Product designer (Phase 2) now includes requirements engineering: acceptance criteria (min 3 per feature), edge cases (min 2 per feature), out-of-scope statements, and traceability cross-reference (REQ-XXX to F-XXX)
- Business analyst changed from phase-owning agent to advisory role: available on-demand during Product Design for requirements pattern advice and during Release for BA acceptance testing
- Solution architect now requires docs/PLATFORM-FOUNDATION.md as mandatory input; must work within locked decisions, not around them
- Architecture phase moved from Phase 5 to Phase 4
- UX/UI Design phase moved from Phase 6 to Phase 5
- Marketing Research moved from Phase 2 to Phase 6 (optional, can run in parallel with Phases 4-5)
- Phase numbering updated across all commands, agents, and templates
- Gate numbering updated in project.config.template.yaml
- Product Design gate (Gate 2) now validates acceptance criteria, edge cases, and traceability
- Sprint coordinator rewritten: now consumes task queue from implementation-planner with strict context isolation, no longer creates its own sprint plans
- Agent count: 24 → 26 (added platform-engineer, implementation-planner)
- Skill count: 20 → 22 (added platform-foundation, implementation-planning)

### Removed
- Business Analysis as standalone Phase 4 (merged into Product Design)
- BA-specific gate (gate_4_requirements) replaced by enhanced Product Design gate
- BRD.md and USER-STORIES.md as standalone deliverables (acceptance criteria now embedded in FEATURE-INVENTORY.md)

### Research Context
Changes informed by "Evaluating AGENTS.md" (Gloaguen et al., ETH Zurich, Feb 2026) findings that redundant artifact layers degrade agent implementation performance. Merging BA into Product Design eliminates a redundant formatting phase. Platform Foundation produces decisions (constraints that reduce search space), not documentation.

## [1.0.0] - 2026-02-22

### Added
- Complete multi-agent project orchestration plugin for Claude Code
- 24 specialized agents covering all development lifecycle phases
- 22 skills with progressive disclosure via references/ directories
- 8 user-invocable commands (/project-init, /orchestrate, /gate-check, /techstack, /status, /chronicle, /sprint, /design-system)
- 30+ document templates for all project artifacts
- Guided techstack selection (technology decisions never made by agents)
- Configurable quality gates (manual/auto/skip per gate)
- 11-phase workflow: Setup, Innovation (opt), Product Design, Marketing (opt), Business Analysis, Architecture, UX/UI Design, Implementation, QA/Security, Release, Documentation
- Technology-specific developer agents: React, Next.js, Python, Java, API, Auth, Database
- Sprint coordination with parallel execution support
- Contract-driven development (TYPE-CONTRACTS + API-CONTRACTS)
- Unique-per-project design system creation (no defaults)
- Three documentation packages: Style Guide (HTML), Developer Guide, User Guide with screenshot placeholders
- Project chronicle for decision logging
- scaffold-docs.sh for directory structure creation
- project.config.yaml for persistent workflow state across sessions
