When the user invokes this command, view or regenerate the design system.

## Steps
1. Check if design system exists (docs/design/DESIGN-SYSTEM.md)
2. If no args: display design system summary (colors, typography, key components)
3. If "create": invoke ux-ui-designer agent to create from scratch
4. If "update": invoke ux-ui-designer to update existing
5. If "export": invoke style-guide-generator to produce HTML version

## Usage
- `/design-system` - View design system summary
- `/design-system create` - Create design system from scratch
- `/design-system update` - Update existing design system
- `/design-system export` - Export HTML style guide

$ARGUMENTS Optional action keyword (create|update|export)
