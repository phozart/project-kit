---
name: business-analysis
description: Requirements engineering with formal specifications and traceability
---

# Business Analysis Skill

Translates product features into formal, testable requirements with full traceability. Creates structured requirements documentation that bridges product design and technical implementation.

## When to Use

- Phase 4 business analysis in the orchestrator workflow
- User says "write requirements" or "create requirements"
- Need to formalize product features into technical requirements
- Creating or updating Requirements Traceability Matrix (RTM)
- Defining acceptance criteria for features

## What This Skill Does

This skill produces formal requirements documentation including:

1. Structured requirements with unique IDs
2. Testable acceptance criteria
3. Requirements Traceability Matrix (RTM)
4. User stories with detailed scenarios

## Requirements Categories

All requirements must be categorized with appropriate ID prefix:

- **REQ-F-XXX**: Functional requirements (what the system does)
- **REQ-D-XXX**: Data requirements (what data is stored/processed)
- **REQ-NF-XXX**: Non-functional requirements (performance, security, usability)
- **REQ-OP-XXX**: Operational requirements (monitoring, backup, deployment)
- **REQ-S-XXX**: Security requirements (auth, encryption, compliance)

## Requirement Structure

Each requirement must include:

```markdown
### [REQ-ID] Requirement Title

**Category**: [Functional/Data/Non-Functional/Operational/Security]
**Priority**: [Must Have / Should Have / Could Have / Won't Have]
**Source**: [FEAT-XXX or stakeholder reference]
**Status**: [Draft / Approved / Implemented / Verified]

**Description**:
[Clear, concise description of the requirement]

**Acceptance Criteria**:
- **Given** [initial context/state]
  **When** [action or event]
  **Then** [expected outcome]

- **Given** [another context]
  **When** [another action]
  **Then** [another outcome]

**Dependencies**: [List of dependent requirements]
**Notes**: [Additional context, constraints, or considerations]
```

## Process

### 1. Review Product Design

Read and analyze:
- `docs/product-strategy.md` - Understand vision and goals
- `docs/personas.md` - Know the users
- `docs/features.md` - Source of requirements

### 2. Extract Requirements from Features

For each feature (FEAT-XXX):

**Identify Functional Requirements**:
- What actions can users perform?
- What business rules must be enforced?
- What workflows must be supported?

**Identify Data Requirements**:
- What data must be stored?
- What are the data relationships?
- What are data validation rules?
- What are data retention requirements?

**Identify Non-Functional Requirements**:
- Performance targets (response time, throughput)
- Scalability needs (concurrent users, data volume)
- Usability standards (accessibility, UX)
- Reliability targets (uptime, error rates)

**Identify Operational Requirements**:
- Monitoring and alerting
- Backup and recovery
- Deployment process
- Maintenance windows

**Identify Security Requirements**:
- Authentication mechanisms
- Authorization rules
- Data encryption (at rest, in transit)
- Audit logging
- Compliance requirements (GDPR, HIPAA, etc.)

### 3. Write Requirements

For each requirement:

1. **Assign unique ID** following category conventions
2. **Set MoSCoW priority** based on feature priority
3. **Write clear description** in present tense, active voice
4. **Define testable acceptance criteria** using Given/When/Then
5. **Identify dependencies** on other requirements
6. **Note constraints** and special considerations

See references for requirements patterns and user story guide.

### 4. Create Requirements Traceability Matrix

Build RTM linking features to requirements to test cases:

```markdown
| Feature ID | Requirement ID | Requirement Description | Priority | Test Case ID | Status |
|------------|----------------|-------------------------|----------|--------------|--------|
| FEAT-001   | REQ-F-001      | User can sign up        | Must     | TC-001       | Draft  |
| FEAT-001   | REQ-F-002      | Email verification      | Must     | TC-002       | Draft  |
| FEAT-001   | REQ-S-001      | Password strength       | Must     | TC-003       | Draft  |
```

RTM must be:
- **Machine-readable**: Markdown tables parseable by tools
- **Human-readable**: Clear and understandable
- **Bidirectional**: Trace from features to requirements AND requirements to features
- **Complete**: Every feature has requirements, every requirement has tests

See RTM guide in references.

### 5. Validation Checklist

Before finalizing requirements:

- [ ] Every feature from product design has corresponding requirements
- [ ] All requirements have unique IDs with proper category prefix
- [ ] All requirements have MoSCoW priority assigned
- [ ] All requirements have testable acceptance criteria (Given/When/Then)
- [ ] All dependencies between requirements are documented
- [ ] RTM is complete and correctly formatted
- [ ] All "Must Have" requirements are necessary for MVP
- [ ] Requirements are unambiguous and verifiable
- [ ] Security and compliance requirements are addressed
- [ ] Non-functional requirements have measurable targets

## Output Files

- `docs/requirements/functional-requirements.md` - REQ-F-XXX requirements
- `docs/requirements/data-requirements.md` - REQ-D-XXX requirements
- `docs/requirements/non-functional-requirements.md` - REQ-NF-XXX requirements
- `docs/requirements/operational-requirements.md` - REQ-OP-XXX requirements
- `docs/requirements/security-requirements.md` - REQ-S-XXX requirements
- `docs/requirements/RTM.md` - Requirements Traceability Matrix
- `docs/requirements/user-stories.md` - Detailed user stories with scenarios

## Quality Guidelines

**Good Requirement**:
- Clear and unambiguous
- Testable and verifiable
- Necessary (not gold-plating)
- Feasible (can be implemented)
- Independent (not coupled to implementation)

**Bad Requirement**:
- Vague ("system should be fast")
- Untestable ("user should be happy")
- Over-specified (dictates implementation)
- Ambiguous (multiple interpretations)

## References

- [Requirements Patterns](./references/requirements-patterns.md)
- [User Story Guide](./references/user-story-guide.md)
- [RTM Guide](./references/rtm-guide.md)
