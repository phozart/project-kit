# Platform Tradeoff Reference

Detailed tradeoff analysis for each platform decision category. The platform-engineer agent references this when explaining options to the user.

## Multi-tenant vs Single-tenant

| Factor | Multi-tenant | Single-tenant |
|--------|-------------|---------------|
| Infrastructure cost | Lower (shared) | Higher (per customer) |
| Data isolation | Complex (RLS or schema separation) | Simple (separate databases) |
| Schema migrations | Risky (affect all tenants) | Safe (per-tenant rollout) |
| Compliance | Harder (shared infrastructure) | Easier (isolated) |
| Onboarding | Needs tenant provisioning flow | Needs deployment pipeline |
| Scaling | Vertical then horizontal | Horizontal by design |

## Auth Pattern Decision Matrix

| Pattern | Best For | Avoid When |
|---------|----------|------------|
| OAuth2 + RBAC | SaaS with defined roles | Access depends on data relationships |
| OAuth2 + ABAC | Multi-tenant with org-scoped data | Simple role-based access suffices |
| API Key | Service-to-service, developer APIs | Human users need sessions |
| Session-based | Internal tools, simple web apps | Mobile apps, API-first |
| Identity Provider | Time-constrained teams, standard auth | Custom auth requirements, cost-sensitive |

## Database Selection Signals

| Signal | Recommendation |
|--------|---------------|
| Relational data with joins | PostgreSQL |
| Document-oriented, schema flexibility | MongoDB |
| Time-series data | TimescaleDB or InfluxDB |
| Graph relationships | Neo4j |
| Key-value cache | Redis |
| Full-text search | PostgreSQL (good enough) or Elasticsearch (advanced) |
| Analytics/OLAP | DuckDB (embedded), Snowflake/BigQuery (cloud) |

## Real-time Mechanism Selection

| Mechanism | Best For | Latency | Complexity |
|-----------|----------|---------|------------|
| Polling | Low-frequency updates, simple | High | Low |
| SSE | Server-push (dashboards, notifications) | Medium | Low |
| WebSocket | Bidirectional (chat, collaboration) | Low | Medium |
| WebRTC | Peer-to-peer (video, audio) | Very low | High |
