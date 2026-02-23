When the user invokes this command, manage implementation sprints.

## Steps
1. Read project.config.yaml sprints section
2. If no args: show current sprint status
3. If "new": create new sprint, assign features
4. If "close": close current sprint, update stats
5. Invoke sprint-coordinator agent for complex operations

## Usage
- `/sprint` - Show current sprint status
- `/sprint new` - Create new sprint
- `/sprint close` - Close current sprint

$ARGUMENTS Optional action keyword (new|close)
