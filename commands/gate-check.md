When the user invokes this command, validate the current or specified quality gate.

## Steps
1. Read project.config.yaml for current gate number
2. Check gate mode (manual/auto/skip)
3. Validate all criteria for that gate
4. If auto: pass if criteria met, fail with details if not
5. If manual: present checklist to user for approval
6. Update gates_passed in config on success

## Usage
- `/gate-check` - Validate current gate
- `/gate-check N` - Validate specific gate number (0-9)

$ARGUMENTS Optional gate number (0-9) to check specific gate instead of current
