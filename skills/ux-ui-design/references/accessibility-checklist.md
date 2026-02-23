# Accessibility Checklist (WCAG 2.1 AA)

Comprehensive checklist for ensuring WCAG 2.1 Level AA compliance.

## Perceivable

### 1.1 Text Alternatives

- [ ] All images have alt text
- [ ] Decorative images use empty alt="" or aria-hidden="true"
- [ ] Complex images (charts, diagrams) have detailed descriptions
- [ ] Icons have accessible labels (aria-label or visually hidden text)
- [ ] Form inputs have associated labels

### 1.2 Time-based Media

- [ ] Video content has captions
- [ ] Audio content has transcripts
- [ ] Video content has audio descriptions (if needed for context)
- [ ] Auto-playing media has controls to pause/stop

### 1.3 Adaptable

- [ ] Semantic HTML used (header, nav, main, article, aside, footer)
- [ ] Heading hierarchy is logical (h1, h2, h3 - no skipping levels)
- [ ] Lists use proper markup (ul, ol, li)
- [ ] Tables use proper structure (thead, tbody, th with scope)
- [ ] Form fields use proper input types (email, tel, number, date)
- [ ] Content order makes sense when CSS is disabled
- [ ] Landmark regions identified (ARIA roles if needed)

### 1.4 Distinguishable

#### Color Contrast

- [ ] Normal text (under 18pt): 4.5:1 contrast ratio minimum
- [ ] Large text (18pt+ or 14pt+ bold): 3:1 contrast ratio minimum
- [ ] UI components and graphics: 3:1 contrast ratio minimum
- [ ] Focus indicators: 3:1 contrast with adjacent colors
- [ ] Test all color combinations (text on backgrounds, buttons, links)

**Testing Tools**:
- Chrome DevTools Accessibility Inspector
- WebAIM Contrast Checker
- Stark plugin for Figma

#### Color Usage

- [ ] Color is not the only means of conveying information
- [ ] Links distinguishable from text (underline or other indicator)
- [ ] Form validation errors indicated by more than just red color
- [ ] Charts use patterns/labels in addition to color

#### Text

- [ ] Text can be resized to 200% without loss of content or functionality
- [ ] Text spacing can be adjusted without breaking layout
- [ ] Line height at least 1.5x font size for body text
- [ ] Paragraph spacing at least 2x font size
- [ ] No images of text (except logos)

#### Audio Control

- [ ] Background audio can be paused or muted
- [ ] Audio does not auto-play for more than 3 seconds

## Operable

### 2.1 Keyboard Accessible

- [ ] All functionality available via keyboard
- [ ] No keyboard traps (can tab in AND out of all elements)
- [ ] Logical tab order matches visual order
- [ ] Skip links provided to bypass repetitive content
- [ ] Keyboard shortcuts don't conflict with assistive technology
- [ ] Custom interactive components have keyboard support

**Keyboard Patterns**:
- Tab: Move forward through focusable elements
- Shift+Tab: Move backward
- Enter/Space: Activate buttons, links
- Arrow keys: Navigate within components (menus, radio groups, tabs)
- Escape: Close modals, dropdowns

### 2.2 Enough Time

- [ ] No time limits, or user can extend/turn off time limits
- [ ] Auto-updating content can be paused/hidden
- [ ] Session timeouts have warnings with option to extend
- [ ] Timeout warnings give at least 20 seconds to respond

### 2.3 Seizures and Physical Reactions

- [ ] No content flashes more than 3 times per second
- [ ] Parallax scrolling can be disabled
- [ ] Animation respects prefers-reduced-motion

### 2.4 Navigable

- [ ] Every page has a unique, descriptive title
- [ ] Focus order is logical and predictable
- [ ] Link purpose is clear from link text or context
- [ ] Multiple ways to find pages (menu, search, sitemap)
- [ ] Headings and labels are descriptive
- [ ] Focus indicator is visible (2px minimum)
- [ ] Current page indicated in navigation

### 2.5 Input Modalities

- [ ] Touch targets are at least 44x44 CSS pixels
- [ ] Adequate spacing between touch targets (8px minimum)
- [ ] Pointer gestures have keyboard/single-pointer alternatives
- [ ] Drag-and-drop has keyboard alternative
- [ ] Motion actuation (shake, tilt) has alternative input

## Understandable

### 3.1 Readable

- [ ] Page language is specified (lang="en")
- [ ] Language changes within page are marked (lang attribute)
- [ ] Avoid unusual words or provide definitions
- [ ] Abbreviations and acronyms expanded on first use
- [ ] Reading level appropriate for audience

### 3.2 Predictable

- [ ] Navigation is consistent across pages
- [ ] Components behave consistently
- [ ] Focus doesn't trigger unexpected context changes
- [ ] Input doesn't trigger automatic submission
- [ ] Changes that affect context are user-initiated or warned

### 3.3 Input Assistance

#### Forms

- [ ] Form fields have visible, persistent labels
- [ ] Labels are programmatically associated with inputs
- [ ] Required fields are indicated (not just by color)
- [ ] Input purpose identified (autocomplete attributes)
- [ ] Error messages are clear and specific
- [ ] Error messages suggest how to fix
- [ ] Errors announced to screen readers
- [ ] Form validation happens at appropriate time (not every keystroke)
- [ ] Success messages confirmed
- [ ] Sensitive data can be reviewed before submission

#### Error Prevention

- [ ] Destructive actions can be reversed or require confirmation
- [ ] Data entry can be reviewed and corrected before submission
- [ ] Mistakes can be easily corrected

## Robust

### 4.1 Compatible

- [ ] Valid HTML (no parsing errors that affect assistive tech)
- [ ] Unique IDs for elements (no duplicate id attributes)
- [ ] ARIA used correctly (roles, states, properties)
- [ ] Name, role, value available for all UI components
- [ ] Status messages use appropriate ARIA roles (alert, status, log)

## ARIA Best Practices

### Use Semantic HTML First

- [ ] Use button instead of div with role="button"
- [ ] Use native form controls when possible
- [ ] Only use ARIA when HTML can't express semantics

### Common ARIA Attributes

**Landmarks**:
```html
<header role="banner">
<nav role="navigation" aria-label="Main">
<main role="main">
<aside role="complementary">
<footer role="contentinfo">
```

**Live Regions**:
```html
<div role="alert">Error message</div>
<div role="status">Loading...</div>
<div aria-live="polite">Dynamic content</div>
```

**Form Fields**:
```html
<input aria-label="Search" />
<input aria-describedby="help-text" />
<input aria-required="true" />
<input aria-invalid="true" />
```

**States**:
```html
<button aria-expanded="true">Menu</button>
<button aria-pressed="true">Bold</button>
<div aria-hidden="true">Not for screen readers</div>
```

**Relationships**:
```html
<input aria-labelledby="label-id" />
<input aria-describedby="description-id" />
<div aria-controls="panel-id">
```

## Component-Specific Guidelines

### Buttons

- [ ] Use button element (not div or span)
- [ ] Clear, descriptive text
- [ ] Icon-only buttons have aria-label
- [ ] Disabled buttons have aria-disabled="true"
- [ ] Loading buttons have aria-busy="true"

### Links

- [ ] Use a element with href
- [ ] Link text describes destination
- [ ] External links indicated (icon + aria-label)
- [ ] Links that open new windows/tabs warned

### Modals/Dialogs

- [ ] Focus moves to modal on open
- [ ] Focus trapped within modal while open
- [ ] Escape key closes modal
- [ ] Focus returns to trigger element on close
- [ ] Background content inert (aria-hidden="true" or inert attribute)
- [ ] role="dialog" or role="alertdialog"
- [ ] aria-labelledby points to modal title
- [ ] aria-describedby points to modal description

### Dropdown Menus

- [ ] Button has aria-expanded (true/false)
- [ ] Arrow keys navigate menu items
- [ ] Escape closes menu
- [ ] Focus management (to first item on open, back to button on close)
- [ ] role="menu" for menu container
- [ ] role="menuitem" for items

### Tabs

- [ ] role="tablist" for container
- [ ] role="tab" for each tab
- [ ] role="tabpanel" for each panel
- [ ] aria-selected on active tab
- [ ] aria-controls links tab to panel
- [ ] Arrow keys navigate between tabs
- [ ] Tab key moves to panel content

### Forms

- [ ] Label element associated with input (for or wrapping)
- [ ] Error messages announced to screen readers
- [ ] aria-invalid="true" on fields with errors
- [ ] aria-describedby links field to error message
- [ ] Required fields have aria-required="true" or required attribute
- [ ] Group related fields (fieldset and legend)

### Tables

- [ ] Use table, thead, tbody, th, td elements
- [ ] Headers have scope="col" or scope="row"
- [ ] Complex tables use aria-describedby for summary
- [ ] Sortable columns indicate sort direction

### Images

- [ ] Informative images: descriptive alt text
- [ ] Decorative images: alt="" or aria-hidden="true"
- [ ] Complex images: alt + longdesc or aria-describedby
- [ ] Icon fonts: aria-hidden="true" with text alternative nearby

### Loading States

- [ ] Loading indicators announced to screen readers
- [ ] Use aria-live="polite" or role="status"
- [ ] Don't announce every state change (debounce updates)

## Testing Checklist

### Automated Testing

- [ ] Run axe DevTools or Lighthouse accessibility audit
- [ ] Fix all critical and serious issues
- [ ] Review moderate issues

### Manual Testing

- [ ] Test with keyboard only (unplug mouse)
- [ ] Test with screen reader (NVDA, JAWS, VoiceOver)
- [ ] Test at 200% zoom
- [ ] Test with Windows High Contrast mode
- [ ] Test with color blindness simulator
- [ ] Test with prefers-reduced-motion enabled

### Screen Reader Testing

**Windows**: NVDA (free), JAWS (paid)
**Mac**: VoiceOver (built-in)
**Mobile**: TalkBack (Android), VoiceOver (iOS)

**Test**:
- [ ] All content announced
- [ ] Navigation landmarks work
- [ ] Forms are usable
- [ ] Dynamic content updates announced
- [ ] Buttons and links clearly identified

## Common Mistakes to Avoid

1. **Placeholder as label**: Placeholders are not labels
2. **Div/span buttons**: Use button element
3. **Click handlers on non-interactive elements**: Use buttons/links
4. **Opening links in new tab without warning**: Add (opens in new tab) to link text
5. **Color-only indicators**: Add text or icons
6. **Auto-playing content**: Provide pause control
7. **Infinite scroll only**: Provide alternative pagination
8. **Icon-only buttons without labels**: Add aria-label
9. **Form without labels**: Every input needs a label
10. **Keyboard trap**: Ensure users can navigate out

## Resources

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WebAIM](https://webaim.org/)
- [A11y Project](https://www.a11yproject.com/)
- [MDN Accessibility](https://developer.mozilla.org/en-US/docs/Web/Accessibility)
- [Inclusive Components](https://inclusive-components.design/)
