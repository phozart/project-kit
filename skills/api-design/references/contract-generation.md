# Contract Generation

How to generate API-CONTRACTS and TYPE-CONTRACTS for different languages and API styles.

## Contract Types

### API-CONTRACTS
Interface definition in standard format:
- **REST**: OpenAPI 3.0 YAML/JSON
- **GraphQL**: GraphQL Schema Definition Language (.graphql)
- **gRPC**: Protocol Buffers (.proto)

### TYPE-CONTRACTS
Language-specific type definitions:
- **TypeScript**: Interfaces (.ts)
- **Java**: DTOs/Records (.java)
- **Python**: Pydantic Models (.py)
- **C#**: DTOs/Records (.cs)

## REST Contracts

### OpenAPI 3.0 (API-CONTRACT)

```yaml
# API-CONTRACTS/users.openapi.yaml
openapi: 3.0.0
info:
  title: User API
  version: 1.0.0
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
                $ref: '#/components/schemas/UserListResponse'
    post:
      summary: Create user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
      responses:
        '201':
          description: Created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserResponse'
  /users/{id}:
    get:
      summary: Get user by ID
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserResponse'
        '404':
          description: Not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

components:
  schemas:
    UserResponse:
      type: object
      required:
        - id
        - email
        - firstName
        - lastName
      properties:
        id:
          type: string
        email:
          type: string
          format: email
        firstName:
          type: string
        lastName:
          type: string
        createdAt:
          type: string
          format: date-time
    CreateUserRequest:
      type: object
      required:
        - email
        - firstName
        - lastName
      properties:
        email:
          type: string
          format: email
        firstName:
          type: string
        lastName:
          type: string
    UserListResponse:
      type: object
      properties:
        data:
          type: array
          items:
            $ref: '#/components/schemas/UserResponse'
        pagination:
          $ref: '#/components/schemas/PaginationMeta'
    ErrorResponse:
      type: object
      properties:
        error:
          type: object
          properties:
            code:
              type: string
            message:
              type: string
```

### TypeScript Types (TYPE-CONTRACT)

```typescript
// TYPE-CONTRACTS/dto/UserDTO.ts
export interface UserDTO {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  createdAt: string;
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

export interface PaginationMeta {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

export interface UserListResponse {
  data: UserDTO[];
  pagination: PaginationMeta;
}

export interface ErrorResponse {
  error: {
    code: string;
    message: string;
    details?: Array<{
      field: string;
      message: string;
    }>;
  };
}
```

## GraphQL Contracts

### GraphQL Schema (API-CONTRACT)

```graphql
# API-CONTRACTS/schema.graphql
scalar DateTime

type User {
  id: ID!
  email: String!
  firstName: String!
  lastName: String!
  createdAt: DateTime!
}

input CreateUserInput {
  email: String!
  firstName: String!
  lastName: String!
}

input UpdateUserInput {
  firstName: String
  lastName: String
}

type UserConnection {
  edges: [UserEdge!]!
  pageInfo: PageInfo!
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
  user(id: ID!): User
  users(first: Int, after: String): UserConnection!
}

type Mutation {
  createUser(input: CreateUserInput!): CreateUserPayload!
  updateUser(id: ID!, input: UpdateUserInput!): UpdateUserPayload!
}

type CreateUserPayload {
  user: User
  errors: [Error!]!
}

type Error {
  field: String
  message: String!
  code: String!
}
```

### TypeScript Types from GraphQL

```typescript
// TYPE-CONTRACTS/graphql/types.ts
// Generated from schema.graphql

export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  createdAt: Date;
}

export interface CreateUserInput {
  email: string;
  firstName: string;
  lastName: string;
}

export interface UpdateUserInput {
  firstName?: string;
  lastName?: string;
}
```

## Java Type Contracts

```java
// TYPE-CONTRACTS/dto/UserDTO.java
package com.example.dto;

import java.time.Instant;

public record UserDTO(
    String id,
    String email,
    String firstName,
    String lastName,
    Instant createdAt
) {}

// TYPE-CONTRACTS/dto/CreateUserRequest.java
public record CreateUserRequest(
    String email,
    String firstName,
    String lastName
) {}

// TYPE-CONTRACTS/dto/UserListResponse.java
public record UserListResponse(
    List<UserDTO> data,
    PaginationMeta pagination
) {}
```

## Python Type Contracts

```python
# TYPE-CONTRACTS/dto/user_dto.py
from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional

class UserDTO(BaseModel):
    id: str
    email: EmailStr
    first_name: str
    last_name: str
    created_at: datetime

class CreateUserRequest(BaseModel):
    email: EmailStr
    first_name: str
    last_name: str

class UpdateUserRequest(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None

class PaginationMeta(BaseModel):
    page: int
    limit: int
    total: int
    total_pages: int

class UserListResponse(BaseModel):
    data: list[UserDTO]
    pagination: PaginationMeta
```

## Code Generation Tools

### From OpenAPI
- **TypeScript**: openapi-typescript, swagger-typescript-api
- **Java**: OpenAPI Generator (maven/gradle plugin)
- **Python**: openapi-python-client, datamodel-code-generator

### From GraphQL
- **TypeScript**: GraphQL Code Generator (@graphql-codegen/cli)
- **Java**: GraphQL Java Generator
- **Python**: graphql-core

### From Protobuf
- **TypeScript**: ts-proto
- **Java**: protoc with java plugin
- **Python**: protoc with python plugin

## Directory Structure

```
project/
├── API-CONTRACTS/
│   ├── openapi/
│   │   ├── users.yaml
│   │   └── orders.yaml
│   ├── graphql/
│   │   └── schema.graphql
│   └── proto/
│       └── service.proto
└── TYPE-CONTRACTS/
    ├── dto/
    │   ├── UserDTO.ts
    │   ├── OrderDTO.ts
    │   └── ...
    └── generated/
        └── (generated files from API-CONTRACTS)
```

## Best Practices

1. Keep API-CONTRACTS as single source of truth
2. Generate TYPE-CONTRACTS from API-CONTRACTS when possible
3. Version contracts alongside code
4. Validate implementations against contracts (contract tests)
5. Automate contract generation in build pipeline
6. Never manually edit generated TYPE-CONTRACTS
7. Use strict mode for TypeScript generation
8. Include validation annotations in Java/Python DTOs
