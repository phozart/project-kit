# Design Style Guide Specification

Specification for generating a self-contained HTML design style guide.

## HTML Template Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Design Style Guide - [Project Name]</title>
  <style>
    /* All CSS embedded here */
  </style>
</head>
<body>
  <!-- Navigation -->
  <!-- Content sections -->
</body>
</html>
```

## Section 1: Introduction

```html
<section id="introduction">
  <h1>Design Style Guide</h1>
  <p>
    This style guide documents the design system for [Project Name].
    It serves as a reference for designers and developers to ensure
    consistency across the application.
  </p>
  <p><strong>Version:</strong> 1.0.0</p>
  <p><strong>Last Updated:</strong> [Date]</p>
</section>
```

## Section 2: Colors

```html
<section id="colors">
  <h2>Colors</h2>

  <h3>Brand Colors</h3>
  <div class="color-grid">
    <div class="color-swatch">
      <div class="color-preview" style="background-color: #1a73e8;"></div>
      <div class="color-info">
        <h4>Primary</h4>
        <p>HEX: #1a73e8</p>
        <p>RGB: rgb(26, 115, 232)</p>
      </div>
    </div>
    <!-- More color swatches -->
  </div>

  <h3>Semantic Colors</h3>
  <div class="color-grid">
    <div class="color-swatch">
      <div class="color-preview" style="background-color: #28a745;"></div>
      <div class="color-info">
        <h4>Success</h4>
        <p>HEX: #28a745</p>
      </div>
    </div>
    <!-- Error, Warning, Info colors -->
  </div>
</section>
```

## Section 3: Typography

```html
<section id="typography">
  <h2>Typography</h2>

  <h3>Font Families</h3>
  <p style="font-family: 'Inter', sans-serif; font-size: 18px;">
    Primary: Inter (Headings, Body)
  </p>
  <p style="font-family: 'Roboto Mono', monospace; font-size: 16px;">
    Monospace: Roboto Mono (Code)
  </p>

  <h3>Type Scale</h3>
  <div class="type-scale">
    <h1>Heading 1 - 32px / 2rem</h1>
    <h2>Heading 2 - 24px / 1.5rem</h2>
    <h3>Heading 3 - 20px / 1.25rem</h3>
    <h4>Heading 4 - 18px / 1.125rem</h4>
    <p>Body - 16px / 1rem</p>
    <small>Small - 14px / 0.875rem</small>
  </div>

  <h3>Font Weights</h3>
  <p style="font-weight: 300;">Light - 300</p>
  <p style="font-weight: 400;">Regular - 400</p>
  <p style="font-weight: 500;">Medium - 500</p>
  <p style="font-weight: 600;">Semibold - 600</p>
  <p style="font-weight: 700;">Bold - 700</p>
</section>
```

## Section 4: Spacing

```html
<section id="spacing">
  <h2>Spacing</h2>

  <h3>Spacing Scale</h3>
  <div class="spacing-demo">
    <div class="spacing-item">
      <div class="spacing-visual" style="width: 4px;"></div>
      <span>XS - 4px / 0.25rem</span>
    </div>
    <div class="spacing-item">
      <div class="spacing-visual" style="width: 8px;"></div>
      <span>S - 8px / 0.5rem</span>
    </div>
    <div class="spacing-item">
      <div class="spacing-visual" style="width: 16px;"></div>
      <span>M - 16px / 1rem</span>
    </div>
    <div class="spacing-item">
      <div class="spacing-visual" style="width: 24px;"></div>
      <span>L - 24px / 1.5rem</span>
    </div>
    <div class="spacing-item">
      <div class="spacing-visual" style="width: 32px;"></div>
      <span>XL - 32px / 2rem</span>
    </div>
  </div>
</section>
```

## Section 5: Components

```html
<section id="components">
  <h2>Components</h2>

  <h3>Buttons</h3>
  <div class="component-demo">
    <button class="btn btn-primary">Primary Button</button>
    <button class="btn btn-secondary">Secondary Button</button>
    <button class="btn btn-outline">Outline Button</button>
    <button class="btn btn-primary" disabled>Disabled Button</button>
  </div>

  <h4>Button Sizes</h4>
  <div class="component-demo">
    <button class="btn btn-primary btn-sm">Small</button>
    <button class="btn btn-primary btn-md">Medium</button>
    <button class="btn btn-primary btn-lg">Large</button>
  </div>

  <h4>HTML</h4>
  <pre><code>&lt;button class="btn btn-primary"&gt;Primary Button&lt;/button&gt;</code></pre>

  <h3>Inputs</h3>
  <div class="component-demo">
    <input type="text" placeholder="Text input" class="input">
    <input type="email" placeholder="Email input" class="input">
    <input type="text" placeholder="Disabled" class="input" disabled>
    <input type="text" value="Error state" class="input input-error">
  </div>

  <!-- More components: Cards, Modals, Tables, Navigation, etc. -->
</section>
```

## Section 6: Layout

```html
<section id="layout">
  <h2>Layout</h2>

  <h3>Grid System</h3>
  <p>12-column grid with 16px gutters</p>
  <div class="grid-demo">
    <div class="col-12">12 columns</div>
    <div class="col-6">6 columns</div>
    <div class="col-6">6 columns</div>
    <div class="col-4">4 columns</div>
    <div class="col-4">4 columns</div>
    <div class="col-4">4 columns</div>
  </div>

  <h3>Breakpoints</h3>
  <ul>
    <li><strong>Mobile:</strong> < 768px</li>
    <li><strong>Tablet:</strong> 768px - 1024px</li>
    <li><strong>Desktop:</strong> > 1024px</li>
  </ul>
</section>
```

## CSS Structure

```css
/* Reset */
* { margin: 0; padding: 0; box-sizing: border-box; }

/* Variables */
:root {
  --color-primary: #1a73e8;
  --color-secondary: #5f6368;
  --spacing-xs: 4px;
  --spacing-s: 8px;
  --spacing-m: 16px;
  --font-family: 'Inter', sans-serif;
}

/* Base styles */
body {
  font-family: var(--font-family);
  line-height: 1.6;
  color: #333;
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

/* Component styles */
.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-primary {
  background: var(--color-primary);
  color: white;
}
```
