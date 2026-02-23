# Journey Mapping Guide

Guide for creating user journey maps during product design.

## What is a Journey Map?

A user journey map visualizes the complete experience a user has with your product to accomplish a specific goal. It identifies touchpoints, actions, emotions, and opportunities for improvement.

## When to Create Journey Maps

- After defining user personas
- For critical user workflows
- When identifying pain points and opportunities
- Before designing detailed features

## Journey Map Structure

### 1. Journey Header
- **Journey Name**: [Descriptive name]
- **Persona**: [Which persona experiences this journey]
- **Goal**: [What the user is trying to accomplish]
- **Scenario**: [Context for this journey]

### 2. Journey Phases

Divide the journey into logical phases (typically 4-7 phases).

Example phases:
- Discovery / Awareness
- Consideration / Research
- Decision / Sign-up
- Onboarding / First Use
- Regular Use
- Renewal / Retention

### 3. For Each Phase Document

**User Actions**:
- What is the user doing?
- What decisions are they making?

**Touchpoints**:
- Where does interaction happen? (Website, app, email, etc.)
- What specific UI/features are involved?

**User Thoughts**:
- What is the user thinking?
- What questions do they have?

**Emotions**:
- How does the user feel? (Frustrated, excited, confused, confident)
- Emotional highs and lows

**Pain Points**:
- What obstacles exist?
- Where does friction occur?
- What causes frustration?

**Opportunities**:
- How can we improve this phase?
- What features could help?
- What can we eliminate?

## Journey Map Template

```markdown
# Journey: [Journey Name]

**Persona**: [Persona Name]
**Goal**: [User's goal]
**Scenario**: [Context/situation]

---

## Phase 1: [Phase Name]

**User Actions**:
- [Action 1]
- [Action 2]

**Touchpoints**:
- [Touchpoint 1 - e.g., Homepage]
- [Touchpoint 2 - e.g., Sign-up form]

**User Thoughts**:
- _"[Thought 1]"_
- _"[Thought 2]"_

**Emotions**: [😊 Positive / 😐 Neutral / 😟 Negative]
- [Emotional state description]

**Pain Points**:
- [Pain point 1]
- [Pain point 2]

**Opportunities**:
- [Opportunity 1]
- [Opportunity 2]

---

## Phase 2: [Phase Name]

[Repeat structure]

---
```

## Example Journey Map

```markdown
# Journey: First Project Setup

**Persona**: Sarah the Startup Founder
**Goal**: Create and configure first project to start tracking work
**Scenario**: Sarah signed up for the platform and wants to get her team using it ASAP

---

## Phase 1: Post-Signup Landing

**User Actions**:
- Clicks confirmation link in email
- Lands on dashboard
- Looks for "Create Project" or similar

**Touchpoints**:
- Email (verification)
- Dashboard (empty state)
- Navigation menu

**User Thoughts**:
- _"Where do I start?"_
- _"I hope this doesn't take long"_
- _"Will I need to watch a tutorial?"_

**Emotions**: 😐 Neutral to slightly anxious
- Wants to move quickly but unsure of next steps

**Pain Points**:
- Empty dashboard doesn't guide next action
- Multiple options visible but unclear priority
- No obvious "start here" flow

**Opportunities**:
- Add prominent "Create Your First Project" CTA
- Show quick setup wizard (3-4 steps max)
- Display estimated time to complete
- Offer "Quick Start with Template" option

---

## Phase 2: Project Creation

**User Actions**:
- Clicks "New Project"
- Fills in project name and description
- Selects project type/template
- Configures basic settings

**Touchpoints**:
- Project creation modal/page
- Form fields
- Template gallery

**User Thoughts**:
- _"Do I need to configure all this now?"_
- _"Can I change this later?"_
- _"Which template matches my use case?"_

**Emotions**: 😊 Optimistic but slightly overwhelmed
- Excited to see templates but concerned about making wrong choice

**Pain Points**:
- Too many configuration options upfront
- Template descriptions are too brief
- Unclear what can be changed later
- Fear of choosing wrong setup

**Opportunities**:
- Reduce required fields to bare minimum (name only?)
- Add "You can change this later" reassurance
- Provide template preview or examples
- Offer "Start blank and customize as you go"
- Add "Skip setup, explore first" option

---

## Phase 3: Team Invitation

**User Actions**:
- Looks for way to invite team
- Enters email addresses
- Customizes invitation message (optional)
- Sends invites

**Touchpoints**:
- Team settings page
- Invitation modal
- Email sent to team members

**User Thoughts**:
- _"Can I add people later or should I do it now?"_
- _"What will they see when they join?"_
- _"Do they need accounts already?"_

**Emotions**: 😊 Positive
- Feels productive, making progress

**Pain Points**:
- Unclear if this step is required now
- Uncertain about team member experience
- May not have all email addresses handy

**Opportunities**:
- Make team invitation optional but suggested
- Show preview of invite email
- Offer "Copy invitation link" alternative
- Add "Skip, I'll invite later" button
- Send her a test invite so she can see experience

---
```

## Tips for Effective Journey Mapping

1. **Focus on one journey at a time** - Don't try to map everything at once
2. **Be specific** - Use real scenarios and concrete actions
3. **Include emotions** - Emotional highs and lows reveal opportunities
4. **Identify pain points honestly** - Don't gloss over friction
5. **Prioritize opportunities** - Not all improvements are equal
6. **Validate with users** - Test your assumptions with real user research
7. **Update regularly** - Journey maps should evolve with your product
