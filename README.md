# Project Kit — Multi-Agent Project Orchestration Plugin for Claude Code

A complete, gated, multi-agent development workflow plugin that covers the full lifecycle from product ideation through release. Technology-agnostic with guided techstack selection, configurable quality gates, and contract-driven development.

## What Problems It Solves

### The "blank canvas" problem
Starting a project with Claude Code is powerful but unstructured. You get great code, but without a methodology you end up with missing requirements, architecture decisions made implicitly by the first developer prompt, and no traceability between what was designed and what was built. Project Kit provides the structure — 11 phases with quality gates — so nothing gets skipped.

### The "one giant context" problem
Claude Code sessions degrade as context grows. Research shows agents with more context use more reasoning tokens and solve tasks *less* effectively (Gloaguen et al., ETH Zurich, Feb 2026). Project Kit enforces context isolation: each developer task gets a scoped brief with only the relevant context slice, not the entire upstream design. Session boundaries are explicit, with clear instructions on what to load and what to discard.

### The "ad-hoc drift" problem
Users inevitably drift into freeform chat during an active project — fixing a bug here, tweaking a component there — bypassing orchestration entirely. This produces useful work that exists outside the workflow. Project Kit's **Guardian Behavior** detects this drift in real-time, logs it, and the `/sync` command reconciles it back into the orchestrated state.

### The "implicit architecture" problem
Without explicit platform decisions, the first implementation prompt becomes the architecture. Project Kit locks 8 foundational decisions (platform type, user model, auth strategy, framework, data layer, deployment model, NFRs, architecture style) in Phase 3 before any design work begins. These locked decisions constrain all downstream agents — the architect can't contradict them, and neither can developers.

### The "everything looks like CRUD" problem
Standard developer agents produce Controller/Service/Repository for every feature regardless of whether it's a monitoring dashboard, a data pipeline, or a search interface. Project Kit's Implementation Thinking skill forces a 5-question decision framework before writing code, with 7 interaction pattern cards that guide developers toward the right architectural pattern per feature.

### The "QA at the end" problem
Testing everything after all code is written is too late — problems compound. Project Kit embeds QA into every work package through a five-stage lifecycle (BUILD → TEST → CODE REVIEW → QA REVIEW → HUMAN VERIFY). Phase 8 becomes system integration validation, not "test everything for the first time."

## Where It Falls Short (Known Limitations)

### Context window pressure
Despite session isolation, complex phases (architecture, implementation planning) can still push context limits. The plugin mitigates this with session break instructions and scoped context loading, but very large projects (30+ features) may need manual context management beyond what the plugin provides.

### No runtime execution
Project Kit is entirely prompt-based — agents, skills, and commands are markdown files that shape Claude's behavior. There are no actual scripts that validate gate criteria programmatically. Gate validation relies on Claude reading files and checking criteria, which means validation is as reliable as the model's attention, not a CI pipeline.

### Single-user workflow
The orchestration assumes one developer working with Claude Code. There's no multiplayer support — no branch-per-agent, no PR-based gate approvals, no conflict resolution between multiple humans editing the same project simultaneously.

### Technology coverage gaps
Developer agents exist for React, Next.js, Python (FastAPI/Django/Flask), Java (Spring Boot), and generic API/Auth/Database patterns. There are no dedicated agents for Vue, Angular, Svelte, Go, Rust, C#/.NET, Ruby, or mobile (React Native, Flutter, Swift, Kotlin). These stacks can still be used — the techstack-config skill supports them — but implementation agents fall back to general patterns rather than framework-specific best practices.

### No persistent memory across sessions
Each Claude Code session starts fresh. CLAUDE.md and project.config.yaml persist state to disk, but there's no vector database or semantic search over past sessions. If a decision was made in session 5 and you're in session 20, the model only knows about it if it's captured in CLAUDE.md's Key Decisions section (capped at 15 entries) or in a document it's instructed to read.

### Orchestration overhead for small projects
For a simple CRUD app or a quick prototype, 11 phases with quality gates is overkill. The plugin supports skipping phases and setting gates to `skip` mode, but the setup ceremony still exists. For projects under ~5 features, using Claude Code directly without Project Kit is likely faster.

### Design output is descriptive, not visual
The UX/UI designer produces design system tokens, wireframe descriptions, and user flow specifications — not Figma files or rendered mockups. The style guide is a self-contained HTML/CSS file, but wireframes are markdown descriptions with layout annotations, not pixel-perfect visual designs.

## Installation

### From GitHub (recommended)

```bash
# 1. Add the marketplace
claude plugin marketplace add phozart/project-kit

# 2. Install the plugin
claude plugin install project-kit@project-kit

# 3. Restart Claude Code to load the plugin
```

### From a local directory

```bash
# 1. Clone or download the repository
git clone https://github.com/phozart/project-kit.git

# 2. Add the local directory as a marketplace
claude plugin marketplace add ./project-kit

# 3. Install from the local marketplace
claude plugin install project-kit@project-kit

# 4. Restart Claude Code to load the plugin
```

### For plugin development

```bash
# Load for a single session without installing (useful for testing changes)
claude --plugin-dir ./project-kit
```

### Verify installation

```bash
claude plugin list
# Should show: project-kit@project-kit — Status: enabled
```

### Updating

```bash
# If installed from GitHub marketplace
claude plugin marketplace update project-kit
claude plugin update project-kit@project-kit

# If installed from local directory, changes are picked up on next session
# (the marketplace points to your local directory)
```

### Uninstalling

```bash
claude plugin uninstall project-kit@project-kit
claude plugin marketplace remove project-kit
```

## Quick Start

```
/project-init          # Set up project, select techstack, configure gates
/orchestrate           # Start or continue the workflow (checks for ad-hoc drift first)
/sync                  # Reconcile ad-hoc work back into orchestration
/status                # Check current progress
/gate-check            # Validate current quality gate
```

### What happens when you run `/project-init`

1. You provide project name, description, and type
2. The techstack-config skill walks you through technology selection layer by layer
3. Directory structure is scaffolded (`docs/`, `src/`, `tests/`)
4. `project.config.yaml` is created with your choices
5. `CLAUDE.md` is created as the orchestration anchor — it persists across sessions and includes Guardian Behavior for drift detection

### What happens when you run `/orchestrate`

1. Reads CLAUDE.md for behavioral context and current state
2. Reads project.config.yaml for full configuration
3. Checks the Ad-Hoc Work Log — if drift was detected, asks whether to reconcile first
4. Invokes the project-lead agent, which determines the current phase and routes to the appropriate specialist agent
5. When a phase completes, validates gate criteria and requests your approval (for manual gates)
6. Updates both project.config.yaml and CLAUDE.md, then moves to the next phase

## Key Design Principles

1. **Technology decisions are never made by agents.** All techstack choices are made by you through guided interactive selection.
2. **Manual vs. autonomous is configurable.** Every quality gate can be `manual`, `auto`, or `skip` via `project.config.yaml`.
3. **Design systems are unique per project.** No default themes — every project gets a custom design system.
4. **Implementation agents are technology-specific.** No generic "fullstack developer" — focused agents per technology area.
5. **Testing is embedded in implementation.** Developer agents write tests alongside code. QA validates the system.
6. **Architecture documentation is living.** Updated throughout the project, not just during the architecture phase.
7. **Contract-driven development.** TYPE-CONTRACTS and API-CONTRACTS bind all implementation streams.
8. **Platform decisions are locked before architecture.** Foundational choices (auth, database, framework, deployment) are confirmed with the user before any design work begins.
9. **Guardian Behavior is always active.** Even outside `/orchestrate`, Claude checks phase context, flags drift, and logs ad-hoc work.
10. **Developer agents run in isolated worktrees.** Each developer agent gets its own copy of the repository, enabling safe parallel execution without file conflicts.
11. **All agents have turn limits.** maxTurns prevents runaway sessions. Calibrated by role complexity.
12. **Modular architecture is a first-class option.** Platform Foundation Decision 8 locks the architecture style. Modular monolith, DDD patterns, and module boundary enforcement flow through all downstream phases.

## Guardian Behavior & Ad-Hoc Drift Detection

CLAUDE.md includes a **Guardian Behavior** section that applies to ALL interactions in a project, not just when `/orchestrate` is invoked. This solves the problem where users drift into freeform chat during an active project, bypassing orchestration entirely.

When a user asks for development work outside the orchestrated workflow:

1. **Phase awareness** — Claude checks the current phase and warns if the requested work belongs to a future phase.
2. **Drift flagging** — Work done outside orchestration is flagged with the relevant phase and a reminder to run `/sync`.
3. **Ad-hoc tracking** — All out-of-orchestration work is logged in the CLAUDE.md Ad-Hoc Work Log (`DYNAMIC:ADHOC` section).
4. **Locked decision respect** — Even in ad-hoc mode, locked decisions from Platform Foundation and Key Decisions are enforced.

Run `/sync` at any time to reconcile ad-hoc work. When `/orchestrate` is invoked, it checks the ad-hoc log first and asks whether to reconcile before resuming. Simple questions and non-project tasks skip the guardian check.

## Workflow Phases

| Phase | Name | Agents | Gate | Default Mode |
|-------|------|--------|------|-------------|
| 0 | Project Setup | — (command + skill) | Config exists, techstack defined | manual |
| 1 | Innovation | innovation-strategist | Concept validated | auto |
| 2 | Product Design | product-designer (+ business-analyst advisory) | Strategy, personas, features with acceptance criteria, edge cases, scope | manual |
| 3 | Platform Foundation | platform-engineer | All 8 decisions locked with user confirmation | manual |
| 4 | Architecture | solution-architect, data-architect | System design, contracts generated (within Platform Foundation constraints) | auto |
| 5 | UX/UI Design | ux-ui-designer | Design system, wireframes, flows | auto |
| 6 | Marketing Research | marketing-researcher | Market sized, positioning defined | skip |
| 7 | Implementation | implementation-planner → sprint-coordinator → developer agents | Decomposition approved, work packages pass BUILD → TEST → CODE REVIEW → QA → HUMAN VERIFY cycle | planner: manual, WP verify: manual |
| 8 | QA & Security | qa-engineer, security-reviewer, code-reviewer | No critical defects, security passed | auto |
| 9 | Release | release-manager (+ business-analyst BA testing) | All gates passed, BA acceptance done | manual |
| 10 | Documentation | style-guide-generator, dev-guide-generator, user-guide-writer | Three doc packages complete | auto |

Phases 1 and 6 are optional (controlled in `project.config.yaml`).
Phase 3 (Platform Foundation) is always manual — human confirms every decision.
Phase 6 (Marketing) can run in parallel with Phases 4-5.
Phase 7 (Implementation) is two-stage: the planner sub-phase is manual (human reviews task queue and work package grouping), and each work package goes through a five-stage lifecycle (BUILD → TEST → CODE REVIEW → QA REVIEW → HUMAN VERIFY) where human verification is always manual.

## Agents (26)

### Orchestrators (model: opus)
| Agent | Purpose |
|-------|---------|
| project-lead | Coordinates all phases, manages gates, routes to agents, detects ad-hoc drift on resume |
| product-designer | Defines WHAT gets built — strategy, personas, features with acceptance criteria and edge cases, MVP |
| sprint-coordinator | Executes work packages through five-stage lifecycle (BUILD → TEST → CODE REVIEW → QA → HUMAN VERIFY), routes task briefs to developer agents with context isolation |

### Specialists (model: sonnet)
| Agent | Purpose |
|-------|---------|
| platform-engineer | Locks foundational technical decisions via structured diagnostic questionnaire |
| implementation-planner | Decomposes design artifacts into bounded, developer-ready task briefs with scoped context |
| business-analyst | Advisory role: requirements pattern advice during Product Design, BA acceptance testing during Release |
| solution-architect | System design, ADRs, infrastructure decisions (constrained by Platform Foundation) |
| data-architect | Data modeling, schemas, TYPE-CONTRACTS, API-CONTRACTS |
| ux-ui-designer | Unique-per-project design system, wireframes, user flows |
| innovation-strategist | Design thinking, feasibility, cross-domain innovation (optional phase) |
| marketing-researcher | Market sizing, competitive analysis (optional phase) |

### Developers (model: opus, isolation: worktree)
| Agent | When Used |
|-------|-----------|
| react-developer | React components, hooks, state management |
| nextjs-developer | Next.js pages, App Router, server components |
| python-developer | FastAPI, Django, Flask backends |
| java-developer | Spring Boot services |
| api-developer | API endpoint implementation following contracts |
| auth-developer | Authentication and authorization |
| database-developer | Migrations, queries, connection management |

### Reviewers (model: sonnet, read-only)
| Agent | Purpose |
|-------|---------|
| qa-engineer | System-level testing, integration, E2E (Level 1: per-WP, Level 2: Phase 8 system) |
| security-reviewer | OWASP review, vulnerability scanning (no write access) |
| code-reviewer | Standards compliance, implementation thinking validation (no write access) |

### Documentation (model: sonnet)
| Agent | Output |
|-------|--------|
| docs-writer | Coordinates all documentation packages |
| style-guide-generator | Self-contained HTML/CSS style guide |
| dev-guide-generator | Developer guide with Mermaid diagrams, ERDs |
| user-guide-writer | User guide with screenshot placeholders for Cowork |
| release-manager | Changelog, deployment config, release notes |

## Skills (24)

Skills provide domain knowledge that agents reference. Each skill has a concise `SKILL.md` (<200 lines) with detailed content in `references/` subdirectories.

| Skill | Purpose | References |
|-------|---------|------------|
| project-init | Project scaffolding and config | — |
| techstack-config | Guided techstack selection | python, typescript, java, data-engineering stacks |
| product-design | Product strategy and feature design | feature completeness, personas, journey mapping |
| business-analysis | Requirements engineering patterns (advisory) | patterns, user stories, RTM guide |
| platform-foundation | Platform decision tradeoff references | platform tradeoffs |
| architecture | System design and ADRs | ADR template, design patterns, data flow |
| ux-ui-design | Design system creation | creation guide, accessibility, cognitive load, responsive |
| data-modeling | Data architecture patterns | OLTP, OLAP, lakehouse, migrations |
| api-design | API conventions and contracts | REST, GraphQL, contract generation |
| implementation-thinking | Pre-code decision framework (5 questions, 7 interaction patterns) | — |
| implementation-planning | Task decomposition patterns | vertical slice patterns, context scoping, dependency mapping |
| implementation-react | React patterns and rules | patterns, components, state, testing |
| implementation-nextjs | Next.js patterns | patterns, App Router, server components |
| implementation-python | Python backend patterns | patterns, FastAPI, Django, async |
| implementation-java | Java/Spring Boot patterns | patterns, Spring Boot conventions |
| implementation-auth | Auth implementation patterns | OAuth, JWT, RBAC |
| implementation-database | Database patterns | queries, migrations, connection pooling |
| testing | Testing patterns across all layers | unit, integration, data quality, E2E |
| qa-review | QA checklists and processes | code review, security, performance |
| deployment | Deployment and CI/CD | Docker, CI/CD, env management |
| documentation | Documentation package specs | style guide, dev guide, user guide |
| sprint-management | Sprint coordination patterns | parallel work, blocker resolution |
| sprint-coordination | Work package lifecycle, context isolation, session management | lifecycle, stage transitions, context isolation, sessions, blockers, progress, changes, communication |
| architecture-maintenance | Living architecture updates | — |

## Commands (9)

| Command | Description |
|---------|-------------|
| `/project-init` | Initialize a new project with techstack selection and scaffolding |
| `/orchestrate` | Start or continue the orchestrated workflow (checks for ad-hoc drift first) |
| `/sync` | Reconcile ad-hoc work back into the orchestration flow |
| `/gate-check` | Validate the current quality gate |
| `/techstack` | View or modify techstack configuration |
| `/status` | Quick overview of project state |
| `/chronicle` | View or add to the project decision chronicle |
| `/sprint` | Manage implementation sprints |
| `/design-system` | View, create, or export the design system |

## Project Configuration

All workflow state persists in `project.config.yaml`:

```yaml
project:
  name: "My App"
  type: "full-stack"

techstack:
  frontend:
    framework: "react"
    styling: "tailwind"
  backend:
    framework: "fastapi"
    orm: "sqlalchemy"
  data:
    database_primary: "postgresql"

gates:
  mode: mixed
  overrides:
    gate_0_setup: manual
    gate_3_platform_foundation: manual
    gate_9_release: manual

workflow:
  current_phase: implementation
  gates_passed: [0, 2, 3, 4, 5]
```

## Multi-Session Workflow

State persists across Claude Code sessions via:
- `project.config.yaml` — workflow state, techstack, gate status
- `CLAUDE.md` — orchestration anchor with behavioral framing, Guardian Behavior, dynamic state, and Ad-Hoc Work Log
- `docs/` — all artifacts produced by agents
- `docs/sprints/` — sprint board tracking parallel work and work package stage logs (WP-XXX-log.md)
- `docs/PLATFORM-FOUNDATION.md` — locked platform decisions (immutable after Phase 3)
- `docs/FEATURE-INVENTORY.md` — features with acceptance criteria and traceability

Each session reads `project.config.yaml` to understand where the project is. Use `/status` for a quick overview.

### Why CLAUDE.md matters

CLAUDE.md is loaded into the system prompt on every session. It provides:
- **Behavioral framing** — Reminds Claude this is an orchestrated project, not a freeform conversation
- **Guardian Behavior** — Drift detection and ad-hoc work tracking, active even outside `/orchestrate`
- **State summary** — Current phase, next phase, blockers in 4 lines
- **Decision history** — Key decisions so Claude doesn't re-ask or contradict them
- **Phase history** — What's done, what's skipped, what's next

This is critical after context compression removes the original agent prompt.

## Contract-Driven Development

Two binding contracts coordinate all implementation streams:

- **TYPE-CONTRACTS** — Exact field names, types, and relationships. Generated in the project's language.
- **API-CONTRACTS** — Exact endpoint paths, HTTP methods, operation names. Generated in the project's language.

Rules:
- Implementation agents MUST import and use these contracts
- Deviation from contracts is a blocking defect
- Contract changes go through the architect agent, never a developer agent

## Three Documentation Packages

Every project produces three deliverables:

1. **Design Style Guide** (`docs/guides/STYLE-GUIDE.html`) — Self-contained HTML/CSS showing all colors, typography, spacing, and components
2. **Developer Guide** (`docs/guides/DEV-GUIDE.md`) — Architecture with Mermaid diagrams, ERDs, API reference, ADR summaries, setup instructions
3. **User Guide** (`docs/guides/USER-GUIDE.md`) — Step-by-step journeys with screenshot placeholders formatted for Cowork capture

## Directory Structure

```
project-kit/
  .claude-plugin/
    plugin.json
    marketplace.json
  agents/                          # 26 agent definitions
    project-lead.md
    product-designer.md
    platform-engineer.md
    implementation-planner.md
    business-analyst.md
    solution-architect.md
    data-architect.md
    ux-ui-designer.md
    sprint-coordinator.md
    react-developer.md
    nextjs-developer.md
    python-developer.md
    java-developer.md
    api-developer.md
    auth-developer.md
    database-developer.md
    qa-engineer.md
    security-reviewer.md
    code-reviewer.md
    docs-writer.md
    style-guide-generator.md
    dev-guide-generator.md
    user-guide-writer.md
    release-manager.md
    innovation-strategist.md
    marketing-researcher.md
  commands/                        # 9 user-invocable commands
    project-init.md
    orchestrate.md
    sync.md
    gate-check.md
    techstack.md
    status.md
    chronicle.md
    sprint.md
    design-system.md
  skills/                          # 23 skills with references
    project-init/SKILL.md
    techstack-config/SKILL.md
    product-design/SKILL.md
    business-analysis/SKILL.md
    platform-foundation/SKILL.md
    architecture/SKILL.md
    ux-ui-design/SKILL.md
    data-modeling/SKILL.md
    api-design/SKILL.md
    implementation-thinking/SKILL.md
    implementation-planning/SKILL.md
    implementation-react/SKILL.md
    implementation-nextjs/SKILL.md
    implementation-python/SKILL.md
    implementation-java/SKILL.md
    implementation-auth/SKILL.md
    implementation-database/SKILL.md
    testing/SKILL.md
    qa-review/SKILL.md
    deployment/SKILL.md
    documentation/SKILL.md
    sprint-management/SKILL.md
    sprint-coordination/SKILL.md
    architecture-maintenance/SKILL.md
  templates/                       # Document and config templates
    CLAUDE.template.md
    project.config.template.yaml
    docs/
      discovery/
      product/
      requirements/
      architecture/
      data/
      api/
      design/
      qa/
      security/
      devops/
      guides/
      chronicles/
      sprints/
  scripts/
    scaffold-docs.sh
  BEST-PRACTICES-CLAUDE-SKILLS-AGENTS.md
  README.md
  LICENSE
  CHANGELOG.md
```

## Supported Project Types

- `web-app` — Frontend-focused web application
- `full-stack` — Frontend + backend + database
- `api-service` — Backend API service
- `data-pipeline` — Data engineering pipeline
- `etl` — Extract, transform, load workflows
- `analytics` — Analytics and reporting
- `ml-pipeline` — Machine learning pipeline
- `library` — Reusable library/package

## Supported Techstacks

### Frontend
React, Next.js, Vue, Angular, Svelte, None

### Backend
FastAPI, Django, Flask, Express, NestJS, Spring Boot, Gin

### Data
PostgreSQL, MySQL, Snowflake, Databricks, BigQuery, MongoDB, SQLite, DuckDB

### Infrastructure
Docker/Podman, GitHub Actions/GitLab CI, AWS/GCP/Azure, Terraform/Pulumi/CDK

### Auth
OAuth2, JWT, Session, API Key, Auth0, Clerk, Supabase Auth, Firebase Auth, Custom

## Version History

See [CHANGELOG.md](CHANGELOG.md) for full details. Key milestones:

| Version | Date | Highlights |
|---------|------|-----------|
| 2.0.0 | 2026-03-01 | Agent() routing, worktree isolation, maxTurns, modular monolith + DDD, Agent Teams (experimental) |
| 1.2.6 | 2026-02-26 | Guardian Behavior, `/sync` command, ad-hoc drift detection |
| 1.2.5 | 2026-02-26 | Session management, context isolation, session break instructions |
| 1.2.4 | 2026-02-26 | Testing rewrite (acceptance-criteria-first), two-level QA |
| 1.2.3 | 2026-02-26 | Implementation Thinking skill, 7 interaction patterns |
| 1.2.2 | 2026-02-26 | Product Type Classifier, hierarchical feature inventory |
| 1.2.1 | 2026-02-26 | Cross-domain innovation, solution space exploration |
| 1.2.0 | 2026-02-26 | Work package system, five-stage lifecycle |
| 1.1.0 | 2026-02-25 | Platform Foundation phase, implementation planner, BA merged into Product Design |
| 1.0.0 | 2026-02-22 | Initial release: 24 agents, 20 skills, 8 commands, 11 phases |

## License

MIT
