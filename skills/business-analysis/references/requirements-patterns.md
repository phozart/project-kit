# Requirements Patterns

Common patterns for writing clear, testable requirements.

## Functional Requirements Patterns

### CRUD Operations

**Pattern**: "The system shall allow [actor] to [create/read/update/delete] [entity]"

**Examples**:
- REQ-F-001: The system shall allow authenticated users to create new projects
- REQ-F-002: The system shall allow project owners to update project details
- REQ-F-003: The system shall allow admins to delete user accounts

### Input Validation

**Pattern**: "The system shall validate that [field] [meets criteria]"

**Examples**:
- REQ-F-010: The system shall validate that email addresses follow RFC 5322 format
- REQ-F-011: The system shall validate that project names are between 3 and 100 characters
- REQ-F-012: The system shall reject file uploads exceeding 10MB

### Business Rules

**Pattern**: "The system shall [enforce rule] when [condition]"

**Examples**:
- REQ-F-020: The system shall prevent project deletion when active tasks exist
- REQ-F-021: The system shall automatically archive projects after 90 days of inactivity
- REQ-F-022: The system shall limit free accounts to 3 projects maximum

### Notifications

**Pattern**: "The system shall notify [actor] when [event]"

**Examples**:
- REQ-F-030: The system shall email users when mentioned in comments
- REQ-F-031: The system shall send in-app notifications when tasks are assigned
- REQ-F-032: The system shall alert admins when storage reaches 80% capacity

## Data Requirements Patterns

### Data Storage

**Pattern**: "The system shall store [data] including [attributes]"

**Examples**:
- REQ-D-001: The system shall store user profiles including name, email, avatar, bio, and creation date
- REQ-D-002: The system shall store project data including title, description, owner, status, and timestamps
- REQ-D-003: The system shall store audit logs including user ID, action, timestamp, and IP address

### Data Relationships

**Pattern**: "The system shall maintain [relationship] between [entity A] and [entity B]"

**Examples**:
- REQ-D-010: The system shall maintain one-to-many relationship between users and projects
- REQ-D-011: The system shall maintain many-to-many relationship between projects and team members
- REQ-D-012: The system shall cascade delete all tasks when a project is deleted

### Data Retention

**Pattern**: "The system shall retain [data] for [duration] or until [condition]"

**Examples**:
- REQ-D-020: The system shall retain deleted items in trash for 30 days before permanent deletion
- REQ-D-021: The system shall retain audit logs for 7 years for compliance
- REQ-D-022: The system shall permanently delete user data within 30 days of account deletion request

## Non-Functional Requirements Patterns

### Performance

**Pattern**: "The system shall [action] within [time] under [conditions]"

**Examples**:
- REQ-NF-001: The system shall respond to API requests within 200ms at p95 under normal load
- REQ-NF-002: The system shall load dashboard within 2 seconds on 3G connection
- REQ-NF-003: The system shall support 10,000 concurrent users without degradation

### Scalability

**Pattern**: "The system shall scale to support [metric] [target]"

**Examples**:
- REQ-NF-010: The system shall scale to support 1 million registered users
- REQ-NF-011: The system shall handle 500 requests per second sustained load
- REQ-NF-012: The system shall store up to 10TB of user data

### Availability

**Pattern**: "The system shall maintain [uptime percentage] availability"

**Examples**:
- REQ-NF-020: The system shall maintain 99.9% uptime (excluding planned maintenance)
- REQ-NF-021: The system shall recover from failures within 15 minutes (RTO)
- REQ-NF-022: The system shall have Recovery Point Objective (RPO) of 1 hour

### Usability

**Pattern**: "The system shall [usability criteria]"

**Examples**:
- REQ-NF-030: The system shall comply with WCAG 2.1 Level AA accessibility standards
- REQ-NF-031: The system shall be responsive on devices from 320px to 4K resolution
- REQ-NF-032: The system shall support keyboard navigation for all primary functions

## Security Requirements Patterns

### Authentication

**Pattern**: "The system shall authenticate users via [method]"

**Examples**:
- REQ-S-001: The system shall authenticate users via email and password
- REQ-S-002: The system shall support OAuth 2.0 authentication with Google and GitHub
- REQ-S-003: The system shall require multi-factor authentication for admin accounts

### Authorization

**Pattern**: "The system shall authorize [actor] to [action] only if [condition]"

**Examples**:
- REQ-S-010: The system shall authorize users to edit projects only if they are project owners or admins
- REQ-S-011: The system shall authorize API access only with valid API keys
- REQ-S-012: The system shall enforce role-based permissions for all operations

### Data Protection

**Pattern**: "The system shall encrypt [data] using [method]"

**Examples**:
- REQ-S-020: The system shall encrypt passwords using bcrypt with cost factor 12
- REQ-S-021: The system shall encrypt data in transit using TLS 1.3
- REQ-S-022: The system shall encrypt sensitive data at rest using AES-256

### Audit & Compliance

**Pattern**: "The system shall log [events] including [details]"

**Examples**:
- REQ-S-030: The system shall log all authentication attempts including timestamp, user ID, IP, and result
- REQ-S-031: The system shall log all data access including user, resource, action, and timestamp
- REQ-S-032: The system shall support GDPR data export and deletion requests

## Operational Requirements Patterns

### Monitoring

**Pattern**: "The system shall monitor [metric] and alert when [threshold]"

**Examples**:
- REQ-OP-001: The system shall monitor API response times and alert when p95 exceeds 500ms
- REQ-OP-002: The system shall monitor error rates and alert when exceeding 1% of requests
- REQ-OP-003: The system shall monitor disk usage and alert at 80% capacity

### Backup & Recovery

**Pattern**: "The system shall backup [data] [frequency] and retain for [duration]"

**Examples**:
- REQ-OP-010: The system shall backup database hourly and retain for 7 days
- REQ-OP-011: The system shall perform full backup daily and retain for 30 days
- REQ-OP-012: The system shall test backup restoration monthly

### Deployment

**Pattern**: "The system shall support [deployment method]"

**Examples**:
- REQ-OP-020: The system shall support zero-downtime deployments
- REQ-OP-021: The system shall support automated rollback on deployment failure
- REQ-OP-022: The system shall complete deployments within 10 minutes

## Writing Tips

1. **Use "shall" for requirements** - Indicates mandatory behavior
2. **Be specific** - Avoid "fast", "easy", "user-friendly" without metrics
3. **One requirement per statement** - Don't combine multiple requirements
4. **Avoid implementation details** - Focus on WHAT, not HOW
5. **Make it testable** - Include measurable criteria
6. **Use active voice** - "The system shall..." not "The user can..."
