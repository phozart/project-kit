# Feature Inventory: [PROJECT_NAME]

**Date:** [DATE]
**Version:** [VERSION]
**Owner:** [OWNER]
**Product Type:** [PRODUCT_TYPE from classification]
**Usage Context:** See docs/PRODUCT-STRATEGY.md for physical, temporal, and cognitive context assessment
**North Star Metric:** [NSM from strategy — growth, operational, efficiency, or data quality metric]

---

## Capability Summary

| CAP-ID | Capability | Feature Groups | Total Features | Must | Should | Could |
|--------|-----------|---------------|---------------|------|--------|-------|
| CAP-001 | [CAPABILITY_NAME] | [COUNT] | [COUNT] | [COUNT] | [COUNT] | [COUNT] |
| CAP-002 | [CAPABILITY_NAME] | [COUNT] | [COUNT] | [COUNT] | [COUNT] | [COUNT] |
| CAP-003 | [CAPABILITY_NAME] | [COUNT] | [COUNT] | [COUNT] | [COUNT] | [COUNT] |

---

## CAP-001: [CAPABILITY_NAME]

[Brief description of this capability area]

### Feature Group Summary

| FG-ID | Feature Group | Features | Priority | Journey Stage |
|-------|--------------|----------|----------|---------------|
| FG-001 | [GROUP_NAME] | F-001 to F-00N | [Must/Should/Could] | [JOURNEY_STAGE] |
| FG-002 | [GROUP_NAME] | F-00N to F-00N | [Must/Should/Could] | [JOURNEY_STAGE] |

### FG-001: [GROUP_NAME]

| F-ID | Feature | Priority | Complexity | Dependencies |
|------|---------|----------|-----------|-------------|
| F-001 | [FEATURE_NAME] | [Must/Should/Could/Won't] | [Low/Medium/High] | [DEPENDENCY_IDS] |
| F-002 | [FEATURE_NAME] | [Must/Should/Could/Won't] | [Low/Medium/High] | [DEPENDENCY_IDS] |

#### F-001: [FEATURE_NAME]

**Description:** [DESCRIPTION]

**User Value:** [WHY_THIS_MATTERS]

**Related Journeys:** [JOURNEY_IDS]

**Acceptance Criteria:**
1. Given [CONTEXT], when [ACTION], then [EXPECTED_RESULT]
2. Given [CONTEXT], when [ACTION], then [EXPECTED_RESULT]
3. Given [CONTEXT], when [ACTION], then [EXPECTED_RESULT]

**Edge Cases:**
1. [BOUNDARY_CONDITION] — [EXPECTED_BEHAVIOR]
2. [BOUNDARY_CONDITION] — [EXPECTED_BEHAVIOR]

**Out of Scope:** [EXPLICIT_STATEMENT_OF_WHAT_THIS_FEATURE_DOES_NOT_DO]

#### F-002: [FEATURE_NAME]

**Description:** [DESCRIPTION]

**User Value:** [WHY_THIS_MATTERS]

**Related Journeys:** [JOURNEY_IDS]

**Acceptance Criteria:**
1. Given [CONTEXT], when [ACTION], then [EXPECTED_RESULT]
2. Given [CONTEXT], when [ACTION], then [EXPECTED_RESULT]
3. Given [CONTEXT], when [ACTION], then [EXPECTED_RESULT]

**Edge Cases:**
1. [BOUNDARY_CONDITION] — [EXPECTED_BEHAVIOR]
2. [BOUNDARY_CONDITION] — [EXPECTED_BEHAVIOR]

**Out of Scope:** [EXPLICIT_STATEMENT_OF_WHAT_THIS_FEATURE_DOES_NOT_DO]

### FG-002: [GROUP_NAME]

[Repeat F-XXX pattern for each feature in this group]

---

## CAP-002: [CAPABILITY_NAME]

[Repeat FG/F pattern for each capability]

---

## Completeness Check

| Category | Addressed | Features | Notes |
|----------|-----------|----------|-------|
| Authentication & Authorization | [Yes/No/N/A] | [F-IDS] | [JUSTIFICATION_IF_NA] |
| User Management | [Yes/No/N/A] | [F-IDS] | [JUSTIFICATION_IF_NA] |
| Admin & Moderation | [Yes/No/N/A] | [F-IDS] | [JUSTIFICATION_IF_NA] |
| Transactional Communications | [Yes/No/N/A] | [F-IDS] | [JUSTIFICATION_IF_NA] |
| Legal & Compliance | [Yes/No/N/A] | [F-IDS] | [JUSTIFICATION_IF_NA] |
| Settings & Configuration | [Yes/No/N/A] | [F-IDS] | [JUSTIFICATION_IF_NA] |
| Error Handling | [Yes/No/N/A] | [F-IDS] | [JUSTIFICATION_IF_NA] |
| Empty States | [Yes/No/N/A] | [F-IDS] | [JUSTIFICATION_IF_NA] |
| Onboarding | [Yes/No/N/A] | [F-IDS] | [JUSTIFICATION_IF_NA] |
| Help & Support | [Yes/No/N/A] | [F-IDS] | [JUSTIFICATION_IF_NA] |
| Domain-Specific Features | [Yes/No/N/A] | [F-IDS] | [JUSTIFICATION_IF_NA] |

---

## Product Framing

### Lenses Applied

**Physical Space Framing:** [ANSWER — control room / workshop / library / marketplace / other]
- Design implication: [IMPLICATION]

**Time Horizon Framing:** [PRIMARY — real-time / operational / tactical / strategic]
- Feature emphasis: [EMPHASIS]

**Information Density Framing:** [ANSWER — newspaper / novel / reference book]
- UX constraint: [CONSTRAINT]

**Failure Mode Framing:**
| Failure Mode | Product Response |
|-------------|-----------------|
| [FAILURE_1] | [RESPONSE_1] |
| [FAILURE_2] | [RESPONSE_2] |

---

## Traceability Cross-Reference

| F-ID | Feature | REQ-ID | Category | Requirement Statement |
|------|---------|--------|----------|----------------------|
| F-001 | [FEATURE_NAME] | REQ-F-001 | Functional | [REQUIREMENT_STATEMENT] |
| F-002 | [FEATURE_NAME] | REQ-F-002 | Functional | [REQUIREMENT_STATEMENT] |
| — | — | REQ-D-001 | Data | [REQUIREMENT_STATEMENT] |
| — | — | REQ-NF-001 | Non-Functional | [REQUIREMENT_STATEMENT] |

**Requirement Categories:**
- REQ-F: Functional requirements (mapped to specific features)
- REQ-D: Data requirements (data quality, schema, retention)
- REQ-NF: Non-functional requirements (performance, security, accessibility)

---

## Platform Foundation Input Package

### Platform Shape Signal
- Product type: [FROM_CLASSIFIER]
- Primary interaction pattern: [dashboard monitoring / CRUD workflow / data pipeline / API consumption / content creation]
- Real-time requirement: [FROM_USAGE_CONTEXT]

### User Model Signal
- User types identified: [LIST]
- Auth complexity: [single role / multiple roles / multi-tenant / B2B with customer-managed users]
- External integrations: [API consumers, system-to-system]

### Data Signal
- Core entities identified: [LIST_FROM_CAPABILITIES]
- Search/filter features present: [yes/no]
- Export features present: [yes/no]
- Audit trail features present: [yes/no]
- Real-time data features present: [yes/no]

### Scale Signal
- Expected concurrent users: [ESTIMATE]
- Data volume expectation: [ESTIMATE]
- Session pattern: [continuous / intermittent]
