# Responsive Design Patterns

Patterns and best practices for responsive user interfaces.

## Mobile-First Approach

**Philosophy**: Design for smallest screen first, enhance for larger screens.

**Benefits**:
- Forces prioritization of content
- Ensures core functionality on all devices
- Easier to scale up than scale down
- Better performance (progressive enhancement)

**CSS Structure**:
```css
/* Base styles (mobile) */
.container {
  padding: 1rem;
}

/* Tablet and up */
@media (min-width: 768px) {
  .container {
    padding: 2rem;
  }
}

/* Desktop and up */
@media (min-width: 1024px) {
  .container {
    padding: 3rem;
    max-width: 1200px;
    margin: 0 auto;
  }
}
```

## Breakpoint Strategy

### Common Breakpoints

```css
/* Phones (portrait) */
--screen-xs: 0px;

/* Phones (landscape) / Small tablets */
--screen-sm: 640px;

/* Tablets */
--screen-md: 768px;

/* Laptops / Small desktops */
--screen-lg: 1024px;

/* Desktops */
--screen-xl: 1280px;

/* Large desktops */
--screen-2xl: 1536px;
```

### Content-Based Breakpoints

**Better approach**: Add breakpoints where content breaks, not at arbitrary device sizes.

**Example**:
```css
/* Base styles */
.navigation {
  /* Vertical menu */
}

/* When space allows horizontal menu (may not align with standard breakpoints) */
@media (min-width: 850px) {
  .navigation {
    /* Horizontal menu */
  }
}
```

### Avoid Too Many Breakpoints

**Guideline**: 3-5 breakpoints is usually sufficient.
- Mobile (320-639px)
- Tablet (640-1023px)
- Desktop (1024px+)
- Optional: Large desktop (1536px+) for very wide screens

## Layout Patterns

### 1. Column Drop

**Behavior**: Columns stack vertically on small screens, arrange horizontally on larger screens.

```css
/* Mobile: stacked */
.column {
  width: 100%;
}

/* Tablet: 2 columns */
@media (min-width: 768px) {
  .column {
    width: 50%;
    float: left;
  }
}

/* Desktop: 3 columns */
@media (min-width: 1024px) {
  .column {
    width: 33.333%;
  }
}
```

**Use for**: Card grids, product listings, feature sections

### 2. Mostly Fluid

**Behavior**: Grid becomes fixed-width at large sizes instead of scaling infinitely.

```css
.container {
  width: 100%;
  padding: 1rem;
}

@media (min-width: 1024px) {
  .container {
    max-width: 1200px;
    margin: 0 auto;
  }
}
```

**Use for**: Content-heavy pages, blogs, documentation

### 3. Layout Shifter

**Behavior**: Layout changes significantly at different breakpoints.

**Example**:
- Mobile: Single column, stacked content
- Tablet: Sidebar + main content
- Desktop: Sidebar + main + right rail

```css
/* Mobile: stack */
.sidebar, .main, .rail {
  width: 100%;
}

/* Tablet: sidebar + main */
@media (min-width: 768px) {
  .sidebar {
    width: 30%;
    float: left;
  }
  .main {
    width: 70%;
    float: left;
  }
  .rail {
    width: 100%;
    clear: both;
  }
}

/* Desktop: three columns */
@media (min-width: 1024px) {
  .sidebar { width: 20%; }
  .main { width: 60%; }
  .rail { width: 20%; clear: none; }
}
```

**Use for**: Dashboards, complex apps

### 4. Off Canvas

**Behavior**: Navigation/sidebar off-screen on mobile, slides in when activated.

```css
/* Mobile: off-screen */
.sidebar {
  position: fixed;
  left: -250px;
  width: 250px;
  transition: left 0.3s;
}

.sidebar.open {
  left: 0;
}

/* Desktop: always visible */
@media (min-width: 1024px) {
  .sidebar {
    position: static;
    left: auto;
  }
}
```

**Use for**: Navigation menus, filters, settings panels

## Typography Responsiveness

### Fluid Typography

**Using clamp()**:
```css
h1 {
  font-size: clamp(2rem, 5vw, 4rem);
  /* min: 2rem (32px)
     preferred: 5% of viewport width
     max: 4rem (64px) */
}

body {
  font-size: clamp(1rem, 2vw, 1.25rem);
}
```

**Benefits**:
- Smooth scaling between breakpoints
- No jarring jumps
- Fewer media queries

### Breakpoint-Based Typography

```css
h1 {
  font-size: 2rem;      /* 32px mobile */
  line-height: 1.2;
}

@media (min-width: 768px) {
  h1 {
    font-size: 3rem;    /* 48px tablet */
  }
}

@media (min-width: 1024px) {
  h1 {
    font-size: 4rem;    /* 64px desktop */
  }
}
```

### Line Length

**Optimal**: 50-75 characters per line for readability.

```css
.content {
  max-width: 65ch; /* ch = character width of "0" */
  margin: 0 auto;
}
```

## Component Adaptations

### Navigation

**Mobile**:
- Hamburger menu
- Full-screen overlay or slide-in drawer
- Stacked vertical links

**Desktop**:
- Horizontal menu bar
- Dropdowns for sub-navigation
- Always visible

**Example**:
```css
/* Mobile: hamburger */
.nav-toggle {
  display: block;
}

.nav-menu {
  display: none;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.nav-menu.open {
  display: block;
}

/* Desktop: horizontal menu */
@media (min-width: 1024px) {
  .nav-toggle {
    display: none;
  }

  .nav-menu {
    display: flex;
    position: static;
    width: auto;
    height: auto;
  }
}
```

### Tables

**Mobile**: Card-based layout
**Desktop**: Traditional table

```css
/* Mobile: stack table as cards */
@media (max-width: 767px) {
  table, thead, tbody, th, td, tr {
    display: block;
  }

  thead {
    display: none; /* Hide header */
  }

  tr {
    margin-bottom: 1rem;
    border: 1px solid #ddd;
  }

  td {
    text-align: right;
    padding-left: 50%;
    position: relative;
  }

  td:before {
    content: attr(data-label);
    position: absolute;
    left: 0;
    width: 45%;
    padding-left: 1rem;
    font-weight: bold;
    text-align: left;
  }
}

/* Desktop: traditional table */
@media (min-width: 768px) {
  table {
    display: table;
  }
}
```

**HTML**:
```html
<td data-label="Name">John Doe</td>
<td data-label="Email">john@example.com</td>
```

### Forms

**Mobile**:
- Full-width inputs
- Stacked labels above inputs
- Large touch targets (44px min)
- Input type optimized keyboards (email, tel, number)

**Desktop**:
- Multi-column layouts
- Inline labels (if appropriate)
- Smaller inputs (but still comfortable)

```css
/* Mobile: full width */
.form-group {
  margin-bottom: 1rem;
}

.form-label {
  display: block;
  margin-bottom: 0.5rem;
}

.form-input {
  width: 100%;
  height: 44px; /* Touch-friendly */
  font-size: 16px; /* Prevent zoom on iOS */
}

/* Desktop: two-column layout */
@media (min-width: 768px) {
  .form-row {
    display: flex;
    gap: 1rem;
  }

  .form-group {
    flex: 1;
  }

  .form-input {
    height: 40px;
  }
}
```

### Modals

**Mobile**:
- Full-screen or nearly full-screen
- Slide up from bottom

**Desktop**:
- Centered overlay
- Max-width (600-800px)

```css
/* Mobile: full screen */
.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: white;
  overflow-y: auto;
}

/* Desktop: centered overlay */
@media (min-width: 768px) {
  .modal {
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 90%;
    max-width: 600px;
    height: auto;
    max-height: 90vh;
    border-radius: 8px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.3);
  }
}
```

### Images

**Responsive Images**:
```html
<!-- Srcset for different sizes -->
<img
  src="image-800.jpg"
  srcset="image-400.jpg 400w,
          image-800.jpg 800w,
          image-1200.jpg 1200w"
  sizes="(max-width: 640px) 100vw,
         (max-width: 1024px) 50vw,
         33vw"
  alt="Description"
>

<!-- Picture for art direction -->
<picture>
  <source media="(min-width: 1024px)" srcset="hero-desktop.jpg">
  <source media="(min-width: 768px)" srcset="hero-tablet.jpg">
  <img src="hero-mobile.jpg" alt="Hero">
</picture>
```

**CSS Background Images**:
```css
.hero {
  background-image: url('hero-mobile.jpg');
}

@media (min-width: 768px) {
  .hero {
    background-image: url('hero-tablet.jpg');
  }
}

@media (min-width: 1024px) {
  .hero {
    background-image: url('hero-desktop.jpg');
  }
}
```

## Touch vs. Mouse Interactions

### Touch Targets

**Minimum size**: 44x44 CSS pixels (Apple) or 48x48 CSS pixels (Android)

```css
.button {
  min-height: 44px;
  min-width: 44px;
  padding: 12px 24px;
}

/* Increase spacing on mobile */
@media (max-width: 767px) {
  .button {
    margin: 0.5rem 0;
  }
}
```

### Hover States

**Problem**: Touch devices don't have hover.

**Solutions**:

1. **Make hover states informative, not essential**:
```css
/* Bad: essential info only on hover */
.card:hover .hidden-info {
  display: block; /* Touch users can't see */
}

/* Good: show on tap/click */
.card.active .additional-info {
  display: block;
}
```

2. **Use @media (hover)**:
```css
/* Only apply hover on devices with hover capability */
@media (hover: hover) {
  .button:hover {
    background-color: #0056b3;
  }
}

/* Touch feedback for all devices */
.button:active {
  background-color: #004085;
}
```

### Gestures

**Avoid**:
- Swipe (conflicts with browser navigation)
- Long press (conflicts with context menus)
- Multi-touch (complex)

**Safe**:
- Tap/click
- Scroll
- Simple drag (with keyboard alternative)

## Performance Considerations

### Lazy Loading

```html
<!-- Native lazy loading -->
<img src="image.jpg" loading="lazy" alt="Description">

<!-- Intersection Observer for more control -->
<img data-src="image.jpg" class="lazy" alt="Description">
```

### Conditional Loading

```javascript
// Load heavy components only on larger screens
if (window.matchMedia('(min-width: 1024px)').matches) {
  import('./DesktopOnlyFeature.js');
}
```

### Reduce Animations on Mobile

```css
/* Full animations on desktop */
@media (min-width: 1024px) {
  .card {
    transition: transform 0.3s, box-shadow 0.3s;
  }

  .card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 16px rgba(0,0,0,0.1);
  }
}

/* Simpler on mobile */
@media (max-width: 1023px) {
  .card:active {
    opacity: 0.8;
  }
}
```

## Testing Responsive Design

### Browser DevTools

1. Toggle device toolbar (Chrome/Firefox)
2. Test at common breakpoints
3. Test in-between sizes (don't just test at exact breakpoints)
4. Test landscape orientation
5. Throttle network to simulate mobile

### Real Devices

**Test on**:
- Small phone (iPhone SE, small Android)
- Large phone (iPhone Pro Max, large Android)
- Tablet (iPad, Android tablet)
- Desktop (various screen sizes)

### Responsive Design Checklist

- [ ] Layouts adapt at all breakpoints
- [ ] Text is readable (min 16px on mobile)
- [ ] Touch targets are 44px+ on mobile
- [ ] Images are responsive and optimized
- [ ] Navigation is usable on mobile
- [ ] Forms are mobile-friendly
- [ ] Tables are readable/usable on mobile
- [ ] No horizontal scrolling
- [ ] Content is prioritized on small screens
- [ ] Performance is good on mobile networks

## Common Mistakes

1. **Desktop-first design**: Hard to strip down for mobile
2. **Too many breakpoints**: Maintenance nightmare
3. **Fixed widths**: Use max-width, not width
4. **Ignoring landscape**: Test both orientations
5. **Tiny touch targets**: Make them bigger on mobile
6. **Hiding too much content**: Mobile users need same info
7. **Separate mobile site**: Use responsive instead
8. **Not testing on real devices**: Emulators aren't enough
9. **Relying on hover**: Touch devices can't hover
10. **Loading desktop images on mobile**: Huge waste of bandwidth

## Resources

- [Responsive Web Design Patterns](https://developers.google.com/web/fundamentals/design-and-ux/responsive/patterns)
- [A Book Apart: Responsive Web Design](https://abookapart.com/products/responsive-web-design)
- [Brad Frost's Responsive Patterns](https://bradfrost.github.io/this-is-responsive/patterns.html)
