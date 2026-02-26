---
name: ux-ui-design
description: UX/UI design with unique design systems and accessibility focus
---

# UX/UI Design Skill

Creates comprehensive user experience and interface design with unique, project-specific design systems. CRITICAL: Design systems must be created FROM SCRATCH for each project — never use generic defaults.

## When to Use

- Phase 5 UX/UI design in the orchestrator workflow
- User says "design the UI" or "create design system"
- Need to create visual design and component specifications
- Defining interaction patterns and user flows
- Creating design system for developer implementation

## External Design System Skills

If a design system skill is available in the project (e.g., phozart-ui, phozart-design, phozart-console), treat it as the token foundation. The UX/UI design process focuses on layout, flows, and interaction patterns. The design system skill handles visual identity, spacing, and component styling. Do not duplicate or override design system tokens — extend them only when the project requires elements the system doesn't cover, and document the extension.

## What This Skill Does

This skill produces detailed UX/UI specifications including:

1. Unique design system (colors, typography, spacing, components)
2. User flow wireframes and mockups
3. Interaction patterns and micro-interactions
4. Accessibility guidelines (WCAG 2.1 AA compliance)
5. Responsive design specifications
6. Implementation-ready component specifications

## Process

### 1. Review Product Context

Read and analyze:
- `docs/product-strategy.md` - Vision, brand direction
- `docs/personas.md` - Target users and their needs
- `docs/features.md` - Features to design
- `docs/journey-maps.md` - User journeys to support

### 2. Define Brand and Visual Direction

**Brand Attributes**:
- What is the brand personality? (professional, playful, bold, minimal, etc.)
- What emotions should the design evoke?
- What is the competitive positioning?

**Visual Mood**:
- Collect visual references (not to copy, but for inspiration)
- Define adjectives that describe the desired aesthetic
- Consider industry conventions and expectations
- Identify opportunities to differentiate

**Output**: `docs/design/brand-direction.md`

### 3. Create Unique Design System

CRITICAL: Every design system must be UNIQUE to the project. Never use default Material Design, Bootstrap, or generic colors.

#### Color Palette

Create a custom color palette FROM SCRATCH:

**Primary Color**:
- Choose based on brand personality and industry
- Consider color psychology
- Ensure sufficient contrast ratios
- Define shades: 50, 100, 200, 300, 400, 500, 600, 700, 800, 900

**Secondary/Accent Colors**:
- Complementary or analogous to primary
- Use for CTAs, highlights, accents
- Same shade system as primary

**Neutral Colors**:
- Grays for text, borders, backgrounds
- Typically 50-900 scale
- Consider warm vs cool grays based on primary

**Semantic Colors**:
- Success (green spectrum)
- Warning (yellow/orange spectrum)
- Error (red spectrum)
- Info (blue spectrum)

**Example** (must be project-specific):
```css
/* Primary - Deep Teal (custom for marine industry SaaS) */
--color-primary-50: #e0f7f7;
--color-primary-500: #0d9488; /* Main */
--color-primary-900: #042f2e;

/* Accent - Coral (warm contrast) */
--color-accent-500: #ff6b6b;

/* Neutrals - Cool grays */
--color-neutral-50: #f8fafc;
--color-neutral-900: #0f172a;
```

#### Typography

Define custom typography system:

**Font Selection**:
- Choose 1-2 fonts that match brand personality
- Consider pairing (serif + sans-serif, or two sans-serifs)
- Ensure web-safe or load via Google Fonts/Adobe Fonts
- Test readability at various sizes

**Type Scale**:
Define harmonious size progression (not random):
- Use modular scale (1.2, 1.25, 1.333, 1.5, 1.618 ratios)
- Define sizes from small (xs) to extra large (6xl)

**Example**:
```css
/* Fonts */
--font-sans: 'Inter', system-ui, sans-serif;
--font-serif: 'Merriweather', Georgia, serif;
--font-mono: 'Fira Code', monospace;

/* Type Scale (1.25 ratio) */
--text-xs: 0.64rem;    /* 10.24px */
--text-sm: 0.8rem;     /* 12.8px */
--text-base: 1rem;     /* 16px */
--text-lg: 1.25rem;    /* 20px */
--text-xl: 1.563rem;   /* 25px */
--text-2xl: 1.953rem;  /* 31.25px */
--text-3xl: 2.441rem;  /* 39px */
--text-4xl: 3.052rem;  /* 48.83px */

/* Weights */
--font-light: 300;
--font-normal: 400;
--font-medium: 500;
--font-semibold: 600;
--font-bold: 700;

/* Line Heights */
--leading-tight: 1.25;
--leading-normal: 1.5;
--leading-relaxed: 1.75;
```

#### Spacing System

Create consistent spacing scale:

**Base Unit**: Typically 4px or 8px
**Scale**: Multiply by 0.5, 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 20, 24, 32

**Example** (8px base):
```css
--space-0: 0;
--space-1: 0.5rem;  /* 8px */
--space-2: 1rem;    /* 16px */
--space-3: 1.5rem;  /* 24px */
--space-4: 2rem;    /* 32px */
--space-5: 2.5rem;  /* 40px */
--space-6: 3rem;    /* 48px */
--space-8: 4rem;    /* 64px */
--space-10: 5rem;   /* 80px */
```

#### Component System

Define all UI components with exact specifications. Each component must specify:

**For Each Component**:
- Visual states (default, hover, active, disabled, loading, error, empty)
- Exact dimensions (height, padding, border width)
- Exact colors (using design tokens)
- Border radius
- Shadow/elevation
- Typography (size, weight, line-height)
- Icons (size, position)
- Spacing (internal padding, external margins)
- Accessibility requirements

**Core Components to Define**:
- Button (primary, secondary, tertiary, danger, icon-only)
- Input (text, email, password, number, search)
- Select/Dropdown
- Checkbox
- Radio button
- Toggle/Switch
- Card
- Modal/Dialog
- Alert/Toast
- Badge
- Avatar
- Tooltip
- Navigation (header, sidebar, breadcrumbs)
- Table
- Pagination
- Tabs
- Accordion
- Progress indicator
- Empty state
- Loading skeleton

**Example Button Specification**:
```markdown
### Button Component

**Primary Button**:
- Height: 40px (--space-5)
- Padding: 12px 24px (--space-3 --space-6)
- Background: --color-primary-500
- Text: --text-base, --font-semibold, white
- Border: none
- Border-radius: 8px (--radius-md)
- Shadow: 0 1px 2px rgba(0,0,0,0.05)

**States**:
- Default: As above
- Hover: Background --color-primary-600, shadow 0 2px 4px rgba(0,0,0,0.1)
- Active: Background --color-primary-700, shadow inset 0 2px 4px rgba(0,0,0,0.1)
- Disabled: Background --color-neutral-200, text --color-neutral-400, cursor not-allowed
- Loading: Same as disabled, add spinner (16px, --color-neutral-400)

**Accessibility**:
- Min contrast ratio: 4.5:1 (text to background)
- Min touch target: 44x44px
- Focus state: 2px solid outline, --color-primary-500, 2px offset
- aria-disabled="true" for disabled state
- aria-busy="true" for loading state

**Icon Buttons**:
- Width/Height: 40px (square)
- Padding: 8px
- Icon size: 24px
- Center icon horizontally and vertically
```

#### Visual Effects

**Border Radius**:
```css
--radius-sm: 4px;
--radius-md: 8px;
--radius-lg: 12px;
--radius-xl: 16px;
--radius-full: 9999px;
```

**Shadows/Elevation**:
```css
--shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
--shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
--shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
--shadow-xl: 0 20px 25px rgba(0, 0, 0, 0.15);
```

**Transitions**:
```css
--transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1);
--transition-base: 250ms cubic-bezier(0.4, 0, 0.2, 1);
--transition-slow: 350ms cubic-bezier(0.4, 0, 0.2, 1);
```

See design system creation reference for comprehensive guidance.

**Output**: `docs/design/design-system.md`

### 4. Design User Flows and Wireframes

For each critical user journey:

**Create Wireframes**:
- Low-fidelity sketches of key screens
- Focus on layout and information hierarchy
- Show navigation paths
- Indicate interactive elements

**Define Screen States**:
- Loading state
- Empty state
- Error state
- Success state
- Partial data state

**Map Interactions**:
- Click/tap targets
- Hover states
- Transitions between screens
- Scroll behavior
- Form validation feedback

**Output**: `docs/design/wireframes.md` (or use design tool exports)

### 5. Apply Cognitive Load Principles

Reduce cognitive burden through:

**Information Hierarchy**:
- Primary, secondary, tertiary information levels
- Visual weight (size, color, position)
- F-pattern or Z-pattern layout

**Gestalt Principles**:
- Proximity: Group related items
- Similarity: Use consistent styling for similar elements
- Closure: Imply boundaries without explicit lines
- Continuity: Guide eye flow with alignment
- Figure-ground: Clear foreground/background separation

**Progressive Disclosure**:
- Show essential information first
- Reveal details on interaction
- Use accordions, tabs, modals for secondary content

**Consistency**:
- Consistent component usage
- Consistent terminology
- Consistent interaction patterns
- Consistent layout structure

See cognitive load principles reference.

**Output**: `docs/design/ux-principles.md`

### 6. Ensure Accessibility (WCAG 2.1 AA)

**Color Contrast**:
- Text: Minimum 4.5:1 contrast ratio (3:1 for large text)
- UI components: Minimum 3:1 contrast ratio
- Test all color combinations
- Don't rely on color alone to convey information

**Keyboard Navigation**:
- All interactive elements keyboard accessible
- Logical tab order
- Visible focus indicators
- Skip links for navigation

**Screen Reader Support**:
- Semantic HTML
- ARIA labels where needed
- Alt text for images
- Form labels and error messages

**Responsive Touch Targets**:
- Minimum 44x44px touch targets
- Adequate spacing between clickable elements

**Motion and Animation**:
- Respect prefers-reduced-motion
- Avoid auto-playing videos
- Provide pause/stop controls

See accessibility checklist reference.

**Output**: `docs/design/accessibility.md`

### 7. Define Responsive Behavior

**Breakpoints**:
```css
--screen-sm: 640px;   /* Mobile landscape */
--screen-md: 768px;   /* Tablet */
--screen-lg: 1024px;  /* Desktop */
--screen-xl: 1280px;  /* Large desktop */
--screen-2xl: 1536px; /* Extra large */
```

**Responsive Strategy**:
- Mobile-first design
- Fluid typography (clamp() or viewport units)
- Flexible layouts (flexbox, grid)
- Adaptive component behavior
- Image optimization (srcset, responsive images)

**Per-Component Responsiveness**:
Document how each component adapts across breakpoints.

See responsive patterns reference.

**Output**: Part of `docs/design/design-system.md`

### 8. Document Micro-interactions and Motion

**Hover Effects**:
- Color changes
- Scale transforms
- Shadow elevation

**Click/Tap Feedback**:
- Active state visual change
- Ripple effects (if appropriate for brand)

**Transitions**:
- Page transitions
- Modal open/close
- Dropdown expand/collapse
- Loading states

**Animation Principles**:
- Use easing functions (not linear)
- Keep duration short (150-350ms)
- Purposeful, not decorative
- Respect reduced motion preference

**Output**: `docs/design/motion-guidelines.md`

### 9. Validation Checklist

Before completing UX/UI design:

- [ ] Design system is completely unique to this project (not generic)
- [ ] All colors tested for WCAG AA contrast ratios
- [ ] Typography scale is harmonious and purposeful
- [ ] All components have all states defined (default, hover, active, disabled, loading, error)
- [ ] Exact dimensions, colors, and spacing specified for developer implementation
- [ ] Responsive behavior documented for all breakpoints
- [ ] Accessibility requirements documented for all components
- [ ] User flows cover all critical journeys
- [ ] Empty states, error states, loading states designed
- [ ] Motion and animation guidelines provided
- [ ] Design reflects brand personality and user needs

## Output Files

- `docs/design/brand-direction.md` - Brand personality and visual mood
- `docs/design/design-system.md` - Complete design system specification
- `docs/design/wireframes.md` - Wireframes and screen designs
- `docs/design/ux-principles.md` - UX principles and cognitive load considerations
- `docs/design/accessibility.md` - Accessibility requirements and guidelines
- `docs/design/motion-guidelines.md` - Animation and micro-interaction specifications

## References

- [Design System Creation](./references/design-system-creation.md)
- [Accessibility Checklist](./references/accessibility-checklist.md)
- [Cognitive Load Principles](./references/cognitive-load-principles.md)
- [Responsive Patterns](./references/responsive-patterns.md)
