# Vertical Slice Patterns

Reference examples for decomposing features into vertical implementation slices.

## Pattern: CRUD Feature Decomposition

A typical CRUD feature for an entity (e.g., "Products") splits into 4-5 tasks:

| Task | Layers | Size | Dependencies |
|------|--------|------|-------------|
| Create product | Form UI + POST API + schema + migration | Medium | Scaffold, Auth, DB foundation |
| List products | Table UI + GET (list) API + pagination query | Medium | Create product (needs data) |
| View product detail | Detail page UI + GET (single) API | Small | Create product |
| Edit product | Edit form UI + PUT API + validation | Medium | View product detail |
| Delete product | Confirm dialog + DELETE API + cascade rules | Small | List products |

## Pattern: Dashboard Feature Decomposition

Dashboards are read-heavy. Split by widget/section:

| Task | Layers | Size | Dependencies |
|------|--------|------|-------------|
| Dashboard layout | Page shell + grid layout + loading skeletons | Small | Layout shell |
| Summary stats widget | Stats component + aggregation API | Medium | DB foundation |
| Recent activity feed | Feed component + activity query API | Medium | At least one feature creating data |
| Chart widget | Chart component + time-series API | Medium | DB foundation |

## Pattern: Auth Feature Decomposition

Auth is foundation but still benefits from splitting:

| Task | Layers | Size | Dependencies |
|------|--------|------|-------------|
| Registration flow | Register form + API + user schema + email verification | Medium | Scaffold, DB foundation |
| Login flow | Login form + API + JWT issuance + session management | Medium | Registration |
| Protected routes | Middleware + redirect logic + token refresh | Small | Login flow |
| User profile | Profile page + API + avatar upload | Medium | Login flow |
| Password reset | Reset form + email flow + token validation | Medium | Login flow |

## Pattern: Search/Filter Feature

| Task | Layers | Size | Dependencies |
|------|--------|------|-------------|
| Basic text search | Search input + API query param + DB index | Small | List view exists |
| Filter by category | Filter dropdown + API query param | Small | List view, categories exist |
| Date range filter | Date picker + API query params | Small | List view |
| Combined filters | Filter state management + multi-param API | Medium | Individual filters |
| Search results empty state | Empty state UI + suggestion logic | Small | Basic search |

## Context Scoping Examples

### Good: Scoped Brief Constraints
```
Technical Constraints:
- Framework: Next.js 15 App Router (Platform Foundation Decision 4)
- Database: PostgreSQL with Prisma (Decision 5)
- This entity uses soft delete (Architecture ADR-007)
```

### Bad: Dumped Full Context
```
Technical Constraints:
- Platform type: Multi-tenant SaaS
- Auth: OAuth2 + RBAC with Auth0
- Framework: Next.js 15 App Router
- Database: PostgreSQL with Prisma
- Cache: Redis for sessions
- CI/CD: GitHub Actions
- Deployment: Docker on AWS ECS
- NFRs: Performance P95 < 200ms, WCAG AA, SOC2
[... 20 more lines from Platform Foundation]
```

The first example gives the developer exactly what they need. The second gives them everything and nothing.
