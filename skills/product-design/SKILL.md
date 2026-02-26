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

### Product Type Classification (REQUIRED FIRST STEP)

Before applying any methodology, classify the product. The classification determines which frameworks apply and which are irrelevant.

#### Classification Decision

```
What type of product is this?
|
+-- Users choose to use it (market-driven)
|   |
|   +-- Self-service signup possible
|   |   --> Consumer/PLG SaaS
|   |       Apply: Full PLG methodology (growth model, activation, PQL, viral)
|   |
|   +-- Sales/demo required
|   |   --> Enterprise SaaS
|   |       Apply: Strategy + Features + Journeys. Skip PLG-specific sections.
|   |       Replace viral/referral with: procurement journey, champion enablement
|   |
|   +-- Developer audience
|       --> Developer Tool / API Product
|           Apply: Strategy + Features. Replace UI journeys with DX journeys.
|           Focus: documentation, SDK, sandbox, error messages, time-to-first-call
|
+-- Users are assigned to use it (organization-driven)
|   |
|   +-- Operational monitoring / decision support
|   |   --> Operational Platform
|   |       Apply: Strategy + Features + Operational Journeys
|   |       Skip: Growth model, viral, referral, PQL, activation flow
|   |       Replace with: Operational Value Framework (see below)
|   |
|   +-- Internal productivity / workflow
|   |   --> Internal Tool
|   |       Apply: Strategy (simplified) + Features + Task Journeys
|   |       Skip: Market analysis, competitive analysis, growth model
|   |       Replace with: Efficiency metrics, adoption within org
|   |
|   +-- Compliance / regulatory
|       --> Compliance Tool
|           Apply: Strategy (regulatory context) + Features + Compliance Journeys
|           Skip: Growth, market, competitive
|           Replace with: Compliance coverage, audit trail, risk reduction metrics
|
+-- The product IS the data (data-driven)
    |
    +-- Analytics / reporting
    |   --> Data Product (Analytical)
    |       Apply: Strategy + Data Quality Framework + Consumer Journeys
    |       Focus: data freshness, accuracy, completeness, discoverability
    |
    +-- Pipeline / integration
        --> Data Product (Operational)
            Apply: Strategy (simplified) + Data Contract Framework
            Focus: SLA, throughput, error rates, schema evolution
```

#### Operational Value Framework (for Operational Platforms)

When the product type is Operational Platform, replace the Growth Model and PLG sections with:

**Core Operational Question**: What operational outcome does this platform improve?

| Metric | Current State | Target State | How the Platform Gets There |
|--------|--------------|-------------|---------------------------|
| [e.g., Undetected delays] | [X per week] | [Y per week] | [Platform shows delays within Z minutes] |
| [e.g., Investigation time] | [X hours avg] | [Y hours avg] | [Platform provides root cause context in one view] |
| [e.g., Manual data reconciliation] | [X hours/week] | [Y hours/week] | [Platform automates matching across data sources] |

**North Star Metric (Operational)**: For operational platforms, the NSM is NOT a growth metric. It's an operational effectiveness metric:

| Platform Type | Example NSM | Why |
|---------------|-------------|-----|
| Monitoring | Mean time to detection (MTTD) | Faster detection = less damage |
| Investigation | Mean time to resolution (MTTR) | Faster resolution = less cost |
| Compliance | Compliance coverage % | Coverage = risk reduction |
| Data quality | Data accuracy score | Accuracy = trust in decisions |
| Workflow | Tasks completed per operator per day | Throughput = efficiency |

**User Types (Not Personas)**: Operational platforms serve roles, not personas. Define:

| Role | What They Monitor | Decision Authority | Time Pressure | Access Pattern |
|------|-------------------|-------------------|---------------|----------------|
| [e.g., Network Operator] | [EDI flow health] | [Escalate anomalies] | [Real-time] | [8hr shifts, 3 monitors] |
| [e.g., Investigation Lead] | [Flagged items] | [Resolve or escalate] | [Same-day] | [Deep-dive sessions, 1-2hr] |
| [e.g., Operations Manager] | [KPI dashboards] | [Resource allocation] | [Daily review] | [10min check, drill on exceptions] |

**Value Demonstration**: Operational platforms don't have "Aha moments" in the PLG sense. They have:

| Value Moment | What Happens | When It Occurs |
|-------------|-------------|----------------|
| **First Catch** | Platform detects an issue the operator would have missed | First week of use |
| **Time Saved** | Operator completes investigation faster than manual process | First month |
| **Pattern Recognition** | Platform reveals a systemic issue across individual events | First quarter |
| **Trust Threshold** | Operators check the platform first instead of legacy tools | Ongoing — this is the real "activation" |

### Usage Context Assessment (REQUIRED)

Before designing features, understand HOW and WHERE the product will be used. This directly influences information density, interaction patterns, and what "good" looks like.

#### Physical Context

| Question | Answer | Design Implication |
|----------|--------|-------------------|
| Primary device? | Desktop / Laptop / Tablet / Mobile / Multi-monitor | Screen real estate, interaction model |
| Dedicated use or alongside other tools? | Dedicated / Split-screen / Background | Information density, notification strategy |
| Noisy or quiet environment? | Office / Warehouse / Field / Home | Audio feedback feasibility, visual prominence |
| Shared or personal device? | Personal / Shared workstation / Kiosk | Auth persistence, session management |

#### Temporal Context

| Question | Answer | Design Implication |
|----------|--------|-------------------|
| How often do they open this? | Continuous / Hourly / Daily / Weekly | Session restoration, notification urgency |
| How long is a typical session? | Hours / 30min / 5min / Glance | Information hierarchy, progressive disclosure |
| Is usage time-pressured? | Real-time response / Same-day / Planning horizon | Loading performance budget, shortcut density |
| Are there peak usage periods? | Shift-based / Market hours / Month-end / Even | Capacity planning, batch vs. real-time |

#### Cognitive Context

| Question | Answer | Design Implication |
|----------|--------|-------------------|
| Domain expertise level? | Expert / Intermediate / Novice / Mixed | Terminology, progressive disclosure, defaults |
| Number of concurrent tasks? | Single-focus / 2-3 parallel / Many parallel | Tab/workspace design, state preservation |
| Decision complexity? | Binary / Choose from options / Open analysis | Recommendation engine, decision support |
| Error consequence? | Low (undo possible) / Medium / High (irreversible) | Confirmation patterns, audit trail |

#### Context-to-Feature Rules

The answers above directly constrain feature design:

- **5-minute glance sessions** — dashboard-first, no onboarding flow, state persists between sessions
- **Multi-monitor continuous use** — keyboard shortcuts mandatory, dense information display, persistent filters
- **Mobile field use** — offline capability, large touch targets, minimal text input
- **High-error-consequence** — confirmation dialogs justified, audit trail required, undo for everything possible
- **Expert users in time-pressure** — command palette (Ctrl+K), skip tutorials, power-user defaults
- **Mixed expertise** — role-based defaults, progressive disclosure, contextual help not mandatory training

This assessment feeds directly into Platform Foundation (phase 3) for technical decisions and UX/UI Design (phase 5) for interaction patterns.

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

**Build Hierarchical Feature Inventory**:

Features are organized in a three-level hierarchy that maps directly to work package decomposition in the Implementation phase:

#### Level 1: Capabilities (CAP-XXX)
A capability is a major area of functionality. Each capability typically becomes one or two work packages.

#### Level 2: Feature Groups (FG-XXX)
A feature group is a cohesive set of features within a capability. Each group is a candidate for a single work package.

#### Level 3: Features (F-XXX)
Individual features. Each feature typically becomes one or two implementation tasks.

**Example Structure:**

```
CAP-001: Dispatch Management
  FG-001: Dispatch CRUD (F-001 to F-005) — Must — Core workflow
  FG-002: Dispatch Filtering (F-006 to F-009) — Must — Daily operations
  FG-003: Dispatch Export (F-010 to F-012) — Should — Reporting
```

For each feature (F-XXX), document:
- Feature name and description
- User value (why this matters)
- MoSCoW priority (Must/Should/Could/Won't)
- Acceptance criteria (minimum 3, specific and testable)
- Edge cases (minimum 2, what happens at boundaries)
- Out of scope (explicitly what this feature does NOT do)

#### Why Hierarchy Matters

- **For Implementation Planner**: CAP to FG mapping directly suggests work package boundaries
- **For MVP Scoping**: Entire capabilities or feature groups can be moved to NEXT/LATER instead of cherry-picking individual features
- **For Platform Foundation**: The capability list informs database schema scope, API surface area, and auth requirements
- **For Architecture**: Each capability suggests a bounded context or module boundary

**CRITICAL: Run Completeness Check**:

Every product must address these categories (from the feature completeness checklist):

1. Authentication & Authorization
2. User Management
3. Admin & Moderation
4. Transactional Communications
5. Legal & Compliance
6. Settings & Configuration
7. Error Handling
8. Empty States
9. Onboarding
10. Help & Support
11. Domain-Specific Features

For each category, verify features exist or mark as "Not Applicable" with justification. See the feature completeness checklist in references for exhaustive details.

**Requirements Integration (Embedded)**:

Since Business Analysis is merged into Product Design, the feature inventory IS the requirements document. No separate handoff needed.

Every feature (F-XXX) must include:
- **Acceptance Criteria**: minimum 3 per feature. Specific, testable statements.
- **Edge Cases**: minimum 2 per feature. What happens at the boundaries?
- **Out of Scope**: explicit statement of what this feature does NOT do. Prevents scope creep during implementation.
- **Traceability ID**: REQ-XXX mapped to F-XXX for traceability purposes.

**Traceability Cross-Reference** (appendix, not a separate document):

| F-ID | Feature | REQ-ID | Requirement Statement |
|------|---------|--------|----------------------|
| F-001 | [Feature name] | REQ-001 | [Requirement statement] |

This table exists for auditability and compliance tracing. It is generated from the feature inventory, not maintained separately.

**BA Agent as Advisor**: The business-analyst agent is available during Product Design for requirements pattern advice, traceability guidance, and edge case discovery. It is not a gate owner and does not produce separate artifacts.

**Define Scope**:

Review all features and:
1. Scope at the feature group (FG) level — Now / Next / Later
2. Ensure "Now" scope covers at least one end-to-end user journey
3. Document "Next" and "Later" for roadmap visibility
4. Ensure scope is viable, complete, and shippable

**Output**: `docs/FEATURE-INVENTORY.md` with hierarchy, acceptance criteria, edge cases, traceability

### Product Framing Beyond Software (RECOMMENDED)

Before locking the feature inventory, challenge the product framing by looking at how the same problem is solved outside software. This prevents the default where every product is "a dashboard with CRUD and filters."

#### 1. Physical Space Framing

Ask: If this product were a physical space, what would it be?

- A **control room** (air traffic control, power grid) — primary view is a live situation map, not a list. Alerts are spatial, not chronological. Design for vigilance, not task completion.
- A **workshop** (craftsman's bench) — tools are within reach, material is in progress, finished work is visible. Design for flow state, not step-by-step.
- A **library** (research institution) — organized for retrieval, cross-referenced, quiet. Design for finding and connecting, not creating.
- A **marketplace** (trading floor) — dynamic, competitive, time-sensitive. Design for speed and comparison, not thoroughness.

The answer changes the entire information architecture. A control room product has fundamentally different features than a library product, even if the underlying data is the same.

#### 2. Time Horizon Framing

Ask: What time horizon does the user operate in?

| Time Horizon | Product Implication | Feature Emphasis |
|-------------|--------------------|-----------------|
| Real-time (seconds) | Live data, auto-refresh, alerts | Monitoring, anomaly detection, instant actions |
| Operational (hours-days) | Batch views, queue management, status tracking | Workflow, assignment, progress |
| Tactical (weeks-months) | Trend analysis, planning, forecasting | Reports, comparisons, projections |
| Strategic (quarters-years) | Portfolio view, long-term metrics, scenario modeling | Dashboards, what-if analysis, governance |

Most products serve multiple time horizons but have a PRIMARY one. If the primary is operational but all features are built for tactical, the product fails daily use even if the reports are excellent.

#### 3. Information Density Framing

Ask: Is this a newspaper or a novel?

- **Newspaper** (high density, scan-and-find) — tables, lists, dense layouts, many small elements visible simultaneously. Users scan for the one thing that matters. Design: show everything, let the eye find it.
- **Novel** (low density, sequential) — one thing at a time, clear progression, guided experience. Users follow a path. Design: hide most things, reveal on demand.
- **Reference book** (medium density, lookup) — structured for retrieval, extensive cross-references, index. Users know what they're looking for. Design: powerful search, consistent structure, deep linking.

The answer directly constrains the UX/UI phase. A newspaper product should not have wizard-style onboarding. A novel product should not have a 50-column data grid.

#### 4. Failure Mode Framing

Ask: What does failure look like for the user of this product?

Not product failure (bugs, downtime). User failure: what goes wrong in the user's world when they use the product incorrectly or miss something?

| Failure Mode | Product Response |
|-------------|-----------------|
| Missed a critical alert — delayed shipment | Alert design must interrupt, not just appear in a list |
| Entered wrong data — cascading errors downstream | Validation must be inline and immediate, not batch |
| Couldn't find the right information — made bad decision | Search and filtering are core features, not nice-to-have |
| Took too long — missed the window | Performance budget is a product requirement, not a technical one |
| Misunderstood a status — took wrong action | Status terminology and color coding are product decisions |

The failure modes often reveal features that wouldn't appear in a standard feature checklist.

### Platform Foundation Input Package

Product Design feeds directly into Platform Foundation (phase 3). To make that phase efficient, package the following decisions explicitly:

#### Platform Shape Signal
Based on the product type classification:
- Product type: [from classifier]
- Primary interaction pattern: [dashboard monitoring / CRUD workflow / data pipeline / API consumption / content creation]
- Real-time requirement: [from Usage Context — temporal context]

#### User Model Signal
From the Usage Context and Feature Inventory:
- User types identified: [list from operational roles or personas]
- Auth complexity: [single role / multiple roles / multi-tenant / B2B with customer-managed users]
- External integrations: [API consumers, system-to-system identified in features]

#### Data Signal
From the Feature Inventory:
- Core entities identified: [list capabilities — each is likely a primary entity]
- Search/filter features present: [yes/no — implies search infrastructure decision]
- Export features present: [yes/no — implies reporting/batch processing]
- Audit trail features present: [yes/no — implies event tracking or temporal tables]
- Real-time data features present: [yes/no — implies WebSocket/SSE decision]

#### Scale Signal
From the Usage Context:
- Expected concurrent users: [from temporal context — peak usage]
- Data volume expectation: [from feature edge cases — e.g., "10,000+ records must load in <2s"]
- Session pattern: [continuous/intermittent — affects session management and caching strategy]

This package doesn't make technical decisions. It provides the signals that the Platform Foundation agent uses to ask the right questions.

## Package Completeness Check

Before this phase can be marked complete:

- [ ] Product type classified
- [ ] Usage context assessed (physical, temporal, cognitive)
- [ ] North Star Metric defined (growth or operational, per product type)
- [ ] Feature inventory complete with hierarchy (CAP → FG → F)
- [ ] Every feature has: acceptance criteria (3+), edge cases (2+), out of scope statement
- [ ] Traceability cross-reference generated (REQ-XXX → F-XXX)
- [ ] Platform Foundation Input Package prepared
- [ ] Product Framing lenses applied (at least 2 of 4)
- [ ] Scope defined (Now / Next / Later at feature group level)
- [ ] Assumptions mapped with confidence scores

## Handoff to Downstream Phases

### → Platform Foundation (Phase 3)
Provide: Platform Foundation Input Package (see above)
Purpose: Technical decisions are informed by product type, user model, data patterns, and scale signals.

### → Architecture (Phase 4)
Provide: Full Feature Inventory (hierarchical), Usage Context Assessment, Product Type Classification
Purpose: Architect designs within the capability boundaries. Feature groups suggest module boundaries. Usage context informs API design (real-time vs. batch, etc.)

### → UX/UI Design (Phase 5)
Provide: Usage Context Assessment, Product Framing (physical space, time horizon, information density), Customer Journeys or Operational Journeys
Purpose: Designer works within the interaction constraints identified by usage context and product framing. If phozart-ui skill is present, mode selection (Surface vs Console) follows directly from product type classification.

### → Implementation Planner (Phase 7 entry)
Provide: Hierarchical Feature Inventory with acceptance criteria and edge cases
Purpose: CAP → FG → F hierarchy maps directly to work package → task decomposition. Acceptance criteria become task-level "what done looks like."

## Output Files

- `docs/PRODUCT-STRATEGY.md` - Vision, problem, value proposition, success metrics
- `docs/PERSONAS.md` - User personas (or User Types for operational platforms)
- `docs/USER-JOURNEYS.md` - User journey maps (or Operational Journeys)
- `docs/FEATURE-INVENTORY.md` - Hierarchical feature inventory with acceptance criteria, edge cases, traceability
- `docs/MVP-SCOPE.md` - Scope definition (Now / Next / Later)

## References

- [Feature Completeness Checklist](./references/feature-completeness-checklist.md)
- [Persona Template](./references/persona-template.md)
- [Journey Mapping Guide](./references/journey-mapping-guide.md)
