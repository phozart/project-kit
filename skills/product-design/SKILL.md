---
name: product-design
description: Product strategy and feature design with completeness validation
---

# Product Design Skill

Defines WHAT gets built through strategic product design. Encompasses product strategy, customer experience mapping, and feature design with comprehensive completeness checks.

## When to Use

- Phase 2 product design in the orchestrator workflow
- User says "design the product" or "define features"
- Need to establish product vision and strategy
- Creating user personas and journey maps
- Defining MVP scope and feature inventory

## What This Skill Does

This skill guides product definition through three internal phases:

1. **Product Strategy** - Vision, problem, value proposition
2. **Customer Experience** - Personas and journey mapping
3. **Feature Design** - Complete feature inventory with validation

## Process

### Phase 1: Product Strategy

**Gather Core Information**:

1. **Vision Statement** (1-2 sentences)
   - What is the aspirational future state?
   - What impact will this product have?

2. **Problem Statement**
   - What problem are we solving?
   - Who experiences this problem?
   - What is the current state and pain points?

3. **Value Proposition**
   - What unique value does this product provide?
   - Why will users choose this over alternatives?
   - What are the key differentiators?

4. **Success Metrics**
   - How will we measure product success?
   - What are the key performance indicators?

**Output**: `docs/product-strategy.md`

### Phase 2: Customer Experience

**Create User Personas**:

For each primary user type:
- Demographics and context
- Goals and motivations
- Pain points and frustrations
- Technical proficiency
- Usage patterns

Use the persona template in references.

**Output**: `docs/personas.md`

**Map User Journeys**:

For each persona, map critical journeys:
- Journey name and goal
- Steps in the journey
- User actions at each step
- Touchpoints (where they interact)
- Pain points and emotions
- Opportunities for improvement

Use the journey mapping guide in references.

**Output**: `docs/journey-maps.md`

### Phase 3: Feature Design

**Build Feature Inventory**:

Create comprehensive feature list organized by category. For each feature:
- Feature ID (FEAT-XXX)
- Feature name and description
- User story format: "As a [persona], I want [capability], so that [benefit]"
- Priority (Must Have, Should Have, Could Have, Won't Have)
- Complexity estimate (Small, Medium, Large)
- Dependencies

**CRITICAL: Run Completeness Check**:

Every product must address these categories (from the feature completeness checklist):

1. **Authentication & Authorization**
   - Sign up, login, logout
   - Password reset
   - Social auth (if applicable)
   - Role-based access control

2. **User Management**
   - Profile management
   - Account settings
   - User preferences
   - Avatar/photo management

3. **Admin & Moderation**
   - Admin dashboard
   - User management (for admins)
   - Content moderation tools
   - System configuration

4. **Transactional Communications**
   - Welcome emails
   - Password reset emails
   - Notification emails
   - Action confirmations

5. **Legal & Compliance**
   - Terms of service
   - Privacy policy
   - Cookie consent
   - Data export (GDPR)
   - Account deletion

6. **Settings & Configuration**
   - App preferences
   - Notification settings
   - Privacy settings
   - Language/localization

7. **Error Handling**
   - 404 pages
   - 500 pages
   - Permission denied pages
   - Offline state handling
   - Error messages and recovery

8. **Empty States**
   - No data states
   - First-time user experience
   - Search with no results
   - Deleted/archived content views

9. **Onboarding**
   - First-time user tutorial
   - Progressive feature discovery
   - Setup wizards
   - Sample data or templates

10. **Help & Support**
    - Help documentation
    - FAQ
    - Contact support
    - In-app help/tooltips
    - Status page

11. **Domain-Specific Features**
    - Core value-delivering features
    - Unique product capabilities
    - Competitive differentiators

For each category, verify features exist or mark as "Not Applicable" with justification.

See the feature completeness checklist in references for exhaustive details.

**Define MVP Scope**:

Review all features and:
1. Mark "Must Have" features for MVP
2. Defer "Should Have" and "Could Have" to post-MVP
3. Eliminate "Won't Have" features
4. Ensure MVP is viable, complete, and shippable

**Output**: `docs/features.md` with completeness validation

## Validation Checklist

Before completing product design:

- [ ] Product strategy document exists with vision, problem, value prop, metrics
- [ ] At least 2-3 user personas defined
- [ ] Critical user journeys mapped for each persona
- [ ] Feature inventory created with IDs and priorities
- [ ] Feature completeness checklist completed (all 11 categories addressed)
- [ ] MVP scope clearly defined
- [ ] All "Must Have" features form a coherent, shippable product

## Output Files

- `docs/product-strategy.md` - Vision, problem, value proposition
- `docs/personas.md` - User personas
- `docs/journey-maps.md` - User journey maps
- `docs/features.md` - Feature inventory with completeness check

## References

- [Feature Completeness Checklist](./references/feature-completeness-checklist.md)
- [Persona Template](./references/persona-template.md)
- [Journey Mapping Guide](./references/journey-mapping-guide.md)
