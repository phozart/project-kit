# Cognitive Load Principles

Principles and patterns for reducing cognitive load in user interfaces.

## What is Cognitive Load?

Cognitive load is the amount of mental effort required to use an interface. High cognitive load leads to:
- User frustration and fatigue
- Errors and mistakes
- Abandonment
- Poor user experience

**Goal**: Minimize cognitive load while maintaining functionality.

## Types of Cognitive Load

### 1. Intrinsic Load
Complexity inherent to the task itself.

**Cannot eliminate, but can:**
- Break complex tasks into smaller steps
- Provide progressive disclosure
- Use familiar patterns
- Add helpful defaults

### 2. Extraneous Load
Unnecessary complexity from poor design.

**Can and should eliminate:**
- Remove visual clutter
- Simplify language
- Reduce choices
- Improve information hierarchy

### 3. Germane Load
Mental effort that helps learning and understanding.

**Should encourage:**
- Clear feedback
- Helpful error messages
- Contextual help
- Progressive feature discovery

## Gestalt Principles

Visual perception principles that reduce cognitive effort.

### Proximity

**Principle**: Items close together are perceived as related.

**Application**:
- Group related form fields
- Place labels next to inputs
- Space sections clearly
- Use whitespace to create groups

**Example**:
```
BAD:
[First Name]
[Email]
[Last Name]
[Phone]

GOOD:
[First Name] [Last Name]

[Email]
[Phone]
```

### Similarity

**Principle**: Similar items are perceived as related or grouped.

**Application**:
- Use consistent styling for similar elements
- Button hierarchy (primary, secondary, tertiary)
- Color coding for categories
- Icon consistency

**Example**:
- All primary CTAs same color/style
- All delete actions same color (red)
- All admin functions same icon style

### Closure

**Principle**: Mind fills in gaps to perceive complete shapes.

**Application**:
- Don't over-explain (users infer meaning)
- Use dotted lines for implied connections
- Card outlines can be subtle (shadow instead of border)
- Loading skeletons show structure

### Continuity

**Principle**: Eyes follow lines and curves.

**Application**:
- Align elements to create visual flow
- Use grid systems
- Align form fields vertically
- Use lines/arrows to guide attention

### Figure-Ground

**Principle**: Objects distinguished from background.

**Application**:
- Modal overlays with dimmed background
- Clear contrast between content and background
- Focused element stands out
- Hierarchy through visual weight

## Information Hierarchy

### Visual Hierarchy Techniques

**Size**:
- Larger = more important
- Headings larger than body text
- Primary button larger than secondary

**Color**:
- High contrast = more attention
- Saturated colors draw eye
- Muted colors recede

**Position**:
- Top and left = seen first (F-pattern)
- Center = focal point
- Bottom = less important

**Weight**:
- Bold = emphasis
- Light = supporting information

**Spacing**:
- More whitespace = more important
- Crowded = less important

### F-Pattern and Z-Pattern

**F-Pattern** (text-heavy content):
```
█████████
███
█████
██
```
- Users scan top
- Then left edge
- Horizontal scans decrease down page

**Design for F-Pattern**:
- Important info at top and left
- Front-load headings with keywords
- Use lists for scannability

**Z-Pattern** (simple pages):
```
█████████
    ███
   ███
  ███
 ████████
```
- Top left to top right
- Diagonal to bottom left
- Bottom left to bottom right

**Design for Z-Pattern**:
- Logo top-left
- CTA top-right
- Value prop in middle
- Secondary CTA bottom-right

## Progressive Disclosure

**Principle**: Show only what's necessary, reveal more as needed.

### Techniques

**1. Accordions**
```
▼ Section 1 (expanded)
  Details of section 1...

▶ Section 2 (collapsed)
▶ Section 3 (collapsed)
```

**Use for**:
- FAQs
- Long forms (wizard steps)
- Settings panels
- Documentation

**2. Tabs**
```
[Active Tab] [Tab 2] [Tab 3]
─────────────────────────────
Content of active tab...
```

**Use for**:
- Related content (Overview, Details, History)
- User profiles (Posts, About, Photos)
- Settings categories

**3. "Show More" Links**
```
Preview of content (first 3 lines)...

[Show more]
```

**Use for**:
- Long descriptions
- Comments
- Activity feeds

**4. Modals/Drawers**
```
[Button] → Opens modal with details
```

**Use for**:
- Advanced options
- Help/documentation
- Detailed forms

**5. Tooltips/Popovers**
```
Label [ⓘ] ← Hover/click for explanation
```

**Use for**:
- Field help text
- Icon explanations
- Inline definitions

### Guidelines

- [ ] Show essential information by default
- [ ] Make it obvious how to reveal more
- [ ] Don't hide critical information
- [ ] Maintain context when revealing content
- [ ] Allow users to collapse expanded sections

## Choice Architecture

### Hick's Law

**Principle**: Decision time increases with number of options.

**Application**:
- Limit choices (5-7 max when possible)
- Categorize large option sets
- Provide sensible defaults
- Use progressive disclosure for advanced options

**Example**:
```
BAD: 50 countries in dropdown (no grouping)
GOOD: Common countries at top, rest alphabetically or by region
```

### Default Values

**Benefits**:
- Reduce decisions
- Guide users to best choice
- Speed up task completion

**Guidelines**:
- Use most common choice
- Use safest choice
- Make defaults visible and changeable
- Explain why default is recommended

**Example**:
```html
<select>
  <option value="usd" selected>USD (most common)</option>
  <option value="eur">EUR</option>
  <option value="gbp">GBP</option>
</select>
```

### Choice Presentation

**Fewer is better**:
```
BAD:  25 filter options visible
GOOD: 5 common filters, "More filters" button
```

**Organized is better**:
```
BAD:  Flat list of 50 categories
GOOD: 5 parent categories → subcategories
```

**Guided is better**:
```
BAD:  "Choose your plan" (no guidance)
GOOD: "Most popular" badge, "Recommended for you" highlight
```

## Consistency

### Types of Consistency

**Visual Consistency**:
- Same components look the same everywhere
- Consistent spacing and alignment
- Consistent colors and typography
- Consistent iconography

**Functional Consistency**:
- Same actions work the same way everywhere
- Same gestures/keyboard shortcuts
- Consistent navigation structure
- Consistent terminology

**Internal Consistency**:
- Within your product

**External Consistency**:
- With user expectations from other products
- Platform conventions (iOS, Android, Web)

### Benefits

- Reduced learning curve
- Faster task completion
- Fewer errors
- Transferable knowledge

### Examples

**Consistent Terminology**:
```
BAD:  "Delete" on one screen, "Remove" on another
GOOD: Always "Delete" for permanent removal
```

**Consistent Actions**:
```
BAD:  Click to expand in some places, hover in others
GOOD: Always click to expand
```

**Consistent Positioning**:
```
BAD:  Save button top-right sometimes, bottom-left other times
GOOD: Primary action always bottom-right of form
```

## Chunking

**Principle**: Group related information into meaningful chunks.

### Working Memory Limit

**Miller's Law**: People can hold 7±2 items in working memory.

**Application**:
- Group phone numbers: (555) 123-4567 not 5551234567
- Group credit cards: 1234 5678 9012 3456 not 1234567890123456
- Limit menu items to 5-7 per category
- Break long forms into sections

### Visual Chunking

**Form Example**:
```
Personal Information
├─ First Name
├─ Last Name
└─ Date of Birth

Contact Information
├─ Email
├─ Phone
└─ Address

Preferences
├─ Language
└─ Timezone
```

**Navigation Example**:
```
Account
├─ Profile
├─ Settings
└─ Billing

Content
├─ Projects
├─ Files
└─ Shared

Admin
├─ Users
└─ Permissions
```

## Reducing Extraneous Load

### Simplify Language

**Before**: "Initiate the authentication process to access your personalized dashboard"
**After**: "Log in to see your dashboard"

**Guidelines**:
- Use common words, not jargon
- Active voice, not passive
- Short sentences
- Second person ("you", not "the user")
- Avoid technical terms when possible

### Remove Visual Clutter

**Techniques**:
- **Whitespace**: Give elements room to breathe
- **Alignment**: Create visual order
- **Contrast**: Highlight what matters
- **Simplicity**: Remove decorative elements

**Example**:
```
BAD:  Heavy borders, background colors, shadows, gradients all at once
GOOD: Subtle borders OR shadows, clean backgrounds, strategic color
```

### Reduce Required Fields

**Only ask for essential information**:
```
BAD:  Name, Email, Phone, Address, Company, Title, Website (all required)
GOOD: Email, Password (required), Name (optional for personalization)
```

**Defer optional information**:
- Collect during onboarding if needed
- Allow users to add later in settings
- Progressive profiling (ask over time)

### Smart Defaults

**Auto-fill when possible**:
- Detect timezone
- Detect language
- Detect location (with permission)
- Remember previous choices

**Example**:
```javascript
// Pre-fill country based on IP (with override option)
const detectedCountry = detectCountryFromIP();
// Pre-select in dropdown but allow change
```

## Feedback and Confirmation

### Immediate Feedback

**Every action should have feedback**:
- Button click → visual state change
- Form submit → loading state
- Save → success message
- Error → error message with solution

**Loading States**:
```
BAD:  No indication of progress
GOOD: Spinner, progress bar, or skeleton screen
```

### Clear Error Messages

**Structure**:
1. What went wrong
2. Why it went wrong (if helpful)
3. How to fix it

**Examples**:
```
BAD:  "Error 422"
GOOD: "Email address is invalid. Please check the format."

BAD:  "Password incorrect"
GOOD: "Password incorrect. Try again or reset your password."
```

### Confirmation for Destructive Actions

**Always confirm**:
- Delete
- Permanent changes
- Irreversible actions

**Example**:
```
[Delete Project] button clicked

Modal appears:
"Delete 'Project Name'?
This will permanently delete the project and all its tasks.
This cannot be undone.

[Cancel] [Delete Project]"
```

## Testing for Cognitive Load

### Usability Testing

**Observe**:
- Time to complete tasks
- Number of errors
- Hesitation or confusion
- Questions asked

**Ask**:
- "What are you thinking?"
- "What do you expect to happen?"
- "Is anything confusing?"

### Metrics

- **Time on task**: Lower is better (for known tasks)
- **Error rate**: Lower is better
- **Completion rate**: Higher is better
- **Satisfaction score**: Higher is better

### Self-Assessment

**Ask yourself**:
- Can a new user complete the main task without help?
- Can I explain the interface in one sentence?
- Could I remove any element without loss of function?
- Is the most important action obvious?
- Does every element serve a purpose?

## Quick Wins

### Immediate Improvements

1. **Remove one thing** - Find something to delete from every screen
2. **Add whitespace** - Increase spacing between sections
3. **Simplify language** - Rewrite one confusing label/message
4. **Reduce choices** - Hide advanced options behind "More"
5. **Add feedback** - Show loading state for slow operations
6. **Fix one inconsistency** - Make one element match the pattern
7. **Improve one error message** - Make it specific and actionable

## Resources

- "Don't Make Me Think" by Steve Krug
- "The Design of Everyday Things" by Don Norman
- "100 Things Every Designer Needs to Know About People" by Susan Weinschenk
