---
name: project-init
description: Initialize new projects with proper structure and configuration
---

# Project Initialization Skill

Creates the foundational structure and configuration for new projects in the Project Kit ecosystem.

## When to Use

- Starting a brand new project
- Running /project-init command
- Need to scaffold initial project structure
- Setting up project configuration and documentation

## What This Skill Does

This skill guides you through project initialization by:

1. Gathering essential project information
2. Creating project.config.yaml with selected techstack
3. Scaffolding documentation structure
4. Setting up CLAUDE.md as the orchestration anchor (behavioral framing + dynamic state)
5. Configuring quality gate modes

## Process

### 1. Gather Project Information

Ask the user for:
- Project name (kebab-case recommended)
- Project description (1-2 sentences)
- Project type (web-app, api-service, data-pipeline, mobile-app, desktop-app, library)
- Target deployment environment (cloud, on-prem, hybrid, local-only)

### 2. Techstack Selection

Hand off to the `techstack-config` skill for guided technology selection.

The techstack-config skill will:
- Guide through layer-by-layer technology choices
- Generate build/test/lint/dev commands
- Return configuration to be stored in project.config.yaml

### 3. Quality Gate Configuration

Ask the user to select gate mode for each phase:
- **manual**: Checklist-only (default for all phases)
- **automated**: Run hooks/scripts (future capability)
- **hybrid**: Both checklist and automated validation

Default all gates to manual mode initially.

### 4. Scaffold Directory Structure

Create the following directories:
```
docs/
  requirements/
  architecture/
  design/
  contracts/
  decisions/
project-management/
  workpackages/
  status-reports/
src/
tests/
```

### 5. Create Core Files

**project.config.yaml**:
```yaml
project:
  name: <project-name>
  description: <project-description>
  type: <project-type>
  created: <ISO-8601-timestamp>

stack:
  # Populated by techstack-config skill
  frontend: {}
  backend: {}
  data: {}
  infrastructure: {}

gates:
  phase2-product: manual
  phase3-requirements: manual
  phase4-architecture: manual
  phase5-design: manual
  phase6-implementation: manual
```

**CLAUDE.md** (orchestration anchor — survives context compression):
```markdown
# <project-name>

<project-description>

**Type:** <project-type> | **Stack:** See project.config.yaml

## Orchestration

This project uses the **project-kit** orchestration workflow.
- Run `/orchestrate` to continue from the current phase.
- NEVER skip phases or gates without explicit user approval.
- All project state lives in `project.config.yaml`. This file provides framing and summaries.

<!-- DYNAMIC:STATE -->
## Current State
- **Phase:** 1 — Setup (complete)
- **Next:** 2 — Product Design
- **Last gate:** Gate 0 (Setup) — passed <date>
- **Blockers:** None
<!-- /DYNAMIC:STATE -->

<!-- DYNAMIC:DECISIONS -->
## Key Decisions
- <date>: Project initialized with <project-type> type
<!-- /DYNAMIC:DECISIONS -->

<!-- DYNAMIC:HISTORY -->
## Phase History
| Phase | Name | Status | Gate Passed |
|-------|------|--------|-------------|
| 0 | Setup | Done | <date> |
<!-- /DYNAMIC:HISTORY -->
```

### 6. Confirmation

Display summary of created structure and next steps:
- Project configuration location
- Documentation directories created
- Recommended next command: /orchestrator to start Phase 2

## Output

- project.config.yaml with initial configuration
- Scaffolded directory structure
- CLAUDE.md as orchestration anchor (behavioral framing + initial state)
- Success message with next steps
