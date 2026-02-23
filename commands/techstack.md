When the user invokes this command, view or modify the project's techstack configuration.

## Steps
1. Read project.config.yaml techstack section
2. If no args: display current techstack summary
3. If "edit": run interactive techstack selection for specific layer
4. Update project.config.yaml and regenerate build/test/dev commands

## Usage
- `/techstack` - View current techstack summary
- `/techstack edit` - Modify entire techstack interactively
- `/techstack edit frontend` - Modify specific layer (frontend|backend|data|infra|testing|devops)

$ARGUMENTS Optional "edit" keyword followed by optional layer name (frontend|backend|data|infra|testing|devops)
