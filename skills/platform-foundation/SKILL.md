---
name: platform-foundation
description: Platform foundation decisions with tradeoff references for the platform-engineer agent
---

# Platform Foundation Skill

Provides reference material for the platform-engineer agent to explain tradeoffs during the diagnostic questionnaire.

## When to Use

- Phase 3 platform foundation in the orchestrator workflow
- User says "platform decisions" or "lock platform choices"
- Need to establish foundational technical constraints before architecture

## What This Skill Does

This skill provides tradeoff knowledge that the platform-engineer agent references when presenting options to the user. It does not produce artifacts directly — the agent uses this as background knowledge.

## Key References

### Platform Type Tradeoffs
- Multi-tenant: lower infra cost, harder data isolation, shared schema migration risk
- Single-tenant: simpler isolation, higher infra cost per customer, easier compliance
- Internal tool: can use corporate SSO, no public attack surface, simpler deployment
- API service: documentation is the product, versioning strategy critical from day one

### Auth Pattern Selection
- OAuth2 + RBAC sufficient for 90% of applications with defined user roles
- ABAC needed when access rules depend on data relationships (user belongs to org X, can see org X data)
- Identity providers (Auth0, Clerk) reduce time-to-auth from weeks to hours but add vendor dependency and cost
- Session-based auth is simpler but breaks in API-first and mobile scenarios

### Framework Selection Signals
- If the product is content-heavy with SEO needs → server rendering matters → Next.js
- If the product is a dense interactive workspace → client-heavy SPA may be simpler than fighting hydration
- If the product is primarily an API consumed by multiple frontends → framework choice is backend-first
- If the product needs real-time operational dashboards → evaluate whether the framework's real-time story is native or bolted on

### Data Architecture Signals
- PostgreSQL covers 80% of use cases. Choose something else only with a specific reason.
- Add Redis only if you have session storage, rate limiting, or cache invalidation needs — not by default
- Event sourcing adds significant complexity. Use only when audit trail is a regulatory requirement, not a nice-to-have.
- Real-time: WebSocket for bidirectional (chat, collaboration), SSE for server-push (dashboards, notifications), polling for everything else

### Deployment Signals
- Docker is the default unless serverless is a strong fit (low traffic, event-driven)
- GitHub Actions for most teams; GitLab CI if already in GitLab ecosystem
- Start with 3 environments (local, staging, production) — add more only with reason
- Infrastructure-as-code from day one if multi-environment or team >1

### Non-Functional Priority Guidance
- Most products need performance + security as baseline, then one differentiator
- Accessibility (WCAG AA) should be baseline for any product with a UI, not a ranked priority
- Internationalization is expensive to add later — decide now if it's needed in year one
- Auditability is a regulatory concern — if compliance requires it, it's not optional

### Architecture Style Signals
- Traditional monolith: team of 1-3, domain not yet clear, prototype or MVP, under 50k LOC expected
- Modular monolith: team of 2-8, clear domain boundaries exist, may need to extract services later, want microservices-like separation without operational overhead
- Microservices: team of 8+, genuinely different scaling needs per component, organization has platform engineering capacity, multiple teams need independent deployment
- Serverless-first: event-driven workloads, spiky traffic, minimal ops desired, acceptable cold starts and vendor dependency
- Default recommendation: start with modular monolith unless there's a specific reason for another style. It provides the best migration path in either direction (simplify to monolith or extract to microservices).

## Gate Criteria

Gate: Platform Foundation
Pass criteria:
- docs/PLATFORM-FOUNDATION.md exists
- All 8 decision sections present and non-empty
- Locked Decisions Summary table has at least 10 entries
- Every decision references user confirmation (not agent-assumed)
- No architecture recommendations present (only constraints)

## Output Files

- `docs/PLATFORM-FOUNDATION.md` — Single document with all locked decisions

## References

- [Platform Type Tradeoffs](./references/platform-tradeoffs.md)
