# Project: {{PROJECT_NAME}}

## This Is a Project-Kit Orchestrated Project

This project follows the project-kit workflow. Use `/orchestrate` to resume.
See project.config.yaml for full state and configuration.

## Stack

- Language: {{LANGUAGE}} {{LANGUAGE_VERSION}}
- Frontend: {{FRONTEND_FRAMEWORK}} + {{STYLING}}
- Backend: {{BACKEND_FRAMEWORK}} + {{ORM}}
- Database: {{DATABASE_PRIMARY}}
- Auth: {{AUTH_METHOD}} via {{AUTH_PROVIDER}}
- API: {{API_STYLE}}

## Conventions

- File naming: kebab-case
- Component naming: PascalCase
- API routes: /api/v1/[resource]
- Database migrations: timestamped

## Current State

- Phase: See `project.config.yaml` → `workflow.current_phase`
- Tasks: See `docs/sprints/TASK-QUEUE.md`
- Work packages: See `docs/sprints/WP-XXX-log.md`

## Key Commands

- dev: {{DEV_COMMAND}}
- test: {{TEST_COMMAND}}
- lint: {{LINT_COMMAND}}
- build: {{BUILD_COMMAND}}

## Key Decisions

<!-- Add 3-5 most impactful decisions as project progresses -->
<!-- Example: "Chose event sourcing for audit trail requirement (ADR-003)" -->

<!--
DO NOT add to this file:
- Architecture overview (it's in docs/architecture/)
- Feature descriptions (they're in task briefs)
- Design decisions (they're in ADRs)
- Coding patterns (they're in technology skills)
- QA checklists (they're in the QA skill)

Keep this file under 50 lines. It's a cheat sheet, not a knowledge base.
-->
