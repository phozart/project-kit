When the user invokes this command, validate the current or specified quality gate.

## Steps
1. Read project.config.yaml for current gate number
2. Check gate mode (manual/auto/skip)
3. Validate all criteria for that gate
4. If auto: pass if criteria met, fail with details if not
5. If manual: present checklist to user for approval
6. Update gates_passed in config on success

## Gate Definitions

### Gate 0: Setup
- project.config.yaml exists and is valid
- Project name, type, and techstack defined

### Gate 1: Innovation (optional)
- docs/VALIDATED-CONCEPT.md exists
- docs/FEASIBILITY-STUDY.md exists
- Concept viability confirmed

### Gate 2: Product Design
- docs/PRODUCT-STRATEGY.md exists and complete
- docs/PERSONAS.md exists with 2+ personas
- docs/USER-JOURNEYS.md exists with journeys per persona
- docs/FEATURE-INVENTORY.md exists with F-XXX IDs
- docs/MVP-SCOPE.md exists with scope defined
- Every feature has acceptance criteria (minimum 3)
- Every feature has edge cases documented (minimum 2)
- Every feature has explicit out-of-scope statement
- No feature description is purely happy-path
- Traceability cross-reference exists (REQ-XXX mapped to F-XXX)
- User has approved scope

### Gate 3: Platform Foundation
- docs/PLATFORM-FOUNDATION.md exists
- All 7 decision sections present and non-empty
- Locked Decisions Summary table has at least 10 entries
- Every decision references user confirmation (not agent-assumed)
- No architecture recommendations present (only constraints)
- This gate is ALWAYS manual — human confirms every decision

### Gate 4: Architecture
- docs/architecture/SYSTEM-DESIGN.md exists
- docs/architecture/ADR/ has minimum 5 ADRs
- docs/contracts/TYPE-CONTRACTS.[ext] exists
- docs/contracts/API-CONTRACTS.md exists
- No contradictions with PLATFORM-FOUNDATION.md locked decisions
- All contracts are complete and unambiguous

### Gate 5: UX/UI Design
- docs/design/DESIGN-SYSTEM.md exists with unique tokens
- docs/design/USER-FLOWS.md exists
- docs/design/WIREFRAMES.md exists
- docs/design/INTERACTIONS.md exists
- docs/design/ACCESSIBILITY-REVIEW.md exists
- All critical journeys have wireframes

### Gate 6: Marketing (optional)
- docs/MARKET-RESEARCH.md exists
- docs/COMPETITIVE-ANALYSIS.md exists
- Market understanding sufficient

### Gate 7a: Implementation Entry (Decomposition)
- docs/sprints/TASK-QUEUE.md exists
- At least 5 foundation tasks defined (scaffold, auth, database, design system, layout shell)
- Every task has a brief in docs/sprints/tasks/
- Every task brief contains: title, what to build, acceptance criteria, technical constraints, dependencies, what done looks like, estimated scope
- No task estimated larger than "Large" (6 hours)
- Dependency graph has no circular dependencies
- User has reviewed and approved the task queue
- Foundation tasks are ordered sequentially
- Feature tasks reference specific product design features by F-ID
- This sub-gate is ALWAYS manual — human reviews task decomposition

### Gate 7b: Implementation Complete (Execution)
- All work packages marked COMPLETE with HUMAN VERIFY: APPROVED
- Every work package has a WP-XXX-log.md with full stage history (BUILD → TEST → CODE REVIEW → QA REVIEW → HUMAN VERIFY)
- No stage was skipped in any work package lifecycle
- All tasks in TASK-QUEUE.md marked Complete
- All code compiles/builds
- Contracts followed (TYPE-CONTRACTS, API-CONTRACTS)
- Unit tests pass
- Changes documented (CHANGE-XXX.md for deviations)
- Full integration test suite passes across all packages

### Gate 8: QA & Security
- Smoke tests pass
- Core journey tests pass
- No critical/high defects open
- No critical security findings
- Accessibility audit no critical violations

### Gate 9: Release
- BA acceptance testing complete (business-analyst validation)
- Product validation done
- CHANGELOG.md updated
- User guide complete
- User final approval

### Gate 10: Documentation
- Style guide (HTML) complete
- Developer guide complete
- User guide complete
- All three packages consistent

## Usage
- `/gate-check` - Validate current gate
- `/gate-check N` - Validate specific gate number (0-10)

$ARGUMENTS Optional gate number (0-10) to check specific gate instead of current
