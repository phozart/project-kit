# REST Conventions

RESTful API design patterns and best practices.

## Resource Naming

### Use Nouns, Not Verbs
```
✓ GET /users
✗ GET /getUsers

✓ POST /users
✗ POST /createUser
```

### Plural Names for Collections
```
✓ GET /users
✗ GET /user

✓ GET /users/123
```

### Lowercase and Hyphens
```
✓ /order-items
✗ /orderItems
✗ /order_items
```

### Nested Resources
```
✓ /users/123/orders
✓ /users/123/orders/456

Limit nesting to 2 levels maximum
```

## HTTP Methods

### Standard CRUD Operations

**GET**: Read resource(s)
```
GET /users          → List all users
GET /users/123      → Get user 123
```

**POST**: Create new resource
```
POST /users
Content-Type: application/json

{
  "email": "user@example.com",
  "firstName": "John"
}
```

**PUT**: Replace entire resource
```
PUT /users/123
Content-Type: application/json

{
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe"
}
```

**PATCH**: Partial update
```
PATCH /users/123
Content-Type: application/json

{
  "firstName": "Jane"
}
```

**DELETE**: Remove resource
```
DELETE /users/123
```

## HTTP Status Codes

### Success (2xx)
- **200 OK**: Successful GET, PUT, PATCH, DELETE
- **201 Created**: Successful POST (include Location header)
- **204 No Content**: Successful DELETE with no response body

### Client Errors (4xx)
- **400 Bad Request**: Invalid input
- **401 Unauthorized**: Missing or invalid auth token
- **403 Forbidden**: Authenticated but not authorized
- **404 Not Found**: Resource doesn't exist
- **409 Conflict**: Resource conflict (duplicate, version mismatch)
- **422 Unprocessable Entity**: Validation errors
- **429 Too Many Requests**: Rate limit exceeded

### Server Errors (5xx)
- **500 Internal Server Error**: Unexpected server error
- **503 Service Unavailable**: Server overloaded or maintenance

## Pagination

### Offset-Based (Simple)
```
GET /users?page=2&limit=20

Response:
{
  "data": [...],
  "pagination": {
    "page": 2,
    "limit": 20,
    "total": 500,
    "totalPages": 25
  }
}
```

### Cursor-Based (Scalable)
```
GET /users?cursor=abc123&limit=20

Response:
{
  "data": [...],
  "pagination": {
    "nextCursor": "def456",
    "hasMore": true
  }
}
```

## Filtering and Sorting

### Filtering
```
GET /users?status=active
GET /users?status=active&role=admin
GET /users?createdAfter=2024-01-01
```

### Sorting
```
GET /users?sort=createdAt        → ascending
GET /users?sort=-createdAt       → descending
GET /users?sort=lastName,firstName
```

### Field Selection
```
GET /users?fields=id,email,firstName
```

## Error Response Format

Standard error structure:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format",
        "code": "INVALID_FORMAT"
      },
      {
        "field": "age",
        "message": "Must be at least 18",
        "code": "MIN_VALUE"
      }
    ],
    "requestId": "req-abc-123",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

Error codes should be:
- Uppercase with underscores
- Specific and actionable
- Documented

## Versioning

### URL Versioning (Recommended)
```
/api/v1/users
/api/v2/users
```

### Header Versioning
```
GET /api/users
Accept: application/vnd.myapi.v2+json
```

## Content Negotiation

Support multiple formats:
```
Accept: application/json       → JSON response
Accept: application/xml        → XML response
Accept: text/csv               → CSV response
```

## Caching

Use HTTP caching headers:

```
Cache-Control: public, max-age=3600
ETag: "abc123"
Last-Modified: Tue, 15 Jan 2024 10:00:00 GMT
```

Conditional requests:
```
GET /users/123
If-None-Match: "abc123"

→ 304 Not Modified (if unchanged)
→ 200 OK with body (if changed)
```

## Rate Limiting

Include rate limit headers:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640000000
Retry-After: 3600
```

## HATEOAS (Optional)

Include links in responses:
```json
{
  "id": "123",
  "email": "user@example.com",
  "_links": {
    "self": { "href": "/users/123" },
    "orders": { "href": "/users/123/orders" },
    "update": { "href": "/users/123", "method": "PUT" }
  }
}
```

## Best Practices

1. Use HTTPS everywhere
2. Include API version in URL
3. Return consistent error format
4. Implement pagination for all collections
5. Support filtering, sorting, field selection
6. Use appropriate HTTP status codes
7. Include request IDs for tracing
8. Document with OpenAPI 3.0
9. Validate all inputs
10. Use JSON as default format
