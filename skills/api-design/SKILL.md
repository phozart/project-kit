---
name: api-design
description: REST, GraphQL, and gRPC API design conventions and contract generation
---

# API Design Skill

Expert guidance for designing REST, GraphQL, and gRPC APIs with contract-first approach.

## When to Use

- Phase 5: Architecture design during contract generation
- Phase 7: Implementation when building API endpoints
- When designing new API endpoints
- When generating API-CONTRACTS and TYPE-CONTRACTS
- When ensuring consistency across API design

## Core Principles

1. **Contract-First**: Generate API-CONTRACTS and TYPE-CONTRACTS before implementation
2. **Consistency**: Follow established conventions for chosen API style
3. **Versioning**: Plan for API evolution from day one
4. **Documentation**: Self-documenting APIs with OpenAPI/GraphQL schemas
5. **Validation**: Strong input validation at API boundaries

## API Design Process

### 1. Choose API Style

Based on project requirements:

**REST**
- Simple CRUD operations
- Public APIs
- HTTP caching needed
- Widely supported clients

**GraphQL**
- Complex data relationships
- Client needs flexible queries
- Reduce over-fetching
- Real-time with subscriptions

**gRPC**
- Internal microservices
- High-performance requirements
- Streaming data
- Strong typing needed

### 2. Read Requirements

Extract from REQUIREMENTS.md:
- Business entities and operations
- Data relationships
- Authentication needs
- Rate limiting requirements
- Response format preferences

### 3. Design Endpoints

Apply conventions from references:
- REST: references/rest-conventions.md
- GraphQL: references/graphql-conventions.md

Design checklist:
- Resource naming
- HTTP methods/operations
- Request/response shapes
- Error handling
- Pagination strategy
- Filtering and sorting

### 4. Generate Contracts

Create two contract types:

**API-CONTRACTS**: API interface definitions
- OpenAPI 3.0 spec for REST
- GraphQL schema for GraphQL
- Protobuf definitions for gRPC

**TYPE-CONTRACTS**: Language-specific types
- TypeScript interfaces
- Java DTOs
- Python Pydantic models

See: references/contract-generation.md

### 5. Validate Design

Ensure:
- All CRUD operations covered
- Error responses defined
- Authentication/authorization specified
- Pagination implemented consistently
- Versioning strategy documented

## Contract-Driven Development

### Golden Rule

**Implementation agents MUST import and use generated contracts. Deviation is a blocking defect.**

### Workflow

```
1. api-design generates API-CONTRACTS + TYPE-CONTRACTS
2. Commits to project repository
3. Implementation agents import contracts
4. Implementation uses contracts for:
   - Request validation
   - Response serialization
   - Client SDK generation
   - Mock server generation
```

### Example Type Contract

```typescript
// TYPE-CONTRACTS/dto/UserDTO.ts
export interface UserDTO {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  createdAt: string; // ISO 8601
}

export interface CreateUserRequest {
  email: string;
  firstName: string;
  lastName: string;
}

export interface UpdateUserRequest {
  firstName?: string;
  lastName?: string;
}
```

### Example API Contract (REST)

```yaml
# API-CONTRACTS/users.openapi.yaml
openapi: 3.0.0
paths:
  /users:
    get:
      summary: List users
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/UserDTO'
                  pagination:
                    $ref: '#/components/schemas/PaginationMeta'
```

## API Versioning

### URL Versioning (Recommended for REST)
```
/api/v1/users
/api/v2/users
```

### Header Versioning
```
Accept: application/vnd.myapi.v2+json
```

### GraphQL Versioning
- Avoid versions, use field deprecation
- Add new fields, deprecate old ones
- Use schema directives

```graphql
type User {
  name: String @deprecated(reason: "Use firstName and lastName")
  firstName: String
  lastName: String
}
```

## Documentation Generation

### REST: OpenAPI/Swagger
- Generate interactive docs from OpenAPI spec
- Tools: Swagger UI, Redoc, Stoplight

### GraphQL: Built-in
- GraphQL Playground
- GraphiQL
- Apollo Studio

### gRPC: Protobuf
- Generate docs from .proto files
- Tools: protoc-gen-doc, grpc-gateway

## Security Considerations

1. **Authentication**: JWT, OAuth2, API keys
2. **Authorization**: Role-based access control
3. **Rate Limiting**: Protect against abuse
4. **Input Validation**: Validate all inputs
5. **HTTPS Only**: Never use HTTP in production
6. **CORS**: Configure appropriately
7. **Sensitive Data**: Never log passwords, tokens

## Error Handling

Consistent error format across all endpoints:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ],
    "requestId": "abc-123-def"
  }
}
```

## Quality Gates

API design must satisfy:
- All endpoints follow style conventions
- API-CONTRACTS generated in standard format
- TYPE-CONTRACTS generated for all DTOs
- Error responses defined for all endpoints
- Authentication/authorization documented
- Versioning strategy documented
- Breaking changes clearly marked

## Anti-Patterns to Avoid

- **Inconsistent Naming**: Pick a convention and stick to it
- **Overfetching**: Design precise endpoints or use GraphQL
- **No Versioning**: Plan for changes from day one
- **Generic Errors**: Provide specific error codes
- **Ignoring Pagination**: Always paginate lists
- **No Rate Limiting**: Protect your API from abuse

## Deliverables

1. **API-CONTRACTS**: OpenAPI/GraphQL schema/Protobuf definitions
2. **TYPE-CONTRACTS**: Language-specific type definitions
3. **API Documentation**: Generated from contracts
4. **Authentication Spec**: Auth flow documentation
5. **Changelog**: Version history and breaking changes

## References

- [REST Conventions](references/rest-conventions.md) - RESTful API design patterns
- [GraphQL Conventions](references/graphql-conventions.md) - GraphQL schema design
- [Contract Generation](references/contract-generation.md) - How to generate contracts

## Integration

Used by:
- **architect agent**: Generates contracts during Phase 5
- **api-developer agent**: Implements endpoints using contracts in Phase 7
- **testing skill**: Uses contracts for contract testing

Produces:
- API-CONTRACTS for API interface definitions
- TYPE-CONTRACTS for implementation code
- Documentation for API consumers
