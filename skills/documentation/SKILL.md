---
name: documentation
description: Generate design style guides, developer guides, and user guides
---

# Documentation Skill

Documentation generation skill for Phase 10. Produces three deliverable packages: Design Style Guide, Developer Guide, and User Guide.

## Overview

This skill provides documentation patterns for:
- **Design Style Guide** — Self-contained HTML/CSS showcasing all design system components
- **Developer Guide** — Technical documentation with Mermaid diagrams, ERDs, API reference
- **User Guide** — Step-by-step user journeys with screenshot placeholders

## When to Use

Use this skill when:
- Entering Phase 10 documentation
- User asks to "generate docs" or "create documentation"
- After QA sign-off and before release
- Creating deliverable documentation packages

## Three Documentation Packages

### 1. Design Style Guide
Self-contained HTML file showcasing the design system.

**Purpose:**
- Reference for designers and developers
- Ensures design consistency
- Documents all colors, typography, spacing, components
- Single file for easy sharing

**Format:**
- Single HTML file with embedded CSS
- No external dependencies
- Organized by sections
- Live component examples

See: `references/style-guide-spec.md`

### 2. Developer Guide
Technical documentation for developers.

**Purpose:**
- System architecture overview
- Database schema (ERD)
- API contracts and examples
- Architecture Decision Records (ADR) summaries
- Development setup instructions

**Format:**
- Markdown files
- Mermaid diagrams for architecture
- Code examples
- Links to API contracts

See: `references/dev-guide-spec.md`

### 3. User Guide
End-user documentation with step-by-step instructions.

**Purpose:**
- Guide users through key workflows
- Document all features
- Provide troubleshooting help
- Support onboarding

**Format:**
- Markdown files
- Step-by-step instructions
- Screenshot placeholders with Cowork instructions
- Organized by user journey

See: `references/user-guide-spec.md`

## Documentation Process

### Phase 10 Entry Criteria
- QA sign-off received
- All features implemented and tested
- Design system finalized
- API contracts stable
- System deployed to staging

### Generation Process

**Step 1: Design Style Guide**
1. Review design system in `docs/DESIGN-SYSTEM/`
2. Extract colors, typography, spacing, components
3. Generate single HTML file with embedded CSS
4. Include live examples of all components
5. Test style guide displays correctly in browsers

**Step 2: Developer Guide**
1. Review system design in `docs/SYSTEM-DESIGN/`
2. Create architecture overview with Mermaid diagram
3. Generate ERD from database schema
4. Compile API reference from contracts
5. Summarize ADRs with links to full documents
6. Document setup instructions

**Step 3: User Guide**
1. Review user journeys from requirements
2. Create step-by-step instructions for each journey
3. Add screenshot placeholders with Cowork instructions
4. Include troubleshooting section
5. Add FAQ section

### Phase 10 Exit Criteria
- All three documentation packages complete
- Style guide tested in browsers
- Developer guide reviewed by technical lead
- User guide reviewed by product owner
- Documentation approved for release

## Design Style Guide Structure

### Required Sections
1. **Introduction** — Purpose and how to use the guide
2. **Colors** — Brand colors, semantic colors, color palette
3. **Typography** — Fonts, sizes, weights, line heights
4. **Spacing** — Spacing scale, margin/padding patterns
5. **Layout** — Grid system, breakpoints, containers
6. **Components** — All UI components with examples
7. **Patterns** — Common UI patterns and compositions
8. **Accessibility** — Color contrast, WCAG compliance

### Component Examples
Each component should show:
- Default state
- Hover/active/disabled states
- Size variants
- Color variants
- Code example (HTML/CSS)

## Developer Guide Structure

### Required Sections
1. **System Overview** — High-level architecture
2. **Architecture Diagram** — Mermaid diagram showing components
3. **Data Model** — ERD showing database schema
4. **API Reference** — All endpoints with examples
5. **ADR Summary** — Key architecture decisions
6. **Development Setup** — How to run locally
7. **Testing Guide** — How to run tests
8. **Deployment Guide** — How to deploy

### Diagram Types
- **System Architecture** — Component diagram
- **Data Flow** — Sequence diagram
- **Entity Relationships** — ERD
- **Deployment Architecture** — Infrastructure diagram

## User Guide Structure

### Required Sections
1. **Introduction** — Product overview and key features
2. **Getting Started** — First-time setup
3. **User Journeys** — Step-by-step instructions for each journey
4. **Features** — Detailed feature documentation
5. **Troubleshooting** — Common issues and solutions
6. **FAQ** — Frequently asked questions

### Screenshot Placeholders
Use this format for screenshot placeholders:

```markdown
![Screenshot: Dashboard Overview](screenshots/dashboard-overview.png)

**Cowork Instructions:**
1. Navigate to dashboard at http://localhost:3000/dashboard
2. Log in as test user (test@example.com / password123)
3. Wait for data to load
4. Take full-screen screenshot
5. Save as screenshots/dashboard-overview.png
```

### User Journey Format
```markdown
## Journey: Create New Order

### Step 1: Navigate to Orders
1. Click "Orders" in the main navigation
2. The orders page displays

![Screenshot: Orders page](screenshots/orders-page.png)

### Step 2: Click Create Order
1. Click "Create Order" button in top right
2. Order creation form appears

![Screenshot: Create order form](screenshots/create-order-form.png)

### Step 3: Fill Order Details
1. Select customer from dropdown
2. Add products using search
3. Review total amount
4. Click "Create Order"

### Step 4: Confirm Creation
1. Success message appears
2. Order appears in orders list
```

## Documentation Maintenance

### Living Documentation
Documentation should be updated when:
- New features added
- Architecture changes
- API contracts change
- Design system updates
- User workflows change

### Version Control
- Store documentation in version control
- Tag documentation versions with releases
- Link documentation version to product version
- Maintain changelog

## Documentation Quality

### Checklist
- [ ] Design style guide displays correctly
- [ ] All colors, typography, components documented
- [ ] Architecture diagrams accurate
- [ ] ERD matches database schema
- [ ] API examples tested and working
- [ ] User journeys complete and accurate
- [ ] Screenshot placeholders have clear instructions
- [ ] All links working
- [ ] Documentation reviewed and approved

## References

Detailed specifications and examples:
- `references/style-guide-spec.md` — HTML style guide structure and sections
- `references/dev-guide-spec.md` — Developer guide structure, diagram types
- `references/user-guide-spec.md` — User guide structure, screenshot placeholder format
