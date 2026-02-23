# GraphQL Conventions

GraphQL schema design patterns and best practices.

## Schema Design Principles

1. **Type Safety**: Strong typing for all fields
2. **Nullable by Default**: Fields nullable unless marked with !
3. **Descriptive Names**: Clear, self-documenting types and fields
4. **Versioning via Deprecation**: Don't version, deprecate old fields
5. **Pagination**: Use Relay-style connections

## Type Naming

### Use PascalCase for Types
```graphql
type User {
  id: ID!
  email: String!
}

type OrderItem {
  product: Product!
  quantity: Int!
}
```

### Use camelCase for Fields
```graphql
type User {
  firstName: String!
  lastName: String!
  createdAt: DateTime!
}
```

## Query Design

### Top-Level Queries

```graphql
type Query {
  # Single resource
  user(id: ID!): User

  # List with filters
  users(
    first: Int
    after: String
    filter: UserFilter
  ): UserConnection!

  # Search
  searchUsers(query: String!): [User!]!
}
```

### Input Types for Complex Arguments

```graphql
input UserFilter {
  status: UserStatus
  role: UserRole
  createdAfter: DateTime
}

input CreateUserInput {
  email: String!
  firstName: String!
  lastName: String!
}
```

## Mutation Design

### Naming Convention

Use verb + noun pattern:
```graphql
type Mutation {
  createUser(input: CreateUserInput!): CreateUserPayload!
  updateUser(id: ID!, input: UpdateUserInput!): UpdateUserPayload!
  deleteUser(id: ID!): DeleteUserPayload!
}
```

### Mutation Payloads

Return payload type with data and errors:

```graphql
type CreateUserPayload {
  user: User
  errors: [Error!]!
  success: Boolean!
}

type Error {
  field: String
  message: String!
  code: String!
}
```

## Pagination

### Relay-Style Connections (Recommended)

```graphql
type UserConnection {
  edges: [UserEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type UserEdge {
  node: User!
  cursor: String!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}

type Query {
  users(
    first: Int
    after: String
    last: Int
    before: String
  ): UserConnection!
}
```

### Simple Pagination (Alternative)

```graphql
type UserPage {
  data: [User!]!
  page: Int!
  limit: Int!
  total: Int!
  hasMore: Boolean!
}

type Query {
  users(page: Int!, limit: Int!): UserPage!
}
```

## Subscriptions

Real-time updates via WebSocket:

```graphql
type Subscription {
  userCreated: User!
  userUpdated(id: ID!): User!
  orderStatusChanged(orderId: ID!): Order!
}
```

## Error Handling

### Field-Level Errors (Preferred)

```graphql
type UpdateUserPayload {
  user: User
  errors: [Error!]!
}

type Error {
  field: String
  message: String!
  code: ErrorCode!
}

enum ErrorCode {
  VALIDATION_ERROR
  NOT_FOUND
  UNAUTHORIZED
  INTERNAL_ERROR
}
```

### Extensions (Alternative)

GraphQL errors with extensions:
```json
{
  "errors": [
    {
      "message": "Invalid email format",
      "extensions": {
        "code": "VALIDATION_ERROR",
        "field": "email"
      }
    }
  ]
}
```

## Custom Scalars

Define custom types for common patterns:

```graphql
scalar DateTime
scalar Email
scalar URL
scalar JSON

type User {
  email: Email!
  website: URL
  createdAt: DateTime!
  metadata: JSON
}
```

## Enums

Use enums for fixed sets of values:

```graphql
enum UserStatus {
  ACTIVE
  INACTIVE
  SUSPENDED
}

enum UserRole {
  ADMIN
  USER
  GUEST
}

type User {
  status: UserStatus!
  role: UserRole!
}
```

## Interfaces and Unions

### Interfaces for Shared Fields

```graphql
interface Node {
  id: ID!
  createdAt: DateTime!
}

type User implements Node {
  id: ID!
  createdAt: DateTime!
  email: String!
}

type Product implements Node {
  id: ID!
  createdAt: DateTime!
  name: String!
}
```

### Unions for Heterogeneous Lists

```graphql
union SearchResult = User | Product | Order

type Query {
  search(query: String!): [SearchResult!]!
}
```

## Deprecation

Deprecate fields instead of removing:

```graphql
type User {
  name: String @deprecated(reason: "Use firstName and lastName")
  firstName: String!
  lastName: String!
}
```

## Documentation

Use descriptions for schema documentation:

```graphql
"""
Represents a user in the system.
"""
type User {
  """
  Unique identifier for the user.
  """
  id: ID!

  """
  User's email address. Must be unique.
  """
  email: String!
}
```

## Directives

### Authorization

```graphql
directive @auth(requires: Role!) on FIELD_DEFINITION

enum Role {
  ADMIN
  USER
}

type Mutation {
  deleteUser(id: ID!): DeleteUserPayload! @auth(requires: ADMIN)
}
```

### Rate Limiting

```graphql
directive @rateLimit(limit: Int!, duration: Int!) on FIELD_DEFINITION

type Query {
  users: [User!]! @rateLimit(limit: 100, duration: 60)
}
```

## Best Practices

1. Make fields nullable by default (flexibility)
2. Use ! only for truly required fields
3. Use connections for pagination
4. Return payload types from mutations
5. Include error handling in schema
6. Use enums for fixed values
7. Deprecate instead of removing fields
8. Document types and fields with descriptions
9. Use custom scalars for validation
10. Implement DataLoader to prevent N+1 queries
11. Use persisted queries in production
12. Enable GraphQL introspection in dev, disable in prod
