When the user invokes this command, start or continue the orchestration workflow for the project.

## Steps
1. Read CLAUDE.md for orchestration context (behavioral framing + state summary)
2. Read project.config.yaml for full state and configuration
3. If neither exists, tell user to run /project-init first
4. Invoke the project-lead agent to manage the workflow
5. Project-lead determines next phase and invokes appropriate agents

## Context Recovery

CLAUDE.md must be read **before** project.config.yaml because it provides:

- **Behavioral framing** — Reminds Claude this is an orchestrated project-kit workflow, not a freeform conversation. This is critical after context compression removes the original agent prompt.
- **State summary** — Current phase, next phase, last gate, and blockers in 4 lines. Enough to orient without parsing the full config.
- **Decision history** — Key decisions that shaped the project, so Claude doesn't re-ask or contradict them.
- **Phase history** — What's done, what's skipped, what's next.

project.config.yaml then provides the full data: techstack details, gate modes, requirement counts, sprint state, and all configuration the project-lead needs to execute.

## Usage
- `/orchestrate` - Resume from current phase
- `/orchestrate phase-name` - Jump to specific phase

$ARGUMENTS Optional phase name (discovery|design|development|deployment|operations|innovation|marketing) to jump to specific phase
