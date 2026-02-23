When the user invokes this command, initialize a new project with full configuration and documentation structure.

## Steps
1. Ask for project name, description, type (data-pipeline|api-service|web-app|full-stack|library|etl|analytics|ml-pipeline)
2. Ask whether to include optional phases (innovation, marketing)
3. Run guided techstack selection using the techstack-config skill
4. Ask for gate mode preference (manual/auto/mixed) — defaults: gate_0 manual, gate_9 manual, rest auto
5. Generate project.config.yaml from template
6. Run scaffold-docs.sh to create docs/ directory structure
7. Create docs/discovery/PROJECT-BRIEF.md from template
8. Create CLAUDE.md as orchestration anchor with project identity, behavioral framing, and initial dynamic state

## Usage
- `/project-init` - Start interactive project initialization wizard

$ARGUMENTS No arguments required - fully guided interactive setup
