# Best Practices: Claude Code Skills & Agents for Full-Project Workflows

> From innovative idea to production release — how to orchestrate Claude Code effectively in 2026.

---

## Table of Contents

1. [The Building Blocks](#1-the-building-blocks)
2. [How the Pieces Fit Together](#2-how-the-pieces-fit-together)
3. [Comparison: Your Project Kit vs cl_project_orchestration](#3-comparison-your-project-kit-vs-cl_project_orchestration)
4. [What Works and What Doesn't](#4-what-works-and-what-doesnt)
5. [Best Practice Architecture](#5-best-practice-architecture)
6. [Full Workflow: Idea to Release](#6-full-workflow-idea-to-release)
7. [Skill Design Patterns](#7-skill-design-patterns)
8. [Subagent & Agent Team Patterns](#8-subagent--agent-team-patterns)
9. [Memory & Context Engineering](#9-memory--context-engineering)
10. [Hooks for Quality Gates](#10-hooks-for-quality-gates)
11. [Plugin Packaging & Distribution](#11-plugin-packaging--distribution)
12. [Anti-Patterns to Avoid](#12-anti-patterns-to-avoid)
13. [Recommended Project Structure](#13-recommended-project-structure)
14. [Sources](#14-sources)

---

## 1. The Building Blocks

Claude Code provides five core extension mechanisms. Understanding when to use each is critical.

### Skills (`.claude/skills/<name>/SKILL.md`)

**What:** Reusable instructions, workflows, and domain knowledge that Claude loads on-demand or you invoke with `/skill-name`.

**Key properties:**
- Each skill is a directory with a `SKILL.md` entrypoint
- YAML frontmatter controls invocation (user-only, Claude-only, or both)
- Can include supporting files (templates, references, scripts)
- Can run in a forked subagent context (`context: fork`)
- Supports `$ARGUMENTS` for dynamic input and `!`command`` for dynamic context injection
- Descriptions are always loaded into context; full content loads only when invoked

**When to use:**
- Domain knowledge (API conventions, coding standards, design patterns)
- Task workflows (deploy, review, commit, generate docs)
- Project-specific methodologies (your orchestration phases)

### Subagents (`.claude/agents/<name>.md`)

**What:** Specialized AI assistants that run in their own context window with custom system prompts, tool access, and permissions.

**Key properties:**
- Run in isolated context — don't pollute your main conversation
- Can restrict tools (read-only, no file writes, etc.)
- Can use different models (Haiku for speed, Opus for capability)
- Support persistent memory across sessions (`memory: user|project|local`)
- Can preload skills via the `skills` field
- Cannot spawn other subagents (no nesting)

**When to use:**
- Tasks that produce verbose output (test runs, large searches)
- Enforcing constraints (read-only reviewer, security auditor)
- Parallel research (multiple subagents exploring different modules)
- Cost optimization (routing simple tasks to Haiku)

**Built-in subagents:** Explore (fast, read-only), Plan (research for planning), general-purpose (full tools).

### Agent Teams (Experimental)

**What:** Multiple Claude Code instances working together with a shared task list, direct inter-agent messaging, and a team lead coordinating work.

**Key properties:**
- Each teammate has its own full context window
- Teammates communicate directly (not just through the lead)
- Shared task list with dependencies, self-claiming, and status tracking
- Higher token cost (~3-4x single session)
- Requires enabling: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`

**When to use:**
- Complex collaborative work requiring discussion between agents
- Cross-layer changes (frontend + backend + tests in parallel)
- Research with competing hypotheses
- Work where teammates need to challenge/validate each other

**When NOT to use:**
- Sequential dependent tasks
- Same-file edits
- Simple parallel tasks (use subagents instead — lower overhead)

### Hooks (settings.json or agent/skill frontmatter)

**What:** Deterministic shell commands or LLM prompts that run at specific lifecycle events.

**Key properties:**
- Fire at defined points: SessionStart, PreToolUse, PostToolUse, Stop, etc.
- Can block actions (exit code 2 denies), modify inputs, or inject context
- Support matchers (regex) to filter which tools/events trigger them
- Three types: `command` (shell), `prompt` (single LLM call), `agent` (multi-turn subagent)
- Run outside the agentic loop — deterministic, not subject to LLM reasoning

**When to use:**
- Quality gates (lint after file write, test after edit)
- Security enforcement (block destructive commands, validate SQL)
- Automation (auto-format, auto-lint, auto-test)
- Context injection (load project state at session start)

### Plugins (directory with `.claude-plugin/plugin.json`)

**What:** Packaged bundles of skills, agents, hooks, and MCP servers for distribution.

**Key properties:**
- Namespaced skills: `/plugin-name:skill-name` (prevents conflicts)
- Can include agents, hooks, MCP servers, LSP servers, and settings
- Distributed via marketplace or `--plugin-dir` for local testing
- Can set a default agent via `settings.json` in plugin root

**When to use:**
- Sharing skill packages across teams or projects
- Distributing your orchestration framework
- Packaging a complete development methodology

### Memory (CLAUDE.md, rules, auto memory)

**What:** Persistent context that loads at session start.

| Type | Location | Scope |
|------|----------|-------|
| Project memory | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team (committed to repo) |
| Project rules | `.claude/rules/*.md` | Team, supports path-scoping |
| User memory | `~/.claude/CLAUDE.md` | Personal, all projects |
| Local memory | `./CLAUDE.local.md` | Personal, this project only |
| Auto memory | `~/.claude/projects/<project>/memory/` | Auto-generated learnings |

**Best practices:**
- Keep CLAUDE.md under 150 lines — link to detailed docs with `@path` imports
- Use `.claude/rules/` for modular, topic-specific rules with path-scoping
- Store build commands, test commands, and project conventions in CLAUDE.md
- Use auto memory for Claude's own learnings (patterns, debugging insights)

---

## 2. How the Pieces Fit Together

```
                    ┌─────────────────────────────────────────┐
                    │              USER                        │
                    │  "Start a new project" or /orchestrator  │
                    └──────────────────┬──────────────────────┘
                                       │
                    ┌──────────────────▼──────────────────────┐
                    │         CLAUDE.md (Memory)               │
                    │  Project conventions, build commands,    │
                    │  architecture notes, team standards      │
                    └──────────────────┬──────────────────────┘
                                       │
                    ┌──────────────────▼──────────────────────┐
                    │      ORCHESTRATOR SKILL (Main)           │
                    │  Coordinates phases, invokes sub-skills, │
                    │  manages gates, routes to agents          │
                    └────┬─────────┬──────────┬───────────────┘
                         │         │          │
              ┌──────────▼──┐  ┌──▼────────┐ ┌▼──────────────┐
              │  Skill A     │  │ Skill B   │ │ Skill C       │
              │  (inline or  │  │ (forked   │ │ (triggers     │
              │   subagent)  │  │  agent)   │ │  agent team)  │
              └──────┬───────┘  └─────┬─────┘ └──────┬────────┘
                     │                │              │
              ┌──────▼───────┐  ┌─────▼─────┐  ┌────▼────────────┐
              │  Hooks        │  │ Subagent  │  │ Agent Team       │
              │  (lint, test, │  │ (isolated │  │ (multi-session   │
              │   security)   │  │  context) │  │  parallel work)  │
              └───────────────┘  └───────────┘  └─────────────────┘
```

**The hierarchy:**
1. **CLAUDE.md** provides baseline context (always loaded)
2. **Skills** provide domain knowledge and task workflows (loaded on demand)
3. **Subagents** provide isolated execution with specialized configurations
4. **Agent Teams** provide multi-session parallel collaboration
5. **Hooks** provide deterministic quality enforcement at lifecycle events
6. **Plugins** package everything for distribution

---

## 3. Comparison: Your Project Kit vs cl_project_orchestration

| Aspect | Your Project Kit | cl_project_orchestration |
|--------|-----------------|--------------------------|
| **Skills count** | 10 (focused, pk-prefixed) | 48+ (broad coverage) |
| **Scope** | Fullstack web (Spring Boot + React + Databricks) | Universal (digital, physical, services) |
| **Orchestration** | Single orchestrator skill with 5 phases | project-orchestrator command with 10 gates |
| **Parallelism** | 3-stream parallel in Phase 2 & 3 | Similar parallel streams, plus continuous flow mode |
| **Multi-session** | Work packages (WP-XXX) files for manual session distribution | Similar work package approach |
| **Traceability** | F-XXX → REQ-XXX → TC-XXX with RTM | Same pattern with RTM |
| **Gates** | 5 gates (Discovery, Analysis, Implementation, Quality, Release) | 10 gates |
| **Agents** | Uses skills only, no custom `.claude/agents/` | 13 coordinator agents |
| **Physical products** | Not supported | Industrial designer, manufacturing, packaging |
| **Marketing** | Not included | Marketing, SEO, content strategy |
| **Plugin packaging** | Not yet (has dist/ with .skill files) | Proper plugin structure |

### Where your Project Kit has it right:
- **Focused scope** — Spring Boot + React + Databricks is concrete enough to give excellent, specific guidance
- **Contract-driven development** — TYPE-CONTRACTS.ts and API-CONTRACTS.md binding all streams is excellent
- **Documentation-as-validation** — docs don't block work, they validate at gates
- **Change control** — CHANGE-XXX records for deviations is practical
- **Living artifacts** — HTML style guides and dev guides as project deliverables

### Where it falls short:
- **No custom agents** — skills alone can't provide isolated context or different model routing
- **No hooks** — quality gates are manual checklists rather than automated enforcement
- **No persistent memory** — agents don't learn across sessions
- **Plugin packaging incomplete** — `.skill` files in `dist/` but no proper plugin manifest
- **Agent teams not utilized** — multi-session relies on manual WP distribution instead of built-in teams
- **No innovation/research phase tools** — starts at product design, not ideation

---

## 4. What Works and What Doesn't

### What works well in practice:

1. **Skills as domain experts** — a well-written skill with clear instructions, supporting references, and a good description is extremely effective
2. **Contract-driven parallel streams** — shared types/API contracts allow truly independent parallel work
3. **Gate-based quality enforcement** — automated checks before phase transitions catch problems early
4. **Progressive disclosure** — loading detailed references only when needed saves context budget
5. **Standalone mode** — every skill working independently (not just via the orchestrator) is essential for flexibility

### What doesn't work well:

1. **Monolithic orchestrator skills** — a single 300+ line SKILL.md trying to manage everything burns context and confuses Claude
2. **Too many skills at once** — skill descriptions eat into context budget (2% of window, ~16K chars). 48+ skills causes some to get dropped
3. **Manual multi-session coordination** — telling users to "open another session and say 'pick up WP-002'" is fragile; agent teams handle this better
4. **Sequential skill invocation in one session** — running 10 skills sequentially in one session hits context limits; better to use subagents or agent teams
5. **Over-documented gates** — exhaustive checklists that Claude can't actually automate create false confidence
6. **Generic skill descriptions** — "QA Engineer" or "Backend Developer" are too broad; Claude struggles to decide when to invoke them

---

## 5. Best Practice Architecture

### Recommended approach: Layered Architecture

```
Layer 1: Plugin Package
├── .claude-plugin/plugin.json          # Manifest
├── agents/                             # Custom subagents
│   ├── discovery-coordinator.md        # Phase 1 coordinator
│   ├── analysis-coordinator.md         # Phase 2 coordinator
│   ├── implementation-coordinator.md   # Phase 3 coordinator
│   ├── quality-reviewer.md             # Phase 4 reviewer
│   └── release-coordinator.md          # Phase 5 coordinator
├── skills/                             # Domain knowledge & workflows
│   ├── orchestrator/SKILL.md           # Main entry point
│   ├── product-designer/SKILL.md       # Discovery workflow
│   ├── business-analyst/SKILL.md       # Requirements engineering
│   ├── solution-architect/SKILL.md     # Architecture & contracts
│   ├── ux-designer/SKILL.md            # UI/UX design
│   ├── backend-developer/SKILL.md      # Backend implementation
│   ├── frontend-developer/SKILL.md     # Frontend implementation
│   ├── data-engineer/SKILL.md          # Data layer
│   ├── qa-engineer/SKILL.md            # Testing & quality
│   └── release-manager/SKILL.md        # Release & security
├── hooks/hooks.json                    # Automated quality gates
└── settings.json                       # Default settings (optional)
```

### Key design principles:

1. **Skills for knowledge, Agents for execution** — Skills contain domain knowledge and instructions. Agents provide isolated execution contexts with tool restrictions and model selection.

2. **One agent per phase coordinator** — Each phase gets a custom agent that preloads the relevant skills and restricts tools to what that phase needs.

3. **Hooks for enforcement, not checklists** — Replace manual gate checklists with automated hooks that actually run tests, lint, validate schemas.

4. **Plugin for distribution** — Package everything as a plugin so teams can install with one command.

5. **Agent teams for true parallelism** — Use agent teams for Phase 2 and Phase 3 parallel streams instead of manual session distribution.

---

## 6. Full Workflow: Idea to Release

### Phase 0: Innovation & Research (Optional)

**When:** Starting from a vague idea, need to validate feasibility.

**Approach:** Use skills for guided discovery, subagents for parallel research.

```
Skills used:
  - innovation-strategist    → Idea generation, competitive analysis
  - research-scientist       → Technical feasibility, R&D
  - prototype-engineer       → Rapid prototyping to validate concepts

Execution:
  - Single session, sequential
  - Or: Agent team with 2-3 researchers investigating different angles

Outputs:
  - RESEARCH-NOTES.md
  - FEASIBILITY-ASSESSMENT.md
  - IDEATION-LOG.md
```

### Phase 1: Discovery & Product Design

**When:** Idea is defined enough to scope a product.

**Approach:** Single skill invocation, interactive with user.

```
Skill: product-designer
  - Context intake (gather existing docs, constraints)
  - Guided discovery conversation with user
  - Feature inventory and scope selection (Full/MVP/Single Feature)
  - User journey mapping

Gate: User explicitly approves scope

Outputs:
  - PRODUCT-INTAKE.md
  - FEATURE-INVENTORY.md
  - APPLICATION-SCOPE.md
  - USER-JOURNEYS.md
```

### Phase 2: Analysis (Parallel)

**When:** Scope is approved, ready for detailed analysis.

**Approach:** Three parallel streams. Choose execution mode based on project size.

```
Small project (≤5 features):
  → Run skills sequentially in main session
  → Stream A: business-analyst → REQUIREMENTS.md, RTM.md
  → Stream B: solution-architect → ARCHITECTURE.md, API-CONTRACTS.md, TYPE-CONTRACTS.ts
  → Stream C: ux-designer → style-guide/, mockups/

Medium project (6-15 features):
  → Use 3 subagents (context: fork) running in parallel
  → Each subagent preloads its skill + Phase 1 outputs
  → Results summarized back to main session

Large project (15+ features):
  → Spawn an Agent Team with 3 teammates
  → Each teammate owns one stream
  → They can discuss contracts and naming conventions via messaging
  → Shared task list tracks progress

Gate: Automated cross-validation
  - Every F-XXX has coverage in all three streams
  - API contracts align with requirements
  - TYPE-CONTRACTS cover all data entities
  - Mockup screens cover all user journeys
  + User approval

Outputs:
  - REQUIREMENTS.md, RTM.md
  - ARCHITECTURE.md, ADR/, API-CONTRACTS.md, TYPE-CONTRACTS.ts
  - ui/style-guide/, ui/dev-guide/, ui/mockups/
```

### Phase 3: Implementation (Parallel)

**When:** Analysis is approved, contracts are finalized.

**Approach:** Three parallel streams, same size-based execution as Phase 2.

```
Streams:
  → Stream D: backend-developer → src/backend/ (Spring Boot)
  → Stream E: frontend-developer → src/frontend/ (React + Vite)
  → Stream F: data-engineer → src/data/ (Databricks/Delta Lake)

Key mechanism: Contract-driven development
  - TYPE-CONTRACTS.ts is the single source of truth for types
  - API-CONTRACTS.md is the single source of truth for endpoints
  - Each stream reads contracts (read-only) and implements against them
  - Deviations create CHANGE-XXX.md records

Gate: Automated verification
  - Backend compiles, all endpoints implemented
  - Frontend builds, all screens match mockups
  - Data schemas match contracts
  - Cross-stream naming consistency
  - Change records reconciled

Hooks (automated):
  PostToolUse on Write|Edit:
    - Run linter on changed files
    - Run affected tests
  Stop:
    - Verify contract compliance
```

### Phase 4: Quality

**When:** All streams integrated, implementation sync gate passed.

**Approach:** Sequential, thorough.

```
Skill: qa-engineer
  Subphases:
    1. Smoke test (app starts and responds)
    2. Core user journey tests (happy path for each journey)
    3. Full test suite (all TC-XXX for all REQ-XXX)
    4. Accessibility audit
    5. Performance baseline

Gate: All critical/high tests pass, no critical a11y violations

Hooks:
  TaskCompleted:
    - Run test suite, block completion if tests fail
```

### Phase 5: Release

**When:** Quality gate passed.

**Approach:** Sequential, final validation.

```
Skill: release-manager
  Steps:
    1. OWASP security review (no critical findings)
    2. BA validation (acceptance criteria verified)
    3. Product validation (features match approved design)
    4. User guide creation/update
    5. CHANGELOG.md update
    6. RTM 100% complete

Gate: User final approval before deploy

Outputs:
  - Security review report
  - Updated user guides
  - CHANGELOG.md
  - Complete RTM
```

### Phase Summary Table

| Phase | Parallelism | Mechanism | Gate Type |
|-------|-------------|-----------|-----------|
| 0. Innovation | Optional parallel research | Subagents or Agent Team | User judgment |
| 1. Discovery | Sequential | Single skill, interactive | User approval |
| 2. Analysis | 3 parallel streams | Subagents or Agent Team | Automated + User |
| 3. Implementation | 3 parallel streams | Subagents or Agent Team | Automated + Hooks |
| 4. Quality | Sequential | Single skill | Automated tests |
| 5. Release | Sequential | Single skill | User approval |

---

## 7. Skill Design Patterns

### Pattern 1: Focused Domain Expert

Keep each skill focused on one domain. Under 500 lines for SKILL.md, with references for detailed knowledge.

```yaml
---
name: api-conventions
description: API design patterns for this codebase. Use when designing
  or implementing API endpoints.
---

## API Design Rules
1. RESTful naming: plural nouns, lowercase, hyphens
2. Consistent error format: { code, message, details }
3. Pagination: cursor-based, not offset
4. Versioning: URL path (/v1/)

## References
- For complete endpoint catalog, see [api-reference.md](references/api-reference.md)
- For error code definitions, see [error-codes.md](references/error-codes.md)
```

### Pattern 2: Task Workflow with User Gate

For workflows that need user approval, use `disable-model-invocation: true`.

```yaml
---
name: deploy-production
description: Deploy the application to production
disable-model-invocation: true
allowed-tools: Bash, Read, Grep
---

## Pre-deploy Checklist
1. Run `npm test` — all tests must pass
2. Run `npm run build` — build must succeed
3. Check `git status` — no uncommitted changes
4. Present summary to user for approval
5. Run deployment script
6. Verify health check
```

### Pattern 3: Forked Research Skill

For heavy exploration that shouldn't pollute main context.

```yaml
---
name: codebase-research
description: Deep research into codebase patterns and architecture
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:
1. Find all relevant files using Glob and Grep
2. Read and analyze the code patterns
3. Summarize findings with specific file:line references
4. Note any inconsistencies or technical debt
```

### Pattern 4: Dynamic Context Injection

Use `!`command`` to inject live data before Claude sees the skill.

```yaml
---
name: pr-review
description: Review a pull request comprehensively
context: fork
agent: general-purpose
---

## Current PR Context
- Diff: !`gh pr diff`
- Changed files: !`gh pr diff --name-only`
- PR description: !`gh pr view`

## Review Instructions
Analyze this PR for: correctness, security, performance, test coverage.
```

### Pattern 5: Orchestrator as Router

The orchestrator should be thin — it routes to sub-skills, not do the work itself.

```yaml
---
name: project-orchestrator
description: Coordinates project phases from discovery to release
disable-model-invocation: true
---

# Project Orchestrator

You coordinate the project workflow. You do NOT do the work yourself.
For each phase, invoke the appropriate skill.

## Phase Routing
1. Discovery → invoke `product-designer` skill
2. Analysis → invoke `business-analyst`, `solution-architect`, `ux-designer`
3. Implementation → invoke `backend-developer`, `frontend-developer`, `data-engineer`
4. Quality → invoke `qa-engineer`
5. Release → invoke `release-manager`

## Your Responsibilities
- Track which phase is active
- Validate gate criteria between phases
- Route to the correct skill for each phase
- Present summaries and get user approval at gates
- Handle errors and blockers
```

---

## 8. Subagent & Agent Team Patterns

### Custom Agent: Phase Coordinator

Create a custom agent that preloads phase-specific skills.

```yaml
# .claude/agents/analysis-coordinator.md
---
name: analysis-coordinator
description: Coordinates Phase 2 analysis streams. Use when running
  business analysis, architecture, and UX design in parallel.
tools: Read, Grep, Glob, Bash, Write, Edit, Task
skills:
  - business-analyst
  - solution-architect
  - ux-designer
model: inherit
memory: project
---

You are the Analysis Phase Coordinator. You manage three parallel
analysis streams and validate their outputs at the sync gate.

## Your Workflow
1. Read Phase 1 outputs (PRODUCT-INTAKE.md, APPLICATION-SCOPE.md, etc.)
2. Launch 3 subagents (one per stream) or create an agent team
3. Monitor progress
4. Run cross-validation at sync gate
5. Present results to user for approval

## Quality Criteria
- Every F-XXX has coverage in all three streams
- API contracts align with requirements
- TYPE-CONTRACTS cover all data entities
```

### Custom Agent: Read-Only Reviewer

```yaml
# .claude/agents/code-reviewer.md
---
name: code-reviewer
description: Reviews code for quality, security, and best practices.
  Use proactively after writing or modifying code.
tools: Read, Grep, Glob, Bash
model: sonnet
memory: user
---

You are a senior code reviewer. When reviewing:
1. Run `git diff` to see changes
2. Focus on modified files
3. Check: readability, naming, error handling, security, tests
4. Provide feedback as: Critical / Warning / Suggestion
```

### When to Use Each Approach

| Scenario | Approach | Why |
|----------|----------|-----|
| Quick file search | Built-in Explore subagent | Fast, read-only, Haiku model |
| Single skill task (e.g., write requirements) | Invoke skill inline | Stays in main context |
| Heavy research task | `context: fork` skill with Explore agent | Isolates verbose output |
| 2-3 independent parallel tasks | Subagents | Lightweight, results summarized back |
| 3+ tasks needing coordination | Agent Team | Teammates can message each other |
| Complex task with specific tool limits | Custom agent | Full control over tools/model/permissions |
| Task that should learn over time | Agent with `memory: user` | Persistent learnings across sessions |
| Risky/destructive operations | Agent with `permissionMode: plan` | Read-only until approved |

---

## 9. Memory & Context Engineering

### CLAUDE.md Structure (Project-Level)

```markdown
# Project: MyApp

## Quick Commands
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`
- Dev: `npm run dev`

## Architecture
- Frontend: Vite + React + TypeScript (src/frontend/)
- Backend: Spring Boot 3 + Java 21 (src/backend/)
- Data: Databricks + Delta Lake (src/data/)

## Conventions
- @.claude/rules/api-conventions.md
- @.claude/rules/testing-standards.md
- @.claude/rules/code-style.md

## Key Files
- TYPE-CONTRACTS.ts: shared types (source of truth)
- API-CONTRACTS.md: endpoint definitions
- docs/ARCHITECTURE.md: system architecture
```

### Rules for Progressive Disclosure

```markdown
# .claude/rules/api-conventions.md
---
paths:
  - "src/backend/**/*.java"
  - "src/frontend/src/services/**/*.ts"
---

## API Conventions
- RESTful naming: /api/v1/{resource}
- Error format: { code: string, message: string, details?: any }
- Pagination: cursor-based with { items, nextCursor, hasMore }
- Auth: Bearer token in Authorization header
```

```markdown
# .claude/rules/react-patterns.md
---
paths:
  - "src/frontend/**/*.tsx"
  - "src/frontend/**/*.ts"
---

## React Patterns
- Components: functional only, no class components
- State: hooks for local, Zustand for global
- Styling: CSS Modules with design tokens from tokens.css
- NO inline styles, NO fetch outside services/
```

### Context Budget Management

- Skill descriptions consume ~2% of context window (~16K chars)
- With 10+ skills, descriptions alone eat 5-10K tokens
- **Strategy:** Use `disable-model-invocation: true` for skills Claude shouldn't auto-discover
- **Strategy:** Use `user-invocable: false` for background knowledge skills
- **Strategy:** Keep descriptions concise — 1-2 sentences max
- Run `/context` to check for warnings about excluded skills
- Override with `SLASH_COMMAND_TOOL_CHAR_BUDGET` env var if needed

---

## 10. Hooks for Quality Gates

### Post-Edit Linting

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/lint-changed.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Pre-Commit Security Check

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous.sh"
          }
        ]
      }
    ]
  }
}
```

### Stop Hook: Verify Tests Pass

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "agent",
            "prompt": "Verify all tests pass by running the test suite. Check git status for uncommitted changes. $ARGUMENTS",
            "timeout": 120
          }
        ]
      }
    ]
  }
}
```

### Agent Team: Task Completion Gate

```json
{
  "hooks": {
    "TaskCompleted": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/verify-task.sh"
          }
        ]
      }
    ]
  }
}
```

---

## 11. Plugin Packaging & Distribution

### Converting Project Kit to a Plugin

```
project-kit/
├── .claude-plugin/
│   └── plugin.json                    # Plugin manifest
├── agents/
│   ├── analysis-coordinator.md
│   ├── implementation-coordinator.md
│   └── quality-reviewer.md
├── skills/
│   ├── pk-orchestrator/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── pk-product-designer/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── pk-business-analyst/
│   │   ├── SKILL.md
│   │   └── references/
│   └── ... (other skills)
├── hooks/
│   └── hooks.json
└── README.md
```

```json
// .claude-plugin/plugin.json
{
  "name": "project-kit",
  "description": "Parallel-first project orchestration for fullstack web applications",
  "version": "2.0.0",
  "author": {
    "name": "Your Name"
  },
  "repository": "https://github.com/yourname/project-kit"
}
```

### Testing Locally

```bash
claude --plugin-dir ./project-kit
```

### Distribution

1. Host the plugin directory in a git repository
2. Create or use a plugin marketplace (see Anthropic's plugin marketplace docs)
3. Users install with `/plugin install`

---

## 12. Anti-Patterns to Avoid

### 1. Monolithic Orchestrator Skill
**Problem:** A 300+ line SKILL.md that describes every phase, gate, and sub-task.
**Fix:** Thin orchestrator that routes to sub-skills. Each sub-skill self-contained.

### 2. Too Many Skills
**Problem:** 48+ skills where descriptions alone exceed the context budget.
**Fix:** Use `disable-model-invocation: true` for non-essential skills. Keep descriptions to 1-2 sentences. Group related skills.

### 3. Skills Doing Agent Work
**Problem:** Skills that need isolated context, restricted tools, or different models but are running inline.
**Fix:** Use custom agents with `skills` preloading, or `context: fork` in the skill.

### 4. Manual Multi-Session Coordination
**Problem:** "Open another terminal and say 'pick up WP-002'" is fragile and confusing.
**Fix:** Use Agent Teams for true parallel work. Use subagents for independent parallel tasks.

### 5. Checklists as Gates
**Problem:** Markdown checklists that Claude "checks" but can't actually verify.
**Fix:** Use hooks with real shell commands that run tests, lint, and validate.

### 6. Generic Skill Names
**Problem:** "QA Engineer" — Claude can't distinguish when to use it vs when to use "Security Engineer."
**Fix:** Specific descriptions: "Test web application functionality, accessibility, and performance. Use after implementation phase or when user says 'test the app'."

### 7. Over-Engineering the Orchestration
**Problem:** Complex state machines, elaborate tracking systems, ceremonial gates.
**Fix:** "Vanilla Claude Code outperforms complex workflows with fragmented tasks." Start simple. Add complexity only when needed.

### 8. Ignoring Context Limits
**Problem:** Running 5 skills sequentially in one session, each producing large outputs.
**Fix:** Use subagents or agent teams. Commit after each phase. Use `/compact` proactively at 50% context.

### 9. Not Using Persistent Memory
**Problem:** Every session starts from scratch, rediscovering the same patterns.
**Fix:** Enable `memory: user` or `memory: project` on frequently-used agents. Use auto memory.

### 10. Forgetting Standalone Mode
**Problem:** Skills only work when invoked through the orchestrator.
**Fix:** Every skill should work independently. When upstream docs don't exist, the skill asks for context.

---

## 13. Recommended Project Structure

### For the Plugin Package (what you distribute):

```
project-kit/
├── .claude-plugin/
│   └── plugin.json
├── agents/
│   ├── analysis-coordinator.md
│   ├── impl-coordinator.md
│   └── quality-reviewer.md
├── skills/
│   ├── pk-orchestrator/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── gate-definitions.md
│   │       └── parallel-model.md
│   ├── pk-product-designer/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── pk-business-analyst/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── pk-solution-architect/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── pk-ux-designer/
│   │   ├── SKILL.md
│   │   ├── references/
│   │   └── assets/
│   ├── pk-backend-developer/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── pk-frontend-developer/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── pk-data-engineer/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── pk-qa-engineer/
│   │   ├── SKILL.md
│   │   └── references/
│   └── pk-release-manager/
│       ├── SKILL.md
│       └── references/
├── hooks/
│   └── hooks.json
└── README.md
```

### For a Generated Project (what the orchestrator creates):

```
my-app/
├── .claude/
│   ├── CLAUDE.md                      # Project memory (auto-generated)
│   └── rules/
│       ├── api-conventions.md         # Path-scoped to backend + services
│       ├── react-patterns.md          # Path-scoped to frontend
│       └── testing-standards.md       # Global
├── docs/
│   ├── PRODUCT-INTAKE.md
│   ├── FEATURE-INVENTORY.md
│   ├── APPLICATION-SCOPE.md
│   ├── USER-JOURNEYS.md
│   ├── REQUIREMENTS.md
│   ├── RTM.md
│   ├── ARCHITECTURE.md
│   ├── API-CONTRACTS.md
│   ├── TYPE-CONTRACTS.ts
│   ├── ADR/
│   └── changes/
├── ui/
│   ├── style-guide/index.html
│   ├── dev-guide/index.html
│   └── mockups/
├── src/
│   ├── backend/
│   ├── frontend/
│   └── data/
├── tests/
└── CHANGELOG.md
```

---

## 14. Sources

### Official Anthropic Documentation
- [Extend Claude with Skills](https://code.claude.com/docs/en/skills)
- [Create Custom Subagents](https://code.claude.com/docs/en/sub-agents)
- [Orchestrate Teams of Claude Code Sessions](https://code.claude.com/docs/en/agent-teams)
- [Create Plugins](https://code.claude.com/docs/en/plugins)
- [Manage Claude's Memory](https://code.claude.com/docs/en/memory)
- [Hooks Reference](https://code.claude.com/docs/en/hooks)

### Reference Implementations
- [phozart/cl_project_orchestration](https://github.com/phozart/cl_project_orchestration) — 48+ skills, 13 coordinator agents, 3 operating modes
- [shanraisshan/claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice) — Community best practices collection
- [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) — Curated list of skills, plugins, and orchestrators

### Community Resources
- [Claude Code Agent Teams: Complete Guide 2026](https://claudefa.st/blog/guide/agents/agent-teams)
- [Claude Code Multiple Agent Systems: Complete 2026 Guide](https://www.eesel.ai/blog/claude-code-multiple-agent-systems-complete-2026-guide)
- [ruvnet/claude-flow](https://github.com/ruvnet/claude-flow) — Multi-agent orchestration platform
- [wshobson/agents](https://github.com/wshobson/agents) — Multi-agent orchestration for Claude Code
