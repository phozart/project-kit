# Blocker Resolution

Patterns for identifying, escalating, and resolving blockers during sprint execution.

## Blocker Types

### Technical Blockers

**Examples:**
- Missing third-party API credentials
- Environment not provisioned
- Tool or library not working
- Performance issue blocking progress
- Technical debt preventing implementation

**Resolution Approach:**
1. Document the technical issue
2. Research potential solutions
3. Implement fix or workaround
4. Escalate to tech lead if needed

### Architecture Blockers

**Examples:**
- Current architecture doesn't support feature
- Performance concerns with design approach
- Security issue with planned implementation
- Missing architecture decision
- Design pattern doesn't fit use case

**Resolution Approach:**
1. Document the architecture gap
2. Propose solution options
3. Route to architecture maintenance skill
4. Block dependent work until resolved
5. Update architecture documentation

**Example Escalation:**
```markdown
## Architecture Blocker: Real-time Updates

**Feature:** Order status dashboard
**Issue:** Current architecture uses REST polling. Feature requires real-time updates.

**Options:**
1. Add WebSocket support (architectural change)
2. Use Server-Sent Events (smaller change)
3. Continue with polling (simplest, may be acceptable)

**Recommendation:** Server-Sent Events
**Escalated to:** Architecture Agent
**Status:** Awaiting decision
```

### Design Blockers

**Examples:**
- Missing UI mockup
- Unclear interaction pattern
- Design system component doesn't exist
- Accessibility requirement unclear
- Responsive behavior not specified

**Resolution Approach:**
1. Document the design gap
2. Use placeholder/best judgment initially
3. Route to design agent for clarification
4. Update implementation when design ready

### Requirements Blockers

**Examples:**
- Requirement unclear or ambiguous
- Conflicting requirements
- Missing acceptance criteria
- Business rule not specified
- Edge case behavior undefined

**Resolution Approach:**
1. Document the ambiguity
2. Make reasonable assumption
3. Route to requirements agent
4. Document assumption in code comments
5. Update when clarified

**Example:**
```typescript
// TODO: Unclear requirement - assuming orders can be edited
// only in "pending" status. Awaiting clarification.
// See BLOCKER-003 in docs/sprints/BLOCKERS.md
if (order.status !== 'pending') {
  throw new Error('Cannot edit non-pending order');
}
```

### Dependency Blockers

**Examples:**
- Waiting for another agent's work
- External API not ready
- Database migration not run
- Third-party library issue
- Upstream service down

**Resolution Approach:**
1. Use mock/stub to continue
2. Work on independent tasks
3. Coordinate with blocking agent
4. Update when dependency ready

### Access Blockers

**Examples:**
- Missing credentials
- No access to environment
- API key not provisioned
- Database access not granted
- Repository permissions issue

**Resolution Approach:**
1. Request access from appropriate owner
2. Document access needs
3. Work on tasks not requiring access
4. Track in blocker log

## Escalation Process

### Level 1: Self-Resolution (Agent)
Agent attempts to resolve blocker independently.

**Time limit:** 1-2 hours
**Actions:**
- Research issue
- Try alternative approaches
- Check documentation

### Level 2: Peer Coordination (Sprint Coordinator)
Sprint coordinator facilitates resolution between agents.

**Time limit:** 4-8 hours
**Actions:**
- Coordinate with related agents
- Identify workarounds
- Prioritize blocker resolution

### Level 3: Upstream Escalation (Specialist Agent)
Route to appropriate specialist agent.

**Routing:**
- Architecture issues → Architecture maintenance agent
- Design issues → Design agent
- Requirements issues → Requirements agent
- Technical issues → Tech lead

**Actions:**
- Provide clear blocker description
- Include context and options
- Request specific decision or clarification

### Level 4: Product Owner (Critical Blockers)
Escalate to product owner for critical blockers.

**When to escalate:**
- Blocker affects critical path
- Requires business decision
- Impacts release timeline
- Requires external coordination

## Blocker Documentation

### Blocker Template
```markdown
## Blocker [ID]: [Short Title]

**Reporter:** [Agent Name]
**Feature:** [Feature Name]
**Type:** [Technical/Architecture/Design/Requirements/Dependency/Access]
**Severity:** [Critical/High/Medium/Low]
**Created:** [Date]
**Status:** [Open/In Progress/Resolved]

### Description
[Clear description of the blocker]

### Impact
[What work is blocked? How critical is it?]

### Options Considered
1. Option A: [description]
   - Pros: [...]
   - Cons: [...]
2. Option B: [description]
   - Pros: [...]
   - Cons: [...]

### Recommendation
[Recommended solution]

### Escalation
- **Escalated to:** [Agent/Role]
- **Escalated on:** [Date]

### Resolution
[How was this resolved? What was the outcome?]
```

### Example Blocker

```markdown
## Blocker 003: Payment Gateway Integration Unclear

**Reporter:** Backend Agent 1
**Feature:** Checkout Payment Processing
**Type:** Requirements
**Severity:** High
**Created:** 2024-01-15
**Status:** Resolved

### Description
Requirements specify "integrate payment gateway" but don't specify which gateway or how to handle different payment methods (credit card, PayPal, etc.)

### Impact
Cannot implement payment processing. Blocking checkout feature (critical path).

### Options Considered
1. Stripe integration with card + PayPal
   - Pros: Popular, well-documented, supports multiple methods
   - Cons: Higher fees than some alternatives
2. PayPal only
   - Pros: Simple integration
   - Cons: Limited to PayPal users
3. Custom card processing
   - Pros: Lower fees
   - Cons: PCI compliance burden

### Recommendation
Stripe integration with card + PayPal support

### Escalation
- **Escalated to:** Product Owner
- **Escalated on:** 2024-01-15

### Resolution
**Resolved on:** 2024-01-16
**Decision:** Use Stripe with card and PayPal methods
**Action:** Updated requirements doc with decision
**Implementation:** Proceeding with Stripe SDK integration
```

## Blocker Severity Levels

### Critical
- Blocks critical path feature
- Affects multiple agents
- No workaround available
- Immediate resolution required

**Response time:** Same day

### High
- Blocks important feature
- Affects one agent significantly
- Limited workaround available
- Resolution needed within sprint

**Response time:** 1-2 days

### Medium
- Blocks non-critical feature
- Workaround available
- Can be deferred to next sprint if needed

**Response time:** 3-5 days

### Low
- Nice to have clarification
- Doesn't block current work
- Can assume and document

**Response time:** End of sprint or next sprint

## Workaround Strategies

### Use Placeholders
```typescript
// Placeholder until real payment gateway integrated
async function processPayment(amount: number): Promise<boolean> {
  console.log(`Mock payment: ${amount}`);
  return true; // Always succeeds in dev
}
```

### Use Mocks
```typescript
// Mock external API until real one available
const mockInventoryAPI = {
  checkStock: (productId: number) => ({ available: true, quantity: 100 })
};
```

### Feature Flags
```typescript
const features = {
  paymentGateway: process.env.FEATURE_PAYMENT === 'true'
};

if (features.paymentGateway) {
  // Real implementation
} else {
  // Mock implementation
}
```

### Stub Implementation
```typescript
// Stub implementation - to be replaced
class PaymentService {
  async process(payment: Payment): Promise<Result> {
    throw new Error('Not implemented - see BLOCKER-003');
  }
}
```
