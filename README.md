# Project Kit — Multi-Agent Project Orchestration Plugin for Claude Code

A complete, gated, multi-agent development workflow plugin that covers the full lifecycle from product ideation through release. Technology-agnostic with guided techstack selection, configurable quality gates, and contract-driven development.

## What It Does

Project Kit replaces ad-hoc project management with a structured methodology. Instead of one developer writing everything sequentially, it deploys **24 specialized agents** coordinated by a project lead through **11 phases** with quality gates between each.

### Key Design Principles

1. **Technology decisions are never made by agents.** All techstack choices are made by you through guided interactive selection.
2. **Manual vs. autonomous is configurable.** Every quality gate can be `manual`, `auto`, or `skip` via `project.config.yaml`.
3. **Design systems are unique per project.** No default themes — every project gets a custom design system.
4. **Implementation agents are technology-specific.** No generic "fullstack developer" — focused agents per technology area.
5. **Testing is embedded in implementation.** Developer agents write tests alongside code. QA validates the system.
6. **Architecture documentation is living.** Updated throughout the project, not just during the architecture phase.
7. **Contract-driven development.** TYPE-CONTRACTS and API-CONTRACTS bind all implementation streams.

## Installation

```bash
# Local testing
claude --plugin-dir ./project-kit

# Or install as a plugin
claude plugin install ./project-kit
```

## Quick Start

```
/project-init          # Set up project, select techstack, configure gates
/orchestrate           # Start or continue the workflow
/status                # Check current progress
/gate-check            # Validate current quality gate
```

## Workflow Phases

| Phase | Name | Agents | Gate | Default Mode |
|-------|------|--------|------|-------------|
| 0 | Project Setup | — (command + skill) | Config exists, techstack defined | manual |
| 1 | Innovation | innovation-strategist | Concept validated | auto |
| 2 | Product Design | product-designer | Strategy, personas, features, MVP | auto |
| 3 | Marketing Research | marketing-researcher | Market sized, positioning defined | skip |
| 4 | Business Analysis | business-analyst | Requirements with IDs, RTM initialized | auto |
| 5 | Architecture | solution-architect, data-architect | System design, contracts generated | auto |
| 6 | UX/UI Design | ux-ui-designer | Design system, wireframes, flows | auto |
| 7 | Implementation | sprint-coordinator + developer agents | Code complete, tests pass, contracts imported | auto |
| 8 | QA & Security | qa-engineer, security-reviewer, code-reviewer | No critical defects, security passed | auto |
| 9 | Release | release-manager | All gates passed, BA acceptance done | manual |
| 10 | Documentation | style-guide-generator, dev-guide-generator, user-guide-writer | Three doc packages complete | auto |

Phases 1 and 3 are optional (controlled in `project.config.yaml`).
Phases 5 and 6 can run in parallel.

## Agents (24)

### Orchestrators (model: opus)
| Agent | Purpose |
|-------|---------|
| project-lead | Coordinates all phases, manages gates, routes to agents |
| product-designer | Defines WHAT gets built — strategy, personas, features, MVP |
| sprint-coordinator | Routes implementation work to developer agents, manages sprints |

### Specialists (model: sonnet)
| Agent | Purpose |
|-------|---------|
| business-analyst | Requirements engineering, RTM, business acceptance testing |
| solution-architect | System design, ADRs, infrastructure decisions |
| data-architect | Data modeling, schemas, TYPE-CONTRACTS, API-CONTRACTS |
| ux-ui-designer | Unique-per-project design system, wireframes, user flows |
| innovation-strategist | Design thinking, feasibility (optional phase) |
| marketing-researcher | Market sizing, competitive analysis (optional phase) |

### Developers (model: sonnet)
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
| qa-engineer | System-level testing, integration, E2E |
| security-reviewer | OWASP review, vulnerability scanning (no write access) |
| code-reviewer | Standards compliance, quality review (no write access) |

### Documentation (model: sonnet)
| Agent | Output |
|-------|--------|
| docs-writer | Coordinates all documentation packages |
| style-guide-generator | Self-contained HTML/CSS style guide |
| dev-guide-generator | Developer guide with Mermaid diagrams, ERDs |
| user-guide-writer | User guide with screenshot placeholders for Cowork |
| release-manager | Changelog, deployment config, release notes |

## Skills (20)

Skills provide domain knowledge that agents reference. Each skill has a concise `SKILL.md` (<200 lines) with detailed content in `references/` subdirectories.

| Skill | Purpose | References |
|-------|---------|------------|
| project-init | Project scaffolding and config | — |
| techstack-config | Guided techstack selection | python, typescript, java, data-engineering stacks |
| product-design | Product strategy and feature design | feature completeness, personas, journey mapping |
| business-analysis | Requirements engineering | patterns, user stories, RTM guide |
| architecture | System design and ADRs | ADR template, design patterns, data flow |
| ux-ui-design | Design system creation | creation guide, accessibility, cognitive load, responsive |
| data-modeling | Data architecture patterns | OLTP, OLAP, lakehouse, migrations |
| api-design | API conventions and contracts | REST, GraphQL, contract generation |
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
| architecture-maintenance | Living architecture updates | — |

## Commands (8)

| Command | Description |
|---------|-------------|
| `/project-init` | Initialize a new project with techstack selection and scaffolding |
| `/orchestrate` | Start or continue the orchestrated workflow |
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
    gate_9_release: manual

workflow:
  current_phase: implementation
  gates_passed: [0, 2, 4, 5, 6]
```

## Multi-Session Workflow

State persists across Claude Code sessions via:
- `project.config.yaml` — workflow state, techstack, gate status
- `docs/` — all artifacts produced by agents
- `docs/sprints/` — sprint board tracking parallel work
- `docs/requirements/RTM.md` — requirements traceability (living document)

Each session reads `project.config.yaml` to understand where the project is. Use `/status` for a quick overview.

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
  agents/                          # 24 agent definitions
    project-lead.md
    product-designer.md
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
  commands/                        # 8 user-invocable commands
    project-init.md
    orchestrate.md
    gate-check.md
    techstack.md
    status.md
    chronicle.md
    sprint.md
    design-system.md
  skills/                          # 20 skills with references
    project-init/SKILL.md
    techstack-config/SKILL.md
    product-design/SKILL.md
    business-analysis/SKILL.md
    architecture/SKILL.md
    ux-ui-design/SKILL.md
    data-modeling/SKILL.md
    api-design/SKILL.md
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
    architecture-maintenance/SKILL.md
  templates/                       # Document and config templates
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

## License

MIT
